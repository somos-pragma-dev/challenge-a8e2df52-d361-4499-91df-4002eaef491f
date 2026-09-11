import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/sync/sync_bloc.dart';
import '../bloc/sync/sync_state.dart';

enum SyncIndicatorStyle { compact, detailed, animated }

class SyncIndicator extends StatelessWidget {
  final SyncIndicatorStyle style;
  final bool showLabel;
  final double size;

  const SyncIndicator({
    super.key,
    this.style = SyncIndicatorStyle.compact,
    this.showLabel = true,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, state) {
        switch (style) {
          case SyncIndicatorStyle.compact:
            return _buildCompactIndicator(state);
          case SyncIndicatorStyle.detailed:
            return _buildDetailedIndicator(context, state);
          case SyncIndicatorStyle.animated:
            return _buildAnimatedIndicator(state);
        }
      },
    );
  }

  Widget _buildCompactIndicator(SyncState state) {
    final (icon, color, tooltip) = _getSyncData(state);
    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }

  Widget _buildDetailedIndicator(BuildContext context, SyncState state) {
    final (icon, color, tooltip) = _getSyncData(state);
    final pendingCount = state is SyncInProgress
        ? (state as SyncInProgress).pendingCount
        : 0;
    final failedCount = state is SyncFailed
        ? (state as SyncFailed).failedCount
        : 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tooltip,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              if (pendingCount > 0 || failedCount > 0)
                Text(
                  '${pendingCount > 0 ? "$pendingCount pending" : ""}'
                  '${pendingCount > 0 && failedCount > 0 ? ", " : ""}'
                  '${failedCount > 0 ? "$failedCount failed" : ""}',
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIndicator(SyncState state) {
    final (icon, color, tooltip) = _getSyncData(state);
    final isSyncing = state is SyncInProgress;

    return Tooltip(
      message: tooltip,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: isSyncing
            ? _AnimatedSyncIcon(color: color, size: size)
            : Icon(icon, color: color, size: size),
      ),
    );
  }

  (IconData, Color, String) _getSyncData(SyncState state) {
    if (state is SyncInitial) {
      return (
        Icons.cloud_queue,
        Colors.grey,
        'Not synced',
      );
    } else if (state is SyncInProgress) {
      return (
        Icons.sync,
        AppConstants.primaryColor,
        'Syncing... ${state.pendingCount} items',
      );
    } else if (state is SyncSuccess) {
      return (
        Icons.cloud_done,
        Colors.green,
        'Synced successfully',
      );
    } else if (state is SyncFailed) {
      return (
        Icons.cloud_off,
        AppConstants.errorColor,
        'Sync failed - ${state.failedCount} errors',
      );
    } else if (state is SyncOffline) {
      return (
        Icons.cloud_off,
        Colors.orange,
        'Offline - changes saved locally',
      );
    } else if (state is SyncConflict) {
      return (
        Icons.warning_amber_rounded,
        Colors.purple,
        '${state.conflictCount} conflicts need resolution',
      );
    }
    return (
      Icons.cloud_queue,
      Colors.grey,
      'Unknown status',
    );
  }
}

class _AnimatedSyncIcon extends StatefulWidget {
  final Color color;
  final double size;

  const _AnimatedSyncIcon({required this.color, required this.size});

  @override
  State<_AnimatedSyncIcon> createState() => _AnimatedSyncIconState();
}

class _AnimatedSyncIconState extends State<_AnimatedSyncIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        Icons.sync,
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}

class SyncStatusBadge extends StatelessWidget {
  final String syncStatus;
  final bool showCount;
  final int? count;

  const SyncStatusBadge({
    super.key,
    required this.syncStatus,
    this.showCount = false,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = _getStatusData();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            showCount && count != null ? '$label ($count)' : label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color, String) _getStatusData() {
    switch (syncStatus) {
      case AppConstants.syncStatusSynced:
        return (Icons.check_circle, Colors.green, 'Synced');
      case AppConstants.syncStatusPending:
        return (Icons.schedule, Colors.orange, 'Pending');
      case AppConstants.syncStatusFailed:
        return (Icons.error, AppConstants.errorColor, 'Failed');
      case AppConstants.syncStatusConflict:
        return (Icons.warning, Colors.purple, 'Conflict');
      default:
        return (Icons.help, Colors.grey, 'Unknown');
    }
  }
}

class SyncProgressIndicator extends StatelessWidget {
  final double progress;
  final String? label;
  final bool showPercentage;

  const SyncProgressIndicator({
    super.key,
    required this.progress,
    this.label,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showPercentage)
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              AppConstants.primaryColor,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}