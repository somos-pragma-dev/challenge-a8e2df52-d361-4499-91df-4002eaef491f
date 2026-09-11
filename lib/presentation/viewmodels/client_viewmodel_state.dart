part of 'client_viewmodel.dart';

enum ClientViewModelStatus {
  initial,
  loading,
  loaded,
  saving,
  saved,
  deleting,
  deleted,
  syncing,
  error,
}

class ClientViewModelState extends Equatable {
  final ClientViewModelStatus status;
  final List<Client> clients;
  final Client? selectedClient;
  final String? errorMessage;
  final bool isOnline;
  final bool hasPendingChanges;

  const ClientViewModelState({
    this.status = ClientViewModelStatus.initial,
    this.clients = const [],
    this.selectedClient,
    this.errorMessage,
    this.isOnline = false,
    this.hasPendingChanges = false,
  });

  ClientViewModelState copyWith({
    ClientViewModelStatus? status,
    List<Client>? clients,
    Client? selectedClient,
    String? errorMessage,
    bool? isOnline,
    bool? hasPendingChanges,
  }) {
    return ClientViewModelState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
      selectedClient: selectedClient ?? this.selectedClient,
      errorMessage: errorMessage ?? this.errorMessage,
      isOnline: isOnline ?? this.isOnline,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
    );
  }

  @override
  List<Object?> get props => [
        status,
        clients,
        selectedClient,
        errorMessage,
        isOnline,
        hasPendingChanges,
      ];
}