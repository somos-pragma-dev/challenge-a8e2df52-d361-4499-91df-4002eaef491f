package field_app.presentation.pages;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:field_app/core/constants/app_constants.dart';
import 'package:field_app/presentation/bloc/task/task_bloc.dart';
import 'package:field_app/presentation/bloc/sync/sync_bloc.dart';
import 'package:field_app/presentation/widgets/task_card.dart';
import 'package:field_app/presentation/widgets/sync_indicator.dart';
import 'package:field_app/presentation/widgets/offline_banner.dart';
import 'package:field_app/presentation/pages/task_list_page.dart';
import 'package:field_app/presentation/pages/task_detail_page.dart';
import 'package:field_app/domain/entities/task_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
    context.read<SyncBloc>().add(StartSyncMonitoring());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: AppConstants.primaryColor,
        actions: const [
          SyncIndicator(),
          SizedBox(width: 8),
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
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToTaskDetail(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tarea'),
        backgroundColor: AppConstants.primaryColor,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.sync_outlined),
            selectedIcon: Icon(Icons.sync),
            label: 'Sincronizar',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const TaskListPage();
      case 2:
        return _buildSyncSection();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
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
          return _buildDashboardContent(state.tasks);
        }

        return const Center(
          child: Text('Cargando tareas...'),
        );
      },
    );
  }

  Widget _buildDashboardContent(List<TaskEntity> tasks) {
    final pendingTasks = tasks.where((t) => t.status == AppConstants.taskStatusPending).toList();
    final inProgressTasks = tasks.where((t) => t.status == AppConstants.taskStatusInProgress).toList();
    final completedTasks = tasks.where((t) => t.status == AppConstants.taskStatusCompleted).toList();
    final highPriorityTasks = tasks.where((t) => t.priority == AppConstants.taskPriorityHigh && t.status != AppConstants.taskStatusCompleted).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 24),
          _buildQuickStatsSection(pendingTasks.length, inProgressTasks.length, completedTasks.length),
          const SizedBox(height: 24),
          if (highPriorityTasks.isNotEmpty) ...[
            _buildHighPrioritySection(highPriorityTasks),
            const SizedBox(height: 24),
          ],
          _buildRecentTasksSection(tasks.take(5).toList()),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.wb_sunny,
                  color: AppConstants.primaryColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Bienvenido a ${AppConstants.appName}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Gestiona tus tareas de campo sin conexión y sincroniza cuando tengas internet.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection(int pending, int inProgress, int completed) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Pendientes',
            pending.toString(),
            Icons.pending_actions,
            AppConstants.warningColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'En Progreso',
            inProgress.toString(),
            Icons.play_circle_outline,
            AppConstants.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Completadas',
            completed.toString(),
            Icons.check_circle_outline,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighPrioritySection(List<TaskEntity> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.priority_high, color: AppConstants.errorColor),
            const SizedBox(width: 8),
            const Text(
              'Tareas Prioritarias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...tasks.map((task) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TaskCard(
            task: task,
            onTap: () => _navigateToTaskDetail(context, task),
          ),
        )),
      ],
    );
  }

  Widget _buildRecentTasksSection(List<TaskEntity> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tareas Recientes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay tareas recientes',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          ...tasks.map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TaskCard(
              task: task,
              onTap: () => _navigateToTaskDetail(context, task),
            ),
          )),
      ],
    );
  }

  Widget _buildSyncSection() {
    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSyncStatusCard(state),
              const SizedBox(height: 24),
              _buildSyncActionsCard(state),
              const SizedBox(height: 24),
              _buildSyncHistoryCard(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSyncStatusCard(SyncState state) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  state.isConnected ? Icons.cloud_done : Icons.cloud_off,
                  color: state.isConnected ? Colors.green : AppConstants.errorColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  state.isConnected ? 'Conectado' : 'Sin Conexión',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: state.isConnected ? Colors.green : AppConstants.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusRow('Estado de sincronización', state.syncStatus),
            _buildStatusRow('Última sincronización', _formatDateTime(state.lastSyncTime)),
            _buildStatusRow('Pendientes', state.pendingSyncCount.toString()),
            _buildStatusRow('Conflictos', state.conflictCount.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSyncActionsCard(SyncState state) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones de Sincronización',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.isSyncing || !state.isConnected
                    ? null
                    : () {
                        context.read<SyncBloc>().add(TriggerManualSync());
                      },
                icon: state.isSyncing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                label: Text(state.isSyncing ? 'Sincronizando...' : 'Sincronizar Ahora'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: state.isConnected
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No hay conexión a internet'),
                            backgroundColor: AppConstants.warningColor,
                          ),
                        );
                      },
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Forzar Subida'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncHistoryCard(SyncState state) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de Sincronización',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (state.syncHistory.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No hay historial de sincronización',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...state.syncHistory.take(10).map((entry) => ListTile(
                leading: Icon(
                  entry['success'] == true ? Icons.check_circle : Icons.error,
                  color: entry['success'] == true ? Colors.green : AppConstants.errorColor,
                ),
                title: Text(entry['message'] ?? 'Sincronización'),
                subtitle: Text(_formatDateTime(entry['timestamp'])),
                contentPadding: EdgeInsets.zero,
              )),
          ],
        ),
      ),
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

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Nunca';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Hace un momento';
    } else if (difference.inHours < 1) {
      return 'Hace ${difference.inMinutes} minutos';
    } else if (difference.inDays < 1) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}