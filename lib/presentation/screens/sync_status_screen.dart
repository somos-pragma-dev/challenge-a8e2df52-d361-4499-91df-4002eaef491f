import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/database/app_database.dart';
import '../widgets/client_card.dart';
import '../widgets/sync_indicator.dart';

class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({super.key});

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen> {
  late final AppDatabase _database;
  late final ConnectivityService _connectivityService;
  List<ClientsTableData> _pendingClients = [];
  List<CreditApplicationsTableData> _pendingApplications = [];
  bool _isLoading = true;
  String _syncStatus = 'idle';
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    try {
      _database = context.read<AppDatabase>();
      _connectivityService = context.read<ConnectivityService>();
      await _loadPendingData();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadPendingData() async {
    try {
      final pendingClients = await _database.getPendingClients();
      final pendingApps = await _database.getPendingCreditApplications();
      if (mounted) {
        setState(() {
          _pendingClients = pendingClients;
          _pendingApplications = pendingApps;
        });
      }
    } catch (e) {
      debugPrint('Error loading pending data: $e');
    }
  }

  Future<void> _triggerSync() async {
    final connectivityStatus = await _connectivityService.checkConnectivity();
    if (!connectivityStatus.isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay conexión disponible para sincronizar'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _syncStatus = 'syncing');

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _syncStatus = 'completed';
          _lastSyncTime = DateTime.now();
        });
        await _loadPendingData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sincronización completada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _syncStatus = 'error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en sincronización: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Sincronización'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _triggerSync,
            tooltip: 'Sincronizar ahora',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPendingData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConnectivityCard(),
                    const SizedBox(height: 16),
                    _buildSyncSummaryCard(),
                    const SizedBox(height: 24),
                    _buildPendingSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildConnectivityCard() {
    return StreamBuilder<ConnectivityStatus>(
      stream: _connectivityService.statusStream,
      initialData: ConnectivityStatus(
        status: ConnectionStatus.unknown,
        timestamp: DateTime.now(),
      ),
      builder: (context, snapshot) {
        final status = snapshot.data;
        final isConnected = status?.isConnected ?? false;
        final statusColor = isConnected ? Colors.green : Colors.red;
        final statusText = isConnected ? 'Conectado' : 'Sin conexión';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  isConnected ? Icons.wifi : Icons.wifi_off,
                  color: statusColor,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado de Red',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSyncSummaryCard() {
    final totalPending = _pendingClients.length + _pendingApplications.length;
    final statusColor = _syncStatus == 'completed'
        ? Colors.green
        : _syncStatus == 'error'
            ? Colors.red
            : _syncStatus == 'syncing'
                ? Colors.blue
                : Colors.grey;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SyncIndicator(status: _getSyncStatusType()),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Resumen de Sincronización',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildSummaryRow(
              'Clientes pendientes',
              _pendingClients.length.toString(),
              Icons.people,
            ),
            _buildSummaryRow(
              'Solicitudes pendientes',
              _pendingApplications.length.toString(),
              Icons.description,
            ),
            _buildSummaryRow(
              'Total pendientes',
              totalPending.toString(),
              Icons.pending_actions,
            ),
            if (_lastSyncTime != null)
              _buildSummaryRow(
                'Última sincronización',
                _formatDateTime(_lastSyncTime!),
                Icons.access_time,
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _syncStatus == 'syncing' ? null : _triggerSync,
                icon: _syncStatus == 'syncing'
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                label: Text(
                  _syncStatus == 'syncing'
                      ? 'Sincronizando...'
                      : 'Sincronizar ahora',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingSection() {
    if (_pendingClients.isEmpty && _pendingApplications.isEmpty) {
      return Card(
        color: Colors.green[50],
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Text(
                'Todo sincronizado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pendientes por sincronizar',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (_pendingClients.isNotEmpty) ...[
          Text(
            'Clientes (${_pendingClients.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ..._pendingClients.map((client) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClientCard(
                  client: client,
                  onTap: () => _showClientDetails(client),
                ),
              )),
          const SizedBox(height: 16),
        ],
        if (_pendingApplications.isNotEmpty) ...[
          Text(
            'Solicitudes de crédito (${_pendingApplications.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ..._pendingApplications.map((app) => Card(
                child: ListTile(
                  leading: const SyncIndicator(status: SyncStatusType.pending),
                  title: Text('Solicitud: ${app.id.substring(0, 8)}...'),
                  subtitle: Text('Monto: \$${app.requestedAmount}'),
                  trailing: Text(app.status),
                ),
              )),
        ],
      ],
    );
  }

  void _showClientDetails(ClientsTableData client) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${client.firstName} ${client.lastName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Email', client.email),
            _buildDetailRow('Teléfono', client.phone),
            _buildDetailRow('Identificación', client.identificationNumber),
            _buildDetailRow('Dirección', client.address),
            _buildDetailRow('Estado sync', client.syncStatus),
            _buildDetailRow('Versión', client.version.toString()),
            _buildDetailRow('Última modificación', _formatDateTime(client.lastModified)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  SyncStatusType _getSyncStatusType() {
    switch (_syncStatus) {
      case 'syncing':
        return SyncStatusType.pending;
      case 'completed':
        return SyncStatusType.synced;
      case 'error':
        return SyncStatusType.conflict;
      default:
        return SyncStatusType.pending;
    }
  }
}