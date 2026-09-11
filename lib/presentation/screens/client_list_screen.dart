import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/client_repository.dart';
import '../../core/network/connectivity_service.dart';
import '../widgets/client_card.dart';
import '../widgets/sync_indicator.dart';
import '../viewmodels/client_viewmodel.dart';

abstract class ClientListEvent extends Equatable {
  const ClientListEvent();
  @override
  List<Object?> get props => [];
}

class LoadClients extends ClientListEvent {
  const LoadClients();
}

class RefreshClients extends ClientListEvent {
  const RefreshClients();
}

class SyncClientsRequested extends ClientListEvent {
  const SyncClientsRequested();
}

class ClientListState extends Equatable {
  final List<Client> clients;
  final bool isLoading;
  final String? errorMessage;
  final bool isSyncing;
  final int pendingCount;
  final bool isConnected;
  final DateTime? lastSyncTime;

  const ClientListState({
    this.clients = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isSyncing = false,
    this.pendingCount = 0,
    this.isConnected = true,
    this.lastSyncTime,
  });

  ClientListState copyWith({
    List<Client>? clients,
    bool? isLoading,
    String? errorMessage,
    bool? isSyncing,
    int? pendingCount,
    bool? isConnected,
    DateTime? lastSyncTime,
  }) {
    return ClientListState(
      clients: clients ?? this.clients,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      isConnected: isConnected ?? this.isConnected,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  List<Object?> get props => [
        clients,
        isLoading,
        errorMessage,
        isSyncing,
        pendingCount,
        isConnected,
        lastSyncTime,
      ];
}

class ClientListBloc extends Bloc<ClientListEvent, ClientListState> {
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;

  ClientListBloc({
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ClientListState()) {
    on<LoadClients>(_onLoadClients);
    on<RefreshClients>(_onRefreshClients);
    on<SyncClientsRequested>(_onSyncClientsRequested);
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final clientsResult = await _clientRepository.getClients();
      final pendingResult = await _clientRepository.getPendingClients();
      final isConnected = await _connectivityService.hasActiveConnection();

      clientsResult.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (clients) {
          final pending = pendingResult.fold(
            (failure) => <Client>[],
            (list) => list,
          );
          emit(state.copyWith(
            isLoading: false,
            clients: clients,
            pendingCount: pending.length,
            isConnected: isConnected,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar clientes: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefreshClients(
    RefreshClients event,
    Emitter<ClientListState> emit,
  ) async {
    add(const LoadClients());
  }

  Future<void> _onSyncClientsRequested(
    SyncClientsRequested event,
    Emitter<ClientListState> emit,
  ) async {
    if (!state.isConnected) {
      emit(state.copyWith(
        errorMessage: 'Sin conexión. No se puede sincronizar.',
      ));
      return;
    }

    emit(state.copyWith(isSyncing: true, errorMessage: null));

    try {
      final syncResult = await _clientRepository.syncClients();

      syncResult.fold(
        (failure) => emit(state.copyWith(
          isSyncing: false,
          errorMessage: 'Error de sincronización: ${failure.message}',
        )),
        (_) {
          add(const LoadClients());
          emit(state.copyWith(
            isSyncing: false,
            lastSyncTime: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isSyncing: false,
        errorMessage: 'Error al sincronizar: ${e.toString()}',
      ));
    }
  }
}

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClientListBloc>().add(const LoadClients());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          BlocBuilder<ClientListBloc, ClientListState>(
            builder: (context, state) {
              return SyncIndicator(
                pendingCount: state.pendingCount,
                isSyncing: state.isSyncing,
                isConnected: state.isConnected,
                onSyncPressed: () {
                  context.read<ClientListBloc>().add(const SyncClientsRequested());
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ClientListBloc, ClientListState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red.shade700,
                action: SnackBarAction(
                  label: 'Reintentar',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<ClientListBloc>().add(const LoadClients());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.clients.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.clients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay clientes registrados',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para agregar el primer cliente',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ClientListBloc>().add(const RefreshClients());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.clients.length,
              itemBuilder: (context, index) {
                final client = state.clients[index];
                return ClientCard(
                  client: client,
                  onTap: () => _navigateToClientForm(context, client: client),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToClientForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToClientForm(BuildContext context, {Client? client}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClientFormScreen(client: client),
      ),
    ).then((_) {
      context.read<ClientListBloc>().add(const LoadClients());
    });
  }
}

class ClientFormScreen extends StatelessWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}