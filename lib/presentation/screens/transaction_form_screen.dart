import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:offline_field_app/domain/entities/transaction.dart';
import 'package:offline_field_app/presentation/providers/transaction_provider.dart';
import 'package:offline_field_app/core/constants/app_constants.dart';
import 'package:offline_field_app/core/errors/failures.dart';

class TransactionFormScreen extends StatefulWidget {
  final Transaction? transaction;

  const TransactionFormScreen({super.key, this.transaction});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _metadataController = TextEditingController();

  String _selectedCurrency = 'USD';
  String _selectedType = 'credit';
  bool _isSubmitting = false;

  bool get isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();
      _descriptionController.text = widget.transaction!.description ?? '';
      _selectedCurrency = widget.transaction!.currency;
      _selectedType = widget.transaction!.transactionType;
      _metadataController.text = widget.transaction!.metadata ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _metadataController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text.trim();
      final metadata = _metadataController.text.trim();

      if (!AppConstants.isValidAmount(amount, _selectedCurrency)) {
        _showError(ValidationFailure.invalidAmount(_selectedCurrency, amount));
        return;
      }

      final provider = context.read<TransactionProvider>();

      if (isEditing) {
        final updated = widget.transaction!.copyWith(
          amount: amount,
          currency: _selectedCurrency,
          transactionType: _selectedType,
          description: description,
          metadata: metadata.isNotEmpty ? metadata : null,
        );
        await provider.updateTransaction(updated);
      } else {
        await provider.createTransaction(
          amount: amount,
          currency: _selectedCurrency,
          transactionType: _selectedType,
          description: description,
          metadata: metadata.isNotEmpty ? metadata : null,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Transacción actualizada' : 'Transacción creada'),
            backgroundColor: Color(AppConstants.successColor),
          ),
        );
        Navigator.of(context).pop();
      }
    } on Failure catch (e) {
      _showError(e);
    } catch (e) {
      _showError(DatabaseFailure.transactionFailed(e.toString()));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(Failure failure) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.message),
        backgroundColor: Color(AppConstants.errorColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar transacción' : 'Nueva transacción'),
        backgroundColor: Color(AppConstants.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAmountField(),
              const SizedBox(height: 16),
              _buildCurrencyDropdown(),
              const SizedBox(height: 16),
              _buildTypeDropdown(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildMetadataField(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        labelText: 'Monto',
        hintText: '0.00',
        prefixIcon: Icon(Icons.attach_money),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El monto es requerido';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Ingrese un monto válido mayor a 0';
        }
        return null;
      },
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCurrency,
      decoration: const InputDecoration(
        labelText: 'Moneda',
        prefixIcon: Icon(Icons.currency_exchange),
        border: OutlineInputBorder(),
      ),
      items: ['USD', 'EUR', 'GBP', 'MXN', 'COP'].map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedCurrency = value);
        }
      },
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: const InputDecoration(
        labelText: 'Tipo de transacción',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(
          value: 'credit',
          child: Row(
            children: [
              Icon(Icons.arrow_upward, color: Colors.green),
              SizedBox(width: 8),
              Text('Crédito'),
            ],
          ),
        ),
        const DropdownMenuItem(
          value: 'debit',
          child: Row(
            children: [
              Icon(Icons.arrow_downward, color: Colors.red),
              SizedBox(width: 8),
              Text('Débito'),
            ],
          ),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedType = value);
        }
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      maxLength: 500,
      decoration: const InputDecoration(
        labelText: 'Descripción',
        hintText: 'Describe la transacción...',
        prefixIcon: Icon(Icons.description),
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'La descripción es requerida';
        }
        return null;
      },
    );
  }

  Widget _buildMetadataField() {
    return TextFormField(
      controller: _metadataController,
      maxLines: 2,
      maxLength: 1000,
      decoration: const InputDecoration(
        labelText: 'Metadatos (opcional)',
        hintText: 'JSON o información adicional...',
        prefixIcon: Icon(Icons.info_outline),
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              isEditing ? 'Actualizar transacción' : 'Crear transacción',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}