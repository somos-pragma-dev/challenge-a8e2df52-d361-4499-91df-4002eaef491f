package field_app.presentation.pages;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_app/core/constants/app_constants.dart';
import 'package:field_app/domain/entities/task_entity.dart';
import 'package:field_app/presentation/bloc/task/task_bloc.dart';
import 'package:field_app/presentation/bloc/sync/sync_bloc.dart';
import 'package:uuid/uuid.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskEntity? task;

  const TaskDetailPage({super.key, this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assignedToController = TextEditingController();
  
  String _selectedPriority = AppConstants.taskPriorityMedium;
  String _selectedStatus = AppConstants.taskStatusPending;
  DateTime? _dueDate;
  bool _isEditing = false;
  bool _hasChanges = false;

  bool get isNewTask => widget.task == null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _assignedToController.text = widget.task!.assignedTo ?? '';
      _selectedPriority = widget.task!.priority;
      _selectedStatus = widget.task!.status;
      _dueDate = widget.task!.dueDate;
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isNewTask ? 'Tarea creada exitosamente' : 'Tarea actualizada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is TaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          if (_hasChanges) {
            return await _showDiscardChangesDialog();
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(isNewTask ? 'Nueva Tarea' : 'Detalle de Tarea'),
            backgroundColor: AppConstants.primaryColor,
            actions: [
              if (!isNewTask)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDeleteTask(),
                ),
            ],
          ),
          body: BlocBuilder<SyncBloc, SyncState>(
            builder: (context, syncState) {
              return Column(
                children: [
                  if (!syncState.isConnected)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      color: AppConstants.warningColor,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_off, size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Sin conexión - Los cambios se guardarán localmente',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: _buildForm(),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: _buildBottomBar(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSyncStatusInfo(),
            const SizedBox(height: 24),
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildPrioritySelector(),
            const SizedBox(height: 16),
            _buildStatusSelector(),
            const SizedBox(height: 16),
            _buildAssignedToField(),
            const SizedBox(height: 16),
            _buildDueDatePicker(),
            const SizedBox(height: 24),
            if (!isNewTask) _buildMetadataSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusInfo() {
    if (isNewTask) return const SizedBox.shrink();

    final syncStatus = widget.task?.syncStatus ?? AppConstants.syncStatusPending;
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (syncStatus) {
      case AppConstants.syncStatusSynced:
        statusColor = Colors.green;
        statusIcon = Icons.cloud_done;
        statusText = 'Sincronizado';
        break;
      case AppConstants.syncStatusPending:
        statusColor = AppConstants.warningColor;
        statusIcon = Icons.cloud_upload;
        statusText = 'Pendiente de sincronización';
        break;
      case AppConstants.syncStatusFailed:
        statusColor = AppConstants.errorColor;
        statusIcon = Icons.cloud_off;
        statusText = 'Error de sincronización';
        break;
      case AppConstants.syncStatusConflict:
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        statusText = 'Conflicto detectado';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.cloud_queue;
        statusText = 'Desconocido';
    }

    return Card(
      color: statusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                statusText,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Título *',
        hintText: 'Ingrese el título de la tarea',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.title),
      ),
      maxLength: AppConstants.maxTitleLength,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El título es obligatorio';
        }
        if (value.trim().length < 3) {
          return 'El título debe tener al menos 3 caracteres';
        }
        return null;
      },
      onChanged: (_) => _markAsChanged(),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Descripción',
        hintText: 'Ingrese la descripción de la tarea',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.description),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      maxLength: AppConstants.maxDescriptionLength,
      onChanged: (_) => _markAsChanged(),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prioridad',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPriorityChip(AppConstants.taskPriorityLow, 'Baja', Colors.green),
            const SizedBox(width: 8),
            _buildPriorityChip(AppConstants.taskPriorityMedium, 'Media', AppConstants.warningColor),
            const SizedBox(width: 8),
            _buildPriorityChip(AppConstants.taskPriorityHigh, 'Alta', AppConstants.errorColor),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityChip(String value, String label, Color color) {
    final isSelected = _selectedPriority == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedPriority = value;
          });
          _markAsChanged();
        }
      },
      selectedColor: color.withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.flag),
          ),
          items: const [
            DropdownMenuItem(
              value: AppConstants.taskStatusPending,
              child: Text('Pendiente'),
            ),
            DropdownMenuItem(
              value: AppConstants.taskStatusInProgress,
              child: Text('En Progreso'),
            ),
            DropdownMenuItem(
              value: AppConstants.taskStatusCompleted,
              child: Text('Completada'),
            ),
            DropdownMenuItem(
              value: AppConstants.taskStatusCancelled,
              child: Text('Cancelada'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedStatus = value;
              });
              _markAsChanged();
            }
          },
        ),
      ],
    );
  }

  Widget _buildAssignedToField() {
    return TextFormField(
      controller: _assignedToController,
      decoration: InputDecoration(
        labelText: 'Asignado a',
        hintText: 'Nombre del responsable',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.person),
      ),
      onChanged: (_) => _markAsChanged(),
    );
  }

  Widget _buildDueDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha Límite',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDueDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.calendar_today),
              suffixIcon: _dueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _dueDate = null;
                        });
                        _markAsChanged();
                      },
                    )
                  : null,
            ),
            child: Text(
              _dueDate != null
                  ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                  : 'Seleccionar fecha',
              style: TextStyle(
                color: _dueDate != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
      _markAsChanged();
    }
  }

  Widget _buildMetadataSection() {
    final task = widget.task!;
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Adicional',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildMetadataRow('ID', task.id),
            _buildMetadataRow('Versión', task.version?.toString() ?? '1'),
            _buildMetadataRow('Creado', _formatDateTime(task.createdAt)),
            _buildMetadataRow('Actualizado', _formatDateTime(task.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _handleCancel(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => _saveTask(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(isNewTask ? 'Crear Tarea' : 'Guardar Cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markAsChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<bool> _showDiscardChangesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Descartar Cambios'),
          content: const Text('¿Estás seguro de descartar los cambios realizados?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.errorColor,
              ),
              child: const Text('Descartar'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void _handleCancel() async {
    if (_hasChanges) {
      final discard = await _showDiscardChangesDialog();
      if (discard) {
        if (mounted) Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final task = TaskEntity(
      id: widget.task?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      status: _selectedStatus,
      priority: _selectedPriority,
      dueDate: _dueDate,
      assignedTo: _assignedToController.text.trim().isEmpty 
          ? null 
          : _assignedToController.text.trim(),
      createdAt: widget.task?.createdAt ?? now,
      updatedAt: now,
      syncStatus: AppConstants.syncStatusPending,
      version: (widget.task?.version ?? 0) + 1,
    );

    if (isNewTask) {
      context.read<TaskBloc>().add(CreateTask(task));
    } else {
      context.read<TaskBloc>().add(UpdateTask(task));
    }
  }

  void _confirmDeleteTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Tarea'),
          content: const Text('¿Estás seguro de eliminar esta tarea? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<TaskBloc>().add(DeleteTask(widget.task!.id));
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.errorColor,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/task/task_bloc.dart';
import '../bloc/task/task_event.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onSync;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onDelete,
    this.onSync,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case AppConstants.taskPriorityHigh:
        return AppConstants.errorColor;
      case AppConstants.taskPriorityMedium:
        return AppConstants.warningColor;
      case AppConstants.taskPriorityLow:
        return AppConstants.primaryColor;
      default:
        return AppConstants.surfaceColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case AppConstants.taskStatusPending:
        return Icons.schedule;
      case AppConstants.taskStatusInProgress:
        return Icons.play_circle_outline;
      case AppConstants.taskStatusCompleted:
        return Icons.check_circle_outline;
      case AppConstants.taskStatusCancelled:
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Color _getSyncStatusColor(String syncStatus) {
    switch (syncStatus) {
      case AppConstants.syncStatusSynced:
        return Colors.green;
      case AppConstants.syncStatusPending:
        return Colors.orange;
      case AppConstants.syncStatusFailed:
        return AppConstants.errorColor;
      case AppConstants.syncStatusConflict:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getSyncStatusIcon(String syncStatus) {
    switch (syncStatus) {
      case AppConstants.syncStatusSynced:
        return Icons.cloud_done;
      case AppConstants.syncStatusPending:
        return Icons.cloud_upload;
      case AppConstants.syncStatusFailed:
        return Icons.cloud_off;
      case AppConstants.syncStatusConflict:
        return Icons.warning_amber_rounded;
      default:
        return Icons.cloud_queue;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: _getPriorityColor(task.priority),
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (task.description != null &&
                              task.description!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              task.description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      _getSyncStatusIcon(task.syncStatus),
                      color: _getSyncStatusColor(task.syncStatus),
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.priority.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getPriorityColor(task.priority),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _getStatusIcon(task.status),
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(task.updatedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (task.syncStatus == AppConstants.syncStatusFailed ||
                        task.syncStatus == AppConstants.syncStatusConflict)
                      TextButton.icon(
                        onPressed: onSync,
                        icon: const Icon(Icons.sync, size: 18),
                        label: const Text('Retry'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppConstants.warningColor,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppConstants.errorColor,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskCardSkeleton extends StatelessWidget {
  const TaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 12,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  height: 20,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 20,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCardCompact extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onTap;

  const TaskCardCompact({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: _getPriorityColor(task.priority),
        child: Icon(
          _getStatusIcon(task.status),
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        task.description ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Icon(
        _getSyncStatusIcon(task.syncStatus),
        color: _getSyncStatusColor(task.syncStatus),
        size: 20,
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case AppConstants.taskPriorityHigh:
        return AppConstants.errorColor;
      case AppConstants.taskPriorityMedium:
        return AppConstants.warningColor;
      case AppConstants.taskPriorityLow:
        return AppConstants.primaryColor;
      default:
        return AppConstants.surfaceColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case AppConstants.taskStatusPending:
        return Icons.schedule;
      case AppConstants.taskStatusInProgress:
        return Icons.play_circle_outline;
      case AppConstants.taskStatusCompleted:
        return Icons.check_circle_outline;
      case AppConstants.taskStatusCancelled:
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  IconData _getSyncStatusIcon(String syncStatus) {
    switch (syncStatus) {
      case AppConstants.syncStatusSynced:
        return Icons.cloud_done;
      case AppConstants.syncStatusPending:
        return Icons.cloud_upload;
      case AppConstants.syncStatusFailed:
        return Icons.cloud_off;
      case AppConstants.syncStatusConflict:
        return Icons.warning_amber_rounded;
      default:
        return Icons.cloud_queue;
    }
  }
}