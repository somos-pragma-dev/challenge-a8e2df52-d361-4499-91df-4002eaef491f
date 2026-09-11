import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/repositories/client_repository.dart';
import '../../domain/repositories/credit_application_repository.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';

abstract class ApplicationFormEvent extends Equatable {
  const ApplicationFormEvent();
  @override
  List<Object?> get props => [];
}

class LoadClientsForSelection extends ApplicationFormEvent {
  const LoadClientsForSelection();
}

class SubmitApplicationRequested extends ApplicationFormEvent {
  final String clientId;
  final double requestedAmount;
  final String purpose;
  final int termMonths;

  const SubmitApplicationRequested({
    required this.clientId,
    required this.requestedAmount,
    required this.purpose,
    required this.termMonths,
  });

  @override
  List<Object?> get props => [clientId, requestedAmount, purpose, termMonths];
}

class ValidateAmount extends ApplicationFormEvent {
  final String amount;

  const ValidateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class ValidateTerm extends ApplicationFormEvent {
  final String term;

  const ValidateTerm(this.term);

  @override
  List<Object?> get props => [term];
}

class ApplicationFormState extends Equatable {
  final List<Client> availableClients;
  final bool isLoading;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final CreditApplication? submittedApplication;
  final bool isOffline;
  final double? validatedAmount;
  final int? validatedTerm;

  const ApplicationFormState({
    this.availableClients = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.submittedApplication,
    this.isOffline = false,
    this.validatedAmount,
    this.validatedTerm,
  });

  ApplicationFormState copyWith({
    List<Client>? availableClients,
    bool? isLoading,
    bool? isSubmitting,
    bool? isSubmitted,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    CreditApplication? submittedApplication,
    bool? isOffline,
    double? validatedAmount,
    int? validatedTerm,
  }) {
    return ApplicationFormState(
      availableClients: availableClients ?? this.availableClients,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      submittedApplication: submittedApplication ?? this.submittedApplication,
      isOffline: isOffline ?? this.isOffline,
      validatedAmount: validatedAmount ?? this.validatedAmount,
      validatedTerm: validatedTerm ?? this.validatedTerm,
    );
  }

  @override
  List<Object?> get props => [
        availableClients,
        isLoading,
        isSubmitting,
        isSubmitted,
        errorMessage,
        fieldErrors,
        submittedApplication,
        isOffline,
        validatedAmount,
        validatedTerm,
      ];
}

class ApplicationFormBloc extends Bloc<ApplicationFormEvent, ApplicationFormState> {
  final CreditApplicationRepository _applicationRepository;
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;

  static const double minAmount = 1000.0;
  static const double maxAmount = 500000.0;
  static const List<int> validTerms = [6, 12, 18, 24, 36, 48, 60];

  ApplicationFormBloc({
    required CreditApplicationRepository applicationRepository,
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _applicationRepository = applicationRepository,
        _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ApplicationFormState()) {
    on<LoadClientsForSelection>(_onLoadClients);
    on<SubmitApplicationRequested>(_onSubmitApplication);
    on<ValidateAmount>(_onValidateAmount);
    on<ValidateTerm>(_onValidateTerm);
  }

  Future<void> _onLoadClients(
    LoadClientsForSelection event,
    Emitter<ApplicationFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _clientRepository.getAllClients();
      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (clients) => emit(state.copyWith(
          isLoading: false,
          availableClients: clients,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar clientes: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSubmitApplication(
    SubmitApplicationRequested event,
    Emitter<ApplicationFormState> emit,
  ) async {
    final validationErrors = _validateApplicationData(
      clientId: event.clientId,
      amount: event.requestedAmount,
      termMonths: event.termMonths,
    );

    if (validationErrors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: validationErrors));
      return;
    }

    emit(state.copyWith(isSubmitting: true, fieldErrors: {}));

    try {
      final isConnected = await _connectivityService.hasActiveConnection();
      final application = CreditApplication(
        id: '',
        clientId: event.clientId,
        requestedAmount: event.requestedAmount,
        purpose: event.purpose,
        termMonths: event.termMonths,
        status: 'pending',
        syncStatus: isConnected ? 'synced' : 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final result = await _applicationRepository.saveApplication(application);

      result.fold(
        (failure) => emit(state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        )),
        (savedApplication) => emit(state.copyWith(
          isSubmitting: false,
          isSubmitted: true,
          submittedApplication: savedApplication,
          isOffline: !isConnected,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Error al enviar solicitud: ${e.toString()}',
      ));
    }
  }

  void _onValidateAmount(
    ValidateAmount event,
    Emitter<ApplicationFormState> emit,
  ) {
    final errors = Map<String, String>.from(state.fieldErrors);
    final amount = double.tryParse(event.amount);

    if (amount == null) {
      errors['amount'] = 'Ingrese un monto válido';
    } else if (amount < minAmount) {
      errors['amount'] = 'El monto mínimo es \$${minAmount.toStringAsFixed(0)}';
    } else if (amount > maxAmount) {
      errors['amount'] = 'El monto máximo es \$${maxAmount.toStringAsFixed(0)}';
    } else {
      errors.remove('amount');
      emit(state.copyWith(
        fieldErrors: errors,
        validatedAmount: amount,
      ));
      return;
    }

    emit(state.copyWith(fieldErrors: errors));
  }

  void _onValidateTerm(
    ValidateTerm event,
    Emitter<ApplicationFormState> emit,
  ) {
    final errors = Map<String, String>.from(state.fieldErrors);
    final term = int.tryParse(event.term);

    if (term == null) {
      errors['term'] = 'Ingrese un plazo válido';
    } else if (!validTerms.contains(term)) {
      errors['term'] = 'Plazo no válido. Seleccione: ${validTerms.join(", ")} meses';
    } else {
      errors.remove('term');
      emit(state.copyWith(
        fieldErrors: errors,
        validatedTerm: term,
      ));
      return;
    }

    emit(state.copyWith(fieldErrors: errors));
  }

  Map<String, String> _validateApplicationData({
    required String clientId,
    required double amount,
    required int termMonths,
  }) {
    final errors = <String, String>{};

    if (clientId.isEmpty) {
      errors['client'] = 'Debe seleccionar un cliente';
    }

    if (amount < minAmount) {
      errors['amount'] = 'El monto mínimo es \$${minAmount.toStringAsFixed(0)}';
    } else if (amount > maxAmount) {
      errors['amount'] = 'El monto máximo es \$${maxAmount.toStringAsFixed(0)}';
    }

    if (!validTerms.contains(termMonths)) {
      errors['term'] = 'Plazo no válido';
    }

    return errors;
  }
}

class ApplicationFormScreen extends StatefulWidget {
  final String? clientId;

  const ApplicationFormScreen({super.key, this.clientId});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClientId;
  late TextEditingController _amountController;
  late TextEditingController _purposeController;
  int? _selectedTerm;

  final List<String> _purposes = [
    'Consumo',
    'Negocio',
    'Vivienda',
    'Vehículo',
    'Educación',
    'Salud',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _selectedClientId = widget.clientId;
    _amountController = TextEditingController();
    _purposeController = TextEditingController();
    _selectedTerm = 12;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApplicationFormBloc(
        applicationRepository: context.read<CreditApplicationRepository>(),
        clientRepository: context.read<ClientRepository>(),
        connectivityService: context.read<ConnectivityService>(),
      )..add(const LoadClientsForSelection()),
      child: BlocConsumer<ApplicationFormBloc, ApplicationFormState>(
        listener: (context, state) {
          if (state.isSubmitted) {
            final message = state.isOffline
                ? 'Solicitud guardada offline. Se sincronizará cuando haya conexión.'
                : 'Solicitud enviada correctamente.';
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
              title: const Text('Nueva Solicitud de Crédito'),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildClientDropdown(context, state),
                          const SizedBox(height: 16),
                          _buildAmountField(context),
                          const SizedBox(height: 16),
                          _buildPurposeDropdown(),
                          const SizedBox(height: 16),
                          _buildTermDropdown(),
                          const SizedBox(height: 16),
                          _buildTermInfo(),
                          const SizedBox(height: 24),
                          _buildSubmitButton(context, state),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildClientDropdown(BuildContext context, ApplicationFormState state) {
    return DropdownButtonFormField<String>(
      value: _selectedClientId,
      decoration: InputDecoration(
        labelText: 'Cliente',
        prefixIcon: const Icon(Icons.person),
        border: const OutlineInputBorder(),
        errorText: state.fieldErrors['client'],
      ),
      items: state.availableClients.map((client) {
        return DropdownMenuItem(
          value: client.id,
          child: Text('${client.firstName} ${client.lastName}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedClientId = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Debe seleccionar un cliente';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField(BuildContext context) {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'Monto Solicitado',
        prefixIcon: const Icon(Icons.attach_money),
        border: const OutlineInputBorder(),
        hintText: 'Entre \$1,000 y \$500,000',
        errorText: context.select<ApplicationFormBloc, ApplicationFormState>(
                  (bloc) => bloc.state.fieldErrors['amount'],
                ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d{0,2}')),
      ],
      onChanged: (value) {
        context.read<ApplicationFormBloc>().add(ValidateAmount(value));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese el monto solicitado';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount < 1000 || amount > 500000) {
          return 'Monto debe estar entre \$1,000 y \$500,000';
        }
        return null;
      },
    );
  }

  Widget _buildPurposeDropdown() {
    return DropdownButtonFormField<String>(
      value: _purposeController.text.isNotEmpty ? _purposeController.text : null,
      decoration: const InputDecoration(
        labelText: 'Finalidad',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      items: _purposes.map((purpose) {
        return DropdownMenuItem(
          value: purpose,
          child: Text(purpose),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _purposeController.text = value ?? '';
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione la finalidad del crédito';
        }
        return null;
      },
    );
  }

  Widget _buildTermDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedTerm,
      decoration: const InputDecoration(
        labelText: 'Plazo (meses)',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      items: ApplicationFormBloc.validTerms.map((term) {
        return DropdownMenuItem(
          value: term,
          child: Text('$term meses'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedTerm = value;
        });
        if (value != null) {
          context.read<ApplicationFormBloc>().add(ValidateTerm(value.toString()));
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Seleccione el plazo';
        }
        return null;
      },
    );
  }

  Widget _buildTermInfo() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Los plazos disponibles son: 6, 12, 18, 24, 36, 48 y 60 meses. '
                'Seleccione el que mejor se adapte a su capacidad de pago.',
                style: TextStyle(color: Colors.blue.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, ApplicationFormState state) {
    return ElevatedButton(
      onPressed: state.isSubmitting ? null : () => _submitApplication(context),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: state.isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Enviar Solicitud'),
    );
  }

  void _submitApplication(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.parse(_amountController.text);
      context.read<ApplicationFormBloc>().add(
            SubmitApplicationRequested(
              clientId: _selectedClientId!,
              requestedAmount: amount,
              purpose: _purposeController.text,
              termMonths: _selectedTerm!,
            ),
          );
    }
  }
}