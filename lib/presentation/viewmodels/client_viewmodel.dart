package credit_field_app.presentation.viewmodels;

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:credit_field_app/core/error/failures.dart';
import 'package:credit_field_app/core/network/connectivity_service.dart';
import 'package:credit_field_app/domain/entities/client.dart';
import 'package:credit_field_app/domain/repositories/client_repository.dart';

part 'client_viewmodel_event.dart';
part 'client_viewmodel_state.dart';

class ClientViewModel extends Bloc<ClientViewModelEvent, ClientViewModelState> {
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;
  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;

  ClientViewModel({
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ClientViewModelState()) {
    on<LoadClients>(_onLoadClients);
    on<LoadClientById>(_onLoadClientById);
    on<SaveClient>(_onSaveClient);
    on<DeleteClient>(_onDeleteClient);
    on<UpdateClient>(_onUpdateClient);
    on<SearchClients>(_onSearchClients);
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<RefreshClients>(_onRefreshClients);

    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) => add(ConnectivityChanged(status)),
    );
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.loading));
    
    final result = await _clientRepository.getClients();
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (clients) => emit(state.copyWith(
        status: ClientViewModelStatus.loaded,
        clients: clients,
      )),
    );
  }

  Future<void> _onLoadClientById(
    LoadClientById event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.loading));
    
    final result = await _clientRepository.getClientById(event.clientId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (client) => emit(state.copyWith(
        status: ClientViewModelStatus.loaded,
        selectedClient: client,
      )),
    );
  }

  Future<void> _onSaveClient(
    SaveClient event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.saving));
    
    final result = await _clientRepository.saveClient(event.client);
    await result.fold(
      (failure) async => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (savedClient) async {
        final updatedClients = List<Client>.from(state.clients)..add(savedClient);
        emit(state.copyWith(
          status: ClientViewModelStatus.saved,
          clients: updatedClients,
          selectedClient: savedClient,
        ));
        
        if (state.isOnline) {
          add(const SyncClients());
        }
      },
    );
  }

  Future<void> _onUpdateClient(
    UpdateClient event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.saving));
    
    final result = await _clientRepository.updateClient(event.client);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (updatedClient) {
        final updatedClients = state.clients.map((c) {
          return c.id == updatedClient.id ? updatedClient : c;
        }).toList();
        emit(state.copyWith(
          status: ClientViewModelStatus.saved,
          clients: updatedClients,
          selectedClient: updatedClient,
        ));
        
        if (state.isOnline) {
          add(const SyncClients());
        }
      },
    );
  }

  Future<void> _onDeleteClient(
    DeleteClient event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.loading));
    
    final result = await _clientRepository.deleteClient(event.clientId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedClients = state.clients
            .where((c) => c.id != event.clientId)
            .toList();
        emit(state.copyWith(
          status: ClientViewModelStatus.deleted,
          clients: updatedClients,
        ));
      },
    );
  }

  Future<void> _onSearchClients(
    SearchClients event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.loading));
    
    final result = await _clientRepository.searchClients(event.query);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (clients) => emit(state.copyWith(
        status: ClientViewModelStatus.loaded,
        clients: clients,
      )),
    );
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ClientViewModelState> emit,
  ) {
    final isOnline = event.status.isConnected;
    emit(state.copyWith(isOnline: isOnline));
    
    if (isOnline && state.hasPendingChanges) {
      add(const SyncClients());
    }
  }

  Future<void> _onRefreshClients(
    RefreshClients event,
    Emitter<ClientViewModelState> emit,
  ) async {
    if (!state.isOnline) {
      emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: 'No hay conexión para actualizar desde el servidor',
      ));
      return;
    }
    
    emit(state.copyWith(status: ClientViewModelStatus.syncing));
    
    final result = await _clientRepository.syncClients();
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (syncedClients) => emit(state.copyWith(
        status: ClientViewModelStatus.loaded,
        clients: syncedClients,
      )),
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}

class SyncClients extends ClientViewModelEvent {
  const SyncClients();
}