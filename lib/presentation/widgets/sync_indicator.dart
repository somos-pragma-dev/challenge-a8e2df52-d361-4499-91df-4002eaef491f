import 'package:flutter/material.dart';

enum SyncStatusType {
  synced,
  pending,
  conflict,
}

class SyncIndicator extends StatelessWidget {
  final SyncStatusType status;
  final double size;
  final bool showLabel;
  final bool animate;

  const SyncIndicator({
    super.key,
    required this.status,
    this.size = 24,
    this.showLabel = false,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(config),
          const SizedBox(width: 8),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return _buildIcon(config);
  }

  Widget _buildIcon(StatusConfig config) {
    if (animate && status == SyncStatusType.pending) {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(config.color),
        ),
      );
    }

    return Tooltip(
      message: config.tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: config.color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          config.icon,
          size: size * 0.6,
          color: config.color,
        ),
      ),
    );
  }

  StatusConfig _getStatusConfig() {
    switch (status) {
      case SyncStatusType.synced:
        return StatusConfig(
          icon: Icons.cloud_done,
          color: const Color(0xFF4CAF50),
          label: 'Sincronizado',
          tooltip: 'Datos sincronizados con el servidor',
        );
      case SyncStatusType.pending:
        return StatusConfig(
          icon: Icons.cloud_upload,
          color: const Color(0xFFFF9800),
          label: 'Pendiente',
          tooltip: 'Esperando para sincronizar',
        );
      case SyncStatusType.conflict:
        return StatusConfig(
          icon: Icons.warning,
          color: const Color(0xFFF44336),
          label: 'Conflicto',
          tooltip: 'Conflicto de datos detectado',
        );
    }
  }
}

class StatusConfig {
  final IconData icon;
  final Color color;
  final String label;
  final String tooltip;

  const StatusConfig({
    required this.icon,
    required this.color,
    required this.label,
    required this.tooltip,
  });
}

class SyncStatusBadge extends StatelessWidget {
  final int pendingCount;
  final int syncedCount;
  final int conflictCount;

  const SyncStatusBadge({
    super.key,
    required this.pendingCount,
    required this.syncedCount,
    required this.conflictCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCountBadge(
            count: pendingCount,
            status: SyncStatusType.pending,
          ),
          const SizedBox(width: 8),
          _buildCountBadge(
            count: syncedCount,
            status: SyncStatusType.synced,
          ),
          if (conflictCount > 0) ...[
            const SizedBox(width: 8),
            _buildCountBadge(
              count: conflictCount,
              status: SyncStatusType.conflict,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountBadge({required int count, required SyncStatusType status}) {
    final config = _getConfigForStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 14, color: config.color),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              color: config.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  StatusConfig _getConfigForStatus(SyncStatusType status) {
    switch (status) {
      case SyncStatusType.synced:
        return const StatusConfig(
          icon: Icons.cloud_done,
          color: Color(0xFF4CAF50),
          label: 'Sincronizado',
          tooltip: '',
        );
      case SyncStatusType.pending:
        return const StatusConfig(
          icon: Icons.cloud_upload,
          color: Color(0xFFFF9800),
          label: 'Pendiente',
          tooltip: '',
        );
      case SyncStatusType.conflict:
        return const StatusConfig(
          icon: Icons.warning,
          color: Color(0xFFF44336),
          label: 'Conflicto',
          tooltip: '',
        );
    }
  }
}