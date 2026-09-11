part of 'sync_viewmodel.dart';

abstract class SyncViewModelEvent extends Equatable {
  const SyncViewModelEvent();

  @override
  List<Object?> get props => [];
}

class StartSync extends SyncViewModelEvent {
  const StartSync();
}

class StopSync extends SyncViewModelEvent {
  const StopSync();
}

class CheckSyncStatus extends SyncViewModelEvent {
  const CheckSyncStatus();
}

class ResolveConflict extends SyncViewModelEvent {
  final String conflictId;
  final ConflictResolution resolution;

  const ResolveConflict({
    required this.conflictId,
    required this.resolution,
  });

  @override
  List<Object?> get props => [conflictId, resolution];
}

class SyncConnectivityChanged extends SyncViewModelEvent {
  final ConnectivityStatus status;

  const SyncConnectivityChanged(this.status);

  @override
  List<Object?> get props => [status];
}

class StartPeriodicSync extends SyncViewModelEvent {
  final Duration interval;

  const StartPeriodicSync({this.interval = const Duration(minutes: 5)});

  @override
  List<Object?> get props => [interval];
}

class StopPeriodicSync extends SyncViewModelEvent {
  const StopPeriodicSync();
}

class ForceSyncAll extends SyncViewModelEvent {
  const ForceSyncAll();
}

class ClearSyncHistory extends SyncViewModelEvent {
  const ClearSyncHistory();
}