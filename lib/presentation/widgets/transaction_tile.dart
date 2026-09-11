package presentation.widgets;

import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';
import '../../core/constants/app_constants.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onSyncTap;
  final bool showSyncStatus;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.onSyncTap,
    this.showSyncStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = transaction.syncStatus == AppConstants.syncStatusPending;
    final isFailed = transaction.syncStatus == AppConstants.syncStatusFailed;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isFailed 
            ? BorderSide(color: theme.colorScheme.error, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTransactionType(context),
                  _buildAmount(context),
                ],
              ),
              const SizedBox(height: 12),
              if (transaction.description != null && 
                  transaction.description!.isNotEmpty)
                Text(
                  transaction.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimestamp(context),
                  if (showSyncStatus) _buildSyncStatus(context),
                ],
              ),
              if (isPending && onSyncTap != null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onSyncTap,
                    icon: const Icon(Icons.sync, size: 18),
                    label: const Text('Sincronizar ahora'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionType(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = transaction.transactionType.toUpperCase() == 'CREDIT' ||
        transaction.transactionType.toUpperCase() == 'DEPOSIT';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCredit 
            ? Colors.green.shade50 
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            size: 16,
            color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            transaction.transactionType.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmount(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = transaction.transactionType.toUpperCase() == 'CREDIT' ||
        transaction.transactionType.toUpperCase() == 'DEPOSIT';
    final formattedAmount = AppConstants.formatAmount(
      transaction.amount, 
      transaction.currency,
    );
    
    return Text(
      '${isCredit ? '+' : '-'}$formattedAmount',
      style: theme.textTheme.titleLarge?.copyWith(
        color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    final theme = Theme.of(context);
    final createdAt = transaction.createdAt;
    final formattedDate = '${createdAt.day.toString().padLeft(2, '0')}/'
        '${createdAt.month.toString().padLeft(2, '0')}/'
        '${createdAt.year} '
        '${createdAt.hour.toString().padLeft(2, '0')}:'
        '${createdAt.minute.toString().padLeft(2, '0')}';
    
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(width: 4),
        Text(
          formattedDate,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildSyncStatus(BuildContext context) {
    final theme = Theme.of(context);
    IconData icon;
    Color color;
    String label;
    
    switch (transaction.syncStatus) {
      case AppConstants.syncStatusPending:
        icon = Icons.cloud_queue;
        color = Colors.orange;
        label = 'Pendiente';
        break;
      case AppConstants.syncStatusInProgress:
        icon = Icons.cloud_sync;
        color = Colors.blue;
        label = 'Sincronizando';
        break;
      case AppConstants.syncStatusCompleted:
        icon = Icons.cloud_done;
        color = Colors.green;
        label = 'Sincronizado';
        break;
      case AppConstants.syncStatusFailed:
        icon = Icons.cloud_off;
        color = Colors.red;
        label = 'Fallido';
        break;
      case AppConstants.syncStatusConflict:
        icon = Icons.warning_amber;
        color = Colors.amber;
        label = 'Conflicto';
        break;
      default:
        icon = Icons.cloud_queue;
        color = Colors.grey;
        label = 'Desconocido';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}