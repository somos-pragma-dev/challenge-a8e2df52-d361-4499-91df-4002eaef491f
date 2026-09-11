package lib.domain.entities;

import 'package:equatable/equatable.dart';

abstract class BaseEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  const BaseEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  BaseEntity copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });

  Map<String, dynamic> toMap();

  @override
  List<Object?> get props => [id, createdAt, updatedAt, version];

  @override
  bool get stringify => true;
}

class BaseEntityImpl implements BaseEntity {
  @override
  final String id;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  @override
  final int version;

  const BaseEntityImpl({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  @override
  BaseEntityImpl copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return BaseEntityImpl(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
    };
  }

  factory BaseEntityImpl.fromMap(Map<String, dynamic> map) {
    return BaseEntityImpl(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      version: map['version'] as int,
    );
  }

  @override
  List<Object?> get props => [id, createdAt, updatedAt, version];

  @override
  bool get stringify => true;
}