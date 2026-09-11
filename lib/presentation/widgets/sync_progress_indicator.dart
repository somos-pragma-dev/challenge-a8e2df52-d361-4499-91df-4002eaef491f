package presentation.widgets;

import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

enum SyncIndicatorStyle {
  compact,
  expanded,
  circular,
  linear,
}

class SyncProgressIndicator extends StatelessWidget {
  final int totalItems;
  final int processedItems;
  final int failedItems;
  final String? currentOperation;
  final SyncIndicatorStyle style;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final bool showDetails;

  const SyncProgressIndicator({
    super.key,
    required this.totalItems,
    required this.processedItems,
    this.failedItems = 0,
    this.currentOperation,
    this.style = SyncIndicatorStyle.expanded,
    this.onCancel,
    this.onRetry,
    this.showDetails = true,
  });

  double get progress => totalItems > 0 ? processedItems / totalItems : 0.0;
  bool get isComplete => processedItems >= totalItems;
  bool get hasFailures => failedItems > 0;
  
  @override
  Widget build(BuildContext context) {
    switch (style) {
      case SyncIndicatorStyle.compact:
        return _buildCompactIndicator(context);
      case SyncIndicatorStyle.expanded:
        return _buildExpandedIndicator(context);
      case SyncIndicatorStyle.circular:
        return _buildCircularIndicator(context);
      case SyncIndicatorStyle.linear:
        return _buildLinearIndicator(context);
    }
  }

  Widget _buildCompactIndicator(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: hasFailures 
            ? Colors.orange.shade50 
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasFailures 
              ? Colors.orange.shade200 
              : Colors.blue.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isComplete)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  hasFailures ? Colors.orange : Colors.blue,
                ),
              ),
            )
          else
            Icon(
              hasFailures ? Icons.warning_amber : Icons.check_circle,
              size: 16,
              color: hasFailures ? Colors.orange : Colors.green,
            ),
          const SizedBox(width: 8),
          Text(
            '$processedItems/$totalItems',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: hasFailures 
                  ? Colors.orange.shade700 
                  : Colors.blue.shade700,
            ),
          ),
          if (hasFailures) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.error_outline,
              size: 14,
              color: Colors.orange.shade700,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedIndicator(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isComplete 
                      ? (hasFailures ? Icons.sync_problem : Icons.sync)
                      : Icons.sync,
                  color: hasFailures 
                      ? Colors.orange 
                      : Colors.blue,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isComplete 
                            ? (hasFailures 
                                ? 'Sincronización completada con errores'
                                : 'Sincronización completada')
                            : 'Sincronizando...',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentOperation != null && showDetails)
                        Text(
                          currentOperation!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: hasFailures 
                        ? Colors.orange 
                        : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  hasFailures ? Colors.orange : Colors.blue,
                ),
              ),
            ),
            if (showDetails) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    Icons.check_circle_outline,
                    'Procesados',
                    processedItems.toString(),
                    Colors.green,
                  ),
                  _buildStatItem(
                    context,
                    Icons.pending_outlined,
                    'Pendientes',
                    (totalItems - processedItems).toString(),
                    Colors.grey,
                  ),
                  _buildStatItem(
                    context,
                    Icons.error_outline,
                    'Fallidos',
                    failedItems.toString(),
                    Colors.red,
                  ),
                ],
              ),
            ],
            if (!isComplete && onCancel != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: const Text('Cancelar sincronización'),
                ),
              ),
            ],
            if (isComplete && hasFailures && onRetry != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar sincronización'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularIndicator(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              hasFailures ? Colors.orange : Colors.blue,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isComplete)
                Icon(
                  hasFailures ? Icons.warning_amber : Icons.check,
                  color: hasFailures ? Colors.orange : Colors.green,
                  size: 20,
                )
              else
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinearIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentOperation ?? 'Sincronizando...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '$processedItems/$totalItems',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              hasFailures ? Colors.orange : Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}