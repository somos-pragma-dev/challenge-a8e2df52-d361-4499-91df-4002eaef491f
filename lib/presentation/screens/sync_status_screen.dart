import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:offline_field_app/domain/entities/sync_record.dart';
import 'package:offline_field_app/presentation/providers/sync_provider.dart';
import 'package:offline_field_app/presentation/widgets/sync_progress_indicator.dart';
import 'package:offline_field_app/core/constants/app_constants.dart';
import 'package:offline_field_app/core/network/network_info.dart';

class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({super.key});

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSyncStatus();
    });
  }

  Future<void> _loadSyncStatus() async {
    final syncProvider = context.read<SyncProvider>();
    await syncProvider.loadPendingOperations();
    await syncProvider.loadConflicts();
  }

  Future<void> _triggerSync() async {
    final syncProvider = context.read<SyncProvider>();
    final networkInfo = context.read<NetworkInfo>();

    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay conexión a internet'),
          backgroundColor: Color(AppConstants.warningColor),
        ),
      );
      return;
    }

    await syncProvider.syncAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de sincronización'),
        backgroundColor: Color(AppConstants.primaryColor),
      ),
      body: Consumer<SyncProvider>(
        builder: (context, provider, child) {
          if (provider.isSyncing) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SyncProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Sincronizando...'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadSyncStatus,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSyncSummaryCard(provider),
                const SizedBox(height: 16),
                _buildPendingOperationsSection(provider),
                const SizedBox(height: 16),
                _buildConflictsSection(provider),
                const SizedBox(height: 24),
                _buildSyncButton(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSyncSummaryCard(SyncProvider provider) {
    final pendingCount = provider.pendingOperations.length;
    final conflictCount = provider.conflicts.length;
    final lastSync = provider.lastSyncTime;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sync,
                  color: Color(AppConstants.primaryColor),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Resumen de sincronización',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              Icons.pending_actions,
              'Operaciones pendientes',
              pendingCount.toString(),
              pendingCount > 0 ? Color(AppConstants.warningColor) : Color(AppConstants.successColor),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              Icons.warning_amber,
              'Conflictos pendientes',
              conflictCount.toString(),
              conflictCount > 0 ? Color(AppConstants.errorColor) : Color(AppConstants.successColor),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              Icons.access_time,
              'Última sincronización',
              lastSync != null
                  ? '${lastSync.day}/${lastSync.month}/${lastSync.year} ${lastSync.hour}:${lastSync.minute.toString().padLeft(2, '0')}'
                  : 'Nunca',
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildPendingOperationsSection(SyncProvider provider) {
    final operations = provider.pendingOperations;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.pending_outlined,
                  color: Color(AppConstants.warningColor),
                ),
                const SizedBox(width: 8),
                Text(
                  'Operaciones pendientes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Divider(),
            if (operations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text('No hay operaciones pendientes'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: operations.length > 5 ? 5 : operations.length,
                itemBuilder: (context, index) {
                  final operation = operations[index];
                  return _buildOperationTile(operation);
                },
              ),
            if (operations.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'y ${operations.length - 5} más...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationTile(SyncRecord operation) {
    final statusColor = _getStatusColor(operation.syncStatus);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getOperationIcon(operation.operationType),
          color: statusColor,
        ),
      ),
      title: Text(
        operation.entityType ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'ID: ${operation.entityId}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Chip(
        label: Text(
          operation.syncStatus,
          style: const TextStyle(fontSize: 10),
        ),
        backgroundColor: statusColor.withOpacity(0.2),
      ),
    );
  }

  Widget _buildConflictsSection(SyncProvider provider) {
    final conflicts = provider.conflicts;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Color(AppConstants.errorColor),
                ),
                const SizedBox(width: 8),
                Text(
                  'Conflictos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Divider(),
            if (conflicts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text('No hay conflictos'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: conflicts.length,
                itemBuilder: (context, index) {
                  final conflict = conflicts[index];
                  return _buildConflictTile(conflict, provider);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConflictTile(SyncRecord conflict, SyncProvider provider) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(AppConstants.errorColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.warning,
          color: Color(AppConstants.errorColor),
        ),
      ),
      title: Text(
        conflict.entityType ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'ID: ${conflict.entityId}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () => _resolveConflict(conflict, 'server'),
            tooltip: 'Usar versión del servidor',
          ),
          IconButton(
            icon: const Icon(Icons.restore, color: Colors.blue),
            onPressed: () => _resolveConflict(conflict, 'client'),
            tooltip: 'Mantener versión local',
          ),
        ],
      ),
    );
  }

  Future<void> _resolveConflict(SyncRecord conflict, String resolution) async {
    final provider = context.read<SyncProvider>();
    await provider.resolveConflict(conflict.entityId, resolution);
    await _loadSyncStatus();
  }

  Widget _buildSyncButton(SyncProvider provider) {
    return ElevatedButton.icon(
      onPressed: provider.isSyncing ? null : _triggerSync,
      icon: const Icon(Icons.sync),
      label: const Text('Sincronizar ahora'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.syncStatusPending:
        return Color(AppConstants.warningColor);
      case AppConstants.syncStatusInProgress:
        return Colors.blue;
      case AppConstants.syncStatusCompleted:
        return Color(AppConstants.successColor);
      case AppConstants.syncStatusFailed:
        return Color(AppConstants.errorColor);
      case AppConstants.syncStatusConflict:
        return Color(AppConstants.errorColor);
      default:
        return Colors.grey;
    }
  }

  IconData _getOperationIcon(String? operationType) {
    switch (operationType) {
      case 'create':
        return Icons.add_circle;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      default:
        return Icons.help_outline;
    }
  }
}