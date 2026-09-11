class AppConstants {
  static const String appName = 'Field Operations';
  static const int primaryColor = 0xFF1E88E5;
  static const int errorColor = 0xFFD32F2F;
  static const int successColor = 0xFF388E3C;
  static const int warningColor = 0xFFF57C00;
  
  static const String baseUrl = 'https://api.fieldoperations.example.com';
  static const String apiVersion = 'v1';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  static const String databaseName = 'field_operations.db';
  static const int databaseVersion = 1;
  
  static const String transactionsTable = 'transactions';
  static const String syncRecordsTable = 'sync_records';
  static const String pendingOperationsTable = 'pending_operations';
  
  static const int schemaVersion = 1;
  static const int minSchemaVersion = 1;
  
  static const int maxRetryAttempts = 3;
  static const int retryDelaySeconds = 5;
  static const int syncBatchSize = 50;
  
  static const String syncStatusPending = 'pending';
  static const String syncStatusInProgress = 'in_progress';
  static const String syncStatusCompleted = 'completed';
  static const String syncStatusFailed = 'failed';
  static const String syncStatusConflict = 'conflict';
  
  static const String conflictStrategyLastWriteWins = 'last_write_wins';
  static const String conflictStrategyServerWins = 'server_wins';
  static const String conflictStrategyClientWins = 'client_wins';
  static const String conflictStrategyManual = 'manual';
  
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  static const List<String> supportedTransactionTypes = [
    'sale',
    'return',
    'exchange',
    'refund',
    'adjustment',
  ];
  
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'MXN',
    'COP',
  ];
  
  static const Map<String, int> maxAmountsByCurrency = {
    'USD': 10000,
    'EUR': 10000,
    'GBP': 8000,
    'MXN': 200000,
    'COP': 40000000,
  };
  
  static const Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'MXN': '\$',
    'COP': '\$',
  };
  
  static String getApiUrl(String endpoint) {
    return '$baseUrl/$apiVersion/$endpoint';
  }
  
  static String formatAmount(double amount, String currency) {
    final symbol = currencySymbols[currency] ?? currency;
    return '$symbol${amount.toStringAsFixed(2)}';
  }
  
  static bool isValidAmount(double amount, String currency) {
    final maxAmount = maxAmountsByCurrency[currency];
    if (maxAmount == null) return false;
    return amount > 0 && amount <= maxAmount;
  }
  
  static bool isValidTransactionType(String type) {
    return supportedTransactionTypes.contains(type);
  }
  
  static bool isValidCurrency(String currency) {
    return supportedCurrencies.contains(currency);
  }
}

class DatabaseColumns {
  static const String id = 'id';
  static const String uuid = 'uuid';
  static const String externalId = 'external_id';
  static const String amount = 'amount';
  static const String currency = 'currency';
  static const String transactionType = 'transaction_type';
  static const String description = 'description';
  static const String metadata = 'metadata';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String version = 'version';
  static const String syncStatus = 'sync_status';
  static const String hash = 'hash';
  static const String operationType = 'operation_type';
  static const String conflictData = 'conflict_data';
}