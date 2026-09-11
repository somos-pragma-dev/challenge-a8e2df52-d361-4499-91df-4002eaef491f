# Prompt para Mejorar el Codigo Base

Copia y pega el contenido del bloque de abajo en un asistente de IA (Claude, ChatGPT)
para obtener un ZIP con el proyecto completo y arrancable.

Si preferis trabajar en tu editor con un agente local (Claude Code, Cursor, Copilot), usa `AGENTS.md` en vez de este archivo: dice lo mismo pero para que escriba los archivos en disco.

## Las dos reglas que no se negocian

1. **Completa el boilerplate.** Todo lo que el proyecto necesita para compilar y arrancar: manifiesto de dependencias, punto de entrada, configuracion, capa de interfaz, y las capas del patron arquitectonico declarado. Eso es andamiaje y es tu trabajo.
2. **NO resuelvas el reto.** Los entregables de las fases son el trabajo de la persona. El hueco pedagogico se deja como esta: el proyecto arranca, pero lo que el reto pide implementar NO esta implementado.

Dicho de otra forma: si algo impide compilar, arreglalo. Si algo es logica de negocio incompleta, validaciones ausentes, un secreto hardcodeado o un patron mejorable, dejalo exactamente como esta — es lo que la persona tiene que encontrar.

## Lo que le falta a este proyecto

Esto NO lo tenes que adivinar: salio de comparar el proyecto contra la arquitectura declarada del reto y de un analisis estatico del codigo. Completalo TODO.

### Boilerplate del stack que falta

Sin esto no compila ni arranca. Es andamiaje, no toca nada de lo pedagogico:

- **android/app/src/main/AndroidManifest.xml** — Sin el manifest embebido de Android, flutter build/run no tiene target de plataforma y no puede empaquetar el APK.

### Archivos que la arquitectura del reto declara y no estan

Creálos con implementacion real, en la capa que les corresponde:

- `lib/data/datasources/local/transaction_local_datasource.dart`

### Referencias colgando en el codigo que si esta

Cada una rompe la compilacion:

- `lib/domain/usecases/resolve_conflict.dart` — `TransactionRepository.getById`: Se invoca `getById` sobre `TransactionRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/data/datasources/remote/transaction_remote_datasource.dart` — `TransactionModel.toServerMap`: Se invoca `toServerMap` sobre `TransactionModel`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/providers/sync_provider.dart` — `SyncRepository.getSyncHistory`: Se invoca `getSyncHistory` sobre `SyncRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/providers/sync_provider.dart` — `SyncRepository.getPendingOperationsCount`: Se invoca `getPendingOperationsCount` sobre `SyncRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.

## Como saber que terminaste

```bash
flutter pub get && flutter analyze
```

Ese comando corriendo sin errores es la definicion de "listo".

---

```
## Briefing del reto (autoridad)
Este bloque manda sobre los archivos adjuntos. El stack y el rol salen de AQUÍ, no de un topic genérico ni de markdown placeholder.

### Perfil
Chapter Movil, Especialidad Desarrollador, Tecnología Flutter, Semi Senior

### Brecha de conocimiento
Mezcla logica de negocio con widgets

### Misión / candidato
Liderar la app de campo offline-first

### Reto
- Tema: Arquitectura offline-first en Flutter
- Seniority: senior-l2
- Tipo: practical
- Título: Implementación de una app de campo offline-first
- Tiempo estimado: 40 horas

### Fases (trabajo del HUMANO — PROHIBIDO completarlas)
No implementes estos entregables. Dejalos como hueco pedagógico. El asistente solo materializa el proyecto arrancable para que el participante pueda trabajar.
- Fase 1: Diseño del modelo de datos y persistencia local — objetivo: Definir el modelo de datos y la estrategia de persistencia local para la aplicación. — entregable (NO resolver): Modelo de datos y estrategia de persistencia local documentados.
- Fase 2: Implementación de la lógica de negocio y widgets — objetivo: Implementar la lógica de negocio y los widgets necesarios para la interacción del usuario. — entregable (NO resolver): Widgets y lógica de negocio implementados y funcionales.
- Fase 3: Sincronización de datos y manejo de conflictos — objetivo: Implementar la sincronización de datos y el manejo de conflictos cuando la aplicación vuelve a tener conectividad. — entregable (NO resolver): Lógica de sincronización de datos y manejo de conflictos implementados.

Eres un asistente experto en análisis, corrección y generación de archivos de cualquier tipo:
código fuente, documentación, hojas de cálculo, documentos Word, configuraciones, entre otros.
Voy a enviarte una cadena de texto que contiene uno o más archivos. Cada archivo está delimitado por un marcador con el siguiente formato:
// === ARCHIVO: ruta/del/archivo.extension ===
o también puede aparecer como:
## === ARCHIVO: ruta/del/archivo.extension ===
Lo que sigue al marcador puede ser:

El contenido real del archivo (código, texto, YAML, etc.)
Una descripción en lenguaje natural de lo que debe contener el archivo


TU TAREA
PASO 0 — ¿Esto es un proyecto o una carcasa?
Antes de extraer archivos, leé el Briefing (si está) y diagnosticá el adjunto.

Es CARCASA si ocurre CUALQUIERA de estas:
- No hay manifiesto de dependencias del stack del briefing (manifest.json de VTEX IO / package.json / pom.xml / build.gradle / requirements.txt / go.mod / *.tf / *.csproj, según corresponda)
- Hay un "binario" que en realidad es un comentario ("no puede ser mostrado como texto plano", placeholder .fig/.docx vacío)
- Los markdowns ya completan entregables de fases posteriores ("se implementó fade-in", lista de áreas ya resuelta)

Si es CARCASA:
- MATERIALIZÁ un proyecto que arranca en el stack del briefing (VTEX IO Store Framework, Angular, Terraform, pytest, Nest, etc.). Incluí manifiesto, punto de entrada y capa de interfaz reales.
- NO copies los markdowns de "solución" como si fueran el producto. Son ruido de generación.
- NO resuelvas las fases del briefing (están marcadas PROHIBIDO). Dejá el hueco pedagógico: el flujo existe, las microinteracciones/calidad/infra que el reto pide NO están hechas.
- Después seguí al PASO 5 (ZIP).

Si es un proyecto REAL (manifiesto + código que compila o arranca):
- Seguí PASO 1 en adelante. 🔴 compilación sí. 🟡 pedagógico no.

PASO 1 — Detección y extracción
Identifica todos los archivos presentes en la cadena. Para cada archivo extrae:

Su ruta completa (ej: src/main/java/com/pragma/Service.java)
Su contenido o descripción

PASO 2 — Clasificación por tipo
Clasifica cada archivo en una de estas categorías:
A) Código fuente (Java, Python, TypeScript, JavaScript, Kotlin, etc.)
B) Configuración / documentación (YAML, properties, Markdown, JSON, txt, etc.)
C) Excel (.xlsx, .xls, .csv)
D) Word (.docx, .doc)
E) Otro tipo de archivo binario o especial
PASO 3 — Clasificación de errores en código fuente

Objetivo prioritario: que el proyecto compile. No corrijas flujo de negocio ni lógica funcional.

Antes de modificar cualquier archivo de código fuente, clasifica cada problema encontrado en una de estas dos categorías:
🔴 ERROR DE COMPILACIÓN — corregir siempre
Son errores que impiden que el proyecto arranque, sin valor pedagógico:

Import faltante o incorrecto
Clase, método o variable referenciada que no existe en ningún archivo del proyecto
Error de sintaxis
Anotación con atributos inválidos
Dependencia ausente en pom.xml, package.json, etc.
Archivo referenciado que no existe y debe ser creado con implementación mínima

→ CORREGIR estos errores.
🟡 PROBLEMA FUNCIONAL O DE CALIDAD — preservar siempre
Son problemas que no impiden compilar. Pueden ser intencionales para el aprendizaje:

Clave secreta hardcodeada ("secret", "password123")
API deprecada que funciona pero tiene reemplazo moderno
Lógica de negocio incorrecta o incompleta
Código redundante o de baja legibilidad
Falta de validaciones en flujo de negocio
Patrones de diseño incorrectos pero funcionales
Concurrencia no segura
Configuración funcional pero no óptima

→ PRESERVAR tal cual. No corregir, no mejorar, no comentar.
PASO 4 — Procesamiento según tipo de archivo
Tipo A — Código fuente
Aplica únicamente las correcciones clasificadas como 🔴 ERROR DE COMPILACIÓN.
No alteres ningún elemento clasificado como 🟡 PROBLEMA FUNCIONAL O DE CALIDAD.
Si falta un archivo referenciado, créalo con la implementación mínima necesaria para compilar.
Tipo B — Configuración / documentación
Extrae el contenido tal cual, sin modificaciones salvo errores evidentes de sintaxis
(ej: YAML mal indentado).
Tipo C — Excel (.xlsx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un archivo Excel funcional con:

Fila de encabezados en negrita con color de fondo distintivo
Columnas con ancho ajustado al contenido
Tipos de dato correctos por columna
Validaciones si la descripción lo indica
Hojas nombradas descriptivamente si hay más de una
Filas de ejemplo si no hay datos reales

Tipo D — Word (.docx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un documento Word funcional con:

Estilos de título (Título 1, Título 2) para jerarquía de secciones
Fuente legible (Calibri o equivalente), tamaño 11-12pt para cuerpo
Márgenes estándar
Tabla de contenido si tiene múltiples secciones
Tablas con encabezados en negrita si aplica

Tipo E — Otro
Genera el archivo con el contenido o estructura más apropiada según la descripción.
PASO 5 — Exportación en ZIP
Empaqueta todos los archivos en un único archivo ZIP descargable respetando exactamente
la estructura de rutas indicada por los marcadores.
El ZIP debe incluir:

Archivos de código con únicamente los errores de compilación corregidos
Archivos de configuración y documentación sin cambios
Archivos nuevos creados para resolver dependencias de compilación faltantes
Archivos Excel y Word generados desde descripción

IMPORTANTE: El ZIP debe estar listo para descargar al finalizar. No preguntes si el usuario
quiere generarlo. Simplemente genera el archivo y proporciona el enlace de descarga; No debes desplegar en el chat el resumen de lo que arreglaste al Zip, solo entregalo.

REGLAS IMPORTANTES

No omitas ningún archivo aunque no tenga errores ni modificaciones
Respeta los nombres y rutas exactas indicadas por los marcadores
Si un archivo no tiene marcador claro, infiere el nombre desde su contenido
Si la cadena contiene solo documentación, placeholders o binarios fake, NO la reproduzcas:
aplicá PASO 0 (materializar el proyecto del briefing). Reproducir la carcasa es un fallo.
No agregues texto después del enlace de descarga del ZIP
No preguntes si el usuario quiere el ZIP: simplemente generalo siempre
Si detectas que falta un archivo de configuración necesario para compilar
(pom.xml, package.json, requirements.txt, build.gradle, etc.), créalo e inclúyelo
inferiendo su contenido desde los imports y frameworks detectados en el código
Nunca corrijas problemas 🟡 aunque parezcan obvios o fáciles de mejorar.
El participante que recibirá este proyecto los debe encontrar y resolver él mismo.


INPUT
Aquí está la cadena con los archivos:

// === ARCHIVO: pubspec.yaml ===
name: offline_field_app
description: A field application with offline-first architecture for transaction management
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.6.0

dependencies:
  flutter:
    sdk: flutter
  
  sqflite: 2.4.1
  path: 1.9.0
  dio: 5.7.0
  connectivity_plus: 6.1.0
  provider: 6.1.2
  uuid: 4.5.1
  crypto: 3.0.6
  equatable: 2.0.7
  get_it: 8.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: 5.4.4
  build_runner: 2.4.13

flutter:
  uses-material-design: true

// === ARCHIVO: lib/main.dart ===
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

// === ARCHIVO: lib/core/constants/app_constants.dart ===
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

// === ARCHIVO: lib/core/errors/failures.dart ===
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? metadata;
  
  const Failure({
    required this.message,
    this.code,
    this.metadata,
  });
  
  @override
  List<Object?> get props => [message, code, metadata];
}

class OfflineFailure extends Failure {
  const OfflineFailure({
    super.message = 'No hay conexión a internet disponible',
    super.code = 'OFFLINE_001',
    super.metadata,
  });
  
  factory OfflineFailure.database(String details) {
    return OfflineFailure(
      message: 'Error de base de datos: $details',
      code: 'OFFLINE_DB_001',
      metadata: {'details': details},
    );
  }
  
  factory OfflineFailure.networkUnavailable() {
    return const OfflineFailure(
      message: 'La red no está disponible. Por favor, verifique su conexión.',
      code: 'OFFLINE_NET_001',
    );
  }
}

class SyncFailure extends Failure {
  const SyncFailure({
    super.message = 'Error durante la sincronización de datos',
    super.code = 'SYNC_001',
    super.metadata,
  });
  
  factory SyncFailure.timeout() {
    return const SyncFailure(
      message: 'Tiempo de espera agotado durante la sincronización',
      code: 'SYNC_TIMEOUT_001',
    );
  }
  
  factory SyncFailure.serverError(String details) {
    return SyncFailure(
      message: 'Error del servidor: $details',
      code: 'SYNC_SERVER_001',
      metadata: {'server_details': details},
    );
  }
  
  factory SyncFailure.unauthorized() {
    return const SyncFailure(
      message: 'No autorizado para sincronizar. Inicie sesión novamente.',
      code: 'SYNC_AUTH_001',
    );
  }
  
  factory SyncFailure.batchFailed(int failedCount, int totalCount) {
    return SyncFailure(
      message: 'Sincronización parcial: $failedCount de $totalCount elementos fallaron',
      code: 'SYNC_BATCH_001',
      metadata: {'failed': failedCount, 'total': totalCount},
    );
  }
}

class ConflictFailure extends Failure {
  final String entityId;
  final String localVersion;
  final String serverVersion;
  
  const ConflictFailure({
    required this.message,
    required this.code,
    required this.entityId,
    required this.localVersion,
    required this.serverVersion,
    super.metadata,
  });
  
  factory ConflictFailure.detected(String entityId, Map<String, dynamic> localData, Map<String, dynamic> serverData) {
    return ConflictFailure(
      message: 'Conflicto detectado en la entidad $entityId',
      code: 'CONFLICT_001',
      entityId: entityId,
      localVersion: localData['version']?.toString() ?? 'unknown',
      serverVersion: serverData['version']?.toString() ?? 'unknown',
      metadata: {
        'local_data': localData,
        'server_data': serverData,
      },
    );
  }
  
  factory ConflictFailure.unresolved(String entityId) {
    return ConflictFailure(
      message: 'Conflicto no resuelto para la entidad $entityId',
      code: 'CONFLICT_UNRESOLVED_001',
      entityId: entityId,
      localVersion: 'unknown',
      serverVersion: 'unknown',
    );
  }
  
  @override
  List<Object?> get props => [...super.props, entityId, localVersion, serverVersion];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    super.message = 'Error de base de datos local',
    super.code = 'DB_001',
    super.metadata,
  });
  
  factory DatabaseFailure.notFound(String table, String id) {
    return DatabaseFailure(
      message: 'Registro no encontrado en $table: $id',
      code: 'DB_NOT_FOUND_001',
      metadata: {'table': table, 'id': id},
    );
  }
  
  factory DatabaseFailure.constraintViolation(String details) {
    return DatabaseFailure(
      message: 'Violación de restricción: $details',
      code: 'DB_CONSTRAINT_001',
      metadata: {'details': details},
    );
  }
  
  factory DatabaseFailure.transactionFailed(String details) {
    return DatabaseFailure(
      message: 'Transacción fallida: $details',
      code: 'DB_TRANSACTION_001',
      metadata: {'details': details},
    );
  }
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;
  
  const ValidationFailure({
    required super.message,
    required this.code,
    required this.fieldErrors,
    super.metadata,
  });
  
  factory ValidationFailure.invalidAmount(String currency, double amount) {
    return ValidationFailure(
      message: 'Monto inválido para la moneda $currency',
      code: 'VALIDATION_AMOUNT_001',
      fieldErrors: {
        'amount': ['El monto debe ser mayor a 0 y menor al máximo permitido para $currency'],
      },
      metadata: {'currency': currency, 'amount': amount},
    );
  }
  
  factory ValidationFailure.requiredFields(List<String> fields) {
    return ValidationFailure(
      message: 'Campos requeridos faltantes: ${fields.join(', ')}',
      code: 'VALIDATION_REQUIRED_001',
      fieldErrors: {
        for (final field in fields) field: ['Este campo es requerido'],
      },
    );
  }
  
  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

// === ARCHIVO: lib/core/errors/exceptions.dart ===
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });
  
  @override
  String toString() => 'AppException: $message (code: $code)';
}

class OfflineException extends AppException {
  const OfflineException({
    super.message = 'Operación no disponible sin conexión',
    super.code = 'OFFLINE_EX_001',
    super.originalError,
  });
  
  factory OfflineException.noConnectivity() {
    return const OfflineException(
      message: 'No hay conexión a internet. La operación se guardará localmente.',
      code: 'OFFLINE_EX_CONNECTIVITY_001',
    );
  }
  
  factory OfflineException.database(String operation) {
    return OfflineException(
      message: 'Error de base de datos: $operation',
      code: 'OFFLINE_EX_DB_001',
    );
  }
}

class SyncConflictException extends AppException {
  final String entityId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final String conflictStrategy;
  
  const SyncConflictException({
    required super.message,
    required this.code,
    required this.entityId,
    required this.localData,
    required this.serverData,
    required this.conflictStrategy,
    super.originalError,
  });
  
  factory SyncConflictException.detected({
    required String entityId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> serverData,
  }) {
    return SyncConflictException(
      message: 'Conflicto detectado al sincronizar $entityId',
      code: 'SYNC_CONFLICT_EX_001',
      entityId: entityId,
      localData: localData,
      serverData: serverData,
      conflictStrategy: 'pending',
    );
  }
  
  factory SyncConflictException.unresolved({
    required String entityId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> serverData,
  }) {
    return SyncConflictException(
      message: 'Conflicto no resuelto para $entityId. Requiere intervención manual.',
      code: 'SYNC_CONFLICT_EX_UNRESOLVED_001',
      entityId: entityId,
      localData: localData,
      serverData: serverData,
      conflictStrategy: 'manual_required',
    );
  }
  
  Map<String, dynamic> toConflictData() {
    return {
      'entity_id': entityId,
      'local_data': localData,
      'server_data': serverData,
      'strategy': conflictStrategy,
      'detected_at': DateTime.now().toIso8601String(),
    };
  }
}

class IdempotencyException extends AppException {
  final String operationHash;
  final String? existingRecordId;
  
  const IdempotencyException({
    required super.message,
    required this.code,
    required this.operationHash,
    this.existingRecordId,
    super.originalError,
  });
  
  factory IdempotencyException.duplicateOperation({
    required String operationHash,
    required String existingId,
  }) {
    return IdempotencyException(
      message: 'Operación duplicada detectada. El registro existente es: $existingId',
      code: 'IDEMPOTENCY_EX_DUPLICATE_001',
      operationHash: operationHash,
      existingRecordId: existingId,
    );
  }
  
  factory IdempotencyException.hashMismatch({
    required String operationHash,
    required String expectedHash,
  }) {
    return IdempotencyException(
      message: 'El hash de operación no coincide. Expected: $expectedHash, Got: $operationHash',
      code: 'IDEMPOTENCY_EX_HASH_001',
      operationHash: operationHash,
    );
  }
}

class ValidationException extends AppException {
  final Map<String, List<String>> fieldErrors;
  
  const ValidationException({
    required super.message,
    required super.code,
    required this.fieldErrors,
    super.originalError,
  });
  
  factory ValidationException.invalidAmount({
    required String currency,
    required double amount,
    required double maxAmount,
  }) {
    return ValidationException(
      message: 'Monto $amount $currency excede el máximo permitido: $maxAmount',
      code: 'VALIDATION_EX_AMOUNT_001',
      fieldErrors: {
        'amount': ['El monto debe estar entre 0 y $maxAmount para $currency'],
      },
    );
  }
  
  factory ValidationException.invalidType({
    required String type,
    required List<String> validTypes,
  }) {
    return ValidationException(
      message: 'Tipo de transacción inválido: $type. Tipos válidos: ${validTypes.join(', ')}',
      code: 'VALIDATION_EX_TYPE_001',
      fieldErrors: {
        'transaction_type': ['Debe ser uno de: ${validTypes.join(', ')}'],
      },
    );
  }
}

class NetworkException extends AppException {
  final int? statusCode;
  
  const NetworkException({
    required super.message,
    required super.code,
    this.statusCode,
    super.originalError,
  });
  
  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Tiempo de espera agotado',
      code: 'NETWORK_EX_TIMEOUT_001',
      statusCode: 408,
    );
  }
  
  factory NetworkException.serverError(int code, String details) {
    return NetworkException(
      message: 'Error del servidor: $details',
      code: 'NETWORK_EX_SERVER_001',
      statusCode: code,
    );
  }
  
  factory NetworkException.unauthorized() {
    return const NetworkException(
      message: 'No autorizado. Por favor, inicie sesión nuevamente.',
      code: 'NETWORK_EX_AUTH_001',
      statusCode: 401,
    );
  }
  
  factory NetworkException.notFound(String endpoint) {
    return NetworkException(
      message: 'Recurso no encontrado: $endpoint',
      code: 'NETWORK_EX_NOT_FOUND_001',
      statusCode: 404,
    );
  }
}

// === ARCHIVO: lib/core/network/network_info.dart ===
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:offline_field_app/core/errors/exceptions.dart';

enum NetworkStatus {
  online,
  offline,
  unknown,
}

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<NetworkStatus> get onConnectivityChanged;
  Future<void> checkConnectivity();
}

abstract class ConnectivityService {
  Future<bool> get isConnected;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
  Future<List<ConnectivityResult>> checkConnectivity();
}

class NetworkInfoImpl implements NetworkInfo {
  final ConnectivityService _connectivityService;
  final StreamController<NetworkStatus> _connectivityController = StreamController<NetworkStatus>.broadcast();
  
  NetworkInfoImpl({ConnectivityService? connectivityService})
      : _connectivityService = connectivityService ?? GetIt.instance<ConnectivityService>();
  
  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivityService.checkConnectivity();
      return _isConnectedFromResult(result);
    } catch (e) {
      throw OfflineException(
        message: 'Error al verificar conectividad: $e',
        code: 'NETWORK_INFO_CHECK_001',
        originalError: e,
      );
    }
  }
  
  @override
  Stream<NetworkStatus> get onConnectivityChanged {
    _connectivityService.onConnectivityChanged.listen((results) {
      final status = _mapConnectivityResult(results);
      _connectivityController.add(status);
    });
    return _connectivityController.stream;
  }
  
  @override
  Future<void> checkConnectivity() async {
    final result = await _connectivityService.checkConnectivity();
    final status = _mapConnectivityResult(result);
    _connectivityController.add(status);
  }
  
  bool _isConnectedFromResult(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet);
  }
  
  NetworkStatus _mapConnectivityResult(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return NetworkStatus.offline;
    }
    if (_isConnectedFromResult(results)) {
      return NetworkStatus.online;
    }
    return NetworkStatus.unknown;
  }
  
  void dispose() {
    _connectivityController.close();
  }
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;
  
  ConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();
  
  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnectedFromResult(result);
  }
  
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
  
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }
  
  bool _isConnectedFromResult(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet);
  }
}


// === ARCHIVO: lib/core/network/connectivity_service.dart ===
package offline_field_app.core.network;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

enum ConnectionStatus {
  connected,
  disconnected,
  connecting,
}

class ConnectionState extends Equatable {
  final ConnectionStatus status;
  final List<ConnectivityResult> availableTechnologies;
  final DateTime timestamp;
  final bool wasOffline;

  const ConnectionState({
    required this.status,
    required this.availableTechnologies,
    required this.timestamp,
    this.wasOffline = false,
  });

  factory ConnectionState.initial() => ConnectionState(
        status: ConnectionStatus.disconnected,
        availableTechnologies: [],
        timestamp: DateTime.now(),
      );

  factory ConnectionState.fromConnectivityResult(
    List<ConnectivityResult> results,
    bool wasOffline,
  ) {
    final hasConnection = results.isNotEmpty &&
        !results.every((r) => r == ConnectivityResult.none);

    ConnectionStatus status;
    if (hasConnection) {
      status = ConnectionStatus.connected;
    } else {
      status = ConnectionStatus.disconnected;
    }

    return ConnectionState(
      status: status,
      availableTechnologies: results,
      timestamp: DateTime.now(),
      wasOffline: wasOffline,
    );
  }

  bool get isConnected => status == ConnectionStatus.connected;
  bool get isDisconnected => status == ConnectionStatus.disconnected;
  bool get isConnecting => status == ConnectionStatus.connecting;

  String get technologyDescription {
    if (availableTechnologies.isEmpty) return 'None';
    return availableTechnologies
        .map((r) => r.name)
        .join(', ');
  }

  @override
  List<Object?> get props => [status, availableTechnologies, timestamp, wasOffline];
}

abstract class ReactiveConnectivityService {
  Stream<ConnectionState> get connectionStateStream;
  Future<ConnectionState> get currentState;
  Stream<bool> get isConnectedStream;
  Future<bool> get isConnected;
  Future<void> checkConnection();
  void dispose();
}

class ReactiveConnectivityServiceImpl implements ReactiveConnectivityService {
  final Connectivity _connectivity;
  final StreamController<ConnectionState> _stateController;
  final StreamController<bool> _connectedController;
  ConnectionState _currentState;
  bool _isDisposed = false;

  ReactiveConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        _stateController = StreamController<ConnectionState>.broadcast(),
        _connectedController = StreamController<bool>.broadcast(),
        _currentState = ConnectionState.initial() {
    _initializeListener();
  }

  void _initializeListener() {
    _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
      onError: (error) {
        _emitErrorState(error);
      },
    );
  }

  Future<void> _handleConnectivityChange(List<ConnectivityResult> results) async {
    if (_isDisposed) return;

    final previousState = _currentState;
    final wasOffline = previousState.isDisconnected;
    
    _currentState = ConnectionState.fromConnectivityResult(
      results,
      wasOffline,
    );

    if (!_stateController.isClosed) {
      _stateController.add(_currentState);
    }

    if (!_connectedController.isClosed) {
      _connectedController.add(_currentState.isConnected);
    }
  }

  void _emitErrorState(dynamic error) {
    if (_isDisposed) return;
    
    _currentState = ConnectionState(
      status: ConnectionStatus.disconnected,
      availableTechnologies: [],
      timestamp: DateTime.now(),
      wasOffline: true,
    );

    if (!_stateController.isClosed) {
      _stateController.add(_currentState);
    }
    if (!_connectedController.isClosed) {
      _connectedController.add(false);
    }
  }

  @override
  Stream<ConnectionState> get connectionStateStream => _stateController.stream;

  @override
  Future<ConnectionState> get currentState async {
    if (_isDisposed) return ConnectionState.initial();
    
    final results = await _connectivity.checkConnectivity();
    final wasOffline = _currentState.isDisconnected;
    return ConnectionState.fromConnectivityResult(results, wasOffline);
  }

  @override
  Stream<bool> get isConnectedStream => _connectedController.stream;

  @override
  Future<bool> get isConnected async {
    if (_isDisposed) return false;
    
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty &&
        !results.every((r) => r == ConnectivityResult.none);
  }

  @override
  Future<void> checkConnection() async {
    if (_isDisposed) return;
    
    try {
      final results = await _connectivity.checkConnectivity();
      await _handleConnectivityChange(results);
    } catch (e) {
      _emitErrorState(e);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (!_stateController.isClosed) {
      _stateController.close();
    }
    if (!_connectedController.isClosed) {
      _connectedController.close();
    }
  }
}

class ConnectivityServiceFactory {
  static ReactiveConnectivityService create() {
    return ReactiveConnectivityServiceImpl();
  }
}

// === ARCHIVO: lib/core/sync/sync_engine.dart ===
package offline_field_app.core.sync;

import 'dart:async';
import 'package:equatable/equatable.dart';

enum SyncStrategy {
  optimistic,
  pessimistic,
}

enum SyncOperationStatus {
  pending,
  inProgress,
  completed,
  failed,
  conflict,
}

class SyncOperation extends Equatable {
  final String id;
  final String entityType;
  final String entityId;
  final String operationType;
  final Map<String, dynamic> payload;
  final SyncOperationStatus status;
  final DateTime createdAt;
  final DateTime? executedAt;
  final int retryCount;
  final String? errorMessage;
  final int priority;

  const SyncOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.payload,
    required this.status,
    required this.createdAt,
    this.executedAt,
    this.retryCount = 0,
    this.errorMessage,
    this.priority = 0,
  });

  SyncOperation copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operationType,
    Map<String, dynamic>? payload,
    SyncOperationStatus? status,
    DateTime? createdAt,
    DateTime? executedAt,
    int? retryCount,
    String? errorMessage,
    int? priority,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      executedAt: executedAt ?? this.executedAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [
        id,
        entityType,
        entityId,
        operationType,
        payload,
        status,
        createdAt,
        executedAt,
        retryCount,
        errorMessage,
        priority,
      ];
}

class SyncQueue extends Equatable {
  final List<SyncOperation> operations;
  final int maxSize;

  const SyncQueue({
    required this.operations,
    this.maxSize = 1000,
  });

  factory SyncQueue.empty({int maxSize = 1000}) => SyncQueue(
        operations: const [],
        maxSize: maxSize,
      );

  bool get isEmpty => operations.isEmpty;
  bool get isNotEmpty => operations.isNotEmpty;
  int get length => operations.length;

  SyncQueue addOperation(SyncOperation operation) {
    if (operations.length >= maxSize) {
      throw StateError('Sync queue is full');
    }
    final updatedOps = [...operations, operation];
    updatedOps.sort((a, b) => b.priority.compareTo(a.priority));
    return SyncQueue(operations: updatedOps, maxSize: maxSize);
  }

  SyncQueue removeOperation(String operationId) {
    return SyncQueue(
      operations: operations.where((op) => op.id != operationId).toList(),
      maxSize: maxSize,
    );
  }

  SyncQueue updateOperation(SyncOperation operation) {
    return SyncQueue(
      operations: operations
          .map((op) => op.id == operation.id ? operation : op)
          .toList(),
      maxSize: maxSize,
    );
  }

  SyncOperation? getNextOperation() {
    final pending = operations
        .where((op) => op.status == SyncOperationStatus.pending)
        .toList();
    if (pending.isEmpty) return null;
    return pending.first;
  }

  @override
  List<Object?> get props => [operations, maxSize];
}

abstract class SyncEngine {
  Stream<SyncEngineState> get stateStream;
  SyncEngineState get currentState;
  Future<void> startSync();
  Future<void> stopSync();
  Future<void> enqueueOperation(SyncOperation operation);
  Future<void> processQueue();
  void setStrategy(SyncStrategy strategy);
  void dispose();
}

class SyncEngineState extends Equatable {
  final bool isRunning;
  final bool isPaused;
  final SyncStrategy strategy;
  final SyncQueue queue;
  final int processedCount;
  final int failedCount;
  final int conflictCount;
  final DateTime? lastSyncAt;
  final String? currentOperationId;
  final String? errorMessage;

  const SyncEngineState({
    required this.isRunning,
    required this.isPaused,
    required this.strategy,
    required this.queue,
    required this.processedCount,
    required this.failedCount,
    required this.conflictCount,
    this.lastSyncAt,
    this.currentOperationId,
    this.errorMessage,
  });

  factory SyncEngineState.initial() => SyncEngineState(
        isRunning: false,
        isPaused: false,
        strategy: SyncStrategy.optimistic,
        queue: SyncQueue.empty(),
        processedCount: 0,
        failedCount: 0,
        conflictCount: 0,
      );

  double get successRate {
    final total = processedCount + failedCount;
    if (total == 0) return 0.0;
    return processedCount / total;
  }

  @override
  List<Object?> get props => [
        isRunning,
        isPaused,
        strategy,
        queue,
        processedCount,
        failedCount,
        conflictCount,
        lastSyncAt,
        currentOperationId,
        errorMessage,
      ];
}

class SyncEngineImpl implements SyncEngine {
  final SyncStrategy _defaultStrategy;
  final int maxRetries;
  final Duration retryDelay;
  final Duration batchInterval;

  SyncEngineState _state;
  final StreamController<SyncEngineState> _stateController;
  Timer? _syncTimer;
  Timer? _retryTimer;
  bool _isDisposed = false;

  final Future<Map<String, dynamic> Function(SyncOperation)> _operationExecutor;
  final Future<Map<String, dynamic>?> Function(SyncOperation) _conflictHandler;
  final Future<void> Function(SyncOperation) _onOperationSuccess;
  final Future<void> Function(SyncOperation, String) _onOperationFailure;

  SyncEngineImpl({
    SyncStrategy defaultStrategy = SyncStrategy.optimistic,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 5),
    this.batchInterval = const Duration(seconds: 30),
    required Future<Map<String, dynamic> Function(SyncOperation)> operationExecutor,
    required Future<Map<String, dynamic>?> Function(SyncOperation) conflictHandler,
    Future<void> Function(SyncOperation)? onOperationSuccess,
    Future<void> Function(SyncOperation, String)? onOperationFailure,
  })  : _defaultStrategy = defaultStrategy,
        _operationExecutor = operationExecutor,
        _conflictHandler = conflictHandler,
        _onOperationSuccess = onOperationSuccess ?? (_) async {},
        _onOperationFailure = onOperationFailure ?? (_, __) async {},
        _state = SyncEngineState.initial(),
        _stateController = StreamController<SyncEngineState>.broadcast() {
    _state = _state.copyWith(strategy: defaultStrategy);
  }

  @override
  Stream<SyncEngineState> get stateStream => _stateController.stream;

  @override
  SyncEngineState get currentState => _state;

  void _emitState(SyncEngineState newState) {
    if (_isDisposed || _stateController.isClosed) return;
    _state = newState;
    _stateController.add(_state);
  }

  @override
  Future<void> startSync() async {
    if (_state.isRunning || _isDisposed) return;

    _emitState(_state.copyWith(
      isRunning: true,
      isPaused: false,
      errorMessage: null,
    ));

    _syncTimer = Timer.periodic(batchInterval, (_) {
      if (!_state.isPaused && _state.queue.isNotEmpty) {
        processQueue();
      }
    });

    await processQueue();
  }

  @override
  Future<void> stopSync() async {
    _syncTimer?.cancel();
    _retryTimer?.cancel();

    if (_isDisposed) return;

    _emitState(_state.copyWith(
      isRunning: false,
      isPaused: true,
    ));
  }

  @override
  Future<void> enqueueOperation(SyncOperation operation) async {
    if (_isDisposed) return;

    final updatedQueue = _state.queue.addOperation(operation);
    _emitState(_state.copyWith(queue: updatedQueue));

    if (_state.isRunning && !_state.isPaused) {
      await processQueue();
    }
  }

  @override
  Future<void> processQueue() async {
    if (_isDisposed || !_state.isRunning || _state.isPaused) return;

    while (_state.queue.isNotEmpty) {
      final operation = _state.queue.getNextOperation();
      if (operation == null) break;

      _emitState(_state.copyWith(currentOperationId: operation.id));

      try {
        await _executeOperation(operation);
      } catch (e) {
        await _handleOperationError(operation, e.toString());
      }

      if (_isDisposed) break;
    }

    _emitState(_state.copyWith(currentOperationId: null));
  }

  Future<void> _executeOperation(SyncOperation operation) async {
    final inProgressOp = operation.copyWith(
      status: SyncOperationStatus.inProgress,
      executedAt: DateTime.now(),
    );

    var queue = _state.queue.updateOperation(inProgressOp);
    _emitState(_state.copyWith(queue: queue));

    try {
      final result = await _operationExecutor(operation);

      if (result.containsKey('conflict')) {
        await _handleConflict(operation, result);
        return;
      }

      queue = _state.queue.removeOperation(operation.id);
      _emitState(_state.copyWith(
        queue: queue,
        processedCount: _state.processedCount + 1,
        lastSyncAt: DateTime.now(),
      ));

      await _onOperationSuccess(operation);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _handleConflict(
    SyncOperation operation,
    Map<String, dynamic> result,
  ) async {
    final conflictData = result['conflict'] as Map<String, dynamic>;
    final resolution = await _conflictHandler(operation);

    if (resolution != null) {
      final resolvedOp = operation.copyWith(
        payload: {...operation.payload, ...resolution},
        status: SyncOperationStatus.pending,
        retryCount: 0,
      );
      final queue = _state.queue.updateOperation(resolvedOp);
      _emitState(_state.copyWith(queue: queue));
    } else {
      final conflictOp = operation.copyWith(
        status: SyncOperationStatus.conflict,
        errorMessage: 'Conflict detected and not resolved',
      );
      final queue = _state.queue.updateOperation(conflictOp);
      _emitState(_state.copyWith(
        queue: queue,
        conflictCount: _state.conflictCount + 1,
      ));
    }
  }

  Future<void> _handleOperationError(
    SyncOperation operation,
    String error,
  ) async {
    if (operation.retryCount < maxRetries) {
      final retryOp = operation.copyWith(
        status: SyncOperationStatus.pending,
        retryCount: operation.retryCount + 1,
        errorMessage: error,
      );
      final queue = _state.queue.updateOperation(retryOp);
      _emitState(_state.copyWith(queue: queue));

      _retryTimer = Timer(retryDelay, () {
        if (_state.isRunning && !_state.isPaused) {
          processQueue();
        }
      });
    } else {
      final failedOp = operation.copyWith(
        status: SyncOperationStatus.failed,
        errorMessage: error,
      );
      final queue = _state.queue.updateOperation(failedOp);
      _emitState(_state.copyWith(
        queue: queue,
        failedCount: _state.failedCount + 1,
        errorMessage: error,
      ));

      await _onOperationFailure(operation, error);
    }
  }

  @override
  void setStrategy(SyncStrategy strategy) {
    if (_isDisposed) return;
    _emitState(_state.copyWith(strategy: strategy));
  }

  @override
  void dispose() {
    _isDisposed = true;
    _syncTimer?.cancel();
    _retryTimer?.cancel();
    if (!_stateController.isClosed) {
      _stateController.close();
    }
  }
}

// === ARCHIVO: lib/core/sync/conflict_resolver.dart ===
package offline_field_app.core.sync;

import 'dart:convert';
import 'package:equatable/equatable.dart';

enum ConflictResolutionStrategy {
  lastWriteWins,
  serverWins,
  clientWins,
  merge,
  manual,
}

class ConflictData extends Equatable {
  final String entityId;
  final String entityType;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final DateTime localTimestamp;
  final DateTime serverTimestamp;
  final int localVersion;
  final int serverVersion;

  const ConflictData({
    required this.entityId,
    required this.entityType,
    required this.localData,
    required this.serverData,
    required this.localTimestamp,
    required this.serverTimestamp,
    required this.localVersion,
    required this.serverVersion,
  });

  bool get localIsNewer => localTimestamp.isAfter(serverTimestamp);
  bool get serverIsNewer => serverTimestamp.isAfter(localTimestamp);

  Duration get timestampDiff => localTimestamp.difference(serverTimestamp).abs();

  List<String> get conflictingFields {
    final fields = <String>{};
    for (final key in localData.keys) {
      if (serverData.containsKey(key)) {
        final localVal = localData[key];
        final serverVal = serverData[key];
        if (localVal != serverVal) {
          fields.add(key);
        }
      }
    }
    return fields.toList();
  }

  @override
  List<Object?> get props => [
        entityId,
        entityType,
        localData,
        serverData,
        localTimestamp,
        serverTimestamp,
        localVersion,
        serverVersion,
      ];
}

abstract class ConflictResolver {
  Future<ConflictResolution?> resolve(ConflictData conflict);
  void setStrategy(ConflictResolutionStrategy strategy);
  ConflictResolutionStrategy get currentStrategy;
}

class ConflictResolution extends Equatable {
  final String entityId;
  final Map<String, dynamic> resolvedData;
  final ConflictResolutionStrategy appliedStrategy;
  final String? resolutionNote;
  final bool requiresManualReview;

  const ConflictResolution({
    required this.entityId,
    required this.resolvedData,
    required this.appliedStrategy,
    this.resolutionNote,
    this.requiresManualReview = false,
  });

  @override
  List<Object?> get props => [
        entityId,
        resolvedData,
        appliedStrategy,
        resolutionNote,
        requiresManualReview,
      ];
}

class ConflictResolverImpl implements ConflictResolver {
  ConflictResolutionStrategy _currentStrategy;
  final Map<String, ConflictResolution Function(ConflictData)> _customResolvers;
  final Future<ConflictResolution?> Function(ConflictData)? manualResolver;

  ConflictResolverImpl({
    ConflictResolutionStrategy defaultStrategy = ConflictResolutionStrategy.lastWriteWins,
    Map<String, ConflictResolution Function(ConflictData)>? customResolvers,
    this.manualResolver,
  })  : _currentStrategy = defaultStrategy,
        _customResolvers = customResolvers ?? {};

  @override
  ConflictResolutionStrategy get currentStrategy => _currentStrategy;

  @override
  void setStrategy(ConflictResolutionStrategy strategy) {
    _currentStrategy = strategy;
  }

  @override
  Future<ConflictResolution?> resolve(ConflictData conflict) async {
    if (_customResolvers.containsKey(conflict.entityType)) {
      return _customResolvers[conflict.entityType]!(conflict);
    }

    switch (_currentStrategy) {
      case ConflictResolutionStrategy.lastWriteWins:
        return _resolveLastWriteWins(conflict);
      case ConflictResolutionStrategy.serverWins:
        return _resolveServerWins(conflict);
      case ConflictResolutionStrategy.clientWins:
        return _resolveClientWins(conflict);
      case ConflictResolutionStrategy.merge:
        return _resolveMerge(conflict);
      case ConflictResolutionStrategy.manual:
        return _resolveManual(conflict);
    }
  }

  ConflictResolution _resolveLastWriteWins(ConflictData conflict) {
    final winner = conflict.localIsNewer ? conflict.localData : conflict.serverData;
    final timestamp = conflict.localIsNewer ? conflict.localTimestamp : conflict.serverTimestamp;

    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: Map<String, dynamic>.from(winner),
      appliedStrategy: ConflictResolutionStrategy.lastWriteWins,
      resolutionNote: 'Winner determined by timestamp: ${timestamp.toIso8601String()}',
    );
  }

  ConflictResolution _resolveServerWins(ConflictData conflict) {
    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: Map<String, dynamic>.from(conflict.serverData),
      appliedStrategy: ConflictResolutionStrategy.serverWins,
      resolutionNote: 'Server version always wins',
    );
  }

  ConflictResolution _resolveClientWins(ConflictData conflict) {
    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: Map<String, dynamic>.from(conflict.localData),
      appliedStrategy: ConflictResolutionStrategy.clientWins,
      resolutionNote: 'Client version always wins',
    );
  }

  ConflictResolution _resolveMerge(ConflictData conflict) {
    final merged = <String, dynamic>{};
    final allKeys = {...conflict.localData.keys, ...conflict.serverData.keys};

    for (final key in allKeys) {
      final localValue = conflict.localData[key];
      final serverValue = conflict.serverData[key];

      if (localValue == null) {
        merged[key] = serverValue;
      } else if (serverValue == null) {
        merged[key] = localValue;
      } else if (localValue == serverValue) {
        merged[key] = localValue;
      } else if (localValue is Map && serverValue is Map) {
        merged[key] = _deepMerge(localValue, serverValue);
      } else if (localValue is List && serverValue is List) {
        merged[key] = {...localValue, ...serverValue}.toList();
      } else {
        merged[key] = conflict.localIsNewer ? localValue : serverValue;
      }
    }

    merged['version'] = conflict.localVersion > conflict.serverVersion
        ? conflict.localVersion
        : conflict.serverVersion;
    merged['updatedAt'] = DateTime.now().toIso8601String();

    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: merged,
      appliedStrategy: ConflictResolutionStrategy.merge,
      resolutionNote: 'Fields merged: ${conflict.conflictingFields.join(', ')}',
    );
  }

  Map<String, dynamic> _deepMerge(
    Map<String, dynamic> local,
    Map<String, dynamic> server,
  ) {
    final merged = <String, dynamic>{};
    final allKeys = {...local.keys, ...server.keys};

    for (final key in allKeys) {
      final localValue = local[key];
      final serverValue = server[key];

      if (localValue == null) {
        merged[key] = serverValue;
      } else if (serverValue == null) {
        merged[key] = localValue;
      } else if (localValue is Map && serverValue is Map) {
        merged[key] = _deepMerge(localValue, serverValue);
      } else if (localValue is List && serverValue is List) {
        merged[key] = [...localValue, ...serverValue];
      } else {
        merged[key] = localValue;
      }
    }

    return merged;
  }

  Future<ConflictResolution?> _resolveManual(ConflictData conflict) async {
    if (manualResolver != null) {
      return manualResolver!(conflict);
    }

    return ConflictResolution(
      entityId: conflict.entityId,
      resolvedData: conflict.localData,
      appliedStrategy: ConflictResolutionStrategy.manual,
      resolutionNote: 'Manual resolution required',
      requiresManualReview: true,
    );
  }
}

class ConflictResolverFactory {
  static ConflictResolver create({
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.lastWriteWins,
    Future<ConflictResolution?> Function(ConflictData)? manualResolver,
  }) {
    return ConflictResolverImpl(
      defaultStrategy: strategy,
      manualResolver: manualResolver,
    );
  }
}


// === ARCHIVO: lib/core/sync/idempotency_manager.dart ===
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import '../errors/exceptions.dart';

enum IdempotencyStatus {
  pending,
  processing,
  completed,
  failed,
  duplicate,
}

class IdempotencyRecord extends Equatable {
  final String operationHash;
  final String? existingRecordId;
  final IdempotencyStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic>? resultData;
  final String? errorMessage;

  const IdempotencyRecord({
    required this.operationHash,
    this.existingRecordId,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.resultData,
    this.errorMessage,
  });

  IdempotencyRecord copyWith({
    String? operationHash,
    String? existingRecordId,
    IdempotencyStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    Map<String, dynamic>? resultData,
    String? errorMessage,
  }) {
    return IdempotencyRecord(
      operationHash: operationHash ?? this.operationHash,
      existingRecordId: existingRecordId ?? this.existingRecordId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      resultData: resultData ?? this.resultData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'operationHash': operationHash,
      'existingRecordId': existingRecordId,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'resultData': resultData != null ? jsonEncode(resultData) : null,
      'errorMessage': errorMessage,
    };
  }

  factory IdempotencyRecord.fromMap(Map<String, dynamic> map) {
    return IdempotencyRecord(
      operationHash: map['operationHash'] as String,
      existingRecordId: map['existingRecordId'] as String?,
      status: IdempotencyStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => IdempotencyStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      resultData: map['resultData'] != null
          ? jsonDecode(map['resultData'] as String) as Map<String, dynamic>
          : null,
      errorMessage: map['errorMessage'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        operationHash,
        existingRecordId,
        status,
        createdAt,
        completedAt,
        resultData,
        errorMessage,
      ];
}

abstract class IdempotencyManager {
  Future<String> generateOperationHash(String operationType, Map<String, dynamic> payload);
  Future<bool> isOperationProcessed(String operationHash);
  Future<IdempotencyRecord?> getRecord(String operationHash);
  Future<void> markAsProcessing(String operationHash);
  Future<void> markAsCompleted(String operationHash, String recordId, Map<String, dynamic>? resultData);
  Future<void> markAsFailed(String operationHash, String errorMessage);
  Future<void> markAsDuplicate(String operationHash, String existingRecordId);
  Future<void> cleanupOldRecords(Duration maxAge);
}

class IdempotencyManagerImpl implements IdempotencyManager {
  final Map<String, IdempotencyRecord> _memoryCache = {};
  final Duration defaultMaxAge;
  final int maxCacheSize;

  IdempotencyManagerImpl({
    this.defaultMaxAge = const Duration(days: 7),
    this.maxCacheSize = 1000,
  });

  @override
  Future<String> generateOperationHash(
    String operationType,
    Map<String, dynamic> payload,
  ) async {
    final normalizedPayload = _normalizePayload(payload);
    final payloadString = jsonEncode(normalizedPayload);
    final hashInput = '$operationType:$payloadString';
    final hashBytes = utf8.encode(hashInput);
    final digest = sha256.convert(hashBytes);
    return digest.toString();
  }

  Map<String, dynamic> _normalizePayload(Map<String, dynamic> payload) {
    final normalized = Map<String, dynamic>.from(payload);
    normalized.remove('id');
    normalized.remove('createdAt');
    normalized.remove('updatedAt');
    normalized.remove('syncStatus');
    normalized.remove('version');
    final sortedKeys = normalized.keys.toList()..sort();
    final result = <String, dynamic>{};
    for (final key in sortedKeys) {
      final value = normalized[key];
      if (value is Map<String, dynamic>) {
        result[key] = _normalizePayload(value);
      } else if (value is List) {
        result[key] = value.map((e) => e is Map<String, dynamic> ? _normalizePayload(e) : e).toList();
      } else {
        result[key] = value;
      }
    }
    return result;
  }

  @override
  Future<bool> isOperationProcessed(String operationHash) async {
    final record = _memoryCache[operationHash];
    if (record != null) {
      return record.status == IdempotencyStatus.completed ||
          record.status == IdempotencyStatus.duplicate;
    }
    return false;
  }

  @override
  Future<IdempotencyRecord?> getRecord(String operationHash) async {
    return _memoryCache[operationHash];
  }

  @override
  Future<void> markAsProcessing(String operationHash) async {
    _enforceCacheLimit();
    final record = IdempotencyRecord(
      operationHash: operationHash,
      status: IdempotencyStatus.processing,
      createdAt: DateTime.now(),
    );
    _memoryCache[operationHash] = record;
  }

  @override
  Future<void> markAsCompleted(
    String operationHash,
    String recordId,
    Map<String, dynamic>? resultData,
  ) async {
    final existing = _memoryCache[operationHash];
    if (existing == null) {
      throw IdempotencyException(
        'Cannot mark non-existent operation as completed',
        operationHash: operationHash,
      );
    }
    _memoryCache[operationHash] = existing.copyWith(
      status: IdempotencyStatus.completed,
      completedAt: DateTime.now(),
      existingRecordId: recordId,
      resultData: resultData,
    );
  }

  @override
  Future<void> markAsFailed(String operationHash, String errorMessage) async {
    final existing = _memoryCache[operationHash];
    if (existing == null) {
      throw IdempotencyException(
        'Cannot mark non-existent operation as failed',
        operationHash: operationHash,
      );
    }
    _memoryCache[operationHash] = existing.copyWith(
      status: IdempotencyStatus.failed,
      completedAt: DateTime.now(),
      errorMessage: errorMessage,
    );
  }

  @override
  Future<void> markAsDuplicate(
    String operationHash,
    String existingRecordId,
  ) async {
    _enforceCacheLimit();
    final record = IdempotencyRecord(
      operationHash: operationHash,
      existingRecordId: existingRecordId,
      status: IdempotencyStatus.duplicate,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );
    _memoryCache[operationHash] = record;
  }

  @override
  Future<void> cleanupOldRecords(Duration maxAge) async {
    final cutoff = DateTime.now().subtract(maxAge);
    final keysToRemove = <String>[];
    for (final entry in _memoryCache.entries) {
      if (entry.value.createdAt.isBefore(cutoff) &&
          (entry.value.status == IdempotencyStatus.completed ||
              entry.value.status == IdempotencyStatus.duplicate ||
              entry.value.status == IdempotencyStatus.failed)) {
        keysToRemove.add(entry.key);
      }
    }
    for (final key in keysToRemove) {
      _memoryCache.remove(key);
    }
  }

  void _enforceCacheLimit() {
    if (_memoryCache.length >= maxCacheSize) {
      final sortedEntries = _memoryCache.entries.toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));
      final toRemove = sortedEntries.take(_memoryCache.length - maxCacheSize + 100);
      for (final entry in toRemove) {
        _memoryCache.remove(entry.key);
      }
    }
  }

  Map<String, IdempotencyRecord> getAllRecords() => Map.unmodifiable(_memoryCache);

  int get recordCount => _memoryCache.length;

  void clearCache() {
    _memoryCache.clear();
  }
}

class HashCollisionException implements Exception {
  final String hash1;
  final String hash2;
  final String message;

  HashCollisionException({
    required this.hash1,
    required this.hash2,
    required this.message,
  });

  @override
  String toString() => 'HashCollisionException: $message (hash1: $hash1, hash2: $hash2)';
}


// === ARCHIVO: lib/domain/entities/base_entity.dart ===
package lib.domain.entities;

import 'package:equatable/equatable.dart';

abstract class BaseEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  const BaseEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  BaseEntity copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });

  Map<String, dynamic> toMap();

  @override
  List<Object?> get props => [id, createdAt, updatedAt, version];

  @override
  bool get stringify => true;
}

class BaseEntityImpl implements BaseEntity {
  @override
  final String id;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  @override
  final int version;

  const BaseEntityImpl({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  @override
  BaseEntityImpl copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return BaseEntityImpl(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
    };
  }

  factory BaseEntityImpl.fromMap(Map<String, dynamic> map) {
    return BaseEntityImpl(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      version: map['version'] as int,
    );
  }

  @override
  List<Object?> get props => [id, createdAt, updatedAt, version];

  @override
  bool get stringify => true;
}

// === ARCHIVO: lib/domain/entities/transaction.dart ===
package lib.domain.entities;

import 'package:equatable/equatable.dart';
import 'base_entity.dart';

enum TransactionStatus {
  pending,
  inProgress,
  completed,
  failed,
  conflict,
}

enum TransactionType {
  payment,
  refund,
  transfer,
  deposit,
  withdrawal,
}

class Transaction extends BaseEntity {
  final String localId;
  final String? remoteId;
  final Map<String, dynamic> payload;
  final TransactionStatus status;
  final DateTime? syncedAt;
  final TransactionType type;
  final double amount;
  final String currency;
  final String? description;
  final String? hash;

  const Transaction({
    required super.id,
    required this.localId,
    this.remoteId,
    required this.payload,
    required this.status,
    required super.createdAt,
    required super.updatedAt,
    required super.version,
    this.syncedAt,
    required this.type,
    required this.amount,
    required this.currency,
    this.description,
    this.hash,
  });

  Transaction copyWith({
    String? id,
    String? localId,
    String? remoteId,
    Map<String, dynamic>? payload,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    DateTime? syncedAt,
    TransactionType? type,
    double? amount,
    String? currency,
    String? description,
    String? hash,
  }) {
    return Transaction(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncedAt: syncedAt ?? this.syncedAt,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      hash: hash ?? this.hash,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'localId': localId,
      'remoteId': remoteId,
      'payload': payload,
      'status': status.name,
      'syncedAt': syncedAt?.toIso8601String(),
      'type': type.name,
      'amount': amount,
      'currency': currency,
      'description': description,
      'hash': hash,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      localId: map['localId'] as String,
      remoteId: map['remoteId'] as String?,
      payload: map['payload'] as Map<String, dynamic>,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TransactionStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      version: map['version'] as int,
      syncedAt: map['syncedAt'] != null
          ? DateTime.parse(map['syncedAt'] as String)
          : null,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.payment,
      ),
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      description: map['description'] as String?,
      hash: map['hash'] as String?,
    );
  }

  bool get isSynced => remoteId != null && syncedAt != null;

  bool get isPending =>
      status == TransactionStatus.pending ||
      status == TransactionStatus.inProgress;

  bool get hasConflict => status == TransactionStatus.conflict;

  String generateHash() {
    final content = '$localId${type.name}$amount$currency$createdAt';
    return content.hashCode.toString();
  }

  @override
  List<Object?> get props => [
        ...super.props,
        localId,
        remoteId,
        payload,
        status,
        syncedAt,
        type,
        amount,
        currency,
        description,
        hash,
      ];

  @override
  bool get stringify => true;
}

// === ARCHIVO: lib/domain/entities/sync_record.dart ===
package lib.domain.entities;

import 'package:equatable/equatable.dart';

enum SyncOperationType {
  create,
  update,
  delete,
}

enum SyncEntityType {
  transaction,
  user,
  config,
  settings,
}

class SyncRecord extends Equatable {
  final String id;
  final SyncOperationType operationType;
  final SyncEntityType entityType;
  final String entityId;
  final String payloadHash;
  final DateTime timestamp;
  final bool synced;
  final int retryCount;
  final String? errorMessage;
  final DateTime? lastAttemptAt;

  const SyncRecord({
    required this.id,
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.payloadHash,
    required this.timestamp,
    required this.synced,
    this.retryCount = 0,
    this.errorMessage,
    this.lastAttemptAt,
  });

  SyncRecord copyWith({
    String? id,
    SyncOperationType? operationType,
    SyncEntityType? entityType,
    String? entityId,
    String? payloadHash,
    DateTime? timestamp,
    bool? synced,
    int? retryCount,
    String? errorMessage,
    DateTime? lastAttemptAt,
  }) {
    return SyncRecord(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payloadHash: payloadHash ?? this.payloadHash,
      timestamp: timestamp ?? this.timestamp,
      synced: synced ?? this.synced,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operationType': operationType.name,
      'entityType': entityType.name,
      'entityId': entityId,
      'payloadHash': payloadHash,
      'timestamp': timestamp.toIso8601String(),
      'synced': synced ? 1 : 0,
      'retryCount': retryCount,
      'errorMessage': errorMessage,
      'lastAttemptAt': lastAttemptAt?.toIso8601String(),
    };
  }

  factory SyncRecord.fromMap(Map<String, dynamic> map) {
    return SyncRecord(
      id: map['id'] as String,
      operationType: SyncOperationType.values.firstWhere(
        (e) => e.name == map['operationType'],
        orElse: () => SyncOperationType.create,
      ),
      entityType: SyncEntityType.values.firstWhere(
        (e) => e.name == map['entityType'],
        orElse: () => SyncEntityType.transaction,
      ),
      entityId: map['entityId'] as String,
      payloadHash: map['payloadHash'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      synced: (map['synced'] as int) == 1,
      retryCount: map['retryCount'] as int? ?? 0,
      errorMessage: map['errorMessage'] as String?,
      lastAttemptAt: map['lastAttemptAt'] != null
          ? DateTime.parse(map['lastAttemptAt'] as String)
          : null,
    );
  }

  bool get canRetry => retryCount < 3 && !synced;

  bool get isStale =>
      !synced &&
      DateTime.now().difference(timestamp).inHours > 24;

  SyncRecord incrementRetry({String? error}) {
    return copyWith(
      retryCount: retryCount + 1,
      lastAttemptAt: DateTime.now(),
      errorMessage: error,
    );
  }

  SyncRecord markAsSynced() {
    return copyWith(
      synced: true,
      lastAttemptAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        operationType,
        entityType,
        entityId,
        payloadHash,
        timestamp,
        synced,
        retryCount,
        errorMessage,
        lastAttemptAt,
      ];

  @override
  bool get stringify => true;
}


// === ARCHIVO: lib/domain/repositories/transaction_repository.dart ===
library;

import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Transaction> createTransaction(Transaction transaction);
  Future<Transaction> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
  Future<Transaction?> getTransactionById(String id);
  Future<Transaction?> getTransactionByExternalId(String externalId);
  Future<Transaction?> getTransactionByHash(String operationHash);
  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getTransactionsBySyncStatus(String syncStatus);
  Future<List<Transaction>> getTransactionsByType(String transactionType);
  Future<List<Transaction>> getTransactionsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<Transaction>> getPendingTransactions();
  Future<int> getTransactionCount();
  Future<int> getTransactionCountBySyncStatus(String syncStatus);
  Future<void> updateSyncStatus(String id, String syncStatus, {String? externalId});
  Future<void> updateSyncStatusBatch(List<String> ids, String syncStatus, {String? externalId});
  Stream<List<Transaction>> watchAllTransactions();
  Stream<List<Transaction>> watchTransactionsBySyncStatus(String syncStatus);
  Future<void> markAsSynced(String id, String externalId, int version);
  Future<void> markAsFailed(String id, String errorDetails);
  Future<List<Transaction>> getUnsyncedTransactions();
  Future<Map<String, dynamic>> exportTransactions(String startDate, String endDate);
  Future<void> importTransactions(Map<String, dynamic> data);
  Future<Transaction?> findByIdempotencyKey(String idempotencyKey);
  Future<void> incrementVersion(String id);
}

class TransactionFilter extends Equatable {
  final String? syncStatus;
  final String? transactionType;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;
  final String? currency;
  final bool? isDeleted;

  const TransactionFilter({
    this.syncStatus,
    this.transactionType,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.currency,
    this.isDeleted,
  });

  @override
  List<Object?> get props => [
        syncStatus,
        transactionType,
        startDate,
        endDate,
        minAmount,
        maxAmount,
        currency,
        isDeleted,
      ];

  TransactionFilter copyWith({
    String? syncStatus,
    String? transactionType,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    String? currency,
    bool? isDeleted,
  }) {
    return TransactionFilter(
      syncStatus: syncStatus ?? this.syncStatus,
      transactionType: transactionType ?? this.transactionType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      currency: currency ?? this.currency,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

class TransactionResult extends Equatable {
  final Transaction transaction;
  final bool isNew;
  final bool wasSynced;

  const TransactionResult({
    required this.transaction,
    required this.isNew,
    required this.wasSynced,
  });

  @override
  List<Object?> get props => [transaction, isNew, wasSynced];
}

// === ARCHIVO: lib/domain/repositories/sync_repository.dart ===
library;

import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../entities/sync_record.dart';

abstract class SyncRepository {
  Future<SyncRecord> createSyncRecord(SyncRecord record);
  Future<SyncRecord> updateSyncRecord(SyncRecord record);
  Future<void> deleteSyncRecord(String id);
  Future<SyncRecord?> getSyncRecordById(String id);
  Future<List<SyncRecord>> getAllSyncRecords();
  Future<List<SyncRecord>> getSyncRecordsByStatus(String status);
  Future<List<SyncRecord>> getPendingSyncRecords();
  Future<List<SyncRecord>> getFailedSyncRecords();
  Future<List<SyncRecord>> getCompletedSyncRecords();
  Future<void> markAsPending(String id);
  Future<void> markAsInProgress(String id);
  Future<void> markAsCompleted(String id, {String? serverResponse});
  Future<void> markAsFailed(String id, String errorDetails);
  Future<void> markAsConflict(String id, String conflictData);
  Future<int> getPendingCount();
  Future<int> getFailedCount();
  Future<int> getCompletedCount();
  Future<void> clearCompletedRecords({DateTime? olderThan});
  Future<void> clearFailedRecords({int keepLastN});
  Future<void> retryFailedRecords();
  Future<void> cancelPendingSync();
  Stream<List<SyncRecord>> watchSyncRecords();
  Stream<List<SyncRecord>> watchPendingSyncRecords();
  Future<Map<String, dynamic>> getSyncStatistics();
  Future<void> updateRetryCount(String id);
  Future<int> getRetryCount(String id);
  Future<void> scheduleSync(String entityType, String entityId, String operationType);
  Future<List<SyncRecord>> getSyncRecordsForEntity(String entityType, String entityId);
  Future<void> removeSyncRecordsForEntity(String entityType, String entityId);
  Future<void> updateConflictResolution(String id, String resolution, String resolvedData);
  Future<SyncRecord?> getLatestSyncRecordForEntity(String entityType, String entityId);
  Future<List<SyncRecord>> getSyncRecordsByOperationType(String operationType);
  Future<void> bulkUpdateStatus(List<String> ids, String status);
  Future<List<SyncRecord>> getConflictedRecords();
  Future<void> resolveConflict(String id, String resolution, String resolvedData);
  Future<void> cancelSync(String id);
  Future<void> pauseSync(String id);
  Future<void> resumeSync(String id);
  Future<void> prioritizeSync(String id);
  Future<void> deprioritizeSync(String id);
}

class SyncBatchResult extends Equatable {
  final int totalRequested;
  final int successfullySynced;
  final int failed;
  final int pending;
  final Duration elapsedTime;
  final List<String> failedIds;
  final List<String> pendingIds;

  const SyncBatchResult({
    required this.totalRequested,
    required this.successfullySynced,
    required this.failed,
    required this.pending,
    required this.elapsedTime,
    required this.failedIds,
    required this.pendingIds,
  });

  bool get isFullySuccessful => failed == 0 && pending == 0;
  bool get hasFailures => failed > 0;
  bool get hasPending => pending > 0;
  double get successRate => totalRequested > 0 ? successfullySynced / totalRequested : 0.0;

  @override
  List<Object?> get props => [
        totalRequested,
        successfullySynced,
        failed,
        pending,
        elapsedTime,
        failedIds,
        pendingIds,
      ];
}

class SyncConfiguration extends Equatable {
  final int maxRetries;
  final int retryDelaySeconds;
  final int batchSize;
  final bool autoSync;
  final bool syncOnWifiOnly;
  final bool syncOnCharging;
  final String conflictStrategy;
  final Duration syncInterval;
  final Duration maxSyncDuration;

  const SyncConfiguration({
    this.maxRetries = 3,
    this.retryDelaySeconds = 30,
    this.batchSize = 50,
    this.autoSync = true,
    this.syncOnWifiOnly = false,
    this.syncOnCharging = false,
    this.conflictStrategy = 'last_write_wins',
    this.syncInterval = const Duration(minutes: 15),
    this.maxSyncDuration = const Duration(minutes: 5),
  });

  @override
  List<Object?> get props => [
        maxRetries,
        retryDelaySeconds,
        batchSize,
        autoSync,
        syncOnWifiOnly,
        syncOnCharging,
        conflictStrategy,
        syncInterval,
        maxSyncDuration,
      ];

  SyncConfiguration copyWith({
    int? maxRetries,
    int? retryDelaySeconds,
    int? batchSize,
    bool? autoSync,
    bool? syncOnWifiOnly,
    bool? syncOnCharging,
    String? conflictStrategy,
    Duration? syncInterval,
    Duration? maxSyncDuration,
  }) {
    return SyncConfiguration(
      maxRetries: maxRetries ?? this.maxRetries,
      retryDelaySeconds: retryDelaySeconds ?? this.retryDelaySeconds,
      batchSize: batchSize ?? this.batchSize,
      autoSync: autoSync ?? this.autoSync,
      syncOnWifiOnly: syncOnWifiOnly ?? this.syncOnWifiOnly,
      syncOnCharging: syncOnCharging ?? this.syncOnCharging,
      conflictStrategy: conflictStrategy ?? this.conflictStrategy,
      syncInterval: syncInterval ?? this.syncInterval,
      maxSyncDuration: maxSyncDuration ?? this.maxSyncDuration,
    );
  }
}

// === ARCHIVO: lib/domain/usecases/create_transaction.dart ===
library;

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class CreateTransaction {
  final TransactionRepository _repository;
  final Uuid _uuid;

  static const List<String> validTransactionTypes = [
    'payment',
    'refund',
    'transfer',
    'deposit',
    'withdrawal',
    'adjustment',
  ];

  static const List<String> validCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'MXN',
  ];

  static const double minAmount = 0.01;
  static const double maxAmount = 999999999.99;

  CreateTransaction(this._repository) : _uuid = const Uuid();

  Future<Transaction> execute(CreateTransactionParams params) async {
    await _validateInput(params);
    final operationHash = _generateOperationHash(params);
    await _checkIdempotency(operationHash, params.idempotencyKey);
    final transaction = _buildTransaction(params, operationHash);
    return await _repository.createTransaction(transaction);
  }

  Future<void> _validateInput(CreateTransactionParams params) async {
    final validationErrors = <String, List<String>>{};

    if (params.amount < minAmount || params.amount > maxAmount) {
      validationErrors['amount'] = [
        'Amount must be between $minAmount and $maxAmount',
      ];
    }

    if (!validTransactionTypes.contains(params.transactionType)) {
      validationErrors['transactionType'] = [
        'Invalid transaction type: ${params.transactionType}. Valid types: ${validTransactionTypes.join(", ")}',
      ];
    }

    if (!validCurrencies.contains(params.currency)) {
      validationErrors['currency'] = [
        'Invalid currency: ${params.currency}. Valid currencies: ${validCurrencies.join(", ")}',
      ];
    }

    if (params.description != null && params.description!.length > 500) {
      validationErrors['description'] = [
        'Description cannot exceed 500 characters',
      ];
    }

    if (params.metadata != null) {
      final metadataSize = params.metadata.toString().length;
      if (metadataSize > 10000) {
        validationErrors['metadata'] = [
          'Metadata cannot exceed 10000 characters',
        ];
      }
    }

    if (validationErrors.isNotEmpty) {
      throw ValidationException(
        'Validation failed for transaction creation',
        fieldErrors: validationErrors,
      );
    }
  }

  String _generateOperationHash(CreateTransactionParams params) {
    final hashInput = '${params.transactionType}:'
        '${params.amount}:'
        '${params.currency}:'
        '${params.description ?? ""}:'
        '${params.createdAt.toIso8601String()}';
    final bytes = hashInput.codeUnits;
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  Future<void> _checkIdempotency(
    String operationHash,
    String? idempotencyKey,
  ) async {
    if (idempotencyKey != null) {
      final existingByKey = await _repository.findByIdempotencyKey(idempotencyKey);
      if (existingByKey != null) {
        throw IdempotencyException.duplicateOperation(
          operationHash,
          existingRecordId: existingByKey.id,
        );
      }
    }

    final existingByHash = await _repository.getTransactionByHash(operationHash);
    if (existingByHash != null) {
      throw IdempotencyException.duplicateOperation(
        operationHash,
        existingRecordId: existingByHash.id,
      );
    }
  }

  Transaction _buildTransaction(
    CreateTransactionParams params,
    String operationHash,
  ) {
    final now = params.createdAt ?? DateTime.now();
    return Transaction(
      id: params.id ?? _uuid.v4(),
      externalId: null,
      amount: params.amount,
      currency: params.currency,
      transactionType: params.transactionType,
      description: params.description,
      metadata: params.metadata,
      createdAt: now,
      updatedAt: now,
      version: 1,
      syncStatus: 'pending',
      hash: operationHash,
    );
  }

  Future<Transaction> executeWithValidation(CreateTransactionParams params) async {
    try {
      return await execute(params);
    } on ValidationException catch (e) {
      throw ValidationFailure(
        'Transaction validation failed: ${e.message}',
        fieldErrors: e.fieldErrors,
      );
    } on IdempotencyException catch (e) {
      throw ConflictFailure.detected(
        e.existingRecordId ?? 'unknown',
        {'hash': e.operationHash},
        {'idempotencyKey': params.idempotencyKey},
      );
    } catch (e) {
      throw DatabaseFailure.transactionFailed('Failed to create transaction: $e');
    }
  }
}

class CreateTransactionParams {
  final String? id;
  final double amount;
  final String currency;
  final String transactionType;
  final String? description;
  final Map<String, dynamic>? metadata;
  final String? idempotencyKey;
  final DateTime? createdAt;

  const CreateTransactionParams({
    this.id,
    required this.amount,
    required this.currency,
    required this.transactionType,
    this.description,
    this.metadata,
    this.idempotencyKey,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'transactionType': transactionType,
      'description': description,
      'metadata': metadata,
      'idempotencyKey': idempotencyKey,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory CreateTransactionParams.fromMap(Map<String, dynamic> map) {
    return CreateTransactionParams(
      id: map['id'] as String?,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      transactionType: map['transactionType'] as String,
      description: map['description'] as String?,
      metadata: map['metadata'] as Map<String, dynamic>?,
      idempotencyKey: map['idempotencyKey'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }
}


// === ARCHIVO: lib/domain/usecases/get_pending_transactions.dart ===
import 'package:equatable/equatable.dart';
import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';

class GetPendingTransactionsParams extends Equatable {
  final int? limit;
  final int? offset;
  final String? transactionType;
  final DateTime? fromDate;
  final DateTime? toDate;

  const GetPendingTransactionsParams({
    this.limit,
    this.offset,
    this.transactionType,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [limit, offset, transactionType, fromDate, toDate];
}

class PendingTransactionInfo extends Equatable {
  final Transaction transaction;
  final int retryCount;
  final DateTime? lastAttempt;
  final String? lastError;
  final DateTime createdAt;

  const PendingTransactionInfo({
    required this.transaction,
    required this.retryCount,
    this.lastAttempt,
    this.lastError,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [transaction, retryCount, lastAttempt, lastError, createdAt];
}

abstract class GetPendingTransactionsUseCase {
  Future<(List<PendingTransactionInfo>, Failure?)> call(GetPendingTransactionsParams params);
  Future<int> getTotalPendingCount();
  Future<Map<String, int>> getPendingCountByType();
}

class GetPendingTransactionsUseCaseImpl implements GetPendingTransactionsUseCase {
  final TransactionRepository _repository;
  final int _defaultPageSize;
  final int _maxPageSize;

  GetPendingTransactionsUseCaseImpl({
    required TransactionRepository repository,
    int defaultPageSize = 20,
    int maxPageSize = 100,
  })  : _repository = repository,
        _defaultPageSize = defaultPageSize,
        _maxPageSize = maxPageSize;

  @override
  Future<(List<PendingTransactionInfo>, Failure?)> call(GetPendingTransactionsParams params) async {
    try {
      final effectiveLimit = _resolveLimit(params.limit);
      final effectiveOffset = params.offset ?? 0;

      final pendingTransactions = await _repository.getPendingTransactions(
        limit: effectiveLimit,
        offset: effectiveOffset,
        transactionType: params.transactionType,
        fromDate: params.fromDate,
        toDate: params.toDate,
      );

      final result = <PendingTransactionInfo>[];
      for (final transaction in pendingTransactions) {
        final syncRecords = await _repository.getSyncRecordsForEntity(transaction.id);
        final latestRecord = syncRecords.isNotEmpty ? syncRecords.first : null;

        result.add(PendingTransactionInfo(
          transaction: transaction,
          retryCount: latestRecord?.retryCount ?? 0,
          lastAttempt: latestRecord?.lastAttempt,
          lastError: latestRecord?.errorMessage,
          createdAt: transaction.createdAt,
        ));
      }

      return (result, null);
    } on OfflineException catch (e) {
      return ( <PendingTransactionInfo>[], OfflineFailure.database(e.message));
    } catch (e) {
      return ( <PendingTransactionInfo>[], DatabaseFailure.transactionFailed(e.toString()));
    }
  }

  @override
  Future<int> getTotalPendingCount() async {
    try {
      return await _repository.getPendingCount();
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<Map<String, int>> getPendingCountByType() async {
    try {
      final allPending = await _repository.getPendingTransactions(limit: 1000);
      final counts = <String, int>{};
      for (final tx in allPending) {
        counts[tx.transactionType] = (counts[tx.transactionType] ?? 0) + 1;
      }
      return counts;
    } catch (e) {
      return {};
    }
  }

  int _resolveLimit(int? requestedLimit) {
    if (requestedLimit == null || requestedLimit <= 0) {
      return _defaultPageSize;
    }
    return requestedLimit > _maxPageSize ? _maxPageSize : requestedLimit;
  }
}

// === ARCHIVO: lib/domain/usecases/sync_transactions.dart ===
import 'package:equatable/equatable.dart';
import '../../entities/transaction.dart';
import '../../entities/sync_record.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/sync_repository.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/constants/app_constants.dart';

class SyncTransactionsParams extends Equatable {
  final bool forceFullSync;
  final int? batchSize;
  final String? conflictStrategy;
  final bool enableRetry;

  const SyncTransactionsParams({
    this.forceFullSync = false,
    this.batchSize,
    this.conflictStrategy,
    this.enableRetry = true,
  });

  @override
  List<Object?> get props => [forceFullSync, batchSize, conflictStrategy, enableRetry];
}

class SyncResult extends Equatable {
  final int uploaded;
  final int downloaded;
  final int conflicts;
  final int failed;
  final Duration duration;
  final List<String> errorMessages;

  const SyncResult({
    required this.uploaded,
    required this.downloaded,
    required this.conflicts,
    required this.failed,
    required this.duration,
    this.errorMessages = const [],
  });

  bool get hasErrors => failed > 0 || conflicts > 0;
  bool get isPartialSuccess => (uploaded + downloaded) > 0 && hasErrors;
  bool get isFullSuccess => uploaded > 0 && failed == 0 && conflicts == 0;

  @override
  List<Object?> get props => [uploaded, downloaded, conflicts, failed, duration, errorMessages];
}

abstract class SyncTransactionsUseCase {
  Future<(SyncResult?, Failure?)> call(SyncTransactionsParams params);
  Future<void> cancelSync();
  Future<SyncStatus> getCurrentSyncStatus();
}

enum SyncStatus { idle, inProgress, failed, completed }

class SyncTransactionsUseCaseImpl implements SyncTransactionsUseCase {
  final TransactionRepository _transactionRepository;
  final SyncRepository _syncRepository;
  final NetworkInfo _networkInfo;
  final int _maxRetryAttempts;
  final int _retryDelaySeconds;
  final int _defaultBatchSize;
  bool _isCancelled = false;

  SyncTransactionsUseCaseImpl({
    required TransactionRepository transactionRepository,
    required SyncRepository syncRepository,
    required NetworkInfo networkInfo,
    int maxRetryAttempts = 3,
    int retryDelaySeconds = 5,
    int defaultBatchSize = 50,
  })  : _transactionRepository = transactionRepository,
        _syncRepository = syncRepository,
        _networkInfo = networkInfo,
        _maxRetryAttempts = maxRetryAttempts,
        _retryDelaySeconds = retryDelaySeconds,
        _defaultBatchSize = defaultBatchSize;

  @override
  Future<(SyncResult?, Failure?)> call(SyncTransactionsParams params) async {
    _isCancelled = false;
    final startTime = DateTime.now();

    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return (null, const OfflineFailure.networkUnavailable());
    }

    try {
      final batchSize = params.batchSize ?? _defaultBatchSize;
      final pendingTransactions = await _transactionRepository.getPendingTransactions(
        limit: batchSize,
      );

      if (pendingTransactions.isEmpty) {
        return (SyncResult(
          uploaded: 0,
          downloaded: 0,
          conflicts: 0,
          failed: 0,
          duration: DateTime.now().difference(startTime),
        ), null);
      }

      int uploaded = 0;
      int conflicts = 0;
      int failed = 0;
      final errorMessages = <String>[];

      for (final transaction in pendingTransactions) {
        if (_isCancelled) break;

        final syncResult = await _syncSingleTransaction(
          transaction,
          params.conflictStrategy ?? AppConstants.conflictStrategyLastWriteWins,
          params.enableRetry,
        );

        switch (syncResult) {
          case _SyncSingleResult.success:
            uploaded++;
            break;
          case _SyncSingleResult.conflict:
            conflicts++;
            break;
          case _SyncSingleResult.failed:
            failed++;
            errorMessages.add('Failed to sync transaction ${transaction.id}');
            break;
        }
      }

      final serverTransactions = await _fetchServerChanges();
      int downloaded = 0;
      for (final serverTx in serverTransactions) {
        if (_isCancelled) break;
        await _applyServerTransaction(serverTx);
        downloaded++;
      }

      final duration = DateTime.now().difference(startTime);
      final result = SyncResult(
        uploaded: uploaded,
        downloaded: downloaded,
        conflicts: conflicts,
        failed: failed,
        duration: duration,
        errorMessages: errorMessages,
      );

      if (failed > 0) {
        return (result, SyncFailure.batchFailed(failed, pendingTransactions.length));
      }

      return (result, null);
    } on SyncConflictException catch (e) {
      return (null, ConflictFailure.detected(e.entityId, e.localData, e.serverData));
    } on NetworkException catch (e) {
      return (null, SyncFailure.serverError(e.message));
    } catch (e) {
      return (null, SyncFailure.serverError(e.toString()));
    }
  }

  Future<_SyncSingleResult> _syncSingleTransaction(
    Transaction transaction,
    String conflictStrategy,
    bool enableRetry,
  ) async {
    int attempts = 0;
    while (attempts <= _maxRetryAttempts) {
      if (_isCancelled) return _SyncSingleResult.failed;

      try {
        final result = await _transactionRepository.syncTransaction(transaction);
        if (result.hasConflict) {
          return _handleConflict(transaction, result.serverData!, conflictStrategy);
        }
        await _updateSyncRecord(transaction.id, true, null);
        return _SyncSingleResult.success;
      } catch (e) {
        attempts++;
        if (attempts > _maxRetryAttempts || !enableRetry) {
          await _updateSyncRecord(transaction.id, false, e.toString());
          return _SyncSingleResult.failed;
        }
        await Future.delayed(Duration(seconds: _retryDelaySeconds * attempts));
      }
    }
    return _SyncSingleResult.failed;
  }

  Future<_SyncSingleResult> _handleConflict(
    Transaction transaction,
    Map<String, dynamic> serverData,
    String strategy,
  ) async {
    switch (strategy) {
      case AppConstants.conflictStrategyServerWins:
        await _transactionRepository.resolveConflict(
          transaction.id,
          serverData,
          'server',
        );
        return _SyncSingleResult.success;
      case AppConstants.conflictStrategyClientWins:
        await _transactionRepository.forceSync(transaction);
        return _SyncSingleResult.success;
      case AppConstants.conflictStrategyManual:
        return _SyncSingleResult.conflict;
      default:
        final localVersion = transaction.version ?? 0;
        final serverVersion = serverData['version'] as int? ?? 0;
        if (serverVersion > localVersion) {
          await _transactionRepository.resolveConflict(
            transaction.id,
            serverData,
            'server',
          );
        } else {
          await _transactionRepository.forceSync(transaction);
        }
        return _SyncSingleResult.success;
    }
  }

  Future<List<Transaction>> _fetchServerChanges() async {
    return await _transactionRepository.getServerTransactions();
  }

  Future<void> _applyServerTransaction(Transaction serverTx) async {
    final localTx = await _transactionRepository.getByExternalId(serverTx.externalId);
    if (localTx == null) {
      await _transactionRepository.create(serverTx);
    } else if ((localTx.version ?? 0) < (serverTx.version ?? 0)) {
      await _transactionRepository.update(serverTx);
    }
  }

  Future<void> _updateSyncRecord(String entityId, bool success, String? error) async {
    final record = SyncRecord(
      id: '',
      entityId: entityId,
      entityType: 'transaction',
      operationType: 'sync',
      status: success ? 'completed' : 'failed',
      retryCount: 0,
      errorMessage: error,
      createdAt: DateTime.now(),
      lastAttempt: DateTime.now(),
    );
    await _syncRepository.saveSyncRecord(record);
  }

  @override
  Future<void> cancelSync() async {
    _isCancelled = true;
  }

  @override
  Future<SyncStatus> getCurrentSyncStatus() async {
    final pendingCount = await _transactionRepository.getPendingCount();
    if (pendingCount > 0) return SyncStatus.idle;
    return SyncStatus.completed;
  }
}

enum _SyncSingleResult { success, conflict, failed }

// === ARCHIVO: lib/domain/usecases/resolve_conflict.dart ===
import 'package:equatable/equatable.dart';
import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/app_constants.dart';

class ResolveConflictParams extends Equatable {
  final String entityId;
  final ConflictResolutionStrategy strategy;
  final Map<String, dynamic>? manualResolution;
  final bool notifyServer;

  const ResolveConflictParams({
    required this.entityId,
    required this.strategy,
    this.manualResolution,
    this.notifyServer = true,
  });

  @override
  List<Object?> get props => [entityId, strategy, manualResolution, notifyServer];
}

enum ConflictResolutionStrategy {
  serverWins,
  clientWins,
  lastWriteWins,
  manual,
  merge,
}

class ConflictData extends Equatable {
  final String entityId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final int localVersion;
  final int serverVersion;
  final DateTime localUpdatedAt;
  final DateTime serverUpdatedAt;
  final List<String> conflictingFields;

  const ConflictData({
    required this.entityId,
    required this.localData,
    required this.serverData,
    required this.localVersion,
    required this.serverVersion,
    required this.localUpdatedAt,
    required this.serverUpdatedAt,
    required this.conflictingFields,
  });

  @override
  List<Object?> get props => [
        entityId,
        localData,
        serverData,
        localVersion,
        serverVersion,
        localUpdatedAt,
        serverUpdatedAt,
        conflictingFields,
      ];
}

class ConflictResolutionResult extends Equatable {
  final bool success;
  final Transaction? resolvedTransaction;
  final String? errorMessage;
  final String resolutionType;

  const ConflictResolutionResult({
    required this.success,
    this.resolvedTransaction,
    this.errorMessage,
    required this.resolutionType,
  });

  @override
  List<Object?> get props => [success, resolvedTransaction, errorMessage, resolutionType];
}

abstract class ResolveConflictUseCase {
  Future<(ConflictData?, Failure?)> getConflictData(String entityId);
  Future<(List<ConflictData>, Failure?)> getAllConflicts();
  Future<(ConflictResolutionResult, Failure?)> call(ResolveConflictParams params);
  Future<(ConflictResolutionResult, Failure?)> autoResolve(String entityId, String strategy);
}

class ResolveConflictUseCaseImpl implements ResolveConflictUseCase {
  final TransactionRepository _repository;
  final int _maxMergeFields;

  ResolveConflictUseCaseImpl({
    required TransactionRepository repository,
    int maxMergeFields = 10,
  })  : _repository = repository,
        _maxMergeFields = maxMergeFields;

  @override
  Future<(ConflictData?, Failure?)> getConflictData(String entityId) async {
    try {
      final localTransaction = await _repository.getById(entityId);
      if (localTransaction == null) {
        return (null, DatabaseFailure.notFound('transactions', entityId));
      }

      final serverTransaction = await _repository.getServerTransactionById(entityId);
      if (serverTransaction == null) {
        return (null, const SyncFailure.serverError('Server version not available'));
      }

      final conflictData = _buildConflictData(localTransaction, serverTransaction);
      return (conflictData, null);
    } on OfflineException catch (e) {
      return (null, OfflineFailure.database(e.message));
    } catch (e) {
      return (null, DatabaseFailure.transactionFailed(e.toString()));
    }
  }

  @override
  Future<(List<ConflictData>, Failure?)> getAllConflicts() async {
    try {
      final pendingWithConflicts = await _repository.getPendingWithConflicts();
      final conflicts = <ConflictData>[];

      for (final localTx in pendingWithConflicts) {
        final serverTx = await _repository.getServerTransactionById(localTx.id);
        if (serverTx != null) {
          conflicts.add(_buildConflictData(localTx, serverTx));
        }
      }

      return (conflicts, null);
    } catch (e) {
      return (<ConflictData>[], DatabaseFailure.transactionFailed(e.toString()));
    }
  }

  @override
  Future<(ConflictResolutionResult, Failure?)> call(ResolveConflictParams params) async {
    try {
      final (conflictData, failure) = await getConflictData(params.entityId);
      if (failure != null || conflictData == null) {
        return (ConflictResolutionResult(
          success: false,
          errorMessage: failure?.message ?? 'Conflict data not found',
          resolutionType: 'failed',
        ), failure);
      }

      final resolution = _determineResolution(params.strategy, conflictData, params.manualResolution);
      final resolvedTransaction = await _applyResolution(params.entityId, resolution);

      if (params.notifyServer) {
        try {
          await _notifyServerOfResolution(params.entityId, resolution);
        } catch (_) {
          // Non-critical, resolution already applied locally
        }
      }

      return (ConflictResolutionResult(
        success: true,
        resolvedTransaction: resolvedTransaction,
        resolutionType: params.strategy.name,
      ), null);
    } on SyncConflictException catch (e) {
      return (ConflictResolutionResult(
        success: false,
        errorMessage: e.message,
        resolutionType: 'failed',
      ), ConflictFailure.unresolved(params.entityId));
    } catch (e) {
      return (ConflictResolutionResult(
        success: false,
        errorMessage: e.toString(),
        resolutionType: 'failed',
      ), ConflictFailure.unresolved(params.entityId));
    }
  }

  @override
  Future<(ConflictResolutionResult, Failure?)> autoResolve(
    String entityId,
    String strategy,
  ) async {
    final strategyEnum = _parseStrategy(strategy);
    final params = ResolveConflictParams(
      entityId: entityId,
      strategy: strategyEnum,
      notifyServer: true,
    );
    return call(params);
  }

  ConflictData _buildConflictData(Transaction local, Transaction server) {
    final localData = _transactionToMap(local);
    final serverData = _transactionToMap(server);
    final conflictingFields = <String>[];

    for (final key in localData.keys) {
      if (localData[key] != serverData[key]) {
        conflictingFields.add(key);
      }
    }

    return ConflictData(
      entityId: local.id,
      localData: localData,
      serverData: serverData,
      localVersion: local.version ?? 0,
      serverVersion: server.version ?? 0,
      localUpdatedAt: local.updatedAt,
      serverUpdatedAt: server.updatedAt,
      conflictingFields: conflictingFields,
    );
  }

  Map<String, dynamic> _transactionToMap(Transaction tx) {
    return {
      'id': tx.id,
      'externalId': tx.externalId,
      'amount': tx.amount,
      'currency': tx.currency,
      'transactionType': tx.transactionType,
      'description': tx.description,
      'metadata': tx.metadata,
      'version': tx.version,
      'updatedAt': tx.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _determineResolution(
    ConflictResolutionStrategy strategy,
    ConflictData conflictData,
    Map<String, dynamic>? manualResolution,
  ) {
    switch (strategy) {
      case ConflictResolutionStrategy.serverWins:
        return conflictData.serverData;
      case ConflictResolutionStrategy.clientWins:
        return conflictData.localData;
      case ConflictResolutionStrategy.lastWriteWins:
        if (conflictData.serverUpdatedAt.isAfter(conflictData.localUpdatedAt)) {
          return conflictData.serverData;
        }
        return conflictData.localData;
      case ConflictResolutionStrategy.manual:
        if (manualResolution != null) return manualResolution;
        return conflictData.localData;
      case ConflictResolutionStrategy.merge:
        return _mergeData(conflictData);
    }
  }

  Map<String, dynamic> _mergeData(ConflictData conflictData) {
    final merged = <String, dynamic>{};
    final allKeys = <String>{...conflictData.localData.keys, ...conflictData.serverData.keys};

    for (final key in allKeys) {
      if (key == 'version') {
        merged[key] = (conflictData.localVersion > conflictData.serverVersion
                ? conflictData.localVersion
                : conflictData.serverVersion) +
            1;
      } else if (conflictData.localData[key] == conflictData.serverData[key]) {
        merged[key] = conflictData.localData[key];
      } else if (conflictData.conflictingFields.contains(key)) {
        merged[key] = conflictData.serverData[key] ?? conflictData.localData[key];
      } else {
        merged[key] = conflictData.localData[key] ?? conflictData.serverData[key];
      }
    }

    return merged;
  }

  Future<Transaction> _applyResolution(
    String entityId,
    Map<String, dynamic> resolution,
  ) async {
    final resolved = resolution['version'] as int? ?? 1;
    final transaction = Transaction(
      id: entityId,
      externalId: resolution['externalId'] as String? ?? '',
      amount: (resolution['amount'] as num?)?.toDouble() ?? 0.0,
      currency: resolution['currency'] as String? ?? 'USD',
      transactionType: resolution['transactionType'] as String? ?? 'default',
      description: resolution['description'] as String? ?? '',
      metadata: resolution['metadata'] as Map<String, dynamic>?,
      version: resolved,
      syncStatus: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.resolveConflict(entityId, resolution, 'resolved');
    return transaction;
  }

  Future<void> _notifyServerOfResolution(
    String entityId,
    Map<String, dynamic> resolution,
  ) async {
    // Placeholder for server notification
    // In a real implementation, this would call the remote datasource
  }

  ConflictResolutionStrategy _parseStrategy(String strategy) {
    switch (strategy) {
      case 'server':
        return ConflictResolutionStrategy.serverWins;
      case 'client':
        return ConflictResolutionStrategy.clientWins;
      case 'last_write':
        return ConflictResolutionStrategy.lastWriteWins;
      case 'merge':
        return ConflictResolutionStrategy.merge;
      default:
        return ConflictResolutionStrategy.manual;
    }
  }
}


// === ARCHIVO: lib/data/models/transaction_model.dart ===
package lib.data.models;

import 'dart:convert';
import 'package:lib/core/constants/app_constants.dart';
import 'package:lib/domain/entities/transaction.dart';

class TransactionModel {
  final String id;
  final String? externalId;
  final double amount;
  final String currency;
  final String transactionType;
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final String syncStatus;
  final String? hash;

  TransactionModel({
    required this.id,
    this.externalId,
    required this.amount,
    required this.currency,
    required this.transactionType,
    required this.description,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.syncStatus,
    this.hash,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json[DatabaseColumns.id] as String,
      externalId: json[DatabaseColumns.externalId] as String?,
      amount: (json[DatabaseColumns.amount] as num).toDouble(),
      currency: json[DatabaseColumns.currency] as String,
      transactionType: json[DatabaseColumns.transactionType] as String,
      description: json[DatabaseColumns.description] as String,
      metadata: json[DatabaseColumns.metadata] != null
          ? jsonDecode(json[DatabaseColumns.metadata] as String) as Map<String, dynamic>
          : null,
      createdAt: DateTime.parse(json[DatabaseColumns.createdAt] as String),
      updatedAt: DateTime.parse(json[DatabaseColumns.updatedAt] as String),
      version: json[DatabaseColumns.version] as int,
      syncStatus: json[DatabaseColumns.syncStatus] as String,
      hash: json[DatabaseColumns.hash] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DatabaseColumns.id: id,
      DatabaseColumns.externalId: externalId,
      DatabaseColumns.amount: amount,
      DatabaseColumns.currency: currency,
      DatabaseColumns.transactionType: transactionType,
      DatabaseColumns.description: description,
      DatabaseColumns.metadata: metadata != null ? jsonEncode(metadata) : null,
      DatabaseColumns.createdAt: createdAt.toIso8601String(),
      DatabaseColumns.updatedAt: updatedAt.toIso8601String(),
      DatabaseColumns.version: version,
      DatabaseColumns.syncStatus: syncStatus,
      DatabaseColumns.hash: hash,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel.fromJson(map);
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      externalId: externalId,
      amount: amount,
      currency: currency,
      transactionType: transactionType,
      description: description,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
      version: version,
      syncStatus: syncStatus,
    );
  }

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      externalId: entity.externalId,
      amount: entity.amount,
      currency: entity.currency,
      transactionType: entity.transactionType,
      description: entity.description,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      version: entity.version,
      syncStatus: entity.syncStatus,
      hash: entity.hash,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? externalId,
    double? amount,
    String? currency,
    String? transactionType,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? syncStatus,
    String? hash,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      transactionType: transactionType ?? this.transactionType,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      hash: hash ?? this.hash,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount $currency, type: $transactionType, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionModel &&
        other.id == id &&
        other.externalId == externalId &&
        other.amount == amount &&
        other.currency == currency &&
        other.transactionType == transactionType &&
        other.description == description &&
        other.version == version &&
        other.syncStatus == syncStatus;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      externalId,
      amount,
      currency,
      transactionType,
      description,
      version,
      syncStatus,
    );
  }
}

// === ARCHIVO: lib/data/models/sync_record_model.dart ===
package lib.data.models;

import 'package:lib/core/constants/app_constants.dart';
import 'package:lib/domain/entities/sync_record.dart';

class SyncRecordModel {
  final String id;
  final String entityId;
  final String entityType;
  final String operationType;
  final String? payload;
  final String? payloadHash;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final int retryCount;
  final String? errorMessage;
  final String? conflictData;
  final int version;

  SyncRecordModel({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.operationType,
    this.payload,
    this.payloadHash,
    required this.syncStatus,
    required this.createdAt,
    this.syncedAt,
    required this.retryCount,
    this.errorMessage,
    this.conflictData,
    required this.version,
  });

  factory SyncRecordModel.fromJson(Map<String, dynamic> json) {
    return SyncRecordModel(
      id: json[DatabaseColumns.id] as String,
      entityId: json[DatabaseColumns.uuid] as String,
      entityType: json['entity_type'] as String,
      operationType: json[DatabaseColumns.operationType] as String,
      payload: json['payload'] as String?,
      payloadHash: json[DatabaseColumns.hash] as String?,
      syncStatus: json[DatabaseColumns.syncStatus] as String,
      createdAt: DateTime.parse(json[DatabaseColumns.createdAt] as String),
      syncedAt: json['synced_at'] != null
          ? DateTime.parse(json['synced_at'] as String)
          : null,
      retryCount: json['retry_count'] as int? ?? 0,
      errorMessage: json['error_message'] as String?,
      conflictData: json[DatabaseColumns.conflictData] as String?,
      version: json[DatabaseColumns.version] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DatabaseColumns.id: id,
      DatabaseColumns.uuid: entityId,
      'entity_type': entityType,
      DatabaseColumns.operationType: operationType,
      'payload': payload,
      DatabaseColumns.hash: payloadHash,
      DatabaseColumns.syncStatus: syncStatus,
      DatabaseColumns.createdAt: createdAt.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
      'retry_count': retryCount,
      'error_message': errorMessage,
      DatabaseColumns.conflictData: conflictData,
      DatabaseColumns.version: version,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory SyncRecordModel.fromMap(Map<String, dynamic> map) {
    return SyncRecordModel.fromJson(map);
  }

  SyncRecord toEntity() {
    return SyncRecord(
      id: id,
      entityId: entityId,
      entityType: entityType,
      operationType: operationType,
      payload: payload,
      payloadHash: payloadHash,
      syncStatus: syncStatus,
      createdAt: createdAt,
      syncedAt: syncedAt,
      retryCount: retryCount,
      errorMessage: errorMessage,
      conflictData: conflictData != null ? _parseConflictData(conflictData!) : null,
      version: version,
    );
  }

  factory SyncRecordModel.fromEntity(SyncRecord entity) {
    return SyncRecordModel(
      id: entity.id,
      entityId: entity.entityId,
      entityType: entity.entityType,
      operationType: entity.operationType,
      payload: entity.payload,
      payloadHash: entity.payloadHash,
      syncStatus: entity.syncStatus,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
      retryCount: entity.retryCount,
      errorMessage: entity.errorMessage,
      conflictData: entity.conflictData != null ? _encodeConflictData(entity.conflictData!) : null,
      version: entity.version,
    );
  }

  static Map<String, dynamic>? _parseConflictData(String data) {
    try {
      final parts = data.split('|');
      if (parts.length >= 3) {
        return {
          'local_version': parts[0],
          'server_version': parts[1],
          'local_data': parts[2],
          'server_data': parts.length > 3 ? parts[3] : '',
        };
      }
    } catch (_) {}
    return null;
  }

  static String? _encodeConflictData(Map<String, dynamic>? data) {
    if (data == null) return null;
    return '${data['local_version']}|${data['server_version']}|${data['local_data']}|${data['server_data']}';
  }

  SyncRecordModel copyWith({
    String? id,
    String? entityId,
    String? entityType,
    String? operationType,
    String? payload,
    String? payloadHash,
    String? syncStatus,
    DateTime? createdAt,
    DateTime? syncedAt,
    int? retryCount,
    String? errorMessage,
    String? conflictData,
    int? version,
  }) {
    return SyncRecordModel(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      payloadHash: payloadHash ?? this.payloadHash,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      conflictData: conflictData ?? this.conflictData,
      version: version ?? this.version,
    );
  }

  bool get isPending => syncStatus == AppConstants.syncStatusPending;
  bool get isInProgress => syncStatus == AppConstants.syncStatusInProgress;
  bool get isCompleted => syncStatus == AppConstants.syncStatusCompleted;
  bool get isFailed => syncStatus == AppConstants.syncStatusFailed;
  bool get isConflict => syncStatus == AppConstants.syncStatusConflict;

  @override
  String toString() {
    return 'SyncRecordModel(id: $id, entityId: $entityId, operation: $operationType, status: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncRecordModel &&
        other.id == id &&
        other.entityId == entityId &&
        other.operationType == operationType &&
        other.syncStatus == syncStatus;
  }

  @override
  int get hashCode {
    return Object.hash(id, entityId, operationType, syncStatus);
  }
}

// === ARCHIVO: lib/data/datasources/local/database_helper.dart ===
package lib.data.datasources.local;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lib/core/constants/app_constants.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._();

  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTransactionsTable(db);
    await _createSyncRecordsTable(db);
    await _createPendingOperationsTable(db);
    await _createIndexes(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion; i < newVersion; i++) {
      await _runMigration(db, i);
    }
  }

  Future<void> _runMigration(Database db, int fromVersion) async {
    switch (fromVersion) {
      case 1:
        await _migrateToVersion2(db);
        break;
      case 2:
        await _migrateToVersion3(db);
        break;
    }
  }

  Future<void> _migrateToVersion2(Database db) async {
    await db.execute('''
      ALTER TABLE ${AppConstants.transactionsTable}
      ADD COLUMN ${DatabaseColumns.hash} TEXT
    ''');
  }

  Future<void> _migrateToVersion3(Database db) async {
    await db.execute('''
      CREATE INDEX idx_transactions_sync_status
      ON ${AppConstants.transactionsTable}(${DatabaseColumns.syncStatus})
    ''');
    await db.execute('''
      CREATE INDEX idx_sync_records_status
      ON ${AppConstants.syncRecordsTable}(${DatabaseColumns.syncStatus})
    ''');
  }

  Future<void> _createTransactionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.transactionsTable} (
        ${DatabaseColumns.id} TEXT PRIMARY KEY,
        ${DatabaseColumns.externalId} TEXT,
        ${DatabaseColumns.amount} REAL NOT NULL,
        ${DatabaseColumns.currency} TEXT NOT NULL,
        ${DatabaseColumns.transactionType} TEXT NOT NULL,
        ${DatabaseColumns.description} TEXT NOT NULL,
        ${DatabaseColumns.metadata} TEXT,
        ${DatabaseColumns.createdAt} TEXT NOT NULL,
        ${DatabaseColumns.updatedAt} TEXT NOT NULL,
        ${DatabaseColumns.version} INTEGER NOT NULL DEFAULT 1,
        ${DatabaseColumns.syncStatus} TEXT NOT NULL DEFAULT '${AppConstants.syncStatusPending}',
        ${DatabaseColumns.hash} TEXT
      )
    ''');
  }

  Future<void> _createSyncRecordsTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.syncRecordsTable} (
        ${DatabaseColumns.id} TEXT PRIMARY KEY,
        ${DatabaseColumns.uuid} TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        ${DatabaseColumns.operationType} TEXT NOT NULL,
        payload TEXT,
        ${DatabaseColumns.hash} TEXT,
        ${DatabaseColumns.syncStatus} TEXT NOT NULL DEFAULT '${AppConstants.syncStatusPending}',
        ${DatabaseColumns.createdAt} TEXT NOT NULL,
        synced_at TEXT,
        retry_count INTEGER DEFAULT 0,
        error_message TEXT,
        ${DatabaseColumns.conflictData} TEXT,
        ${DatabaseColumns.version} INTEGER DEFAULT 1
      )
    ''');
  }

  Future<void> _createPendingOperationsTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.pendingOperationsTable} (
        ${DatabaseColumns.id} TEXT PRIMARY KEY,
        ${DatabaseColumns.uuid} TEXT NOT NULL,
        operation_type TEXT NOT NULL,
        payload TEXT NOT NULL,
        ${DatabaseColumns.hash} TEXT NOT NULL,
        created_at TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending'
      )
    ''');
  }

  Future<void> _createIndexes(Database db) async {
    await db.execute('''
      CREATE INDEX idx_transactions_created_at
      ON ${AppConstants.transactionsTable}(${DatabaseColumns.createdAt})
    ''');
    await db.execute('''
      CREATE INDEX idx_transactions_sync_status
      ON ${AppConstants.transactionsTable}(${DatabaseColumns.syncStatus})
    ''');
    await db.execute('''
      CREATE INDEX idx_sync_records_entity_id
      ON ${AppConstants.syncRecordsTable}(${DatabaseColumns.uuid})
    ''');
    await db.execute('''
      CREATE INDEX idx_sync_records_status
      ON ${AppConstants.syncRecordsTable}(${DatabaseColumns.syncStatus})
    ''');
  }

  Future<T> runInTransaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    final db = await database;
    return await db.transaction(action);
  }

  Future<void> runInTransactionVoid(
    Future<void> Function(Transaction txn) action,
  ) async {
    final db = await database;
    await db.transaction(action);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertOrThrow(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<Map<String, dynamic>?> queryById(String table, String id) async {
    final db = await database;
    final results = await db.query(
      table,
      where: '${DatabaseColumns.id} = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> count(String table, {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
      whereArgs,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete(AppConstants.transactionsTable);
    await db.delete(AppConstants.syncRecordsTable);
    await db.delete(AppConstants.pendingOperationsTable);
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/sync_record.dart';
import '../models/transaction_model.dart';
import '../models/sync_record_model.dart';
import 'database_helper.dart';

class TransactionLocalDatasource {
  final DatabaseHelper _databaseHelper;
  final NetworkInfo _networkInfo;
  final Uuid _uuid;

  TransactionLocalDatasource({
    required DatabaseHelper databaseHelper,
    required NetworkInfo networkInfo,
    Uuid? uuid,
  })  : _databaseHelper = databaseHelper,
        _networkInfo = networkInfo,
        _uuid = uuid ?? const Uuid();

  Future<TransactionModel> createTransaction(Transaction transaction) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();
      
      final id = _uuid.v4();
      final hash = _generateOperationHash(transaction);
      
      final model = TransactionModel(
        id: id,
        externalId: null,
        amount: transaction.amount,
        currency: transaction.currency,
        transactionType: transaction.transactionType,
        description: transaction.description,
        metadata: transaction.metadata,
        createdAt: now,
        updatedAt: now,
        version: 1,
        syncStatus: AppConstants.syncStatusPending,
        hash: hash,
      );

      await db.insert(
        AppConstants.transactionsTable,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final syncRecord = SyncRecordModel(
        id: _uuid.v4(),
        entityId: id,
        entityType: 'transaction',
        operationType: 'CREATE',
        payload: model.toMap(),
        createdAt: now,
        retryCount: 0,
        lastAttempt: null,
        status: AppConstants.syncStatusPending,
      );

      await db.insert(
        AppConstants.pendingOperationsTable,
        syncRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return model;
    } catch (e) {
      throw OfflineException.database('Failed to create transaction: $e');
    }
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return TransactionModel.fromMap(results.first);
    } catch (e) {
      throw OfflineException.database('Failed to get transaction: $e');
    }
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        orderBy: '${DatabaseColumns.createdAt} DESC',
      );

      return results.map((map) => TransactionModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get all transactions: $e');
    }
  }

  Future<List<TransactionModel>> getPendingTransactions() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [AppConstants.syncStatusPending],
        orderBy: '${DatabaseColumns.createdAt} ASC',
      );

      return results.map((map) => TransactionModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get pending transactions: $e');
    }
  }

  Future<List<TransactionModel>> getTransactionsByStatus(String status) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [status],
        orderBy: '${DatabaseColumns.createdAt} DESC',
      );

      return results.map((map) => TransactionModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get transactions by status: $e');
    }
  }

  Future<TransactionModel> updateTransaction(TransactionModel model) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();
      
      final updatedModel = model.copyWith(
        updatedAt: now,
        version: model.version + 1,
        syncStatus: AppConstants.syncStatusPending,
      );

      await db.update(
        AppConstants.transactionsTable,
        updatedModel.toMap(),
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [model.id],
      );

      final syncRecord = SyncRecordModel(
        id: _uuid.v4(),
        entityId: model.id,
        entityType: 'transaction',
        operationType: 'UPDATE',
        payload: updatedModel.toMap(),
        createdAt: now,
        retryCount: 0,
        lastAttempt: null,
        status: AppConstants.syncStatusPending,
      );

      await db.insert(
        AppConstants.pendingOperationsTable,
        syncRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return updatedModel;
    } catch (e) {
      throw OfflineException.database('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();

      await db.delete(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );

      final syncRecord = SyncRecordModel(
        id: _uuid.v4(),
        entityId: id,
        entityType: 'transaction',
        operationType: 'DELETE',
        payload: {'id': id},
        createdAt: now,
        retryCount: 0,
        lastAttempt: null,
        status: AppConstants.syncStatusPending,
      );

      await db.insert(
        AppConstants.pendingOperationsTable,
        syncRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw OfflineException.database('Failed to delete transaction: $e');
    }
  }

  Future<void> markTransactionAsSynced(String id, String? externalId) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.transactionsTable,
        {
          DatabaseColumns.syncStatus: AppConstants.syncStatusCompleted,
          DatabaseColumns.externalId: externalId,
        },
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark transaction as synced: $e');
    }
  }

  Future<void> markTransactionAsFailed(String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.transactionsTable,
        {DatabaseColumns.syncStatus: AppConstants.syncStatusFailed},
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark transaction as failed: $e');
    }
  }

  Future<bool> isOperationIdempotent(String operationHash) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.hash} = ?',
        whereArgs: [operationHash],
        limit: 1,
      );

      return results.isNotEmpty;
    } catch (e) {
      throw OfflineException.database('Failed to check idempotency: $e');
    }
  }

  Future<int> getPendingCount() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.transactionsTable} WHERE ${DatabaseColumns.syncStatus} = ?',
        [AppConstants.syncStatusPending],
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw OfflineException.database('Failed to get pending count: $e');
    }
  }

  String _generateOperationHash(Transaction transaction) {
    final data = '${transaction.amount}${transaction.currency}${transaction.transactionType}${transaction.description}${DateTime.now().millisecondsSinceEpoch}';
    return sha256.convert(data.codeUnits).toString();
  }

  Future<void> markTransactionAsConflict(
    String id,
    Map<String, dynamic> conflictData,
  ) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.transactionsTable,
        {
          DatabaseColumns.syncStatus: AppConstants.syncStatusConflict,
          DatabaseColumns.metadata: conflictData.toString(),
        },
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark transaction as conflict: $e');
    }
  }

  Future<void> resolveConflict(
    String id,
    TransactionModel resolvedModel,
    String strategy,
  ) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();
      
      await db.update(
        AppConstants.transactionsTable,
        {
          DatabaseColumns.amount: resolvedModel.amount,
          DatabaseColumns.currency: resolvedModel.currency,
          DatabaseColumns.transactionType: resolvedModel.transactionType,
          DatabaseColumns.description: resolvedModel.description,
          DatabaseColumns.metadata: resolvedModel.metadata,
          DatabaseColumns.updatedAt: now,
          DatabaseColumns.version: resolvedModel.version,
          DatabaseColumns.syncStatus: AppConstants.syncStatusPending,
        },
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to resolve conflict: $e');
    }
  }
}
// === ARCHIVO: lib/data/datasources/local/sync_local_datasource.dart ===
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/sync_record.dart';
import '../models/sync_record_model.dart';
import 'database_helper.dart';

class SyncLocalDatasource {
  final DatabaseHelper _databaseHelper;
  final Uuid _uuid;

  SyncLocalDatasource({
    required DatabaseHelper databaseHelper,
    Uuid? uuid,
  })  : _databaseHelper = databaseHelper,
        _uuid = uuid ?? const Uuid();

  Future<SyncRecordModel> createSyncRecord(SyncRecord syncRecord) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();

      final model = SyncRecordModel(
        id: syncRecord.id ?? _uuid.v4(),
        entityId: syncRecord.entityId,
        entityType: syncRecord.entityType,
        operationType: syncRecord.operationType,
        payload: syncRecord.payload,
        createdAt: syncRecord.createdAt ?? now,
        retryCount: syncRecord.retryCount ?? 0,
        lastAttempt: syncRecord.lastAttempt,
        status: syncRecord.status ?? AppConstants.syncStatusPending,
      );

      await db.insert(
        AppConstants.pendingOperationsTable,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return model;
    } catch (e) {
      throw OfflineException.database('Failed to create sync record: $e');
    }
  }

  Future<SyncRecordModel?> getSyncRecordById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return SyncRecordModel.fromMap(results.first);
    } catch (e) {
      throw OfflineException.database('Failed to get sync record: $e');
    }
  }

  Future<List<SyncRecordModel>> getPendingSyncRecords() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [AppConstants.syncStatusPending],
        orderBy: '${DatabaseColumns.createdAt} ASC',
      );

      return results.map((map) => SyncRecordModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get pending sync records: $e');
    }
  }

  Future<List<SyncRecordModel>> getFailedSyncRecords() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [AppConstants.syncStatusFailed],
        orderBy: '${DatabaseColumns.createdAt} ASC',
      );

      return results.map((map) => SyncRecordModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get failed sync records: $e');
    }
  }

  Future<List<SyncRecordModel>> getSyncRecordsByEntityId(String entityId) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: 'entity_id = ?',
        whereArgs: [entityId],
        orderBy: '${DatabaseColumns.createdAt} DESC',
      );

      return results.map((map) => SyncRecordModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get sync records by entity: $e');
    }
  }

  Future<SyncRecordModel> updateSyncRecord(SyncRecordModel model) async {
    try {
      final db = await _databaseHelper.database;

      await db.update(
        AppConstants.pendingOperationsTable,
        model.toMap(),
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [model.id],
      );

      return model;
    } catch (e) {
      throw OfflineException.database('Failed to update sync record: $e');
    }
  }

  Future<void> deleteSyncRecord(String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to delete sync record: $e');
    }
  }

  Future<void> markSyncRecordAsCompleted(String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.pendingOperationsTable,
        {DatabaseColumns.syncStatus: AppConstants.syncStatusCompleted},
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark sync record as completed: $e');
    }
  }

  Future<void> markSyncRecordAsFailed(String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.pendingOperationsTable,
        {
          DatabaseColumns.syncStatus: AppConstants.syncStatusFailed,
          DatabaseColumns.operationType: 'RETRY',
        },
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark sync record as failed: $e');
    }
  }

  Future<void> incrementRetryCount(String id) async {
    try {
      final db = await _databaseHelper.database;
      final record = await getSyncRecordById(id);
      
      if (record != null) {
        await db.update(
          AppConstants.pendingOperationsTable,
          {
            DatabaseColumns.operationType: record.retryCount + 1,
            DatabaseColumns.syncStatus: record.lastAttempt = DateTime.now().toIso8601String(),
          },
          where: '${DatabaseColumns.id} = ?',
          whereArgs: [id],
        );
      }
    } catch (e) {
      throw OfflineException.database('Failed to increment retry count: $e');
    }
  }

  Future<void> deleteCompletedSyncRecords() async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [AppConstants.syncStatusCompleted],
      );
    } catch (e) {
      throw OfflineException.database('Failed to delete completed sync records: $e');
    }
  }

  Future<int> getPendingCount() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.pendingOperationsTable} WHERE ${DatabaseColumns.syncStatus} = ?',
        [AppConstants.syncStatusPending],
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw OfflineException.database('Failed to get pending count: $e');
    }
  }

  Future<int> getFailedCount() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.pendingOperationsTable} WHERE ${DatabaseColumns.syncStatus} = ?',
        [AppConstants.syncStatusFailed],
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw OfflineException.database('Failed to get failed count: $e');
    }
  }

  Future<void> clearAllSyncRecords() async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(AppConstants.pendingOperationsTable);
    } catch (e) {
      throw OfflineException.database('Failed to clear all sync records: $e');
    }
  }

  Future<List<SyncRecordModel>> getSyncRecordsByStatus(String status) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [status],
        orderBy: '${DatabaseColumns.createdAt} ASC',
      );

      return results.map((map) => SyncRecordModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get sync records by status: $e');
    }
  }

  Future<void> bulkUpdateStatus(
    List<String> ids,
    String newStatus,
  ) async {
    try {
      final db = await _databaseHelper.database;
      final batch = db.batch();

      for (final id in ids) {
        batch.update(
          AppConstants.pendingOperationsTable,
          {DatabaseColumns.syncStatus: newStatus},
          where: '${DatabaseColumns.id} = ?',
          whereArgs: [id],
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw OfflineException.database('Failed to bulk update sync records: $e');
    }
  }
}
// === ARCHIVO: lib/data/datasources/remote/transaction_remote_datasource.dart ===
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/transaction.dart';
import '../models/transaction_model.dart';

class TransactionRemoteDatasource {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  TransactionRemoteDatasource({
    required Dio dio,
    required NetworkInfo networkInfo,
  })  : _dio = dio,
        _networkInfo = networkInfo;

  Future<bool> get isConnected => _networkInfo.isConnected;

  Future<TransactionModel> createTransaction(TransactionModel model) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.post(
        AppConstants.getApiUrl('/transactions'),
        data: model.toServerMap(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TransactionModel.fromServerMap(response.data);
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to create transaction on server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<TransactionModel?> getTransactionById(String externalId) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.get(
        AppConstants.getApiUrl('/transactions/$externalId'),
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return TransactionModel.fromServerMap(response.data);
      } else if (response.statusCode == 404) {
        return null;
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to get transaction from server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<TransactionModel>> getAllTransactions({
    int page = 1,
    int pageSize = AppConstants.defaultPageSize,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.get(
        AppConstants.getApiUrl('/transactions'),
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['items'] ?? response.data;
        return data.map((json) => TransactionModel.fromServerMap(json)).toList();
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to get transactions from server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<TransactionModel> updateTransaction(TransactionModel model) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.put(
        AppConstants.getApiUrl('/transactions/${model.externalId ?? model.id}'),
        data: model.toServerMap(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'If-Match': model.version.toString(),
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return TransactionModel.fromServerMap(response.data);
      } else if (response.statusCode == 409) {
        throw SyncConflictException.detected(
          entityId: model.id,
          localData: model.toMap(),
          serverData: response.data,
          conflictStrategy: AppConstants.conflictStrategyLastWriteWins,
        );
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to update transaction on server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteTransaction(String externalId) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.delete(
        AppConstants.getApiUrl('/transactions/$externalId'),
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw NetworkException.serverError(
          response.statusCode ?? 500,
          'Failed to delete transaction on server',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<TransactionModel>> syncBatch(
    List<TransactionModel> models,
  ) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.post(
        AppConstants.getApiUrl('/transactions/batch'),
        data: {
          'operations': models.map((m) => m.toServerMap()).toList(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout * 2),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout * 2),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? [];
        return data.map((json) => TransactionModel.fromServerMap(json)).toList();
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to sync batch to server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> checkServerVersion() async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.get(
        AppConstants.getApiUrl('/version'),
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to check server version',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout();
      case DioExceptionType.connectionError:
        return const OfflineException.noConnectivity();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 500;
        if (statusCode == 401) {
          return NetworkException.unauthorized();
        } else if (statusCode == 404) {
          return NetworkException.notFound(e.requestOptions.uri.toString());
        }
        return NetworkException.serverError(
          statusCode,
          e.response?.data?['message'] ?? 'Unknown server error',
        );
      case DioExceptionType.cancel:
        return const AppException(message: 'Request cancelled', code: 'CANCELLED');
      default:
        return AppException(
          message: e.message ?? 'Unknown network error',
          code: 'NETWORK_ERROR',
          originalError: e,
        );
    }
  }
}

// === ARCHIVO: lib/data/repositories/transaction_repository_impl.dart ===
package offline_field_app.data.repositories;

import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/transaction.dart' as domain;
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';
import '../datasources/local/transaction_local_datasource.dart';
import '../datasources/remote/transaction_remote_datasource.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;
  final Hash hash;

  TransactionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.uuid,
    required this.hash,
  });

  @override
  Future<domain.Transaction> createTransaction(domain.Transaction transaction) async {
    final operationHash = _generateOperationHash(transaction);
    final existingRecord = await localDataSource.getTransactionByHash(operationHash);
    if (existingRecord != null) {
      throw IdempotencyException.duplicateOperation(operationHash, existingRecord.id);
    }

    final now = DateTime.now().toUtc();
    final transactionId = uuid.v4();
    final model = TransactionModel(
      id: transactionId,
      externalId: transaction.externalId,
      amount: transaction.amount,
      currency: transaction.currency,
      transactionType: transaction.transactionType,
      description: transaction.description,
      metadata: transaction.metadata,
      createdAt: now,
      updatedAt: now,
      version: 1,
      syncStatus: 'pending',
      hash: operationHash,
    );

    await localDataSource.insertTransaction(model);
    
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteModel = await remoteDataSource.createTransaction(model.toJson());
        await localDataSource.updateTransactionSyncStatus(transactionId, 'completed', remoteModel.id);
        return _mapModelToEntity(
          await localDataSource.getTransactionById(transactionId)!,
        );
      } catch (e) {
        await localDataSource.updateTransactionSyncStatus(transactionId, 'failed', null);
        rethrow;
      }
    }

    return _mapModelToEntity(model);
  }

  @override
  Future<domain.Transaction?> getTransactionById(String id) async {
    final model = await localDataSource.getTransactionById(id);
    if (model == null) return null;
    return _mapModelToEntity(model);
  }

  @override
  Future<List<domain.Transaction>> getAllTransactions({int? limit, int? offset}) async {
    final models = await localDataSource.getAllTransactions(limit: limit, offset: offset);
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<List<domain.Transaction>> getPendingTransactions() async {
    final models = await localDataSource.getPendingTransactions();
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<domain.Transaction> updateTransaction(domain.Transaction transaction) async {
    final existing = await localDataSource.getTransactionById(transaction.id);
    if (existing == null) {
      throw const OfflineException.database('Transaction not found');
    }

    final newVersion = existing.version + 1;
    final operationHash = _generateOperationHash(transaction, existing.version);
    final model = TransactionModel(
      id: transaction.id,
      externalId: transaction.externalId,
      amount: transaction.amount,
      currency: transaction.currency,
      transactionType: transaction.transactionType,
      description: transaction.description,
      metadata: transaction.metadata,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
      version: newVersion,
      syncStatus: 'pending',
      hash: operationHash,
    );

    await localDataSource.updateTransaction(model);

    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        await remoteDataSource.updateTransaction(model.toJson());
        await localDataSource.updateTransactionSyncStatus(transaction.id, 'completed', null);
      } catch (e) {
        await localDataSource.updateTransactionSyncStatus(transaction.id, 'failed', null);
        rethrow;
      }
    }

    return _mapModelToEntity(model);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final existing = await localDataSource.getTransactionById(id);
    if (existing == null) {
      throw const OfflineException.database('Transaction not found');
    }

    await localDataSource.deleteTransaction(id);

    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        await remoteDataSource.deleteTransaction(id);
      } catch (e) {
        // Log error but don't throw - local delete succeeded
      }
    }
  }

  @override
  Future<List<domain.Transaction>> searchTransactions(String query) async {
    final models = await localDataSource.searchTransactions(query);
    return models.map(_mapModelToEntity).toList();
  }

  String _generateOperationHash(domain.Transaction transaction, [int? baseVersion]) {
    final content = '${transaction.amount}${transaction.currency}'
        '${transaction.transactionType}${transaction.description}'
        '${baseVersion ?? 0}';
    return hash.convert(content.codeUnits).toString();
  }

  domain.Transaction _mapModelToEntity(TransactionModel model) {
    return domain.Transaction(
      id: model.id,
      externalId: model.externalId,
      amount: model.amount,
      currency: model.currency,
      transactionType: model.transactionType,
      description: model.description,
      metadata: model.metadata,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      version: model.version,
      syncStatus: model.syncStatus,
    );
  }
}

// === ARCHIVO: lib/data/repositories/sync_repository_impl.dart ===
package offline_field_app.data.repositories;

import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/sync_record.dart' as domain;
import '../../domain/repositories/sync_repository.dart';
import '../models/sync_record_model.dart';
import '../datasources/local/sync_local_datasource.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';

class SyncRepositoryImpl implements SyncRepository {
  final SyncLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;

  SyncRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
    required this.uuid,
  });

  @override
  Future<domain.SyncRecord> recordOperation(domain.SyncRecord record) async {
    final recordId = uuid.v4();
    final now = DateTime.now().toUtc();
    
    final model = SyncRecordModel(
      id: recordId,
      entityId: record.entityId,
      entityType: record.entityType,
      operationType: record.operationType,
      payload: record.payload,
      status: 'pending',
      createdAt: now,
      updatedAt: now,
      attempts: 0,
      lastAttemptAt: null,
      errorMessage: null,
      version: 1,
    );

    await localDataSource.insertSyncRecord(model);
    return _mapModelToEntity(model);
  }

  @override
  Future<List<domain.SyncRecord>> getPendingSyncRecords() async {
    final models = await localDataSource.getPendingRecords();
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<List<domain.SyncRecord>> getFailedSyncRecords() async {
    final models = await localDataSource.getFailedRecords();
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<domain.SyncRecord> updateSyncRecord(domain.SyncRecord record) async {
    final existing = await localDataSource.getSyncRecordById(record.id);
    if (existing == null) {
      throw const OfflineException.database('Sync record not found');
    }

    final model = SyncRecordModel(
      id: record.id,
      entityId: record.entityId,
      entityType: record.entityType,
      operationType: record.operationType,
      payload: record.payload,
      status: record.status,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
      attempts: record.attempts,
      lastAttemptAt: record.lastAttemptAt,
      errorMessage: record.errorMessage,
      version: existing.version + 1,
    );

    await localDataSource.updateSyncRecord(model);
    return _mapModelToEntity(model);
  }

  @override
  Future<void> markAsCompleted(String recordId) async {
    await localDataSource.updateSyncRecordStatus(recordId, 'completed');
  }

  @override
  Future<void> markAsFailed(String recordId, String errorMessage) async {
    final record = await localDataSource.getSyncRecordById(recordId);
    if (record == null) {
      throw const OfflineException.database('Sync record not found');
    }

    await localDataSource.updateSyncRecordWithError(
      recordId,
      'failed',
      record.attempts + 1,
      DateTime.now().toUtc(),
      errorMessage,
    );
  }

  @override
  Future<void> incrementAttempt(String recordId) async {
    final record = await localDataSource.getSyncRecordById(recordId);
    if (record == null) {
      throw const OfflineException.database('Sync record not found');
    }

    await localDataSource.updateSyncRecordWithError(
      recordId,
      'in_progress',
      record.attempts + 1,
      DateTime.now().toUtc(),
      null,
    );
  }

  @override
  Future<void> deleteSyncRecord(String recordId) async {
    await localDataSource.deleteSyncRecord(recordId);
  }

  @override
  Future<void> clearCompletedRecords() async {
    await localDataSource.deleteCompletedRecords();
  }

  @override
  Future<int> getPendingCount() async {
    final records = await localDataSource.getPendingRecords();
    return records.length;
  }

  @override
  Future<int> getFailedCount() async {
    final records = await localDataSource.getFailedRecords();
    return records.length;
  }

  @override
  Future<List<domain.SyncRecord>> getSyncRecordsByEntityId(String entityId) async {
    final models = await localDataSource.getSyncRecordsByEntityId(entityId);
    return models.map(_mapModelToEntity).toList();
  }

  domain.SyncRecord _mapModelToEntity(SyncRecordModel model) {
    return domain.SyncRecord(
      id: model.id,
      entityId: model.entityId,
      entityType: model.entityType,
      operationType: model.operationType,
      payload: model.payload,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      attempts: model.attempts,
      lastAttemptAt: model.lastAttemptAt,
      errorMessage: model.errorMessage,
    );
  }
}


// === ARCHIVO: lib/presentation/screens/home_screen.dart ===
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:offline_field_app/domain/entities/transaction.dart';
import 'package:offline_field_app/presentation/providers/transaction_provider.dart';
import 'package:offline_field_app/presentation/providers/sync_provider.dart';
import 'package:offline_field_app/presentation/widgets/transaction_tile.dart';
import 'package:offline_field_app/presentation/widgets/connectivity_banner.dart';
import 'package:offline_field_app/presentation/screens/transaction_form_screen.dart';
import 'package:offline_field_app/presentation/screens/sync_status_screen.dart';
import 'package:offline_field_app/core/constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactions();
    });
  }

  Future<void> _loadTransactions() async {
    final transactionProvider = context.read<TransactionProvider>();
    await transactionProvider.loadTransactions();
  }

  Future<void> _refreshTransactions() async {
    await _loadTransactions();
  }

  void _navigateToTransactionForm({Transaction? transaction}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransactionFormScreen(transaction: transaction),
      ),
    );
  }

  void _navigateToSyncStatus() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SyncStatusScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: Color(AppConstants.primaryColor),
        actions: [
          Consumer<SyncProvider>(
            builder: (context, syncProvider, child) {
              final pendingCount = syncProvider.pendingOperations.length;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: _navigateToSyncStatus,
                    tooltip: 'Estado de sincronización',
                  ),
                  if (pendingCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          pendingCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Color(AppConstants.errorColor),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.error!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadTransactions,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final transactions = provider.transactions;

                if (transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay transacciones',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Toca el botón + para crear una',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshTransactions,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionTile(
                        transaction: transaction,
                        onTap: () => _navigateToTransactionForm(transaction: transaction),
                        onDelete: () => _confirmDelete(transaction),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTransactionForm(),
        backgroundColor: Color(AppConstants.primaryColor),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(Transaction transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar la transacción ${transaction.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Color(AppConstants.errorColor),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final provider = context.read<TransactionProvider>();
      await provider.deleteTransaction(transaction.id);
    }
  }
}

// === ARCHIVO: lib/presentation/screens/transaction_form_screen.dart ===
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

// === ARCHIVO: lib/presentation/screens/sync_status_screen.dart ===
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:offline_field_app/domain/entities/sync_record.dart';
import 'package:offline_field_app/presentation/providers/sync_provider.dart';
import 'package:offline_field_app/presentation/widgets/sync_progress_indicator.dart';
import 'package:offline_field_app/core/constants/app_constants.dart';
import 'package:offline_field_app/core/network/network_info.dart';

class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({super.key});

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSyncStatus();
    });
  }

  Future<void> _loadSyncStatus() async {
    final syncProvider = context.read<SyncProvider>();
    await syncProvider.loadPendingOperations();
    await syncProvider.loadConflicts();
  }

  Future<void> _triggerSync() async {
    final syncProvider = context.read<SyncProvider>();
    final networkInfo = context.read<NetworkInfo>();

    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay conexión a internet'),
          backgroundColor: Color(AppConstants.warningColor),
        ),
      );
      return;
    }

    await syncProvider.syncAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de sincronización'),
        backgroundColor: Color(AppConstants.primaryColor),
      ),
      body: Consumer<SyncProvider>(
        builder: (context, provider, child) {
          if (provider.isSyncing) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SyncProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Sincronizando...'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadSyncStatus,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSyncSummaryCard(provider),
                const SizedBox(height: 16),
                _buildPendingOperationsSection(provider),
                const SizedBox(height: 16),
                _buildConflictsSection(provider),
                const SizedBox(height: 24),
                _buildSyncButton(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSyncSummaryCard(SyncProvider provider) {
    final pendingCount = provider.pendingOperations.length;
    final conflictCount = provider.conflicts.length;
    final lastSync = provider.lastSyncTime;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sync,
                  color: Color(AppConstants.primaryColor),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Resumen de sincronización',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              Icons.pending_actions,
              'Operaciones pendientes',
              pendingCount.toString(),
              pendingCount > 0 ? Color(AppConstants.warningColor) : Color(AppConstants.successColor),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              Icons.warning_amber,
              'Conflictos pendientes',
              conflictCount.toString(),
              conflictCount > 0 ? Color(AppConstants.errorColor) : Color(AppConstants.successColor),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              Icons.access_time,
              'Última sincronización',
              lastSync != null
                  ? '${lastSync.day}/${lastSync.month}/${lastSync.year} ${lastSync.hour}:${lastSync.minute.toString().padLeft(2, '0')}'
                  : 'Nunca',
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildPendingOperationsSection(SyncProvider provider) {
    final operations = provider.pendingOperations;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.pending_outlined,
                  color: Color(AppConstants.warningColor),
                ),
                const SizedBox(width: 8),
                Text(
                  'Operaciones pendientes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Divider(),
            if (operations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text('No hay operaciones pendientes'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: operations.length > 5 ? 5 : operations.length,
                itemBuilder: (context, index) {
                  final operation = operations[index];
                  return _buildOperationTile(operation);
                },
              ),
            if (operations.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'y ${operations.length - 5} más...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationTile(SyncRecord operation) {
    final statusColor = _getStatusColor(operation.syncStatus);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getOperationIcon(operation.operationType),
          color: statusColor,
        ),
      ),
      title: Text(
        operation.entityType ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'ID: ${operation.entityId}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Chip(
        label: Text(
          operation.syncStatus,
          style: const TextStyle(fontSize: 10),
        ),
        backgroundColor: statusColor.withOpacity(0.2),
      ),
    );
  }

  Widget _buildConflictsSection(SyncProvider provider) {
    final conflicts = provider.conflicts;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Color(AppConstants.errorColor),
                ),
                const SizedBox(width: 8),
                Text(
                  'Conflictos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Divider(),
            if (conflicts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text('No hay conflictos'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: conflicts.length,
                itemBuilder: (context, index) {
                  final conflict = conflicts[index];
                  return _buildConflictTile(conflict, provider);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConflictTile(SyncRecord conflict, SyncProvider provider) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(AppConstants.errorColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.warning,
          color: Color(AppConstants.errorColor),
        ),
      ),
      title: Text(
        conflict.entityType ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'ID: ${conflict.entityId}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () => _resolveConflict(conflict, 'server'),
            tooltip: 'Usar versión del servidor',
          ),
          IconButton(
            icon: const Icon(Icons.restore, color: Colors.blue),
            onPressed: () => _resolveConflict(conflict, 'client'),
            tooltip: 'Mantener versión local',
          ),
        ],
      ),
    );
  }

  Future<void> _resolveConflict(SyncRecord conflict, String resolution) async {
    final provider = context.read<SyncProvider>();
    await provider.resolveConflict(conflict.entityId, resolution);
    await _loadSyncStatus();
  }

  Widget _buildSyncButton(SyncProvider provider) {
    return ElevatedButton.icon(
      onPressed: provider.isSyncing ? null : _triggerSync,
      icon: const Icon(Icons.sync),
      label: const Text('Sincronizar ahora'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.syncStatusPending:
        return Color(AppConstants.warningColor);
      case AppConstants.syncStatusInProgress:
        return Colors.blue;
      case AppConstants.syncStatusCompleted:
        return Color(AppConstants.successColor);
      case AppConstants.syncStatusFailed:
        return Color(AppConstants.errorColor);
      case AppConstants.syncStatusConflict:
        return Color(AppConstants.errorColor);
      default:
        return Colors.grey;
    }
  }

  IconData _getOperationIcon(String? operationType) {
    switch (operationType) {
      case 'create':
        return Icons.add_circle;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      default:
        return Icons.help_outline;
    }
  }
}


// === ARCHIVO: lib/presentation/widgets/transaction_tile.dart ===
package presentation.widgets;

import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';
import '../../core/constants/app_constants.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onSyncTap;
  final bool showSyncStatus;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.onSyncTap,
    this.showSyncStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = transaction.syncStatus == AppConstants.syncStatusPending;
    final isFailed = transaction.syncStatus == AppConstants.syncStatusFailed;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isFailed 
            ? BorderSide(color: theme.colorScheme.error, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTransactionType(context),
                  _buildAmount(context),
                ],
              ),
              const SizedBox(height: 12),
              if (transaction.description != null && 
                  transaction.description!.isNotEmpty)
                Text(
                  transaction.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimestamp(context),
                  if (showSyncStatus) _buildSyncStatus(context),
                ],
              ),
              if (isPending && onSyncTap != null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onSyncTap,
                    icon: const Icon(Icons.sync, size: 18),
                    label: const Text('Sincronizar ahora'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionType(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = transaction.transactionType.toUpperCase() == 'CREDIT' ||
        transaction.transactionType.toUpperCase() == 'DEPOSIT';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCredit 
            ? Colors.green.shade50 
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            size: 16,
            color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            transaction.transactionType.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmount(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = transaction.transactionType.toUpperCase() == 'CREDIT' ||
        transaction.transactionType.toUpperCase() == 'DEPOSIT';
    final formattedAmount = AppConstants.formatAmount(
      transaction.amount, 
      transaction.currency,
    );
    
    return Text(
      '${isCredit ? '+' : '-'}$formattedAmount',
      style: theme.textTheme.titleLarge?.copyWith(
        color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    final theme = Theme.of(context);
    final createdAt = transaction.createdAt;
    final formattedDate = '${createdAt.day.toString().padLeft(2, '0')}/'
        '${createdAt.month.toString().padLeft(2, '0')}/'
        '${createdAt.year} '
        '${createdAt.hour.toString().padLeft(2, '0')}:'
        '${createdAt.minute.toString().padLeft(2, '0')}';
    
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(width: 4),
        Text(
          formattedDate,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildSyncStatus(BuildContext context) {
    final theme = Theme.of(context);
    IconData icon;
    Color color;
    String label;
    
    switch (transaction.syncStatus) {
      case AppConstants.syncStatusPending:
        icon = Icons.cloud_queue;
        color = Colors.orange;
        label = 'Pendiente';
        break;
      case AppConstants.syncStatusInProgress:
        icon = Icons.cloud_sync;
        color = Colors.blue;
        label = 'Sincronizando';
        break;
      case AppConstants.syncStatusCompleted:
        icon = Icons.cloud_done;
        color = Colors.green;
        label = 'Sincronizado';
        break;
      case AppConstants.syncStatusFailed:
        icon = Icons.cloud_off;
        color = Colors.red;
        label = 'Fallido';
        break;
      case AppConstants.syncStatusConflict:
        icon = Icons.warning_amber;
        color = Colors.amber;
        label = 'Conflicto';
        break;
      default:
        icon = Icons.cloud_queue;
        color = Colors.grey;
        label = 'Desconocido';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// === ARCHIVO: lib/presentation/widgets/connectivity_banner.dart ===
package presentation.widgets;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/app_constants.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget? child;
  final bool showBanner;
  final Duration animationDuration;

  const ConnectivityBanner({
    super.key,
    this.child,
    this.showBanner = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  StreamSubscription? _connectivitySubscription;
  NetworkStatus _currentStatus = NetworkStatus.connected;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    final networkInfo = context.read<NetworkInfo>();
    _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
      (status) {
        setState(() {
          _currentStatus = status;
          _isVisible = status == NetworkStatus.disconnected ||
              status == NetworkStatus.connecting;
        });
      },
      onError: (error) {
        debugPrint('Error en listener de conectividad: $error');
      },
    );
    
    networkInfo.checkConnectivity().then((_) {
      if (mounted) {
        setState(() {
          _isVisible = _currentStatus == NetworkStatus.disconnected ||
              _currentStatus == NetworkStatus.connecting;
        });
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSlide(
          duration: widget.animationDuration,
          curve: Curves.easeInOut,
          offset: _isVisible && widget.showBanner 
              ? Offset.zero 
              : const Offset(0, -1),
          child: AnimatedOpacity(
            duration: widget.animationDuration,
            opacity: _isVisible && widget.showBanner ? 1.0 : 0.0,
            child: _buildBanner(context),
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    final theme = Theme.of(context);
    final isConnecting = _currentStatus == NetworkStatus.connecting;
    final isDisconnected = _currentStatus == NetworkStatus.disconnected;
    
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String message;
    
    if (isConnecting) {
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
      icon = Icons.wifi_find;
      message = 'Conectando...';
    } else if (isDisconnected) {
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
      icon = Icons.wifi_off;
      message = 'Sin conexión - Modo offline';
    } else {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
      icon = Icons.wifi;
      message = 'Conectado';
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (isConnecting)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            else
              Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isDisconnected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'OFFLINE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// === ARCHIVO: lib/presentation/widgets/sync_progress_indicator.dart ===
package presentation.widgets;

import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

enum SyncIndicatorStyle {
  compact,
  expanded,
  circular,
  linear,
}

class SyncProgressIndicator extends StatelessWidget {
  final int totalItems;
  final int processedItems;
  final int failedItems;
  final String? currentOperation;
  final SyncIndicatorStyle style;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final bool showDetails;

  const SyncProgressIndicator({
    super.key,
    required this.totalItems,
    required this.processedItems,
    this.failedItems = 0,
    this.currentOperation,
    this.style = SyncIndicatorStyle.expanded,
    this.onCancel,
    this.onRetry,
    this.showDetails = true,
  });

  double get progress => totalItems > 0 ? processedItems / totalItems : 0.0;
  bool get isComplete => processedItems >= totalItems;
  bool get hasFailures => failedItems > 0;
  
  @override
  Widget build(BuildContext context) {
    switch (style) {
      case SyncIndicatorStyle.compact:
        return _buildCompactIndicator(context);
      case SyncIndicatorStyle.expanded:
        return _buildExpandedIndicator(context);
      case SyncIndicatorStyle.circular:
        return _buildCircularIndicator(context);
      case SyncIndicatorStyle.linear:
        return _buildLinearIndicator(context);
    }
  }

  Widget _buildCompactIndicator(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: hasFailures 
            ? Colors.orange.shade50 
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasFailures 
              ? Colors.orange.shade200 
              : Colors.blue.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isComplete)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  hasFailures ? Colors.orange : Colors.blue,
                ),
              ),
            )
          else
            Icon(
              hasFailures ? Icons.warning_amber : Icons.check_circle,
              size: 16,
              color: hasFailures ? Colors.orange : Colors.green,
            ),
          const SizedBox(width: 8),
          Text(
            '$processedItems/$totalItems',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: hasFailures 
                  ? Colors.orange.shade700 
                  : Colors.blue.shade700,
            ),
          ),
          if (hasFailures) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.error_outline,
              size: 14,
              color: Colors.orange.shade700,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedIndicator(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isComplete 
                      ? (hasFailures ? Icons.sync_problem : Icons.sync)
                      : Icons.sync,
                  color: hasFailures 
                      ? Colors.orange 
                      : Colors.blue,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isComplete 
                            ? (hasFailures 
                                ? 'Sincronización completada con errores'
                                : 'Sincronización completada')
                            : 'Sincronizando...',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentOperation != null && showDetails)
                        Text(
                          currentOperation!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: hasFailures 
                        ? Colors.orange 
                        : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  hasFailures ? Colors.orange : Colors.blue,
                ),
              ),
            ),
            if (showDetails) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    Icons.check_circle_outline,
                    'Procesados',
                    processedItems.toString(),
                    Colors.green,
                  ),
                  _buildStatItem(
                    context,
                    Icons.pending_outlined,
                    'Pendientes',
                    (totalItems - processedItems).toString(),
                    Colors.grey,
                  ),
                  _buildStatItem(
                    context,
                    Icons.error_outline,
                    'Fallidos',
                    failedItems.toString(),
                    Colors.red,
                  ),
                ],
              ),
            ],
            if (!isComplete && onCancel != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: const Text('Cancelar sincronización'),
                ),
              ),
            ],
            if (isComplete && hasFailures && onRetry != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar sincronización'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularIndicator(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              hasFailures ? Colors.orange : Colors.blue,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isComplete)
                Icon(
                  hasFailures ? Icons.warning_amber : Icons.check,
                  color: hasFailures ? Colors.orange : Colors.green,
                  size: 20,
                )
              else
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinearIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentOperation ?? 'Sincronizando...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '$processedItems/$totalItems',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              hasFailures ? Colors.orange : Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}


// === ARCHIVO: lib/presentation/providers/transaction_provider.dart ===
package offline_field_app.presentation.providers;

import 'package:flutter/foundation.dart';
import 'package:offline_field_app/domain/entities/transaction.dart';
import 'package:offline_field_app/domain/repositories/transaction_repository.dart';
import 'package:offline_field_app/domain/usecases/create_transaction.dart';
import 'package:offline_field_app/domain/usecases/get_pending_transactions.dart';
import 'package:offline_field_app/core/errors/failures.dart';
import 'package:offline_field_app/core/errors/exceptions.dart';

enum TransactionListState { initial, loading, loaded, error }
enum TransactionCreateState { initial, creating, success, error }

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;
  final CreateTransaction _createTransactionUseCase;
  final GetPendingTransactions _getPendingTransactionsUseCase;

  TransactionProvider({
    required TransactionRepository repository,
    required CreateTransaction createTransactionUseCase,
    required GetPendingTransactions getPendingTransactionsUseCase,
  })  : _repository = repository,
        _createTransactionUseCase = createTransactionUseCase,
        _getPendingTransactionsUseCase = getPendingTransactionsUseCase;

  TransactionListState _listState = TransactionListState.initial;
  TransactionCreateState _createState = TransactionCreateState.initial;
  List<Transaction> _transactions = [];
  Transaction? _selectedTransaction;
  Failure? _lastFailure;
  String? _successMessage;

  TransactionListState get listState => _listState;
  TransactionCreateState get createState => _createState;
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  Transaction? get selectedTransaction => _selectedTransaction;
  Failure? get lastFailure => _lastFailure;
  String? get successMessage => _successMessage;
  bool get isLoading => _listState == TransactionListState.loading;
  bool get isCreating => _createState == TransactionCreateState.creating;
  int get pendingCount => _transactions.where((t) => t.syncStatus == 'pending').length;
  int get failedCount => _transactions.where((t) => t.syncStatus == 'failed').length;

  Future<void> loadTransactions() async {
    _listState = TransactionListState.loading;
    _lastFailure = null;
    notifyListeners();

    try {
      final result = await _repository.getAllTransactions();
      result.fold(
        (failure) {
          _lastFailure = failure;
          _listState = TransactionListState.error;
        },
        (transactions) {
          _transactions = transactions;
          _listState = TransactionListState.loaded;
        },
      );
    } catch (e) {
      _lastFailure = const OfflineFailure.database('Failed to load transactions');
      _listState = TransactionListState.error;
    }
    notifyListeners();
  }

  Future<void> loadPendingTransactions() async {
    _listState = TransactionListState.loading;
    _lastFailure = null;
    notifyListeners();

    try {
      final result = await _getPendingTransactionsUseCase();
      result.fold(
        (failure) {
          _lastFailure = failure;
          _listState = TransactionListState.error;
        },
        (transactions) {
          _transactions = transactions;
          _listState = TransactionListState.loaded;
        },
      );
    } catch (e) {
      _lastFailure = const OfflineFailure.database('Failed to load pending transactions');
      _listState = TransactionListState.error;
    }
    notifyListeners();
  }

  Future<bool> createTransaction({
    required double amount,
    required String currency,
    required String transactionType,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    _createState = TransactionCreateState.creating;
    _lastFailure = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await _createTransactionUseCase(
        amount: amount,
        currency: currency,
        transactionType: transactionType,
        description: description,
        metadata: metadata,
      );

      return result.fold(
        (failure) {
          _lastFailure = failure;
          _createState = TransactionCreateState.error;
          notifyListeners();
          return false;
        },
        (transaction) {
          _transactions.insert(0, transaction);
          _createState = TransactionCreateState.success;
          _successMessage = 'Transaction created successfully';
          notifyListeners();
          return true;
        },
      );
    } on ValidationException catch (e) {
      _lastFailure = ValidationFailure(e.fieldErrors);
      _createState = TransactionCreateState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _lastFailure = DatabaseFailure.transactionFailed(e.toString());
      _createState = TransactionCreateState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTransaction(Transaction transaction) async {
    _listState = TransactionListState.loading;
    _lastFailure = null;
    notifyListeners();

    try {
      final result = await _repository.updateTransaction(transaction);
      return result.fold(
        (failure) {
          _lastFailure = failure;
          _listState = TransactionListState.error;
          notifyListeners();
          return false;
        },
        (updated) {
          final index = _transactions.indexWhere((t) => t.id == updated.id);
          if (index != -1) {
            _transactions[index] = updated;
          }
          _listState = TransactionListState.loaded;
          _successMessage = 'Transaction updated successfully';
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _lastFailure = DatabaseFailure.transactionFailed(e.toString());
      _listState = TransactionListState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    _listState = TransactionListState.loading;
    _lastFailure = null;
    notifyListeners();

    try {
      final result = await _repository.deleteTransaction(id);
      return result.fold(
        (failure) {
          _lastFailure = failure;
          _listState = TransactionListState.error;
          notifyListeners();
          return false;
        },
        (_) {
          _transactions.removeWhere((t) => t.id == id);
          _listState = TransactionListState.loaded;
          _successMessage = 'Transaction deleted successfully';
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _lastFailure = DatabaseFailure.transactionFailed(e.toString());
      _listState = TransactionListState.error;
      notifyListeners();
      return false;
    }
  }

  void selectTransaction(Transaction? transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }

  Future<void> retryFailedTransaction(String id) async {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      final transaction = _transactions[index];
      final updated = Transaction(
        id: transaction.id,
        externalId: transaction.externalId,
        amount: transaction.amount,
        currency: transaction.currency,
        transactionType: transaction.transactionType,
        description: transaction.description,
        metadata: transaction.metadata,
        createdAt: transaction.createdAt,
        updatedAt: DateTime.now(),
        version: transaction.version,
        syncStatus: 'pending',
        hash: transaction.hash,
      );
      await updateTransaction(updated);
    }
  }

  void clearMessages() {
    _lastFailure = null;
    _successMessage = null;
    notifyListeners();
  }

  void reset() {
    _listState = TransactionListState.initial;
    _createState = TransactionCreateState.initial;
    _transactions = [];
    _selectedTransaction = null;
    _lastFailure = null;
    _successMessage = null;
    notifyListeners();
  }
}

// === ARCHIVO: lib/presentation/providers/sync_provider.dart ===
package offline_field_app.presentation.providers;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:offline_field_app/core/network/network_info.dart';
import 'package:offline_field_app/domain/repositories/sync_repository.dart';
import 'package:offline_field_app/domain/entities/sync_record.dart';
import 'package:offline_field_app/domain/usecases/sync_transactions.dart';
import 'package:offline_field_app/domain/usecases/resolve_conflict.dart';
import 'package:offline_field_app/core/errors/failures.dart';
import 'package:offline_field_app/core/errors/exceptions.dart';

enum SyncState { idle, checking, syncing, completed, error }
enum ConflictResolutionState { none, detecting, resolved, manualRequired }

class SyncProvider extends ChangeNotifier {
  final SyncRepository _syncRepository;
  final SyncTransactions _syncTransactionsUseCase;
  final ResolveConflict _resolveConflictUseCase;
  final NetworkInfo _networkInfo;

  SyncProvider({
    required SyncRepository syncRepository,
    required SyncTransactions syncTransactionsUseCase,
    required ResolveConflict resolveConflictUseCase,
    required NetworkInfo networkInfo,
  })  : _syncRepository = syncRepository,
        _syncTransactionsUseCase = syncTransactionsUseCase,
        _resolveConflictUseCase = resolveConflictUseCase,
        _networkInfo = networkInfo {
    _initConnectivityListener();
  }

  SyncState _syncState = SyncState.idle;
  ConflictResolutionState _conflictState = ConflictResolutionState.none;
  NetworkStatus _networkStatus = NetworkStatus.disconnected;
  List<SyncRecord> _syncHistory = [];
  SyncRecord? _lastSyncRecord;
  Failure? _lastFailure;
  String? _successMessage;
  double _syncProgress = 0.0;
  int _totalItems = 0;
  int _processedItems = 0;
  Map<String, dynamic>? _currentConflict;
  StreamSubscription<NetworkStatus>? _connectivitySubscription;
  Timer? _autoSyncTimer;
  bool _autoSyncEnabled = false;

  SyncState get syncState => _syncState;
  ConflictResolutionState get conflictState => _conflictState;
  NetworkStatus get networkStatus => _networkStatus;
  List<SyncRecord> get syncHistory => List.unmodifiable(_syncHistory);
  SyncRecord? get lastSyncRecord => _lastSyncRecord;
  Failure? get lastFailure => _lastFailure;
  String? get successMessage => _successMessage;
  double get syncProgress => _syncProgress;
  int get totalItems => _totalItems;
  int get processedItems => _processedItems;
  Map<String, dynamic>? get currentConflict => _currentConflict;
  bool get isOnline => _networkStatus == NetworkStatus.connected;
  bool get isSyncing => _syncState == SyncState.syncing;
  bool get autoSyncEnabled => _autoSyncEnabled;
  bool get hasConflicts => _conflictState == ConflictResolutionState.detecting ||
                           _conflictState == ConflictResolutionState.manualRequired;

  void _initConnectivityListener() {
    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen(
      (status) {
        final previousStatus = _networkStatus;
        _networkStatus = status;
        notifyListeners();
        if (previousStatus == NetworkStatus.disconnected &&
            status == NetworkStatus.connected) {
          if (_autoSyncEnabled) {
            syncPendingTransactions();
          }
        }
      },
    );
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    await _networkInfo.checkConnectivity();
    _networkStatus = _networkInfo.isConnected ? NetworkStatus.connected : NetworkStatus.disconnected;
    notifyListeners();
  }

  Future<void> loadSyncHistory() async {
    try {
      final result = await _syncRepository.getSyncHistory();
      result.fold(
        (failure) {
          _lastFailure = failure;
        },
        (records) {
          _syncHistory = records;
          if (records.isNotEmpty) {
            _lastSyncRecord = records.first;
          }
        },
      );
    } catch (e) {
      _lastFailure = OfflineFailure.database('Failed to load sync history');
    }
    notifyListeners();
  }

  Future<bool> syncPendingTransactions() async {
    if (_syncState == SyncState.syncing) {
      return false;
    }

    if (!isOnline) {
      _lastFailure = const OfflineFailure.networkUnavailable();
      notifyListeners();
      return false;
    }

    _syncState = SyncState.syncing;
    _lastFailure = null;
    _successMessage = null;
    _syncProgress = 0.0;
    _processedItems = 0;
    notifyListeners();

    try {
      final result = await _syncTransactionsUseCase();
      return result.fold(
        (failure) {
          _handleSyncFailure(failure);
          return false;
        },
        (syncResult) async {
          _totalItems = syncResult['total'] ?? 0;
          _processedItems = syncResult['processed'] ?? 0;
          _syncProgress = _totalItems > 0 ? _processedItems / _totalItems : 1.0;

          if (syncResult['conflicts'] != null && (syncResult['conflicts'] as List).isNotEmpty) {
            _conflictState = ConflictResolutionState.detecting;
            _currentConflict = syncResult['conflicts'].first as Map<String, dynamic>;
          } else {
            _conflictState = ConflictResolutionState.resolved;
            _currentConflict = null;
          }

          await _saveSyncRecord(syncResult);
          _syncState = SyncState.completed;
          _successMessage = 'Sync completed: $_processedItems of $_totalItems items';
          notifyListeners();
          return true;
        },
      );
    } on SyncConflictException catch (e) {
      _conflictState = ConflictResolutionState.manualRequired;
      _currentConflict = e.toConflictData();
      _syncState = SyncState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _lastFailure = SyncFailure.serverError(e.toString());
      _syncState = SyncState.error;
      notifyListeners();
      return false;
    }
  }

  void _handleSyncFailure(Failure failure) {
    _syncState = SyncState.error;
    _lastFailure = failure;
    if (failure is SyncFailure) {
      if (failure.code == 'timeout') {
        _lastFailure = SyncFailure.timeout();
      } else if (failure.code == 'unauthorized') {
        _lastFailure = SyncFailure.unauthorized();
      }
    }
    notifyListeners();
  }

  Future<void> _saveSyncRecord(Map<String, dynamic> syncResult) async {
    final record = SyncRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      syncStatus: syncResult['success'] == true ? 'completed' : 'failed',
      recordsProcessed: syncResult['processed'] ?? 0,
      recordsFailed: syncResult['failed'] ?? 0,
      conflictsDetected: (syncResult['conflicts'] as List?)?.length ?? 0,
      startedAt: DateTime.now().subtract(const Duration(seconds: 30)),
      completedAt: DateTime.now(),
      errorDetails: _lastFailure?.message,
    );

    final result = await _syncRepository.saveSyncRecord(record);
    result.fold(
      (failure) {},
      (_) {
        _syncHistory.insert(0, record);
        _lastSyncRecord = record;
      },
    );
  }

  Future<bool> resolveConflict({
    required String entityId,
    required String resolution,
    Map<String, dynamic>? resolvedData,
  }) async {
    if (_currentConflict == null) {
      return false;
    }

    _conflictState = ConflictResolutionState.detecting;
    notifyListeners();

    try {
      final result = await _resolveConflictUseCase(
        entityId: entityId,
        resolution: resolution,
        resolvedData: resolvedData,
      );

      return result.fold(
        (failure) {
          _lastFailure = failure;
          _conflictState = ConflictResolutionState.manualRequired;
          notifyListeners();
          return false;
        },
        (_) {
          _conflictState = ConflictResolutionState.resolved;
          _currentConflict = null;
          _successMessage = 'Conflict resolved successfully';
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _lastFailure = SyncFailure.serverError(e.toString());
      _conflictState = ConflictResolutionState.manualRequired;
      notifyListeners();
      return false;
    }
  }

  void enableAutoSync({Duration interval = const Duration(minutes: 5)}) {
    _autoSyncEnabled = true;
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(interval, (_) {
      if (isOnline) {
        syncPendingTransactions();
      }
    });
    notifyListeners();
  }

  void disableAutoSync() {
    _autoSyncEnabled = false;
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
    notifyListeners();
  }

  Future<void> checkAndSync() async {
    if (!isOnline) {
      return;
    }

    _syncState = SyncState.checking;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final hasPending = await _checkPendingItems();
    if (hasPending) {
      await syncPendingTransactions();
    } else {
      _syncState = SyncState.idle;
      notifyListeners();
    }
  }

  Future<bool> _checkPendingItems() async {
    try {
      final result = await _syncRepository.getPendingOperationsCount();
      return result.fold(
        (_) => false,
        (count) => count > 0,
      );
    } catch (e) {
      return false;
    }
  }

  void clearConflict() {
    _currentConflict = null;
    _conflictState = ConflictResolutionState.none;
    notifyListeners();
  }

  void clearMessages() {
    _lastFailure = null;
    _successMessage = null;
    notifyListeners();
  }

  void reset() {
    _syncState = SyncState.idle;
    _conflictState = ConflictResolutionState.none;
    _syncHistory = [];
    _lastSyncRecord = null;
    _lastFailure = null;
    _successMessage = null;
    _syncProgress = 0.0;
    _totalItems = 0;
    _processedItems = 0;
    _currentConflict = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _autoSyncTimer?.cancel();
    super.dispose();
  }
}

// === ARCHIVO: lib/domain/repositories/transaction_repository.dart ===
library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/sync_record.dart';

abstract class TransactionRepository {
  Future<Transaction> createTransaction(Transaction transaction);
  Future<Transaction> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
  Future<Transaction?> getTransactionById(String id);
  Future<Transaction?> getTransactionByExternalId(String externalId);
  Future<Transaction?> getTransactionByHash(String operationHash);
  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getTransactionsBySyncStatus(String syncStatus);
  Future<List<Transaction>> getTransactionsByType(String transactionType);
  Future<List<Transaction>> getTransactionsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<Transaction>> getPendingTransactions({int? limit, int? offset, String? transactionType, DateTime? fromDate, DateTime? toDate});
  Future<int> getTransactionCount();
  Future<int> getTransactionCountBySyncStatus(String syncStatus);
  Future<int> getPendingCount();
  Future<void> updateSyncStatus(String id, String syncStatus, {String? externalId});
  Future<void> updateSyncStatusBatch(List<String> ids, String syncStatus, {String? externalId});
  Stream<List<Transaction>> watchAllTransactions();
  Stream<List<Transaction>> watchTransactionsBySyncStatus(String syncStatus);
  Future<void> markAsSynced(String id, String externalId, int version);
  Future<void> markAsFailed(String id, String errorDetails);
  Future<List<Transaction>> getUnsyncedTransactions();
  Future<Map<String, dynamic>> exportTransactions(String startDate, String endDate);
  Future<void> importTransactions(Map<String, dynamic> data);
  Future<Transaction?> findByIdempotencyKey(String idempotencyKey);
  Future<void> incrementVersion(String id);
  Future<List<SyncRecord>> getSyncRecordsForEntity(String entityId);
  Future<Map<String, dynamic>?> syncTransaction(Transaction transaction);
  Future<void> resolveConflict(String entityId, Map<String, dynamic> serverData, String resolution);
  Future<void> forceSync(Transaction transaction);
  Future<List<Transaction>> getServerTransactions();
  Future<Transaction?> getByExternalId(String externalId);
  Future<Transaction?> create(Transaction transaction);
  Future<Transaction?> update(Transaction transaction);
  Future<Transaction?> getServerTransactionById(String entityId);
  Future<List<Transaction>> getPendingWithConflicts();
}

class TransactionFilter extends Equatable {
  final String? syncStatus;
  final String? transactionType;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;
  final String? currency;
  final bool? isDeleted;

  const TransactionFilter({
    this.syncStatus,
    this.transactionType,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.currency,
    this.isDeleted,
  });

  TransactionFilter copyWith({
    String? syncStatus,
    String? transactionType,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    String? currency,
    bool? isDeleted,
  }) {
    return TransactionFilter(
      syncStatus: syncStatus ?? this.syncStatus,
      transactionType: transactionType ?? this.transactionType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      currency: currency ?? this.currency,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        syncStatus,
        transactionType,
        startDate,
        endDate,
        minAmount,
        maxAmount,
        currency,
        isDeleted,
      ];
}

class TransactionResult extends Equatable {
  final Transaction transaction;
  final bool isNew;
  final bool wasSynced;

  const TransactionResult({
    required this.transaction,
    required this.isNew,
    required this.wasSynced,
  });

  @override
  List<Object?> get props => [transaction, isNew, wasSynced];
}

// === ARCHIVO: lib/domain/repositories/sync_repository.dart ===
library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/sync_record.dart';

abstract class SyncRepository {
  Future<SyncRecord> createSyncRecord(SyncRecord record);
  Future<SyncRecord> updateSyncRecord(SyncRecord record);
  Future<void> deleteSyncRecord(String id);
  Future<SyncRecord?> getSyncRecordById(String id);
  Future<List<SyncRecord>> getAllSyncRecords();
  Future<List<SyncRecord>> getSyncRecordsByStatus(String status);
  Future<List<SyncRecord>> getPendingSyncRecords();
  Future<List<SyncRecord>> getFailedSyncRecords();
  Future<List<SyncRecord>> getCompletedSyncRecords();
  Future<void> markAsPending(String id);
  Future<void> markAsInProgress(String id);
  Future<void> markAsCompleted(String id, {String? externalId});
  Future<void> markAsFailed(String id, String errorDetails);
  Future<void> markAsConflict(String id, String conflictData);
  Future<int> getPendingCount();
  Future<int> getFailedCount();
  Future<int> getCompletedCount();
  Future<void> clearCompletedRecords({DateTime? before});
  Future<void> clearFailedRecords({DateTime? before});
  Future<void> retryFailedRecords();
  Future<void> cancelPendingSync();
  Stream<List<SyncRecord>> watchSyncRecords();
  Stream<List<SyncRecord>> watchPendingSyncRecords();
  Future<Map<String, dynamic>> getSyncStatistics();
  Future<void> updateRetryCount(String id);
  Future<int> getRetryCount(String id);
  Future<void> scheduleSync(String entityType, String entityId, String operationType);
  Future<List<SyncRecord>> getSyncRecordsForEntity(String entityType, String entityId);
  Future<void> removeSyncRecordsForEntity(String entityType, String entityId);
  Future<void> updateConflictResolution(String id, String resolution, String resolvedData);
  Future<SyncRecord?> getLatestSyncRecordForEntity(String entityType, String entityId);
  Future<List<SyncRecord>> getSyncRecordsByOperationType(String operationType);
  Future<void> bulkUpdateStatus(List<String> ids, String status);
  Future<List<SyncRecord>> getConflictedRecords();
  Future<void> resolveConflict(String id, String resolution, String resolvedData);
  Future<void> cancelSync(String id);
  Future<void> pauseSync(String id);
  Future<void> resumeSync(String id);
  Future<void> prioritizeSync(String id);
  Future<void> deprioritizeSync(String id);
  Future<SyncRecord> saveSyncRecord(SyncRecord record);
}

class SyncBatchResult extends Equatable {
  final int totalRequested;
  final int successfullySynced;
  final int failed;
  final int pending;
  final Duration elapsedTime;
  final List<String> failedIds;
  final List<String> pendingIds;

  const SyncBatchResult({
    required this.totalRequested,
    required this.successfullySynced,
    required this.failed,
    required this.pending,
    required this.elapsedTime,
    this.failedIds = const [],
    this.pendingIds = const [],
  });

  bool get isFullySuccessful => failed == 0 && pending == 0;
  bool get hasFailures => failed > 0;
  bool get hasPending => pending > 0;
  double get successRate => totalRequested > 0 ? successfullySynced / totalRequested : 0.0;

  @override
  List<Object?> get props => [
        totalRequested,
        successfullySynced,
        failed,
        pending,
        elapsedTime,
        failedIds,
        pendingIds,
      ];
}

class SyncConfiguration extends Equatable {
  final int maxRetries;
  final int retryDelaySeconds;
  final int batchSize;
  final bool autoSync;
  final bool syncOnWifiOnly;
  final bool syncOnCharging;
  final String conflictStrategy;
  final Duration syncInterval;
  final Duration maxSyncDuration;

  const SyncConfiguration({
    this.maxRetries = 3,
    this.retryDelaySeconds = 5,
    this.batchSize = 50,
    this.autoSync = true,
    this.syncOnWifiOnly = false,
    this.syncOnCharging = false,
    this.conflictStrategy = 'last_write_wins',
    this.syncInterval = const Duration(minutes: 15),
    this.maxSyncDuration = const Duration(minutes: 5),
  });

  SyncConfiguration copyWith({
    int? maxRetries,
    int? retryDelaySeconds,
    int? batchSize,
    bool? autoSync,
    bool? syncOnWifiOnly,
    bool? syncOnCharging,
    String? conflictStrategy,
    Duration? syncInterval,
    Duration? maxSyncDuration,
  }) {
    return SyncConfiguration(
      maxRetries: maxRetries ?? this.maxRetries,
      retryDelaySeconds: retryDelaySeconds ?? this.retryDelaySeconds,
      batchSize: batchSize ?? this.batchSize,
      autoSync: autoSync ?? this.autoSync,
      syncOnWifiOnly: syncOnWifiOnly ?? this.syncOnWifiOnly,
      syncOnCharging: syncOnCharging ?? this.syncOnCharging,
      conflictStrategy: conflictStrategy ?? this.conflictStrategy,
      syncInterval: syncInterval ?? this.syncInterval,
      maxSyncDuration: maxSyncDuration ?? this.maxSyncDuration,
    );
  }

  @override
  List<Object?> get props => [
        maxRetries,
        retryDelaySeconds,
        batchSize,
        autoSync,
        syncOnWifiOnly,
        syncOnCharging,
        conflictStrategy,
        syncInterval,
        maxSyncDuration,
      ];
}

```
