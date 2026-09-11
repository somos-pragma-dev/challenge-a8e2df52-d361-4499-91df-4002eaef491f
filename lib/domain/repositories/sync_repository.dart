abstract class SyncRepository {
  Future<List<SyncStatusEntity>> getPendingSyncItems();
}

extension SyncRepositoryExtension on SyncRepository {
  Future<List<SyncStatusEntity>> getPendingSyncItems() async {
    // Default implementation - override in implementation class
    return [];
  }
}