package offline_field_app.core.sync;

import 'dart:convert';
import 'package:equatable/equatable.dart';

enum ConflictResolutionStrategy {
  lastWriteWins,
  serverWins,
  clientWins,
  merge,
  manual,
}

class ConflictData extends Equatable {
  final String entityId;
  final String entityType;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final DateTime localTimestamp;
  final DateTime serverTimestamp;
  final int localVersion;
  final int serverVersion;

  const ConflictData({
    required this.entityId,
    required this.entityType,
    required this.localData,
    required this.serverData,
    required this.localTimestamp,
    required this.serverTimestamp,
    required this.localVersion,
    required this.serverVersion,
  });

  bool get localIsNewer => localTimestamp.isAfter(serverTimestamp);
  bool get serverIsNewer => serverTimestamp.isAfter(localTimestamp);

  Duration get timestampDiff => localTimestamp.difference(serverTimestamp).abs();

  List<String> get conflictingFields {
    final fields = <String>{};
    for (final key in localData.keys) {
      if (serverData.containsKey(key)) {
        final localVal = localData[key];
        final serverVal = serverData[key];
        if (localVal != serverVal) {
          fields.add(key);
        }
      }
    }
    return fields.toList();
  }

  @override
  List<Object?> get props => [
        entityId,
        entityType,
        localData,
        serverData,
        localTimestamp,
        serverTimestamp,
        localVersion,
        serverVersion,
      ];
}

abstract class ConflictResolver {
  Future<ConflictResolution?> resolve(ConflictData conflict);
  void setStrategy(ConflictResolutionStrategy strategy);
  ConflictResolutionStrategy get currentStrategy;
}

class ConflictResolution extends Equatable {
  final String entityId;
  final Map<String, dynamic> resolvedData;
  final ConflictResolutionStrategy appliedStrategy;
  final String? resolutionNote;
  final bool requiresManualReview;

  const ConflictResolution({
    required this.entityId,
    required this.resolvedData,
    required this.appliedStrategy,
    this.resolutionNote,
    this.requiresManualReview = false,
  });

  @override
  List<Object?> get props => [
        entityId,
        resolvedData,
        appliedStrategy,
        resolutionNote,
        requiresManualReview,
      ];
}

class ConflictResolverImpl implements ConflictResolver {
  ConflictResolutionStrategy _currentStrategy;
  final Map<String, ConflictResolution Function(ConflictData)> _customResolvers;
  final Future<ConflictResolution?> Function(ConflictData)? manualResolver;

  ConflictResolverImpl({
    ConflictResolutionStrategy defaultStrategy = ConflictResolutionStrategy.lastWriteWins,
    Map<String, ConflictResolution Function(ConflictData)>? customResolvers,
    this.manualResolver,
  })  : _currentStrategy = defaultStrategy,
        _customResolvers = customResolvers ?? {};

  @override
  ConflictResolutionStrategy get currentStrategy => _currentStrategy;

  @override
  void setStrategy(ConflictResolutionStrategy strategy) {
    _currentStrategy = strategy;
  }

  @override
  Future<ConflictResolution?> resolve(ConflictData conflict) async {
    if (_customResolvers.containsKey(conflict.entityType)) {
      return _customResolvers[conflict.entityType]!(conflict);
    }

    switch (_currentStrategy) {
      case ConflictResolutionStrategy.lastWriteWins:
        return _resolveLastWriteWins(conflict);
      case ConflictResolutionStrategy.serverWins:
        return _resolveServerWins(conflict);
      case ConflictResolutionStrategy.clientWins:
        return _resolveClientWins(conflict);
      case ConflictResolutionStrategy.merge:
        return _resolveMerge(conflict);
      case ConflictResolutionStrategy.manual:
        return _resolveManual(conflict);
    }
  }

  ConflictResolution _resolveLastWriteWins(ConflictData conflict) {
    final winner = conflict.localIsNewer ? conflict.localData : conflict.serverData;
    final timestamp = conflict.localIsNewer ? conflict.localTimestamp : conflict.serverTimestamp;

    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: Map<String, dynamic>.from(winner),
      appliedStrategy: ConflictResolutionStrategy.lastWriteWins,
      resolutionNote: 'Winner determined by timestamp: ${timestamp.toIso8601String()}',
    );
  }

  ConflictResolution _resolveServerWins(ConflictData conflict) {
    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: Map<String, dynamic>.from(conflict.serverData),
      appliedStrategy: ConflictResolutionStrategy.serverWins,
      resolutionNote: 'Server version always wins',
    );
  }

  ConflictResolution _resolveClientWins(ConflictData conflict) {
    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: Map<String, dynamic>.from(conflict.localData),
      appliedStrategy: ConflictResolutionStrategy.clientWins,
      resolutionNote: 'Client version always wins',
    );
  }

  ConflictResolution _resolveMerge(ConflictData conflict) {
    final merged = <String, dynamic>{};
    final allKeys = {...conflict.localData.keys, ...conflict.serverData.keys};

    for (final key in allKeys) {
      final localValue = conflict.localData[key];
      final serverValue = conflict.serverData[key];

      if (localValue == null) {
        merged[key] = serverValue;
      } else if (serverValue == null) {
        merged[key] = localValue;
      } else if (localValue == serverValue) {
        merged[key] = localValue;
      } else if (localValue is Map && serverValue is Map) {
        merged[key] = _deepMerge(localValue, serverValue);
      } else if (localValue is List && serverValue is List) {
        merged[key] = {...localValue, ...serverValue}.toList();
      } else {
        merged[key] = conflict.localIsNewer ? localValue : serverValue;
      }
    }

    merged['version'] = conflict.localVersion > conflict.serverVersion
        ? conflict.localVersion
        : conflict.serverVersion;
    merged['updatedAt'] = DateTime.now().toIso8601String();

    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: merged,
      appliedStrategy: ConflictResolutionStrategy.merge,
      resolutionNote: 'Fields merged: ${conflict.conflictingFields.join(', ')}',
    );
  }

  Map<String, dynamic> _deepMerge(
    Map<String, dynamic> local,
    Map<String, dynamic> server,
  ) {
    final merged = <String, dynamic>{};
    final allKeys = {...local.keys, ...server.keys};

    for (final key in allKeys) {
      final localValue = local[key];
      final serverValue = server[key];

      if (localValue == null) {
        merged[key] = serverValue;
      } else if (serverValue == null) {
        merged[key] = localValue;
      } else if (localValue is Map && serverValue is Map) {
        merged[key] = _deepMerge(localValue, serverValue);
      } else if (localValue is List && serverValue is List) {
        merged[key] = [...localValue, ...serverValue];
      } else {
        merged[key] = localValue;
      }
    }

    return merged;
  }

  Future<ConflictResolution?> _resolveManual(ConflictData conflict) async {
    if (manualResolver != null) {
      return manualResolver!(conflict);
    }

    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: conflict.localData,
      appliedStrategy: ConflictResolutionStrategy.manual,
      resolutionNote: 'Manual resolution required',
      requiresManualReview: true,
    );
  }
}

class ConflictResolverFactory {
  static ConflictResolver create({
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.lastWriteWins,
    Future<ConflictResolution?> Function(ConflictData)? manualResolver,
  }) {
    return ConflictResolverImpl(
      defaultStrategy: strategy,
      manualResolver: manualResolver,
    );
  }
}