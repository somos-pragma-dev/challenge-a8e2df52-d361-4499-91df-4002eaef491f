part of 'client_viewmodel.dart';

abstract class ClientViewModelEvent extends Equatable {
  const ClientViewModelEvent();

  @override
  List<Object?> get props => [];
}

class LoadClients extends ClientViewModelEvent {
  const LoadClients();
}

class LoadClientById extends ClientViewModelEvent {
  final String clientId;

  const LoadClientById(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

class SaveClient extends ClientViewModelEvent {
  final Client client;

  const SaveClient(this.client);

  @override
  List<Object?> get props => [client];
}

class UpdateClient extends ClientViewModelEvent {
  final Client client;

  const UpdateClient(this.client);

  @override
  List<Object?> get props => [client];
}

class DeleteClient extends ClientViewModelEvent {
  final String clientId;

  const DeleteClient(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

class SearchClients extends ClientViewModelEvent {
  final String query;

  const SearchClients(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshClients extends ClientViewModelEvent {
  const RefreshClients();
}

class ConnectivityChanged extends ClientViewModelEvent {
  final ConnectivityStatus status;

  const ConnectivityChanged(this.status);

  @override
  List<Object?> get props => [status];
}