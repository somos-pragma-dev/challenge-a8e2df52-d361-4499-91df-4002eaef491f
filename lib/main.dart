import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:field_app/core/constants/app_constants.dart';
import 'package:field_app/core/network/network_info.dart';
import 'package:field_app/core/errors/failures.dart';
import 'package:field_app/core/errors/exceptions.dart';
import 'package:field_app/data/datasources/local/task_local_datasource.dart';
import 'package:field_app/data/datasources/local/database_helper.dart';
import 'package:field_app/data/datasources/remote/task_remote_datasource.dart';
import 'package:field_app/data/repositories/task_repository_impl.dart';
import 'package:field_app/data/repositories/sync_repository_impl.dart';
import 'package:field_app/domain/repositories/task_repository.dart';
import 'package:field_app/domain/repositories/sync_repository.dart';
import 'package:field_app/domain/usecases/get_local_tasks.dart';
import 'package:field_app/domain/usecases/save_task_local.dart';
import 'package:field_app/domain/usecases/sync_tasks.dart';
import 'package:field_app/domain/usecases/resolve_conflict.dart';
import 'package:field_app/presentation/bloc/task/task_bloc.dart';
import 'package:field_app/presentation/bloc/task/task_event.dart';
import 'package:field_app/presentation/bloc/sync/sync_bloc.dart';
import 'package:field_app/presentation/bloc/sync/sync_event.dart';
import 'package:field_app/presentation/pages/home_page.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  
  final databaseHelper = DatabaseHelper();
  await databaseHelper.database;
  sl.registerLazySingleton<DatabaseHelper>(() => databaseHelper);
  
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(databaseHelper: sl()),
  );
  
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(dio: sl()),
  );
  
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  sl.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  sl.registerLazySingleton(() => GetLocalTasks(sl()));
  sl.registerLazySingleton(() => SaveTaskLocal(sl()));
  sl.registerLazySingleton(() => SyncTasks(sl()));
  sl.registerLazySingleton(() => ResolveConflict(sl()));
  
  sl.registerFactory(() => TaskBloc(
    getLocalTasks: sl(),
    saveTaskLocal: sl(),
    resolveConflict: sl(),
  ));
  
  sl.registerFactory(() => SyncBloc(
    syncTasks: sl(),
    networkInfo: sl(),
  ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDependencies();
  
  runApp(const FieldApp());
}

class FieldApp extends StatelessWidget {
  const FieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>()..add(LoadTasksEvent()),
        ),
        BlocProvider<SyncBloc>(
          create: (context) => sl<SyncBloc>()..add(StartNetworkMonitoring()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}