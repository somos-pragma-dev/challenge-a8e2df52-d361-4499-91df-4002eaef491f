import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'core/config/app_config.dart';
import 'core/database/app_database.dart';
import 'core/network/connectivity_service.dart';
import 'core/error/failures.dart';
import 'domain/repositories/client_repository.dart';
import 'domain/repositories/credit_application_repository.dart';
import 'data/repositories/client_repository_impl.dart';
import 'data/repositories/credit_application_repository_impl.dart';
import 'presentation/screens/client_list_screen.dart';
import 'presentation/viewmodels/client_viewmodel.dart';
import 'presentation/viewmodels/sync_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final database = AppDatabase.instance;
  final connectivityService = ConnectivityService();
  final appConfig = AppConfig();
  
  await database.initialize();
  
  final getIt = GetIt.instance;
  getIt.registerSingleton<AppDatabase>(database);
  getIt.registerSingleton<ConnectivityService>(connectivityService);
  getIt.registerSingleton<AppConfig>(appConfig);
  
  getIt.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      connectivityService: getIt(),
    ),
  );
  
  getIt.registerLazySingleton<CreditApplicationRepository>(
    () => CreditApplicationRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      connectivityService: getIt(),
    ),
  );
  
  runApp(const CreditFieldApp());
}

class CreditFieldApp extends StatelessWidget {
  const CreditFieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClientViewModel>(
          create: (context) => ClientViewModel(
            clientRepository: GetIt.instance<ClientRepository>(),
            connectivityService: GetIt.instance<ConnectivityService>(),
          ),
        ),
        BlocProvider<SyncViewModel>(
          create: (context) => SyncViewModel(
            clientRepository: GetIt.instance<ClientRepository>(),
            creditApplicationRepository: GetIt.instance<CreditApplicationRepository>(),
            connectivityService: GetIt.instance<ConnectivityService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Campo de Crédito',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ClientListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}