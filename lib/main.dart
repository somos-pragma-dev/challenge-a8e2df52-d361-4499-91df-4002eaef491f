import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:offline_field_app/core/constants/app_constants.dart';
import 'package:offline_field_app/core/network/network_info.dart';
import 'package:offline_field_app/data/datasources/local/database_helper.dart';
import 'package:offline_field_app/data/datasources/local/transaction_local_datasource.dart';
import 'package:offline_field_app/data/datasources/local/sync_local_datasource.dart';
import 'package:offline_field_app/data/repositories/transaction_repository_impl.dart';
import 'package:offline_field_app/data/repositories/sync_repository_impl.dart';
import 'package:offline_field_app/domain/repositories/transaction_repository.dart';
import 'package:offline_field_app/domain/repositories/sync_repository.dart';
import 'package:offline_field_app/domain/usecases/create_transaction.dart';
import 'package:offline_field_app/domain/usecases/get_pending_transactions.dart';
import 'package:offline_field_app/domain/usecases/sync_transactions.dart';
import 'package:offline_field_app/domain/usecases/resolve_conflict.dart';
import 'package:offline_field_app/presentation/providers/transaction_provider.dart';
import 'package:offline_field_app/presentation/providers/sync_provider.dart';
import 'package:offline_field_app/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final databaseHelper = DatabaseHelper();
  await databaseHelper.database;
  
  runApp(const OfflineFieldApp());
}

class OfflineFieldApp extends StatelessWidget {
  const OfflineFieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseHelper>(
          create: (_) => DatabaseHelper(),
        ),
        Provider<TransactionLocalDataSource>(
          create: (context) => TransactionLocalDataSourceImpl(
            databaseHelper: context.read<DatabaseHelper>(),
          ),
        ),
        Provider<SyncLocalDataSource>(
          create: (context) => SyncLocalDataSourceImpl(
            databaseHelper: context.read<DatabaseHelper>(),
          ),
        ),
        Provider<TransactionRepository>(
          create: (context) => TransactionRepositoryImpl(
            localDataSource: context.read<TransactionLocalDataSource>(),
            syncLocalDataSource: context.read<SyncLocalDataSource>(),
          ),
        ),
        Provider<SyncRepository>(
          create: (context) => SyncRepositoryImpl(
            localDataSource: context.read<SyncLocalDataSource>(),
          ),
        ),
        Provider<CreateTransaction>(
          create: (context) => CreateTransaction(
            repository: context.read<TransactionRepository>(),
          ),
        ),
        Provider<GetPendingTransactions>(
          create: (context) => GetPendingTransactions(
            repository: context.read<TransactionRepository>(),
          ),
        ),
        Provider<SyncTransactions>(
          create: (context) => SyncTransactions(
            transactionRepository: context.read<TransactionRepository>(),
            syncRepository: context.read<SyncRepository>(),
          ),
        ),
        Provider<ResolveConflict>(
          create: (context) => ResolveConflict(
            syncRepository: context.read<SyncRepository>(),
          ),
        ),
        StreamProvider<NetworkStatus>(
          create: (context) => NetworkInfoImpl().onConnectivityChanged,
          initialData: NetworkStatus.unknown,
        ),
        ChangeNotifierProvider<TransactionProvider>(
          create: (context) => TransactionProvider(
            createTransaction: context.read<CreateTransaction>(),
            getPendingTransactions: context.read<GetPendingTransactions>(),
          ),
        ),
        ChangeNotifierProvider<SyncProvider>(
          create: (context) => SyncProvider(
            syncTransactions: context.read<SyncTransactions>(),
            resolveConflict: context.read<ResolveConflict>(),
          ),
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
        ),
        home: const HomeScreen(),
      ),
    );
  }
}