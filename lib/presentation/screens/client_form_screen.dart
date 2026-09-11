import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';

abstract class ClientFormEvent extends Equatable {
  const ClientFormEvent();
  @override
  List<Object?> get props => [];
}

class SaveClientRequested extends ClientFormEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String identificationNumber;

  const SaveClientRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.identificationNumber,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
      ];
}

class UpdateClientRequested extends ClientFormEvent {
  final Client client;

  const UpdateClientRequested({required this.client});

  @override
  List<Object?> get props => [client];
}

class ValidateField extends ClientFormEvent {
  final String fieldName;
  final String value;

  const ValidateField({required this.fieldName, required this.value});

  @override
  List<Object?> get props => [fieldName, value];
}

class ResetForm extends ClientFormEvent {
  const ResetForm();
}

class ClientFormState extends Equatable {
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final Client? savedClient;
  final bool isOffline;

  const ClientFormState({
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.savedClient,
    this.isOffline = false,
  });

  ClientFormState copyWith({
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    Client? savedClient,
    bool? isOffline,
  }) {
    return ClientFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      savedClient: savedClient ?? this.savedClient,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSaved,
        errorMessage,
        fieldErrors,
        savedClient,
        isOffline,
      ];
}

class ClientFormBloc extends Bloc<ClientFormEvent, ClientFormState> {
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;

  ClientFormBloc({
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ClientFormState()) {
    on<SaveClientRequested>(_onSaveClient);
    on<UpdateClientRequested>(_onUpdateClient);
    on<ValidateField>(_onValidateField);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onSaveClient(
    SaveClientRequested event,
    Emitter<ClientFormState> emit,
  ) async {
    final validationErrors = _validateClientData(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      phone: event.phone,
      identificationNumber: event.identificationNumber,
    );

    if (validationErrors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: validationErrors));
      return;
    }

    emit(state.copyWith(isLoading: true, fieldErrors: {}));

    try {
      final isConnected = await _connectivityService.hasActiveConnection();
      final client = Client(
        id: '',
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phone: event.phone,
        address: event.address,
        identificationNumber: event.identificationNumber,
        syncStatus: ClientSyncStatus.pending,
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final result = await _clientRepository.saveClient(client);

      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (savedClient) => emit(state.copyWith(
          isLoading: false,
          isSaved: true,
          savedClient: savedClient,
          isOffline: !isConnected,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al guardar cliente: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateClient(
    UpdateClientRequested event,
    Emitter<ClientFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final isConnected = await _connectivityService.hasActiveConnection();
      final updatedClient = event.client.copyWith(
        syncStatus: ClientSyncStatus.pending,
        version: event.client.version + 1,
        lastModified: DateTime.now(),
      );

      final result = await _clientRepository.updateClient(updatedClient);

      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (client) => emit(state.copyWith(
          isLoading: false,
          isSaved: true,
          savedClient: client,
          isOffline: !isConnected,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al actualizar cliente: ${e.toString()}',
      ));
    }
  }

  void _onValidateField(
    ValidateField event,
    Emitter<ClientFormState> emit,
  ) {
    final errors = Map<String, String>.from(state.fieldErrors);
    final error = _validateSingleField(event.fieldName, event.value);
    if (error != null) {
      errors[event.fieldName] = error;
    } else {
      errors.remove(event.fieldName);
    }
    emit(state.copyWith(fieldErrors: errors));
  }

  void _onResetForm(ResetForm event, Emitter<ClientFormState> emit) {
    emit(const ClientFormState());
  }

  Map<String, String> _validateClientData({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String identificationNumber,
  }) {
    final errors = <String, String>{};

    final firstNameError = _validateSingleField('firstName', firstName);
    if (firstNameError != null) errors['firstName'] = firstNameError;

    final lastNameError = _validateSingleField('lastName', lastName);
    if (lastNameError != null) errors['lastName'] = lastNameError;

    final emailError = _validateSingleField('email', email);
    if (emailError != null) errors['email'] = emailError;

    final phoneError = _validateSingleField('phone', phone);
    if (phoneError != null) errors['phone'] = phoneError;

    final idError = _validateSingleField('identificationNumber', identificationNumber);
    if (idError != null) errors['identificationNumber'] = idError;

    return errors;
  }

  String? _validateSingleField(String fieldName, String value) {
    if (value.trim().isEmpty) {
      return 'El campo $fieldName es requerido';
    }

    switch (fieldName) {
      case 'email':
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Ingrese un correo electrónico válido';
        }
        break;
      case 'phone':
        final phoneRegex = RegExp(r'^[0-9]{10,15}$');
        if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
          return 'Ingrese un número de teléfono válido';
        }
        break;
      case 'identificationNumber':
        if (value.length < 5 || value.length > 20) {
          return 'La identificación debe tener entre 5 y 20 caracteres';
        }
        break;
      case 'firstName':
      case 'lastName':
        if (value.length < 2) {
          return 'El nombre debe tener al menos 2 caracteres';
        }
        if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
          return 'Solo se permiten letras y espacios';
        }
        break;
    }

    return null;
  }
}

class ClientFormScreen extends StatefulWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _identificationController;

  bool get isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.client?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.client?.lastName ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _addressController = TextEditingController(text: widget.client?.address ?? '');
    _identificationController = TextEditingController(text: widget.client?.identificationNumber ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _identificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientFormBloc(
        clientRepository: context.read<ClientRepository>(),
        connectivityService: context.read<ConnectivityService>(),
      ),
      child: BlocConsumer<ClientFormBloc, ClientFormState>(
        listener: (context, state) {
          if (state.isSaved) {
            final message = state.isOffline
                ? 'Cliente guardado offline. Se sincronizará cuando haya conexión.'
                : 'Cliente guardado correctamente.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green.shade700,
              ),
            );
            Navigator.of(context).pop(true);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Editar Cliente' : 'Nuevo Cliente'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _firstNameController,
                      label: 'Nombre',
                      icon: Icons.person,
                      error: state.fieldErrors['firstName'],
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _lastNameController,
                      label: 'Apellido',
                      icon: Icons.person_outline,
                      error: state.fieldErrors['lastName'],
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _identificationController,
                      label: 'Número de Identificación',
                      icon: Icons.badge,
                      error: state.fieldErrors['identificationNumber'],
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      error: state.fieldErrors['email'],
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Teléfono',
                      icon: Icons.phone,
                      error: state.fieldErrors['phone'],
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Dirección',
                      icon: Icons.home,
                      error: state.fieldErrors['address'],
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () => _saveClient(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEditing ? 'Actualizar Cliente' : 'Guardar Cliente'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? error,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        errorText: error,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
    );
  }

  void _saveClient(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final bloc = context.read<ClientFormBloc>();
      if (isEditing && widget.client != null) {
        final updatedClient = widget.client!.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          identificationNumber: _identificationController.text.trim(),
        );
        bloc.add(UpdateClientRequested(client: updatedClient));
      } else {
        bloc.add(SaveClientRequested(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          identificationNumber: _identificationController.text.trim(),
        ));
      }
    }
  }
}


=== ARCHIVO: lib/domain/repositories/client_repository.dart ===
package domain.repositories;

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/client.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getClients();
  Future<Either<Failure, Client>> getClientById(String id);
  Future<Either<Failure, Client>> saveClient(Client client);
  Future<Either<Failure, void>> deleteClient(String id);
  Future<Either<Failure, List<Client>>> getPendingClients();
  Stream<List<Client>> watchAllClients();
  Stream<List<Client>> watchPendingClients();
  Future<Either<Failure, List<Client>>> getRemoteClients();
  Future<Either<Failure, Client?>> getRemoteClient(String id);
  Future<Either<Failure, Client>> syncClient(Client client);
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

enum ClientSyncStatus {
  pending,
  synced,
  conflict,
}