package field_app.presentation.pages;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_app/core/constants/app_constants.dart';
import 'package:field_app/domain/entities/task_entity.dart';
import 'package:field_app/presentation/bloc/task/task_bloc.dart';
import 'package:field_app/presentation/bloc/sync/sync_bloc.dart';
import 'package:field_app/presentation/widgets/task_card.dart';
import 'package:field_app/presentation/widgets/offline_banner.dart';
import 'package:field_app/presentation/pages/task_detail_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String _selectedFilter = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        backgroundColor: AppConstants.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<SyncBloc, SyncState>(
            builder: (context, state) {
              if (!state.isConnected) {
                return const OfflineBanner();
              }
              return const SizedBox.shrink();
            },
          ),
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskDetail(context, null),
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar tareas...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('all', 'Todas'),
          const SizedBox(width: 8),
          _buildFilterChip('pending', 'Pendientes'),
          const SizedBox(width: 8),
          _buildFilterChip('in_progress', 'En Progreso'),
          const SizedBox(width: 8),
          _buildFilterChip('completed', 'Completadas'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: AppConstants.primaryColor.withOpacity(0.2),
      checkmarkColor: AppConstants.primaryColor,
    );
  }

  Widget _buildTaskList() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is TaskError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppConstants.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<TaskBloc>().add(LoadTasks());
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is TaskLoaded) {
          final filteredTasks = _filterTasks(state.tasks);
          
          if (filteredTasks.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TaskBloc>().add(LoadTasks());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    task: task,
                    onTap: () => _navigateToTaskDetail(context, task),
                    onLongPress: () => _showTaskOptions(context, task),
                  ),
                );
              },
            ),
          );
        }

        return const Center(
          child: Text('Cargando tareas...'),
        );
      },
    );
  }

  List<TaskEntity> _filterTasks(List<TaskEntity> tasks) {
    var filteredTasks = tasks;

    if (_searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.title.toLowerCase().contains(_searchQuery) ||
               (task.description?.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }

    switch (_selectedFilter) {
      case 'pending':
        filteredTasks = filteredTasks
            .where((t) => t.status == AppConstants.taskStatusPending)
            .toList();
        break;
      case 'in_progress':
        filteredTasks = filteredTasks
            .where((t) => t.status == AppConstants.taskStatusInProgress)
            .toList();
        break;
      case 'completed':
        filteredTasks = filteredTasks
            .where((t) => t.status == AppConstants.taskStatusCompleted)
            .toList();
        break;
      case 'all':
      default:
        break;
    }

    filteredTasks.sort((a, b) {
      final priorityOrder = {
        AppConstants.taskPriorityHigh: 0,
        AppConstants.taskPriorityMedium: 1,
        AppConstants.taskPriorityLow: 2,
      };
      
      final priorityCompare = (priorityOrder[a.priority] ?? 3)
          .compareTo(priorityOrder[b.priority] ?? 3);
      
      if (priorityCompare != 0) return priorityCompare;
      
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return filteredTasks;
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    
    switch (_selectedFilter) {
      case 'pending':
        message = 'No hay tareas pendientes';
        icon = Icons.check_circle_outline;
        break;
      case 'in_progress':
        message = 'No hay tareas en progreso';
        icon = Icons.play_circle_outline;
        break;
      case 'completed':
        message = 'No hay tareas completadas';
        icon = Icons.task_alt;
        break;
      default:
        if (_searchQuery.isNotEmpty) {
          message = 'No se encontraron tareas con "$_searchQuery"';
          icon = Icons.search_off;
        } else {
          message = 'No hay tareas disponibles';
          icon = Icons.inbox_outlined;
        }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToTaskDetail(context, null),
            icon: const Icon(Icons.add),
            label: const Text('Crear Nueva Tarea'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrar Tareas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildFilterOption('all', 'Todas las tareas'),
              _buildFilterOption('priority_high', 'Alta prioridad'),
              _buildFilterOption('priority_medium', 'Media prioridad'),
              _buildFilterOption('priority_low', 'Baja prioridad'),
              _buildFilterOption('sync_pending', 'Pendientes de sincronización'),
              _buildFilterOption('sync_conflict', 'Con conflictos'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String value, String label) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedFilter,
        onChanged: (newValue) {
          setState(() {
            _selectedFilter = newValue ?? 'all';
          });
          Navigator.pop(context);
        },
      ),
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showTaskOptions(BuildContext context, TaskEntity task) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar Tarea'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToTaskDetail(context, task);
                },
              ),
              if (task.status != AppConstants.taskStatusCompleted)
                ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: const Text('Marcar como Completada'),
                  onTap: () {
                    Navigator.pop(context);
                    _updateTaskStatus(context, task, AppConstants.taskStatusCompleted);
                  },
                ),
              if (task.status == AppConstants.taskStatusPending)
                ListTile(
                  leading: const Icon(Icons.play_arrow),
                  title: const Text('Iniciar Tarea'),
                  onTap: () {
                    Navigator.pop(context);
                    _updateTaskStatus(context, task, AppConstants.taskStatusInProgress);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete, color: AppConstants.errorColor),
                title: const Text('Eliminar Tarea', style: TextStyle(color: AppConstants.errorColor)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteTask(context, task);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateTaskStatus(BuildContext context, TaskEntity task, String newStatus) {
    final updatedTask = TaskEntity(
      id: task.id,
      title: task.title,
      description: task.description,
      status: newStatus,
      priority: task.priority,
      dueDate: task.dueDate,
      assignedTo: task.assignedTo,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: task.syncStatus,
      version: task.version,
    );
    context.read<TaskBloc>().add(UpdateTask(updatedTask));
  }

  void _confirmDeleteTask(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Tarea'),
          content: Text('¿Estás seguro de eliminar la tarea "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<TaskBloc>().add(DeleteTask(task.id));
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

  void _navigateToTaskDetail(BuildContext context, TaskEntity? task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(task: task),
      ),
    );
  }
}