import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';
import 'sync_indicator.dart';

class ClientCard extends StatelessWidget {
  final ClientsTableData client;
  final VoidCallback? onTap;
  final VoidCallback? onSyncTap;
  final bool showSyncAction;

  const ClientCard({
    super.key,
    required this.client,
    this.onTap,
    this.onSyncTap,
    this.showSyncAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildAvatar(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildName(context),
                    const SizedBox(height: 4),
                    _buildIdentification(),
                    const SizedBox(height: 4),
                    _buildContactInfo(),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SyncIndicator(status: _parseSyncStatus(client.syncStatus)),
                  if (showSyncAction) ...[
                    const SizedBox(height: 8),
                    _buildSyncButton(context),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final initials = _getInitials();
    final colorScheme = Theme.of(context).colorScheme;
    
    return CircleAvatar(
      radius: 24,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        initials,
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Text(
      '${client.firstName} ${client.lastName}',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildIdentification() {
    return Row(
      children: [
        const Icon(Icons.badge, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          client.identificationNumber,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Row(
      children: [
        if (client.phone.isNotEmpty) ...[
          const Icon(Icons.phone, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              client.phone,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        if (client.email.isNotEmpty) ...[
          const SizedBox(width: 8),
          const Icon(Icons.email, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              client.email,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSyncButton(BuildContext context) {
    final isPending = client.syncStatus == 'pending';
    return InkWell(
      onTap: onSyncTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPending ? Colors.orange.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPending ? Colors.orange : Colors.green,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPending ? Icons.cloud_upload : Icons.cloud_done,
              size: 14,
              color: isPending ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 4),
            Text(
              isPending ? 'Subir' : 'Sincronizado',
              style: TextStyle(
                fontSize: 11,
                color: isPending ? Colors.orange : Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    final firstInitial = client.firstName.isNotEmpty 
        ? client.firstName[0].toUpperCase() 
        : '';
    final lastInitial = client.lastName.isNotEmpty 
        ? client.lastName[0].toUpperCase() 
        : '';
    return '$firstInitial$lastInitial';
  }

  SyncStatusType _parseSyncStatus(String status) {
    switch (status.toLowerCase()) {
      case 'synced':
        return SyncStatusType.synced;
      case 'conflict':
        return SyncStatusType.conflict;
      case 'pending':
      default:
        return SyncStatusType.pending;
    }
  }
}

class ClientCardSkeleton extends StatelessWidget {
  const ClientCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 150,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 100,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}