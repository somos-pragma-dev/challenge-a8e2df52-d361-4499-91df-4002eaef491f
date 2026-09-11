package domain.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/client.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getClients();
  Future<Either<Failure, Client>> getClientById(String id);
  Future<Either<Failure, Client>> saveClient(Client client);
  Future<Either<Failure, Client>> updateClient(Client client);
  Future<Either<Failure, void>> deleteClient(String id);
  Future<Either<Failure, List<Client>>> getPendingClients();
  Future<Either<Failure, void>> syncClients();
  Stream<List<Client>> watchAllClients();
  Stream<List<Client>> watchPendingClients();
}

class ClientFilter extends Equatable {
  final String? searchQuery;
  final ClientSyncStatus? syncStatus;
  final DateTime? fromDate;
  final DateTime? toDate;

  const ClientFilter({
    this.searchQuery,
    this.syncStatus,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [searchQuery, syncStatus, fromDate, toDate];
}

enum ClientSyncStatus { pending, synced, conflict }