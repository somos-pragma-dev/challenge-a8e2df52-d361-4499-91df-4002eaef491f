package domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../core/error/failures.dart';
import '../entities/client.dart';
import '../entities/sync_status.dart';
import '../repositories/client_repository.dart';

class SaveClient {
  final ClientRepository repository;
  final Uuid _uuid;

  SaveClient(this.repository) : _uuid = const Uuid();

  Future<Either<Failure, Client>> call(SaveClientParams params) async {
    final now = DateTime.now();
    
    final clientId = params.id ?? _uuid.v4();
    
    final validationResult = _validateClientParams(params);
    if (validationResult != null) {
      return Left(validationResult);
    }

    final client = Client(
      id: clientId,
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phone: params.phone,
      address: params.address,
      identificationNumber: params.identificationNumber,
      syncStatus: SyncStatus.pending,
      version: 1,
      lastModified: now,
      createdAt: now,
      syncedAt: null,
    );

    return repository.saveClient(client);
  }

  ValidationFailure? _validateClientParams(SaveClientParams params) {
    if (params.firstName == null || params.firstName!.trim().isEmpty) {
      return const ValidationFailure.required('firstName');
    }
    if (params.lastName == null || params.lastName!.trim().isEmpty) {
      return const ValidationFailure.required('lastName');
    }
    if (params.phone == null || params.phone!.trim().isEmpty) {
      return const ValidationFailure.required('phone');
    }
    if (params.identificationNumber == null || params.identificationNumber!.trim().isEmpty) {
      return const ValidationFailure.required('identificationNumber');
    }
    if (params.email != null && params.email!.isNotEmpty) {
      if (!_isValidEmail(params.email!)) {
        return ValidationFailure.invalidFormat('email', 'a valid email format');
      }
    }
    return null;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}

class SaveClientParams extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;
  final String? email;
  final String phone;
  final String? address;
  final String identificationNumber;

  const SaveClientParams({
    this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phone,
    this.address,
    required this.identificationNumber,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
      ];
}

class UpdateClient {
  final ClientRepository repository;

  UpdateClient(this.repository);

  Future<Either<Failure, Client>> call(UpdateClientParams params) async {
    final existingResult = await repository.getClientById(params.id);
    
    return existingResult.fold(
      (failure) => Left(failure),
      (existingClient) async {
        final now = DateTime.now();
        final updatedClient = existingClient.copyWith(
          firstName: params.firstName,
          lastName: params.lastName,
          email: params.email,
          phone: params.phone,
          address: params.address,
          identificationNumber: params.identificationNumber,
          syncStatus: SyncStatus.pending,
          version: existingClient.version + 1,
          lastModified: now,
        );
        
        return repository.saveClient(updatedClient);
      },
    );
  }
}

class UpdateClientParams extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String phone;
  final String? address;
  final String identificationNumber;

  const UpdateClientParams({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phone,
    this.address,
    required this.identificationNumber,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
      ];
}