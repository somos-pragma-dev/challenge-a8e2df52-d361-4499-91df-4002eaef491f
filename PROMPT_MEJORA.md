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

- `lib/presentation/widgets/task_card.dart`

### Referencias colgando en el codigo que si esta

Cada una rompe la compilacion:

- `lib/domain/usecases/sync_tasks.dart` — `SyncRepository.recordSyncOperation`: Se invoca `recordSyncOperation` sobre `SyncRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/sync_tasks.dart` — `TaskRepository.syncTask`: Se invoca `syncTask` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/sync_tasks.dart` — `TaskRepository.markTaskAsConflict`: Se invoca `markTaskAsConflict` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/sync_tasks.dart` — `TaskRepository.resolveConflict`: Se invoca `resolveConflict` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/resolve_conflict.dart` — `TaskRepository.updateTask`: Se invoca `updateTask` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/resolve_conflict.dart` — `TaskRepository.getServerTaskById`: Se invoca `getServerTaskById` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/resolve_conflict.dart` — `TaskRepository.getConflictingTasks`: Se invoca `getConflictingTasks` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.cacheTasks`: Se invoca `cacheTasks` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.getTasks`: Se invoca `getTasks` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.cacheTask`: Se invoca `cacheTask` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.getPendingTasks`: Se invoca `getPendingTasks` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.searchTasks`: Se invoca `searchTasks` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.getTasksByStatus`: Se invoca `getTasksByStatus` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.getTasksByPriority`: Se invoca `getTasksByPriority` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.

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
- Seniority: junior-l3
- Tipo: practical
- Título: Implementación de una arquitectura offline-first en una aplicación de campo
- Tiempo estimado: 2 semanas

### Fases (trabajo del HUMANO — PROHIBIDO completarlas)
No implementes estos entregables. Dejalos como hueco pedagógico. El asistente solo materializa el proyecto arrancable para que el participante pueda trabajar.
- Fase 1: Diseño de la arquitectura offline-first — objetivo: Definir la estructura de la aplicación que permita el funcionamiento sin conexión y la sincronización de datos al recuperar la conexión. — entregable (NO resolver): Diagrama de la arquitectura propuesta y documento de diseño detallado.
- Fase 2: Implementación del almacenamiento local — objetivo: Implementar el almacenamiento local de datos para permitir el funcionamiento de la aplicación sin conexión. — entregable (NO resolver): Código fuente que implementa el almacenamiento local de datos.
- Fase 3: Implementación de la sincronización de datos — objetivo: Implementar la sincronización de datos entre el almacenamiento local y el servidor cuando la conexión se restablezca. — entregable (NO resolver): Código fuente que implementa la sincronización de datos.

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
name: field_app
description: A logistics field application with offline-first architecture
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.6.0
  flutter: '>=3.27.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.0
  sqflite: ^2.4.2
  path_provider: ^2.1.5
  connectivity_plus: ^6.1.4
  dio: ^5.8.0+1
  get_it: ^8.0.3
  equatable: ^2.0.7
  uuid: ^4.5.1
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^10.0.0
  mocktail: ^1.0.4
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true

// === ARCHIVO: lib/main.dart ===
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

// === ARCHIVO: lib/core/constants/app_constants.dart ===
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Field App';
  static const String appVersion = '1.0.0';
  
  static const Color primaryColor = Color(0xFF1565C0);
  static const Color secondaryColor = Color(0xFF43A047);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color surfaceColor = Color(0xFFF5F5F5);
  
  static const String baseUrl = 'https://api.fieldapp.example.com';
  static const String apiVersion = 'v1';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  static const int maxRetryAttempts = 3;
  static const int retryDelayMilliseconds = 1000;
  static const int syncIntervalMinutes = 5;
  static const int conflictResolutionTimeoutSeconds = 30;
  
  static const String databaseName = 'field_app.db';
  static const int databaseVersion = 1;
  
  static const int taskTableId = 1;
  static const String taskTableName = 'tasks';
  static const String syncStatusTableName = 'sync_status';
  
  static const int maxOfflineTasks = 1000;
  static const int batchSyncSize = 50;
  
  static const Duration networkCheckInterval = Duration(seconds: 10);
  static const Duration syncDebounceDelay = Duration(seconds: 2);
  
  static const String syncStatusPending = 'pending';
  static const String syncStatusSynced = 'synced';
  static const String syncStatusFailed = 'failed';
  static const String syncStatusConflict = 'conflict';
  
  static const String taskPriorityLow = 'low';
  static const String taskPriorityMedium = 'medium';
  static const String taskPriorityHigh = 'high';
  
  static const String taskStatusPending = 'pending';
  static const String taskStatusInProgress = 'in_progress';
  static const String taskStatusCompleted = 'completed';
  static const String taskStatusCancelled = 'cancelled';
  
  static const String conflictResolutionStrategyServer = 'server';
  static const String conflictResolutionStrategyClient = 'client';
  static const String conflictResolutionStrategyManual = 'manual';
  static const String conflictResolutionStrategyLastWriteWins = 'last_write_wins';
  
  static const List<String> validTaskPriorities = [
    taskPriorityLow,
    taskPriorityMedium,
    taskPriorityHigh,
  ];
  
  static const List<String> validTaskStatuses = [
    taskStatusPending,
    taskStatusInProgress,
    taskStatusCompleted,
    taskStatusCancelled,
  ];
  
  static const int maxTitleLength = 200;
  static const int maxDescriptionLength = 2000;
  
  static const String locale = 'es_ES';
  static const String timezone = 'America/Bogota';
  
  static const bool enableOfflineMode = true;
  static const bool enableAutoSync = true;
  static const bool enableConflictDetection = true;
  static const bool enableDetailedLogs = true;
  
  static const Map<String, dynamic> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-App-Version': appVersion,
    'X-Platform': 'android',
    'X-Locale': locale,
  };
}

class DatabaseConstants {
  static const String tasksTable = '''
    CREATE TABLE tasks (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      priority TEXT NOT NULL,
      status TEXT NOT NULL,
      due_date INTEGER,
      assigned_to TEXT,
      location_lat REAL,
      location_lng REAL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      synced_at INTEGER,
      sync_status TEXT NOT NULL,
      version INTEGER NOT NULL DEFAULT 1,
      is_deleted INTEGER NOT NULL DEFAULT 0,
      metadata TEXT
    )
  ''';
  
  static const String syncStatusTable = '''
    CREATE TABLE sync_status (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      operation TEXT NOT NULL,
      status TEXT NOT NULL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      error_message TEXT,
      retry_count INTEGER NOT NULL DEFAULT 0
    )
  ''';
  
  static const String createTasksIndex = '''
    CREATE INDEX idx_tasks_sync_status ON tasks(sync_status)
  ''';
  
  static const String createSyncStatusIndex = '''
    CREATE INDEX idx_sync_status_entity ON sync_status(entity_type, entity_id)
  ''';
}

// === ARCHIVO: lib/core/errors/failures.dart ===
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const Failure({
    required this.message,
    this.code,
    this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? const _DefaultTimestamp();

  @override
  List<Object?> get props => [message, code, metadata, timestamp];

  String get failureType => runtimeType.toString();
  
  String get userFriendlyMessage => message;
  
  bool get isRecoverable => this is CacheFailure || this is NetworkFailure;
  
  Map<String, dynamic> toMap() {
    return {
      'type': failureType,
      'message': message,
      'code': code,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class _DefaultTimestamp implements DateTime {
  const _DefaultTimestamp();

  DateTime get _now => DateTime.now();
  
  @override
  int get year => _now.year;
  
  @override
  int get month => _now.month;
  
  @override
  int get day => _now.day;
  
  @override
  int get hour => _now.hour;
  
  @override
  int get minute => _now.minute;
  
  @override
  int get second => _now.second;
  
  @override
  int get millisecond => _now.millisecond;
  
  @override
  int get microsecond => _now.microsecond;
  
  @override
  int get weekday => _now.weekday;
  
  @override
  bool get isUtc => _now.isUtc;
  
  @override
  String get timeZoneName => _now.timeZoneName;
  
  @override
  Duration get timeZoneOffset => _now.timeZoneOffset;
  
  @override
  int get millisecondsSinceEpoch => _now.millisecondsSinceEpoch;
  
  @override
  int get microsecondsSinceEpoch => _now.microsecondsSinceEpoch;
  
  @override
  DateTime add(Duration duration) => _now.add(duration);
  
  @override
  DateTime subtract(Duration duration) => _now.subtract(duration);
  
  @override
  Duration difference(DateTime other) => _now.difference(other);
  
  @override
  bool isAfter(DateTime other) => _now.isAfter(other);
  
  @override
  bool isBefore(DateTime other) => _now.isBefore(other);
  
  @override
  bool isAtSameMomentAs(DateTime other) => _now.isAtSameMomentAs(other);
  
  @override
  int compareTo(DateTime other) => _now.compareTo(other);
  
  @override
  String toIso8601String() => _now.toIso8601String();
  
  @override
  DateTime toLocal() => _now.toLocal();
  
  @override
  DateTime toUtc() => _now.toUtc();
  
  @override
  String toString() => _now.toString();
}

class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.statusCode,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
  
  @override
  bool get isRecoverable => statusCode != null && 
      statusCode! >= 500 && statusCode! < 600;
}

class CacheFailure extends Failure {
  final String? cacheKey;
  
  const CacheFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.cacheKey,
  });

  @override
  List<Object?> get props => [...super.props, cacheKey];
}

class NetworkFailure extends Failure {
  final bool isConnectionError;
  final bool isTimeout;
  
  const NetworkFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.isConnectionError = false,
    this.isTimeout = false,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    isConnectionError,
    isTimeout,
  ];
  
  @override
  String get userFriendlyMessage {
    if (isConnectionError) {
      return 'No hay conexión a internet. Los datos se guardarán localmente.';
    }
    if (isTimeout) {
      return 'La conexión tardó demasiado. Por favor, intente más tarde.';
    }
    return message;
  }
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;
  
  const ValidationFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.fieldErrors = const {},
  });

  @override
  List<Object?> get props => [...super.props, fieldErrors];
  
  String getFieldError(String fieldName) {
    return fieldErrors[fieldName]?.join(', ') ?? '';
  }
}

class SyncFailure extends Failure {
  final String? entityId;
  final String? operation;
  final int retryCount;
  
  const SyncFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.entityId,
    this.operation,
    this.retryCount = 0,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    entityId,
    operation,
    retryCount,
  ];
  
  @override
  bool get isRecoverable => retryCount < 3;
}

class ConflictFailure extends Failure {
  final String entityId;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final String conflictType;
  
  const ConflictFailure({
    required super.message,
    required this.entityId,
    required this.localVersion,
    required this.remoteVersion,
    required this.conflictType,
    super.code,
    super.metadata,
    super.timestamp,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    entityId,
    localVersion,
    remoteVersion,
    conflictType,
  ];
  
  @override
  String get userFriendlyMessage {
    return 'Conflicto detectado en los datos. Por favor, revise las diferencias.';
  }
}

class PermissionFailure extends Failure {
  final String permission;
  
  const PermissionFailure({
    required super.message,
    required this.permission,
    super.code,
    super.metadata,
    super.timestamp,
  });

  @override
  List<Object?> get props => [...super.props, permission];
}

// === ARCHIVO: lib/core/errors/exceptions.dart ===
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  AppException({
    required this.message,
    this.code,
    this.originalException,
    StackTrace? stackTrace,
    DateTime? timestamp,
  })  : timestamp = timestamp ?? DateTime.now(),
        stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() => 'AppException: $message (code: $code)';
  
  Map<String, dynamic> toMap() {
    return {
      'type': runtimeType.toString(),
      'message': message,
      'code': code,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ServerException extends AppException {
  final int? statusCode;
  final String? endpoint;
  
  ServerException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.statusCode,
    this.endpoint,
  });

  @override
  String toString() => 'ServerException: $message (status: $statusCode, endpoint: $endpoint)';
  
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isNotFound => statusCode == 404;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
}

class CacheException extends AppException {
  final String? cacheKey;
  final String operation;
  
  CacheException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.cacheKey,
    this.operation = 'read',
  });

  @override
  String toString() => 'CacheException: $message (key: $cacheKey, operation: $operation)';
}

class NetworkException extends AppException {
  final String url;
  final bool isConnectionError;
  final bool isTimeout;
  final bool isSslError;
  
  NetworkException({
    required super.message,
    required this.url,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.isConnectionError = false,
    this.isTimeout = false,
    this.isSslError = false,
  });

  @override
  String toString() => 'NetworkException: $message (url: $url, connection: $isConnectionError, timeout: $isTimeout)';
  
  String get userMessage {
    if (isConnectionError) {
      return 'No se pudo conectar al servidor. Verifique su conexión a internet.';
    }
    if (isTimeout) {
      return 'La solicitud tardó demasiado. Por favor, intente de nuevo.';
    }
    if (isSslError) {
      return 'Error de seguridad en la conexión. Por favor, contacte al administrador.';
    }
    return message;
  }
}

class DatabaseException extends AppException {
  final String? sql;
  final Map<String, dynamic>? queryParameters;
  
  DatabaseException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.sql,
    this.queryParameters,
  });

  @override
  String toString() => 'DatabaseException: $message (sql: $sql)';
  
  bool get isConstraintViolation => code == 'constraint' || code == 'UNIQUE constraint failed';
  bool get isNotFound => code == 'NOT FOUND';
}

class ValidationException extends AppException {
  final Map<String, List<String>> fieldErrors;
  
  ValidationException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.fieldErrors = const {},
  });

  @override
  String toString() => 'ValidationException: $message (fields: ${fieldErrors.keys.join(', ')})';
  
  String getFieldError(String fieldName) {
    return fieldErrors[fieldName]?.join(', ') ?? '';
  }
  
  bool hasFieldError(String fieldName) {
    return fieldErrors.containsKey(fieldName) && fieldErrors[fieldName]!.isNotEmpty;
  }
}

class SyncException extends AppException {
  final String? entityId;
  final String operation;
  final int retryCount;
  final DateTime? nextRetryAt;
  
  SyncException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.entityId,
    this.operation = 'sync',
    this.retryCount = 0,
    this.nextRetryAt,
  });

  @override
  String toString() => 'SyncException: $message (entity: $entityId, operation: $operation, retry: $retryCount)';
  
  bool get canRetry => retryCount < 3;
  
  Duration? get timeUntilRetry {
    if (nextRetryAt == null) return null;
    return nextRetryAt!.difference(DateTime.now());
  }
}

class ConflictException extends AppException {
  final String entityId;
  final dynamic localData;
  final dynamic remoteData;
  final String conflictType;
  
  ConflictException({
    required super.message,
    required this.entityId,
    required this.localData,
    required this.remoteData,
    required this.conflictType,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String toString() => 'ConflictException: $message (entity: $entityId, type: $conflictType)';
  
  Map<String, dynamic> getConflictDetails() {
    return {
      'entityId': entityId,
      'localData': localData,
      'remoteData': remoteData,
      'conflictType': conflictType,
    };
  }
}

class PermissionException extends AppException {
  final String permission;
  
  PermissionException({
    required super.message,
    required this.permission,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String toString() => 'PermissionException: $message (permission: $permission)';
}

// === ARCHIVO: lib/core/network/network_info.dart ===
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
  Future<ConnectivityResult> get connectivityResult;
  Future<List<ConnectivityResult>> get connectivityResults;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final StreamController<bool> _connectivityStreamController;
  bool _lastKnownState = false;
  
  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        _connectivityStreamController = StreamController<bool>.broadcast() {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = _checkConnectivity(results);
      if (isConnected != _lastKnownState) {
        _lastKnownState = isConnected;
        _connectivityStreamController.add(isConnected);
      }
    });
  }

  bool _checkConnectivity(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }
    return results.any((result) => result != ConnectivityResult.none);
  }

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _checkConnectivity(results);
  }

  @override
  Stream<bool> get onConnectivityChanged => _connectivityStreamController.stream;

  @override
  Future<ConnectivityResult> get connectivityResult async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityResult.none;
    }
    return results.first;
  }

  @override
  Future<List<ConnectivityResult>> get connectivityResults async {
    final results = await _connectivity.checkConnectivity();
    return results;
  }

  Future<NetworkType> getNetworkType() async {
    final result = await connectivityResult;
    switch (result) {
      case ConnectivityResult.wifi:
        return NetworkType.wifi;
      case ConnectivityResult.mobile:
        return NetworkType.mobile;
      case ConnectivityResult.ethernet:
        return NetworkType.ethernet;
      case ConnectivityResult.bluetooth:
        return NetworkType.bluetooth;
      case ConnectivityResult.vpn:
        return NetworkType.vpn;
      case ConnectivityResult.other:
        return NetworkType.other;
      case ConnectivityResult.none:
      default:
        return NetworkType.none;
    }
  }

  bool isWifiConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.wifi);
  }

  bool isMobileDataConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile);
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}

enum NetworkType {
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
  none,
}

extension NetworkTypeExtension on NetworkType {
  String get displayName {
    switch (this) {
      case NetworkType.wifi:
        return 'WiFi';
      case NetworkType.mobile:
        return 'Datos Móviles';
      case NetworkType.ethernet:
        return 'Ethernet';
      case NetworkType.bluetooth:
        return 'Bluetooth';
      case NetworkType.vpn:
        return 'VPN';
      case NetworkType.other:
        return 'Otra';
      case NetworkType.none:
        return 'Sin conexión';
    }
  }

  bool get isAvailable => this != NetworkType.none;
  bool get isHighSpeed => this == NetworkType.wifi || this == NetworkType.ethernet;
}


// === ARCHIVO: lib/core/utils/date_utils.dart ===
library;

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class DateTimeUtils {
  static const String iso8601Format = 'yyyy-MM-ddTHH:mm:ss.SSSZ';
  static const String dateOnlyFormat = 'yyyy-MM-dd';
  static const String timeOnlyFormat = 'HH:mm:ss';
  static const String displayFormat = 'dd/MM/yyyy HH:mm';
  static const String syncTimestampFormat = 'yyyy-MM-dd HH:mm:ss';

  static String nowUtc() {
    return DateTime.now().toUtc().toIso8601String();
  }

  static String nowLocal() {
    return DateTime.now().toIso8601String();
  }

  static DateTime parseIso8601(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  static DateTime parseIso8601Utc(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now().toUtc();
    }
    try {
      final parsed = DateTime.parse(dateString);
      return parsed.toUtc();
    } catch (e) {
      return DateTime.now().toUtc();
    }
  }

  static String formatForSync(DateTime dateTime) {
    return '${dateTime.toUtc().year}-'
        '${_twoDigits(dateTime.toUtc().month)}-${'
        '${_twoDigits(dateTime.toUtc().day)} ${'
        '${_twoDigits(dateTime.toUtc().hour)}:${'
        '${_twoDigits(dateTime.toUtc().minute)}:${'
        '${_twoDigits(dateTime.toUtc().second)}';
  }

  static String formatForDisplay(DateTime dateTime) {
    return '${_twoDigits(dateTime.day)}/${'
        '${_twoDigits(dateTime.month)}/${'
        '${dateTime.year} ${'
        '${_twoDigits(dateTime.hour)}:${'
        '${_twoDigits(dateTime.minute)}';
  }

  static String formatDateOnly(DateTime dateTime) {
    return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}';
  }

  static String formatTimeOnly(DateTime dateTime) {
    return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
  }

  static String formatWithTimezone(DateTime dateTime) {
    final utc = dateTime.toUtc();
    final offset = dateTime.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs();
    final minutes = (offset.inMinutes.abs() % 60);
    return '${utc.toIso8601String()}${sign}${_twoDigits(hours)}:${_twoDigits(minutes)}';
  }

  static String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  static bool isSameHour(DateTime date1, DateTime date2) {
    return isSameDay(date1, date2) && date1.hour == date2.hour;
  }

  static bool isExpired(DateTime date, Duration maxAge) {
    final now = DateTime.now();
    return now.difference(date) > maxAge;
  }

  static bool isExpiredUtc(DateTime utcDate, Duration maxAge) {
    final now = DateTime.now().toUtc();
    return now.difference(utcDate) > maxAge;
  }

  static Duration timeSince(DateTime date) {
    return DateTime.now().difference(date);
  }

  static Duration timeSinceUtc(DateTime utcDate) {
    return DateTime.now().toUtc().difference(utcDate);
  }

  static String timeAgo(DateTime date) {
    final duration = timeSince(date);
    return _formatDuration(duration);
  }

  static String timeAgoUtc(DateTime utcDate) {
    final duration = timeSinceUtc(utcDate);
    return _formatDuration(duration);
  }

  static String _formatDuration(Duration duration) {
    if (duration.inDays > 365) {
      final years = (duration.inDays / 365).floor();
      return '$years año${years > 1 ? 's' : ''}';
    } else if (duration.inDays > 30) {
      final months = (duration.inDays / 30).floor();
      return '$months mes${months > 1 ? 'es' : ''}';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} día${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hora${duration.inHours > 1 ? 's' : ''}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minuto${duration.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'menos de un minuto';
    }
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }

  static bool isWithinRange(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  static bool isValidDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return false;
    }
    try {
      DateTime.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var remaining = days;
    while (remaining > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday && 
          result.weekday != DateTime.sunday) {
        remaining--;
      }
    }
    return result;
  }

  static int businessDaysBetween(DateTime from, DateTime to) {
    var count = 0;
    var current = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    while (current.isBefore(end)) {
      current = current.add(const Duration(days: 1));
      if (current.weekday != DateTime.saturday && 
          current.weekday != DateTime.sunday) {
        count++;
      }
    }
    return count;
  }

  static DateTime fromTimestampMillis(int millis) {
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  static DateTime fromTimestampMicros(int micros) {
    return DateTime.fromMicrosecondsSinceEpoch(micros);
  }

  static int toTimestampMillis(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  static int toTimestampMicros(DateTime date) {
    return date.microsecondsSinceEpoch;
  }

  static String generateSyncTimestamp() {
    return formatForSync(DateTime.now().toUtc());
  }

  static String generateVersionId() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static DateTime minDate(List<DateTime> dates) {
    if (dates.isEmpty) {
      return DateTime.now();
    }
    return dates.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  static DateTime maxDate(List<DateTime> dates) {
    if (dates.isEmpty) {
      return DateTime.now();
    }
    return dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  static bool isDateInFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  static bool isDateInPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  static bool isUtcDateInFuture(DateTime utcDate) {
    return utcDate.isAfter(DateTime.now().toUtc());
  }

  static bool isUtcDateInPast(DateTime utcDate) {
    return utcDate.isBefore(DateTime.now().toUtc());
  }

  static DateTime convertToLocal(DateTime utcDate) {
    return utcDate.toLocal();
  }

  static DateTime convertToUtc(DateTime localDate) {
    return localDate.toUtc();
  }

  static String formatRelative(DateTime date) {
    if (isToday(date)) {
      return 'Hoy, ${formatTimeOnly(date)}';
    } else if (isYesterday(date)) {
      return 'Ayer, ${formatTimeOnly(date)}';
    } else if (isTomorrow(date)) {
      return 'Mañana, ${formatTimeOnly(date)}';
    } else {
      return formatForDisplay(date);
    }
  }

  static Duration parseDuration(String? durationString) {
    if (durationString == null || durationString.isEmpty) {
      return Duration.zero;
    }
    try {
      final parts = durationString.split(':');
      if (parts.length == 3) {
        return Duration(
          hours: int.parse(parts[0]),
          minutes: int.parse(parts[1]),
          seconds: int.parse(parts[2]),
        );
      } else if (parts.length == 2) {
        return Duration(
          minutes: int.parse(parts[0]),
          seconds: int.parse(parts[1]),
        );
      }
      return Duration.zero;
    } catch (e) {
      return Duration.zero;
    }
  }

  static String durationToString(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  static DateTime nextSyncTime(DateTime lastSync, Duration interval) {
    return lastSync.add(interval);
  }

  static bool shouldSync(DateTime? lastSync, Duration interval) {
    if (lastSync == null) {
      return true;
    }
    return DateTime.now().isAfter(lastSync.add(interval));
  }

  static int calculateRetryDelay(int attempt, {int baseDelayMs = 1000, int maxDelayMs = 30000}) {
    final delay = baseDelayMs * (1 << (attempt - 1));
    return delay > maxDelayMs ? maxDelayMs : delay;
  }

  static DateTime calculateNextRetry(int attempt, {int baseDelayMs = 1000}) {
    final delayMs = calculateRetryDelay(attempt, baseDelayMs: baseDelayMs);
    return DateTime.now().add(Duration(milliseconds: delayMs));
  }

  static bool isWithinSyncWindow(DateTime syncTime, Duration window) {
    final now = DateTime.now();
    final windowStart = syncTime.subtract(window);
    final windowEnd = syncTime.add(window);
    return now.isAfter(windowStart) && now.isBefore(windowEnd);
  }

  static Map<String, dynamic> dateToMap(DateTime date) {
    return {
      'iso8601': date.toIso8601String(),
      'millis': date.millisecondsSinceEpoch,
      'utc': date.toUtc().toIso8601String(),
      'local': date.toLocal().toIso8601String(),
      'year': date.year,
      'month': date.month,
      'day': date.day,
      'hour': date.hour,
      'minute': date.minute,
      'second': date.second,
      'weekday': date.weekday,
      'isUtc': date.isUtc,
    };
  }

  static DateTime dateFromMap(Map<String, dynamic> map) {
    if (map.containsKey('millis')) {
      return DateTime.fromMillisecondsSinceEpoch(map['millis'] as int);
    } else if (map.containsKey('iso8601')) {
      return DateTime.parse(map['iso8601'] as String);
    }
    return DateTime.now();
  }
}

// === ARCHIVO: lib/domain/entities/task_entity.dart ===
package field_app.domain.entities;

import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? assignedTo;
  final DateTime? dueDate;
  final String syncStatus;
  final int version;
  final Map<String, dynamic>? metadata;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    this.dueDate,
    required this.syncStatus,
    required this.version,
    this.metadata,
  });

  bool get isPendingSync => syncStatus == 'pending';
  bool get isSynced => syncStatus == 'synced';
  bool get hasFailed => syncStatus == 'failed';
  bool get hasConflict => syncStatus == 'conflict';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';

  bool get isHighPriority => priority == 'high';
  bool get isMediumPriority => priority == 'medium';
  bool get isLowPriority => priority == 'low';

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && !isCompleted && !isCancelled;
  }

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedTo,
    DateTime? dueDate,
    String? syncStatus,
    int? version,
    Map<String, dynamic>? metadata,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      dueDate: dueDate ?? this.dueDate,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        createdAt,
        updatedAt,
        assignedTo,
        dueDate,
        syncStatus,
        version,
        metadata,
      ];

  @override
  bool get stringify => true;
}

// === ARCHIVO: lib/domain/entities/sync_status_entity.dart ===
package field_app.domain.entities;

import 'package:equatable/equatable.dart';

class SyncStatusEntity extends Equatable {
  final String id;
  final String entityId;
  final String entityType;
  final String status;
  final DateTime? lastSyncAttempt;
  final DateTime? lastSuccessfulSync;
  final int retryCount;
  final String? errorMessage;
  final String? errorCode;
  final Map<String, dynamic>? conflictDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SyncStatusEntity({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.status,
    this.lastSyncAttempt,
    this.lastSuccessfulSync,
    required this.retryCount,
    this.errorMessage,
    this.errorCode,
    this.conflictDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPending => status == 'pending';
  bool get isSynced => status == 'synced';
  bool get isFailed => status == 'failed';
  bool get hasConflict => status == 'conflict';
  bool get canRetry => retryCount < 3 && (isFailed || isPending);
  bool get isRecoverable => errorCode != 'FATAL';

  Duration? get timeSinceLastAttempt {
    if (lastSyncAttempt == null) return null;
    return DateTime.now().difference(lastSyncAttempt!);
  }

  Duration? get timeSinceLastSuccess {
    if (lastSuccessfulSync == null) return null;
    return DateTime.now().difference(lastSuccessfulSync!);
  }

  SyncStatusEntity copyWith({
    String? id,
    String? entityId,
    String? entityType,
    String? status,
    DateTime? lastSyncAttempt,
    DateTime? lastSuccessfulSync,
    int? retryCount,
    String? errorMessage,
    String? errorCode,
    Map<String, dynamic>? conflictDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SyncStatusEntity(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      status: status ?? this.status,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      lastSuccessfulSync: lastSuccessfulSync ?? this.lastSuccessfulSync,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
      conflictDetails: conflictDetails ?? this.conflictDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        entityId,
        entityType,
        status,
        lastSyncAttempt,
        lastSuccessfulSync,
        retryCount,
        errorMessage,
        errorCode,
        conflictDetails,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}

// === ARCHIVO: lib/domain/repositories/task_repository.dart ===
package field_app.domain.repositories;

import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity?> getTaskById(String id);
  Future<List<TaskEntity>> getTasksByStatus(String status);
  Future<List<TaskEntity>> getTasksByPriority(String priority);
  Future<List<TaskEntity>> getPendingSyncTasks();
  Future<TaskEntity> saveTask(TaskEntity task);
  Future<void> deleteTask(String id);
  Future<void> deleteAllTasks();
  Future<int> getTaskCount();
  Future<int> getPendingSyncCount();
  Future<List<TaskEntity>> searchTasks(String query);
  Future<void> updateTaskSyncStatus(String id, String syncStatus);
  Future<void> incrementTaskVersion(String id);
  Future<List<TaskEntity>> getTasksDueSoon(Duration within);
  Future<List<TaskEntity>> getOverdueTasks();
  Future<void> batchSaveTasks(List<TaskEntity> tasks);
  Stream<List<TaskEntity>> watchTasks();
  Stream<TaskEntity?> watchTask(String id);
}


// === ARCHIVO: lib/domain/repositories/sync_repository.dart ===
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';

abstract class SyncRepository extends Equatable {
  const SyncRepository();

  Future<Either<Failure, void>> syncPendingTasks();

  Future<Either<Failure, SyncResult>> syncAllData();

  Future<Either<Failure, ConflictResolutionResult>> resolveConflict(
    String entityId,
    String entityType,
    ConflictResolutionStrategy strategy,
  );

  Future<Either<Failure, List<SyncStatusSummary>>>> getSyncStatusSummary();

  Future<Either<Failure, void>> retryFailedSync(String entityId);

  Future<Either<Failure, void>> cancelSync(String syncId);

  Stream<SyncProgress> get syncProgressStream;
}

class SyncResult extends Equatable {
  final int totalSynced;
  final int totalFailed;
  final int totalConflicts;
  final Duration syncDuration;
  final List<String> syncedEntityIds;
  final List<SyncErrorDetails> failedEntities;
  final List<ConflictDetails> conflicts;

  const SyncResult({
    required this.totalSynced,
    required this.totalFailed,
    required this.totalConflicts,
    required this.syncDuration,
    required this.syncedEntityIds,
    required this.failedEntities,
    required this.conflicts,
  });

  bool get hasErrors => totalFailed > 0;
  bool get hasConflicts => totalConflicts > 0;
  bool get isFullySuccessful => totalFailed == 0 && totalConflicts == 0;

  @override
  List<Object?> get props => [
        totalSynced,
        totalFailed,
        totalConflicts,
        syncDuration,
        syncedEntityIds,
        failedEntities,
        conflicts,
      ];
}

class SyncErrorDetails extends Equatable {
  final String entityId;
  final String entityType;
  final String errorMessage;
  final int retryCount;
  final DateTime lastAttempt;

  const SyncErrorDetails({
    required this.entityId,
    required this.entityType,
    required this.errorMessage,
    required this.retryCount,
    required this.lastAttempt,
  });

  @override
  List<Object?> get props => [
        entityId,
        entityType,
        errorMessage,
        retryCount,
        lastAttempt,
      ];
}

class ConflictDetails extends Equatable {
  final String entityId;
  final String entityType;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final DateTime localModifiedAt;
  final DateTime remoteModifiedAt;
  final List<String> conflictingFields;

  const ConflictDetails({
    required this.entityId,
    required this.entityType,
    required this.localData,
    required this.remoteData,
    required this.localModifiedAt,
    required this.remoteModifiedAt,
    required this.conflictingFields,
  });

  @override
  List<Object?> get props => [
        entityId,
        entityType,
        localData,
        remoteData,
        localModifiedAt,
        remoteModifiedAt,
        conflictingFields,
      ];
}

enum ConflictResolutionStrategy {
  serverWins,
  clientWins,
  lastWriteWins,
  manual,
  merge,
}

class ConflictResolutionResult extends Equatable {
  final bool success;
  final String entityId;
  final ConflictResolutionStrategy usedStrategy;
  final Map<String, dynamic>? resolvedData;
  final String? errorMessage;

  const ConflictResolutionResult({
    required this.success,
    required this.entityId,
    required this.usedStrategy,
    this.resolvedData,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        success,
        entityId,
        usedStrategy,
        resolvedData,
        errorMessage,
      ];
}

class SyncStatusSummary extends Equatable {
  final int pendingCount;
  final int syncedCount;
  final int failedCount;
  final int conflictCount;
  final DateTime? lastSyncAt;
  final bool isSyncing;

  const SyncStatusSummary({
    required this.pendingCount,
    required this.syncedCount,
    required this.failedCount,
    required this.conflictCount,
    this.lastSyncAt,
    required this.isSyncing,
  });

  int get totalCount => pendingCount + syncedCount + failedCount + conflictCount;
  double get syncPercentage =>
      totalCount > 0 ? (syncedCount / totalCount) * 100 : 0;

  @override
  List<Object?> get props => [
        pendingCount,
        syncedCount,
        failedCount,
        conflictCount,
        lastSyncAt,
        isSyncing,
      ];
}

class SyncProgress extends Equatable {
  final String phase;
  final int currentItem;
  final int totalItems;
  final String? currentEntityId;
  final double progressPercentage;
  final String? statusMessage;

  const SyncProgress({
    required this.phase,
    required this.currentItem,
    required this.totalItems,
    this.currentEntityId,
    required this.progressPercentage,
    this.statusMessage,
  });

  @override
  List<Object?> get props => [
        phase,
        currentItem,
        totalItems,
        currentEntityId,
        progressPercentage,
        statusMessage,
      ];
}

// === ARCHIVO: lib/domain/usecases/get_local_tasks.dart ===
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../entities/task_entity.dart';

abstract class GetLocalTasks extends Equatable {
  const GetLocalTasks();

  Future<Either<Failure, List<TaskEntity>>> call({
    GetLocalTasksParams? params,
  });
}

class GetLocalTasksParams extends Equatable {
  final TaskFilter? filter;
  final TaskSortOptions? sortBy;
  final bool ascending;
  final int? limit;
  final int? offset;

  const GetLocalTasksParams({
    this.filter,
    this.sortBy,
    this.ascending = true,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [filter, sortBy, ascending, limit, offset];
}

enum TaskFilter {
  all,
  pending,
  inProgress,
  completed,
  cancelled,
  failed,
  synced,
  notSynced,
  hasConflict,
}

enum TaskSortOptions {
  createdAt,
  updatedAt,
  priority,
  status,
  dueDate,
  title,
}

class GetLocalTasksImpl implements GetLocalTasks {
  final TaskRepository _taskRepository;

  const GetLocalTasksImpl(this._taskRepository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call({
    GetLocalTasksParams? params,
  }) async {
    final effectiveParams = params ?? const GetLocalTasksParams();

    final result = await _taskRepository.getLocalTasks(
      filter: effectiveParams.filter,
      sortBy: effectiveParams.sortBy,
      ascending: effectiveParams.ascending,
      limit: effectiveParams.limit,
      offset: effectiveParams.offset,
    );

    return result.fold(
      (failure) => Left(failure),
      (tasks) {
        if (tasks.isEmpty) {
          return const Right<Failure, List<TaskEntity>>([]);
        }
        return Right<Failure, List<TaskEntity>>(tasks);
      },
    );
  }
}

abstract class TaskRepository extends Equatable {
  const TaskRepository();

  Future<Either<Failure, List<TaskEntity>>> getLocalTasks({
    TaskFilter? filter,
    TaskSortOptions? sortBy,
    bool ascending = true,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, TaskEntity>> getLocalTaskById(String id);

  Future<Either<Failure, void>> saveLocalTask(TaskEntity task);

  Future<Either<Failure, void>> updateLocalTask(TaskEntity task);

  Future<Either<Failure, void>> deleteLocalTask(String id);

  Future<Either<Failure, List<TaskEntity>>> getUnsyncedTasks();

  Future<Either<Failure, void>> markTaskAsSynced(String id);

  Future<Either<Failure, void>> markTaskAsFailed(String id, String error);

  Future<Either<Failure, int>> getPendingSyncCount();

  Future<Either<Failure, void>> clearAllLocalTasks();
}

// === ARCHIVO: lib/domain/usecases/save_task_local.dart ===
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../entities/task_entity.dart';

abstract class SaveTaskLocal extends Equatable {
  const SaveTaskLocal();

  Future<Either<Failure, SaveTaskResult>> call(SaveTaskParams params);
}

class SaveTaskParams extends Equatable {
  final TaskEntity task;
  final bool markForSync;
  final bool validateBeforeSave;

  const SaveTaskParams({
    required this.task,
    this.markForSync = true,
    this.validateBeforeSave = true,
  });

  @override
  List<Object?> get props => [task, markForSync, validateBeforeSave];
}

class SaveTaskResult extends Equatable {
  final bool success;
  final String taskId;
  final bool wasCreated;
  final bool wasUpdated;
  final bool markedForSync;
  final DateTime savedAt;
  final String? errorMessage;

  const SaveTaskResult({
    required this.success,
    required this.taskId,
    required this.wasCreated,
    required this.wasUpdated,
    required this.markedForSync,
    required this.savedAt,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        success,
        taskId,
        wasCreated,
        wasUpdated,
        markedForSync,
        savedAt,
        errorMessage,
      ];
}

class SaveTaskLocalImpl implements SaveTaskLocal {
  final TaskRepository _taskRepository;

  const SaveTaskLocalImpl(this._taskRepository);

  @override
  Future<Either<Failure, SaveTaskResult>> call(
    SaveTaskParams params,
  ) async {
    if (params.validateBeforeSave) {
      final validationResult = _validateTask(params.task);
      if (validationResult != null) {
        return Left(validationResult);
      }
    }

    final existingTaskResult = await _taskRepository.getLocalTaskById(
      params.task.id,
    );

    final isUpdate = existingTaskResult.isRight() &&
        existingTaskResult.fold((_) => false, (_) => true);

    final saveResult = isUpdate
        ? await _taskRepository.updateLocalTask(params.task)
        : await _taskRepository.saveLocalTask(params.task);

    return saveResult.fold(
      (failure) => Left(failure),
      (_) async {
        if (params.markForSync && !params.task.isSynced) {
          return Right<Failure, SaveTaskResult>(SaveTaskResult(
            success: true,
            taskId: params.task.id,
            wasCreated: !isUpdate,
            wasUpdated: isUpdate,
            markedForSync: true,
            savedAt: DateTime.now(),
          ));
        }

        return Right<Failure, SaveTaskResult>(SaveTaskResult(
          success: true,
          taskId: params.task.id,
          wasCreated: !isUpdate,
          wasUpdated: isUpdate,
          markedForSync: false,
          savedAt: DateTime.now(),
        ));
      },
    );
  }

  Failure? _validateTask(TaskEntity task) {
    if (task.title.isEmpty) {
      return const ValidationFailure(
        message: 'El título de la tarea no puede estar vacío',
        fieldErrors: {'title': ['El título es requerido']},
      );
    }

    if (task.title.length > 200) {
      return const ValidationFailure(
        message: 'El título excede la longitud máxima permitida',
        fieldErrors: {'title': ['El título no puede exceder 200 caracteres']},
      );
    }

    if (task.description != null && task.description!.length > 2000) {
      return const ValidationFailure(
        message: 'La descripción excede la longitud máxima permitida',
        fieldErrors: {
          'description': ['La descripción no puede exceder 2000 caracteres']
        },
      );
    }

    return null;
  }
}


// === ARCHIVO: lib/domain/usecases/sync_tasks.dart ===
package field_app.domain.usecases;

import 'package:equatable/equatable.dart';
import 'package:field_app/core/errors/failures.dart';
import 'package:field_app/core/network/network_info.dart';
import 'package:field_app/domain/entities/task_entity.dart';
import 'package:field_app/domain/repositories/task_repository.dart';
import 'package:field_app/domain/repositories/sync_repository.dart';

class SyncTasksParams extends Equatable {
  final bool forceFullSync;
  final int? batchSize;
  final bool resolveConflictsAutomatically;

  const SyncTasksParams({
    this.forceFullSync = false,
    this.batchSize,
    this.resolveConflictsAutomatically = false,
  });

  @override
  List<Object?> get props => [forceFullSync, batchSize, resolveConflictsAutomatically];
}

class SyncTasksResult extends Equatable {
  final int syncedCount;
  final int failedCount;
  final int conflictCount;
  final Duration duration;
  final List<String> errorMessages;

  const SyncTasksResult({
    required this.syncedCount,
    required this.failedCount,
    required this.conflictCount,
    required this.duration,
    this.errorMessages = const [],
  });

  bool get hasConflicts => conflictCount > 0;
  bool get hasErrors => failedCount > 0;
  bool get isPartialSuccess => syncedCount > 0 && (failedCount > 0 || conflictCount > 0);
  bool get isFullSuccess => syncedCount > 0 && failedCount == 0 && conflictCount == 0;

  @override
  List<Object?> get props => [syncedCount, failedCount, conflictCount, duration, errorMessages];
}

abstract class SyncTasks {
  Future<({SyncTasksResult result, Failure? failure})> call(SyncTasksParams params);
}

class SyncTasksImpl implements SyncTasks {
  final TaskRepository taskRepository;
  final SyncRepository syncRepository;
  final NetworkInfo networkInfo;

  static const int defaultBatchSize = 50;
  static const int maxRetryAttempts = 3;

  SyncTasksImpl({
    required this.taskRepository,
    required this.syncRepository,
    required this.networkInfo,
  });

  @override
  Future<({SyncTasksResult result, Failure? failure})> call(SyncTasksParams params) async {
    final stopwatch = Stopwatch()..start();
    
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      stopwatch.stop();
      return (
        result: SyncTasksResult(
          syncedCount: 0,
          failedCount: 0,
          conflictCount: 0,
          duration: stopwatch.elapsed,
          errorMessages: ['No network connection available'],
        ),
        failure: const NetworkFailure(
          message: 'No network connection available for sync',
          isConnectionError: true,
          isTimeout: false,
        ),
      );
    }

    try {
      final pendingTasks = await taskRepository.getPendingSyncTasks();
      
      if (pendingTasks.isEmpty) {
        stopwatch.stop();
        return (
          result: SyncTasksResult(
            syncedCount: 0,
            failedCount: 0,
            conflictCount: 0,
            duration: stopwatch.elapsed,
            errorMessages: [],
          ),
          failure: null,
        );
      }

      final batchSize = params.batchSize ?? defaultBatchSize;
      final batches = _createBatches(pendingTasks, batchSize);
      
      int syncedCount = 0;
      int failedCount = 0;
      int conflictCount = 0;
      final List<String> errorMessages = [];

      for (final batch in batches) {
        final batchResult = await _processBatch(
          batch,
          params.resolveConflictsAutomatically,
        );
        
        syncedCount += batchResult.synced;
        failedCount += batchResult.failed;
        conflictCount += batchResult.conflicts;
        errorMessages.addAll(batchResult.errors);
      }

      stopwatch.stop();
      
      await syncRepository.recordSyncOperation(
        entityType: 'tasks',
        totalCount: pendingTasks.length,
        successCount: syncedCount,
        failedCount: failedCount,
        conflictCount: conflictCount,
      );

      return (
        result: SyncTasksResult(
          syncedCount: syncedCount,
          failedCount: failedCount,
          conflictCount: conflictCount,
          duration: stopwatch.elapsed,
          errorMessages: errorMessages,
        ),
        failure: failedCount > 0 || conflictCount > 0
            ? SyncFailure(
                message: 'Sync completed with errors',
                retryCount: failedCount,
              )
            : null,
      );
    } catch (e) {
      stopwatch.stop();
      return (
        result: SyncTasksResult(
          syncedCount: 0,
          failedCount: 0,
          conflictCount: 0,
          duration: stopwatch.elapsed,
          errorMessages: [e.toString()],
        ),
        failure: SyncFailure(
          message: 'Sync operation failed: ${e.toString()}',
          retryCount: 0,
        ),
      );
    }
  }

  List<List<TaskEntity>> _createBatches(List<TaskEntity> tasks, int batchSize) {
    final batches = <List<TaskEntity>>[];
    for (var i = 0; i < tasks.length; i += batchSize) {
      final end = (i + batchSize < tasks.length) ? i + batchSize : tasks.length;
      batches.add(tasks.sublist(i, end));
    }
    return batches;
  }

  Future<({int synced, int failed, int conflicts, List<String> errors})> _processBatch(
    List<TaskEntity> batch,
    bool resolveAutomatically,
  ) async {
    int synced = 0;
    int failed = 0;
    int conflicts = 0;
    final errors = <String>[];

    for (final task in batch) {
      try {
        final syncResult = await taskRepository.syncTask(task);
        
        if (syncResult.isConflict) {
          conflicts++;
          if (resolveAutomatically) {
            await _autoResolveConflict(task, syncResult);
          } else {
            await taskRepository.markTaskAsConflict(task.id);
          }
        } else if (syncResult.isSuccess) {
          synced++;
        } else {
          failed++;
          errors.add('Failed to sync task ${task.id}: ${syncResult.errorMessage}');
        }
      } catch (e) {
        failed++;
        errors.add('Exception syncing task ${task.id}: $e');
      }
    }

    return (synced: synced, failed: failed, conflicts: conflicts, errors: errors);
  }

  Future<void> _autoResolveConflict(TaskEntity task, SyncResult result) async {
    final resolutionStrategy = result.serverVersion != null 
        ? ConflictResolutionStrategy.serverWins 
        : ConflictResolutionStrategy.keepLocal;
    
    await taskRepository.resolveConflict(
      taskId: task.id,
      resolution: resolutionStrategy,
      winningVersion: resolutionStrategy == ConflictResolutionStrategy.serverWins
          ? result.serverVersion
          : task,
    );
  }
}

enum ConflictResolutionStrategy {
  serverWins,
  clientWins,
  keepLocal,
  merge,
}

class SyncResult {
  final bool isSuccess;
  final bool isConflict;
  final String? errorMessage;
  final TaskEntity? serverVersion;

  const SyncResult({
    required this.isSuccess,
    this.isConflict = false,
    this.errorMessage,
    this.serverVersion,
  });
}

// === ARCHIVO: lib/domain/usecases/resolve_conflict.dart ===
package field_app.domain.usecases;

import 'package:equatable/equatable.dart';
import 'package:field_app/core/errors/failures.dart';
import 'package:field_app/domain/entities/task_entity.dart';
import 'package:field_app/domain/repositories/task_repository.dart';

enum ResolutionStrategy {
  useLocal,
  useServer,
  merge,
  lastWriteWins,
}

class ResolveConflictParams extends Equatable {
  final String taskId;
  final ResolutionStrategy strategy;
  final TaskEntity? mergedData;

  const ResolveConflictParams({
    required this.taskId,
    required this.strategy,
    this.mergedData,
  });

  @override
  List<Object?> get props => [taskId, strategy, mergedData];
}

class ConflictData extends Equatable {
  final String taskId;
  final TaskEntity localVersion;
  final TaskEntity serverVersion;
  final DateTime localModifiedAt;
  final DateTime serverModifiedAt;
  final List<String> conflictingFields;

  const ConflictData({
    required this.taskId,
    required this.localVersion,
    required this.serverVersion,
    required this.localModifiedAt,
    required this.serverModifiedAt,
    required this.conflictingFields,
  });

  Duration get timeDifference => localModifiedAt.difference(serverModifiedAt);
  bool get localIsNewer => localModifiedAt.isAfter(serverModifiedAt);
  bool get serverIsNewer => serverModifiedAt.isAfter(localModifiedAt);

  @override
  List<Object?> get props => [
        taskId,
        localVersion,
        serverVersion,
        localModifiedAt,
        serverModifiedAt,
        conflictingFields,
      ];
}

class ResolveConflictResult extends Equatable {
  final bool success;
  final TaskEntity? resolvedTask;
  final String? errorMessage;
  final ResolutionStrategy appliedStrategy;

  const ResolveConflictResult({
    required this.success,
    this.resolvedTask,
    this.errorMessage,
    required this.appliedStrategy,
  });

  @override
  List<Object?> get props => [success, resolvedTask, errorMessage, appliedStrategy];
}

abstract class ResolveConflict {
  Future<({ResolveConflictResult result, Failure? failure})> call(ResolveConflictParams params);
  Future<ConflictData?> getConflictData(String taskId);
  Future<List<ConflictData>> getAllConflicts();
}

class ResolveConflictImpl implements ResolveConflict {
  final TaskRepository taskRepository;

  ResolveConflictImpl({required this.taskRepository});

  @override
  Future<({ResolveConflictResult result, Failure? failure})> call(ResolveConflictParams params) async {
    if (params.taskId.isEmpty) {
      return (
        result: ResolveConflictResult(
          success: false,
          errorMessage: 'Task ID cannot be empty',
          appliedStrategy: params.strategy,
        ),
        failure: const ValidationFailure(
          message: 'Invalid task ID for conflict resolution',
          fieldErrors: {'taskId': ['Task ID is required']},
        ),
      );
    }

    try {
      final conflictData = await getConflictData(params.taskId);
      
      if (conflictData == null) {
        return (
          result: ResolveConflictResult(
            success: false,
            errorMessage: 'No conflict found for task ${params.taskId}',
            appliedStrategy: params.strategy,
          ),
          failure: ConflictFailure(
            entityId: params.taskId,
            localVersion: null,
            remoteVersion: null,
            conflictType: 'not_found',
          ),
        );
      }

      TaskEntity resolvedTask;
      
      switch (params.strategy) {
        case ResolutionStrategy.useLocal:
          resolvedTask = await _resolveWithLocal(conflictData);
          break;
        case ResolutionStrategy.useServer:
          resolvedTask = await _resolveWithServer(conflictData);
          break;
        case ResolutionStrategy.merge:
          resolvedTask = await _resolveWithMerge(conflictData, params.mergedData);
          break;
        case ResolutionStrategy.lastWriteWins:
          resolvedTask = await _resolveWithLastWriteWins(conflictData);
          break;
      }

      await taskRepository.updateTask(resolvedTask);
      await taskRepository.markTaskAsSynced(resolvedTask.id);

      return (
        result: ResolveConflictResult(
          success: true,
          resolvedTask: resolvedTask,
          appliedStrategy: params.strategy,
        ),
        failure: null,
      );
    } catch (e) {
      return (
        result: ResolveConflictResult(
          success: false,
          errorMessage: 'Failed to resolve conflict: ${e.toString()}',
          appliedStrategy: params.strategy,
        ),
        failure: ConflictFailure(
          entityId: params.taskId,
          localVersion: null,
          remoteVersion: null,
          conflictType: 'resolution_failed',
        ),
      );
    }
  }

  @override
  Future<ConflictData?> getConflictData(String taskId) async {
    final localTask = await taskRepository.getTaskById(taskId);
    if (localTask == null) return null;

    if (localTask.syncStatus != 'conflict') return null;

    final serverTask = await taskRepository.getServerTaskById(taskId);
    if (serverTask == null) return null;

    final conflictingFields = _identifyConflictingFields(localTask, serverTask);
    
    return ConflictData(
      taskId: taskId,
      localVersion: localTask,
      serverVersion: serverTask,
      localModifiedAt: localTask.updatedAt,
      serverModifiedAt: serverTask.updatedAt,
      conflictingFields: conflictingFields,
    );
  }

  @override
  Future<List<ConflictData>> getAllConflicts() async {
    final conflictingTasks = await taskRepository.getConflictingTasks();
    final conflicts = <ConflictData>[];

    for (final task in conflictingTasks) {
      final conflictData = await getConflictData(task.id);
      if (conflictData != null) {
        conflicts.add(conflictData);
      }
    }

    return conflicts;
  }

  List<String> _identifyConflictingFields(TaskEntity local, TaskEntity server) {
    final conflictingFields = <String>[];

    if (local.title != server.title) conflictingFields.add('title');
    if (local.description != server.description) conflictingFields.add('description');
    if (local.status != server.status) conflictingFields.add('status');
    if (local.priority != server.priority) conflictingFields.add('priority');
    if (local.dueDate != server.dueDate) conflictingFields.add('dueDate');
    if (local.assignedTo != server.assignedTo) conflictingFields.add('assignedTo');
    if (local.location != server.location) conflictingFields.add('location');
    if (local.notes != server.notes) conflictingFields.add('notes');

    return conflictingFields;
  }

  Future<TaskEntity> _resolveWithLocal(ConflictData conflictData) async {
    return conflictData.localVersion;
  }

  Future<TaskEntity> _resolveWithServer(ConflictData conflictData) async {
    return conflictData.serverVersion;
  }

  Future<TaskEntity> _resolveWithMerge(
    ConflictData conflictData,
    TaskEntity? mergedData,
  ) async {
    if (mergedData != null) return mergedData;

    final local = conflictData.localVersion;
    return TaskEntity(
      id: local.id,
      title: local.title,
      description: local.description.isNotEmpty ? local.description : conflictData.serverVersion.description,
      status: local.status,
      priority: local.priority,
      dueDate: local.dueDate ?? conflictData.serverVersion.dueDate,
      assignedTo: local.assignedTo,
      location: local.location,
      notes: local.notes.isNotEmpty ? local.notes : conflictData.serverVersion.notes,
      createdAt: local.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: 'synced',
      version: conflictData.serverVersion.version + 1,
    );
  }

  Future<TaskEntity> _resolveWithLastWriteWins(ConflictData conflictData) async {
    if (conflictData.localIsNewer) {
      return conflictData.localVersion;
    } else {
      return conflictData.serverVersion;
    }
  }
}


// === ARCHIVO: lib/data/models/task_model.dart ===
package field_app.data.models;

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task_entity.dart';
import '../../core/constants/app_constants.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? assignedTo;
  final String? location;
  final String syncStatus;
  final int version;
  final bool isDeleted;
  final Map<String, dynamic>? metadata;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    this.location,
    required this.syncStatus,
    required this.version,
    this.isDeleted = false,
    this.metadata,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      assignedTo: entity.assignedTo,
      location: entity.location,
      syncStatus: entity.syncStatus,
      version: entity.version,
      isDeleted: entity.isDeleted,
      metadata: entity.metadata,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: map['priority'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      assignedTo: map['assigned_to'] as String?,
      location: map['location'] as String?,
      syncStatus: map['sync_status'] as String,
      version: map['version'] as int,
      isDeleted: (map['is_deleted'] as int) == 1,
      metadata: map['metadata'] != null
          ? jsonDecode(map['metadata'] as String) as Map<String, dynamic>
          : null,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      assignedTo: json['assigned_to'] as String?,
      location: json['location'] as String?,
      syncStatus: json['sync_status'] as String? ?? AppConstants.syncStatusPending,
      version: json['version'] as int? ?? 1,
      isDeleted: json['is_deleted'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  factory TaskModel.create({
    required String title,
    required String description,
    required String priority,
    String? assignedTo,
    String? location,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now();
    return TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      priority: priority,
      status: AppConstants.taskStatusPending,
      createdAt: now,
      updatedAt: now,
      assignedTo: assignedTo,
      location: location,
      syncStatus: AppConstants.syncStatusPending,
      version: 1,
      isDeleted: false,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'assigned_to': assignedTo,
      'location': location,
      'sync_status': syncStatus,
      'version': version,
      'is_deleted': isDeleted ? 1 : 0,
      'metadata': metadata != null ? jsonEncode(metadata) : null,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'assigned_to': assignedTo,
      'location': location,
      'sync_status': syncStatus,
      'version': version,
      'is_deleted': isDeleted,
      'metadata': metadata,
    };
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      assignedTo: assignedTo,
      location: location,
      syncStatus: syncStatus,
      version: version,
      isDeleted: isDeleted,
      metadata: metadata,
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedTo,
    String? location,
    String? syncStatus,
    int? version,
    bool? isDeleted,
    Map<String, dynamic>? metadata,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      location: location ?? this.location,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      metadata: metadata ?? this.metadata,
    );
  }

  TaskModel incrementVersion() {
    return copyWith(version: version + 1);
  }

  TaskModel markForDeletion() {
    return copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
      syncStatus: AppConstants.syncStatusPending,
    );
  }

  TaskModel markSynced() {
    return copyWith(syncStatus: AppConstants.syncStatusSynced);
  }

  TaskModel markFailed() {
    return copyWith(syncStatus: AppConstants.syncStatusFailed);
  }

  TaskModel markConflict() {
    return copyWith(syncStatus: AppConstants.syncStatusConflict);
  }

  bool get isPendingSync => syncStatus == AppConstants.syncStatusPending;
  bool get isSynced => syncStatus == AppConstants.syncStatusSynced;
  bool get hasFailed => syncStatus == AppConstants.syncStatusFailed;
  bool get hasConflict => syncStatus == AppConstants.syncStatusConflict;

  bool get isValidTitle => title.isNotEmpty && title.length <= AppConstants.maxTitleLength;
  bool get isValidDescription => description.length <= AppConstants.maxDescriptionLength;
  bool get isValidPriority => [AppConstants.taskPriorityLow, AppConstants.taskPriorityMedium, AppConstants.taskPriorityHigh].contains(priority);
  bool get isValidStatus => [AppConstants.taskStatusPending, AppConstants.taskStatusInProgress, AppConstants.taskStatusCompleted, AppConstants.taskStatusCancelled].contains(status);

  bool get isValid => isValidTitle && isValidDescription && isValidPriority && isValidStatus;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        createdAt,
        updatedAt,
        assignedTo,
        location,
        syncStatus,
        version,
        isDeleted,
        metadata,
      ];
}

// === ARCHIVO: lib/data/models/sync_status_model.dart ===
package field_app.data.models;

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/sync_status_entity.dart';
import '../../core/constants/app_constants.dart';

class SyncStatusModel extends Equatable {
  final String id;
  final String entityType;
  final String entityId;
  final String status;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncAt;
  final int retryCount;
  final String? errorMessage;
  final String? errorCode;
  final Map<String, dynamic>? metadata;

  const SyncStatusModel({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncAt,
    this.retryCount = 0,
    this.errorMessage,
    this.errorCode,
    this.metadata,
  });

  factory SyncStatusModel.fromEntity(SyncStatusEntity entity) {
    return SyncStatusModel(
      id: entity.id,
      entityType: entity.entityType,
      entityId: entity.entityId,
      status: entity.status,
      version: entity.version,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastSyncAt: entity.lastSyncAt,
      retryCount: entity.retryCount,
      errorMessage: entity.errorMessage,
      errorCode: entity.errorCode,
      metadata: entity.metadata,
    );
  }

  factory SyncStatusModel.fromMap(Map<String, dynamic> map) {
    return SyncStatusModel(
      id: map['id'] as String,
      entityType: map['entity_type'] as String,
      entityId: map['entity_id'] as String,
      status: map['status'] as String,
      version: map['version'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      lastSyncAt: map['last_sync_at'] != null
          ? DateTime.parse(map['last_sync_at'] as String)
          : null,
      retryCount: map['retry_count'] as int? ?? 0,
      errorMessage: map['error_message'] as String?,
      errorCode: map['error_code'] as String?,
      metadata: map['metadata'] != null
          ? jsonDecode(map['metadata'] as String) as Map<String, dynamic>
          : null,
    );
  }

  factory SyncStatusModel.fromJson(Map<String, dynamic> json) {
    return SyncStatusModel(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      status: json['status'] as String,
      version: json['version'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: json['last_sync_at'] != null
          ? DateTime.parse(json['last_sync_at'] as String)
          : null,
      retryCount: json['retry_count'] as int? ?? 0,
      errorMessage: json['error_message'] as String?,
      errorCode: json['error_code'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  factory SyncStatusModel.create({
    required String entityType,
    required String entityId,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now();
    return SyncStatusModel(
      id: const Uuid().v4(),
      entityType: entityType,
      entityId: entityId,
      status: AppConstants.syncStatusPending,
      version: 1,
      createdAt: now,
      updatedAt: now,
      lastSyncAt: null,
      retryCount: 0,
      errorMessage: null,
      errorCode: null,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'status': status,
      'version': version,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'retry_count': retryCount,
      'error_message': errorMessage,
      'error_code': errorCode,
      'metadata': metadata != null ? jsonEncode(metadata) : null,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'status': status,
      'version': version,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'retry_count': retryCount,
      'error_message': errorMessage,
      'error_code': errorCode,
      'metadata': metadata,
    };
  }

  SyncStatusEntity toEntity() {
    return SyncStatusEntity(
      id: id,
      entityType: entityType,
      entityId: entityId,
      status: status,
      version: version,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastSyncAt: lastSyncAt,
      retryCount: retryCount,
      errorMessage: errorMessage,
      errorCode: errorCode,
      metadata: metadata,
    );
  }

  SyncStatusModel copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? status,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? retryCount,
    String? errorMessage,
    String? errorCode,
    Map<String, dynamic>? metadata,
  }) {
    return SyncStatusModel(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      status: status ?? this.status,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
      metadata: metadata ?? this.metadata,
    );
  }

  SyncStatusModel markAsSynced() {
    return copyWith(
      status: AppConstants.syncStatusSynced,
      updatedAt: DateTime.now(),
      lastSyncAt: DateTime.now(),
      retryCount: 0,
      errorMessage: null,
      errorCode: null,
    );
  }

  SyncStatusModel markAsFailed({String? errorMessage, String? errorCode}) {
    return copyWith(
      status: AppConstants.syncStatusFailed,
      updatedAt: DateTime.now(),
      retryCount: retryCount + 1,
      errorMessage: errorMessage,
      errorCode: errorCode,
    );
  }

  SyncStatusModel markAsConflict() {
    return copyWith(
      status: AppConstants.syncStatusConflict,
      updatedAt: DateTime.now(),
    );
  }

  SyncStatusModel incrementVersion() {
    return copyWith(
      version: version + 1,
      updatedAt: DateTime.now(),
    );
  }

  SyncStatusModel resetRetry() {
    return copyWith(
      retryCount: 0,
      errorMessage: null,
      errorCode: null,
    );
  }

  bool get isPending => status == AppConstants.syncStatusPending;
  bool get isSynced => status == AppConstants.syncStatusSynced;
  bool get isFailed => status == AppConstants.syncStatusFailed;
  bool get isConflict => status == AppConstants.syncStatusConflict;
  bool get canRetry => retryCount < AppConstants.maxRetryAttempts;
  bool get hasError => errorMessage != null;

  @override
  List<Object?> get props => [
        id,
        entityType,
        entityId,
        status,
        version,
        createdAt,
        updatedAt,
        lastSyncAt,
        retryCount,
        errorMessage,
        errorCode,
        metadata,
      ];
}

// === ARCHIVO: lib/data/datasources/local/task_local_datasource.dart ===
package field_app.data.datasources.local;

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/task_model.dart';
import '../../models/sync_status_model.dart';
import 'database_helper.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getPendingSyncTasks();
  Future<TaskModel?> getTaskById(String id);
  Future<void> saveTask(TaskModel task);
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> markTaskAsSynced(String id);
  Future<void> markTaskAsFailed(String id, {String? errorMessage});
  Future<void> markTaskAsConflict(String id);
  Future<int> getPendingTasksCount();
  Future<void> clearAllTasks();
  Future<SyncStatusModel?> getSyncStatus(String entityId);
  Future<void> saveSyncStatus(SyncStatusModel status);
  Future<List<SyncStatusModel>> getAllSyncStatuses();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Uuid _uuid = const Uuid();

  TaskLocalDataSourceImpl({required this.databaseHelper});

  Future<Database> get _db async => await databaseHelper.database;

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.taskTableName,
        where: 'is_deleted = ?',
        whereArgs: [0],
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error fetching all tasks: ${e.toString()}',
        operation: 'getAllTasks',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<TaskModel>> getPendingSyncTasks() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.taskTableName,
        where: 'sync_status = ? AND is_deleted = ?',
        whereArgs: [AppConstants.syncStatusPending, 0],
        orderBy: 'updated_at ASC',
        limit: AppConstants.batchSyncSize,
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error fetching pending sync tasks: ${e.toString()}',
        operation: 'getPendingSyncTasks',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.taskTableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return TaskModel.fromMap(maps.first);
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error fetching task by id: ${e.toString()}',
        operation: 'getTaskById',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    try {
      final db = await _db;
      await db.insert(
        AppConstants.taskTableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _updateSyncStatus(task.id, AppConstants.syncStatusPending);
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error saving task: ${e.toString()}',
        operation: 'saveTask',
        sql: 'INSERT INTO ${AppConstants.taskTableName}',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    if (tasks.isEmpty) return;
    try {
      final db = await _db;
      final batch = db.batch();
      for (final task in tasks) {
        batch.insert(
          AppConstants.taskTableName,
          task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        batch.insert(
          AppConstants.syncStatusTableName,
          SyncStatusModel.create(
            entityType: AppConstants.taskTableName,
            entityId: task.id,
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error saving tasks batch: ${e.toString()}',
        operation: 'saveTasks',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      final db = await _db;
      final updatedTask = task.copyWith(
        updatedAt: DateTime.now(),
        syncStatus: AppConstants.syncStatusPending,
        version: task.version + 1,
      );
      final rowsAffected = await db.update(
        AppConstants.taskTableName,
        updatedTask.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      if (rowsAffected == 0) {
        throw DatabaseException(
          message: 'Task not found for update: ${task.id}',
          operation: 'updateTask',
        );
      }
      await _updateSyncStatus(task.id, AppConstants.syncStatusPending);
    } catch (e, st) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException(
        message: 'Error updating task: ${e.toString()}',
        operation: 'updateTask',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final db = await _db;
      final task = await getTaskById(id);
      if (task == null) {
        throw DatabaseException(
          message: 'Task not found for deletion: $id',
          operation: 'deleteTask',
        );
      }
      final deletedTask = task.markForDeletion();
      await db.update(
        AppConstants.taskTableName,
        deletedTask.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      await _updateSyncStatus(id, AppConstants.syncStatusPending);
    } catch (e, st) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException(
        message: 'Error deleting task: ${e.toString()}',
        operation: 'deleteTask',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> markTaskAsSynced(String id) async {
    try {
      final db = await _db;
      await db.update(
        AppConstants.taskTableName,
        {
          'sync_status': AppConstants.syncStatusSynced,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      await _updateSyncStatus(id, AppConstants.syncStatusSynced);
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error marking task as synced: ${e.toString()}',
        operation: 'markTaskAsSynced',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> markTaskAsFailed(String id, {String? errorMessage}) async {
    try {
      final db = await _db;
      await db.update(
        AppConstants.taskTableName,
        {
          'sync_status': AppConstants.syncStatusFailed,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      await _updateSyncStatus(id, AppConstants.syncStatusFailed, errorMessage: errorMessage);
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error marking task as failed: ${e.toString()}',
        operation: 'markTaskAsFailed',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> markTaskAsConflict(String id) async {
    try {
      final db = await _db;
      await db.update(
        AppConstants.taskTableName,
        {
          'sync_status': AppConstants.syncStatusConflict,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      await _updateSyncStatus(id, AppConstants.syncStatusConflict);
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error marking task as conflict: ${e.toString()}',
        operation: 'markTaskAsConflict',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<int> getPendingTasksCount() async {
    try {
      final db = await _db;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.taskTableName} '
        'WHERE sync_status = ? AND is_deleted = ?',
        [AppConstants.syncStatusPending, 0],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error counting pending tasks: ${e.toString()}',
        operation: 'getPendingTasksCount',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> clearAllTasks() async {
    try {
      final db = await _db;
      await db.delete(AppConstants.taskTableName);
      await db.delete(AppConstants.syncStatusTableName);
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error clearing all tasks: ${e.toString()}',
        operation: 'clearAllTasks',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<SyncStatusModel?> getSyncStatus(String entityId) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.syncStatusTableName,
        where: 'entity_id = ?',
        whereArgs: [entityId],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return SyncStatusModel.fromMap(maps.first);
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error fetching sync status: ${e.toString()}',
        operation: 'getSyncStatus',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> saveSyncStatus(SyncStatusModel status) async {
    try {
      final db = await _db;
      await db.insert(
        AppConstants.syncStatusTableName,
        status.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error saving sync status: ${e.toString()}',
        operation: 'saveSyncStatus',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<SyncStatusModel>> getAllSyncStatuses() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.syncStatusTableName,
        orderBy: 'updated_at DESC',
      );
      return maps.map((map) => SyncStatusModel.fromMap(map)).toList();
    } catch (e, st) {
      throw DatabaseException(
        message: 'Error fetching all sync statuses: ${e.toString()}',
        operation: 'getAllSyncStatuses',
        originalException: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _updateSyncStatus(
    String entityId,
    String status, {
    String? errorMessage,
  }) async {
    final db = await _db;
    final existingStatus = await getSyncStatus(entityId);
    final now = DateTime.now();
    
    if (existingStatus != null) {
      SyncStatusModel updatedStatus;
      if (status == AppConstants.syncStatusSynced) {
        updatedStatus = existingStatus.markAsSynced();
      } else if (status == AppConstants.syncStatusFailed) {
        updatedStatus = existingStatus.markAsFailed(errorMessage: errorMessage);
      } else if (status == AppConstants.syncStatusConflict) {
        updatedStatus = existingStatus.markAsConflict();
      } else {
        updatedStatus = existingStatus.copyWith(
          status: status,
          updatedAt: now,
        );
      }
      await db.update(
        AppConstants.syncStatusTableName,
        updatedStatus.toMap(),
        where: 'entity_id = ?',
        whereArgs: [entityId],
      );
    } else {
      final newStatus = SyncStatusModel.create(
        entityType: AppConstants.taskTableName,
        entityId: entityId,
      ).copyWith(status: status, updatedAt: now);
      await db.insert(
        AppConstants.syncStatusTableName,
        newStatus.toMap(),
      );
    }
  }
}

// === ARCHIVO: lib/data/datasources/local/database_helper.dart ===
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_constants.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.databaseName);

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
    await db.execute('''
      CREATE TABLE ${AppConstants.taskTableName} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        due_date INTEGER,
        assigned_to TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT NOT NULL,
        local_modified INTEGER NOT NULL DEFAULT 0,
        server_version INTEGER,
        is_deleted INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.syncStatusTableName} (
        id TEXT PRIMARY KEY,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        last_attempt INTEGER,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        error_message TEXT,
        retry_after INTEGER
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_tasks_sync_status 
      ON ${AppConstants.taskTableName}(sync_status)
    ''');

    await db.execute('''
      CREATE INDEX idx_sync_status_entity 
      ON ${AppConstants.syncStatusTableName}(entity_type, entity_id)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await _performMigration(db, oldVersion, newVersion);
    }
  }

  Future<void> _performMigration(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE ${AppConstants.taskTableName} 
        ADD COLUMN server_version INTEGER
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS task_tags (
          task_id TEXT NOT NULL,
          tag TEXT NOT NULL,
          PRIMARY KEY (task_id, tag),
          FOREIGN KEY (task_id) REFERENCES ${AppConstants.taskTableName}(id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete(AppConstants.taskTableName);
    await db.delete(AppConstants.syncStatusTableName);
  }

  Future<int> getPendingSyncCount() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count 
      FROM ${AppConstants.taskTableName} 
      WHERE sync_status IN (?, ?)
    ''', [AppConstants.syncStatusPending, AppConstants.syncStatusFailed]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> resetDatabase() async {
    await clearAllTables();
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.databaseName);
    await deleteDatabase(path);
    _database = null;
  }
}

// === ARCHIVO: lib/data/datasources/remote/task_remote_datasource.dart ===
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(String id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<List<TaskModel>> syncTasks(List<TaskModel> tasks);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio _dio;

  TaskRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _dio.get(
        '/${AppConstants.apiVersion}/tasks',
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['tasks'] ?? response.data;
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch tasks',
          statusCode: response.statusCode,
          endpoint: '/tasks',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks');
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final response = await _dio.get(
        '/${AppConstants.apiVersion}/tasks/$id',
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw ServerException(
          message: 'Task not found',
          statusCode: 404,
          endpoint: '/tasks/$id',
        );
      } else {
        throw ServerException(
          message: 'Failed to fetch task',
          statusCode: response.statusCode,
          endpoint: '/tasks/$id',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/$id');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _dio.post(
        '/${AppConstants.apiVersion}/tasks',
        data: task.toJson(),
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to create task',
          statusCode: response.statusCode,
          endpoint: '/tasks',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await _dio.put(
        '/${AppConstants.apiVersion}/tasks/${task.id}',
        data: task.toJson(),
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw ServerException(
          message: 'Task not found for update',
          statusCode: 404,
          endpoint: '/tasks/${task.id}',
        );
      } else {
        throw ServerException(
          message: 'Failed to update task',
          statusCode: response.statusCode,
          endpoint: '/tasks/${task.id}',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/${task.id}');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await _dio.delete(
        '/${AppConstants.apiVersion}/tasks/$id',
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Failed to delete task',
          statusCode: response.statusCode,
          endpoint: '/tasks/$id',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/$id');
    }
  }

  @override
  Future<List<TaskModel>> syncTasks(List<TaskModel> tasks) async {
    try {
      final response = await _dio.post(
        '/${AppConstants.apiVersion}/tasks/sync',
        data: {
          'tasks': tasks.map((t) => t.toJson()).toList(),
        },
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout * 2),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout * 2),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['tasks'] ?? response.data;
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to sync tasks',
          statusCode: response.statusCode,
          endpoint: '/tasks/sync',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/sync');
    }
  }

  AppException _handleDioError(DioException e, String endpoint) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timeout while accessing $endpoint',
          url: endpoint,
          isConnectionError: false,
          isTimeout: true,
          isSslError: false,
          originalException: e,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
          url: endpoint,
          isConnectionError: true,
          isTimeout: false,
          isSslError: false,
          originalException: e,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return ServerException(
            message: 'Unauthorized access',
            statusCode: statusCode,
            endpoint: endpoint,
            originalException: e,
          );
        } else if (statusCode == 403) {
          return ServerException(
            message: 'Forbidden access',
            statusCode: statusCode,
            endpoint: endpoint,
            originalException: e,
          );
        } else if (statusCode == 404) {
          return ServerException(
            message: 'Resource not found',
            statusCode: statusCode,
            endpoint: endpoint,
            originalException: e,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: 'Server error',
            statusCode: statusCode,
            endpoint: endpoint,
            originalException: e,
          );
        }
        return ServerException(
          message: 'Bad response from server',
          statusCode: statusCode,
          endpoint: endpoint,
          originalException: e,
        );
      case DioExceptionType.cancel:
        return ServerException(
          message: 'Request cancelled',
          endpoint: endpoint,
          originalException: e,
        );
      default:
        return ServerException(
          message: e.message ?? 'Unknown network error',
          endpoint: endpoint,
          originalException: e,
        );
    }
  }
}

// === ARCHIVO: lib/data/repositories/task_repository_impl.dart ===
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local/task_local_datasource.dart';
import '../datasources/remote/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.uuid,
  });

  @override
  Future<List<TaskEntity>> getTasks() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteTasks = await remoteDataSource.getTasks();
        await localDataSource.cacheTasks(remoteTasks);
        return remoteTasks.map((model) => model.toEntity()).toList();
      } on ServerException {
        return await _getLocalTasks();
      } on NetworkException {
        return await _getLocalTasks();
      }
    } else {
      return await _getLocalTasks();
    }
  }

  Future<List<TaskEntity>> _getLocalTasks() async {
    final localTasks = await localDataSource.getTasks();
    return localTasks.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TaskEntity?> getTaskById(String id) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteTask = await remoteDataSource.getTaskById(id);
        await localDataSource.cacheTask(remoteTask);
        return remoteTask.toEntity();
      } on ServerException {
        return await _getLocalTaskById(id);
      } on NetworkException {
        return await _getLocalTaskById(id);
      }
    } else {
      return await _getLocalTaskById(id);
    }
  }

  Future<TaskEntity?> _getLocalTaskById(String id) async {
    final localTask = await localDataSource.getTaskById(id);
    return localTask?.toEntity();
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final isConnected = await networkInfo.isConnected;
    final now = DateTime.now();
    final taskId = task.id ?? uuid.v4();

    final taskModel = TaskModel(
      id: taskId,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      dueDate: task.dueDate,
      assignedTo: task.assignedTo,
      createdAt: now,
      updatedAt: now,
      syncStatus: isConnected ? AppConstants.syncStatusSynced : AppConstants.syncStatusPending,
      localModified: !isConnected,
      serverVersion: 1,
      isDeleted: false,
    );

    await localDataSource.saveTask(taskModel);

    if (isConnected) {
      try {
        final createdTask = await remoteDataSource.createTask(taskModel);
        await localDataSource.updateTaskSyncStatus(
          taskId,
          AppConstants.syncStatusSynced,
        );
        return createdTask.toEntity();
      } on ServerException {
        await localDataSource.updateTaskSyncStatus(
          taskId,
          AppConstants.syncStatusPending,
        );
        return taskModel.toEntity();
      }
    }

    return taskModel.toEntity();
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    final isConnected = await networkInfo.isConnected;
    final now = DateTime.now();

    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      dueDate: task.dueDate,
      assignedTo: task.assignedTo,
      createdAt: task.createdAt,
      updatedAt: now,
      syncStatus: isConnected ? AppConstants.syncStatusSynced : AppConstants.syncStatusPending,
      localModified: !isConnected,
      serverVersion: task.serverVersion,
      isDeleted: task.isDeleted,
    );

    await localDataSource.updateTask(taskModel);

    if (isConnected) {
      try {
        final updatedTask = await remoteDataSource.updateTask(taskModel);
        await localDataSource.updateTaskSyncStatus(
          task.id!,
          AppConstants.syncStatusSynced,
        );
        return updatedTask.toEntity();
      } on ServerException catch (e) {
        if (e.statusCode == 409) {
          throw ConflictException(
            message: 'Conflict detected during update',
            entityId: task.id!,
            localData: taskModel.toJson(),
            remoteData: null,
            conflictType: 'update',
          );
        }
        await localDataSource.updateTaskSyncStatus(
          task.id!,
          AppConstants.syncStatusPending,
        );
        return taskModel.toEntity();
      }
    }

    return taskModel.toEntity();
  }

  @override
  Future<void> deleteTask(String id) async {
    final isConnected = await networkInfo.isConnected;
    final now = DateTime.now();

    final existingTask = await localDataSource.getTaskById(id);
    if (existingTask == null) {
      throw DatabaseException(
        message: 'Task not found for deletion',
        sql: 'DELETE FROM tasks WHERE id = ?',
      );
    }

    final deletedTask = TaskModel(
      id: existingTask.id,
      title: existingTask.title,
      description: existingTask.description,
      priority: existingTask.priority,
      status: existingTask.status,
      dueDate: existingTask.dueDate,
      assignedTo: existingTask.assignedTo,
      createdAt: existingTask.createdAt,
      updatedAt: now,
      syncStatus: isConnected ? AppConstants.syncStatusSynced : AppConstants.syncStatusPending,
      localModified: !isConnected,
      serverVersion: existingTask.serverVersion,
      isDeleted: true,
    );

    await localDataSource.updateTask(deletedTask);

    if (isConnected) {
      try {
        await remoteDataSource.deleteTask(id);
        await localDataSource.deleteTask(id);
      } on ServerException {
        await localDataSource.updateTaskSyncStatus(
          id,
          AppConstants.syncStatusPending,
        );
      }
    }
  }

  @override
  Future<List<TaskEntity>> getPendingSyncTasks() async {
    final pendingTasks = await localDataSource.getPendingTasks();
    return pendingTasks.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> syncTasks() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      throw NetworkException(
        message: 'No internet connection for sync',
        url: '/sync',
        isConnectionError: true,
        isTimeout: false,
        isSslError: false,
      );
    }

    final pendingTasks = await localDataSource.getPendingTasks();
    if (pendingTasks.isEmpty) return;

    try {
      final syncedTasks = await remoteDataSource.syncTasks(pendingTasks);

      for (final syncedTask in syncedTasks) {
        await localDataSource.updateTaskSyncStatus(
          syncedTask.id,
          AppConstants.syncStatusSynced,
        );
      }
    } on ServerException catch (e) {
      if (e.statusCode == 409) {
        throw ConflictException(
          message: 'Conflict during batch sync',
          entityId: 'batch',
          localData: pendingTasks.map((t) => t.toJson()).toList(),
          remoteData: null,
          conflictType: 'batch_sync',
        );
      }
      for (final task in pendingTasks) {
        await localDataSource.updateTaskSyncStatus(
          task.id,
          AppConstants.syncStatusFailed,
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<TaskEntity>> searchTasks(String query) async {
    final localTasks = await localDataSource.searchTasks(query);
    return localTasks.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<TaskEntity>> getTasksByStatus(String status) async {
    final localTasks = await localDataSource.getTasksByStatus(status);
    return localTasks.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<TaskEntity>> getTasksByPriority(String priority) async {
    final localTasks = await localDataSource.getTasksByPriority(priority);
    return localTasks.map((model) => model.toEntity()).toList();
  }
}


// === ARCHIVO: lib/data/repositories/sync_repository_impl.dart ===
package lib.data.repositories;

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:field_app/core/constants/app_constants.dart';
import 'package:field_app/core/errors/exceptions.dart';
import 'package:field_app/core/network/network_info.dart';
import 'package:field_app/data/datasources/local/task_local_datasource.dart';
import 'package:field_app/data/datasources/remote/task_remote_datasource.dart';
import 'package:field_app/data/models/task_model.dart';
import 'package:field_app/data/models/sync_status_model.dart';
import 'package:field_app/domain/entities/task_entity.dart';
import 'package:field_app/domain/repositories/sync_repository.dart';
import 'package:uuid/uuid.dart';

class SyncRepositoryImpl implements SyncRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;

  SyncRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.uuid,
  });

  @override
  Future<SyncResult> syncAll() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return SyncResult(
        success: false,
        syncedCount: 0,
        failedCount: 0,
        conflicts: [],
        errorMessage: 'No hay conexión a internet',
      );
    }

    final pendingTasks = await localDataSource.getPendingSyncTasks();
    final conflicts = <SyncConflict>[];
    int syncedCount = 0;
    int failedCount = 0;

    for (final task in pendingTasks) {
      try {
        final result = await _syncSingleTask(task);
        if (result.conflict != null) {
          conflicts.add(result.conflict!);
          await localDataSource.updateTaskSyncStatus(
            task.id,
            AppConstants.syncStatusConflict,
          );
        } else if (result.success) {
          syncedCount++;
          await localDataSource.updateTaskSyncStatus(
            task.id,
            AppConstants.syncStatusSynced,
          );
          await _recordSyncOperation(task.id, 'sync', true);
        } else {
          failedCount++;
          await localDataSource.updateTaskSyncStatus(
            task.id,
            AppConstants.syncStatusFailed,
          );
        }
      } catch (e) {
        failedCount++;
        await localDataSource.updateTaskSyncStatus(
          task.id,
          AppConstants.syncStatusFailed,
        );
      }
    }

    await _fetchRemoteChanges();

    return SyncResult(
      success: conflicts.isEmpty && failedCount == 0,
      syncedCount: syncedCount,
      failedCount: failedCount,
      conflicts: conflicts,
    );
  }

  @override
  Future<SyncResult> syncTask(String taskId) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return SyncResult(
        success: false,
        syncedCount: 0,
        failedCount: 1,
        conflicts: [],
        errorMessage: 'No hay conexión a internet',
      );
    }

    final task = await localDataSource.getTaskById(taskId);
    if (task == null) {
      return SyncResult(
        success: false,
        syncedCount: 0,
        failedCount: 1,
        conflicts: [],
        errorMessage: 'Tarea no encontrada',
      );
    }

    final result = await _syncSingleTask(task);
    if (result.conflict != null) {
      await localDataSource.updateTaskSyncStatus(
        taskId,
        AppConstants.syncStatusConflict,
      );
      return SyncResult(
        success: false,
        syncedCount: 0,
        failedCount: 0,
        conflicts: [result.conflict!],
      );
    } else if (result.success) {
      await localDataSource.updateTaskSyncStatus(
        taskId,
        AppConstants.syncStatusSynced,
      );
      await _recordSyncOperation(taskId, 'sync', true);
      return SyncResult(
        success: true,
        syncedCount: 1,
        failedCount: 0,
        conflicts: [],
      );
    } else {
      await localDataSource.updateTaskSyncStatus(
        taskId,
        AppConstants.syncStatusFailed,
      );
      return SyncResult(
        success: false,
        syncedCount: 0,
        failedCount: 1,
        conflicts: [],
        errorMessage: result.errorMessage,
      );
    }
  }

  @override
  Future<List<TaskEntity>> getPendingSyncItems() async {
    final tasks = await localDataSource.getPendingSyncTasks();
    return tasks;
  }

  @override
  Future<SyncResult> resolveConflict({
    required String taskId,
    required ConflictResolutionStrategy strategy,
    TaskEntity? localVersion,
    TaskEntity? remoteVersion,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return SyncResult(
        success: false,
        syncedCount: 0,
        failedCount: 1,
        conflicts: [],
        errorMessage: 'No hay conexión a internet',
      );
    }

    TaskEntity resolvedTask;
    switch (strategy) {
      case ConflictResolutionStrategy.server:
        if (remoteVersion == null) {
          return SyncResult(
            success: false,
            syncedCount: 0,
            failedCount: 1,
            conflicts: [],
            errorMessage: 'Versión remota no disponible',
          );
        }
        resolvedTask = remoteVersion;
        break;
      case ConflictResolutionStrategy.client:
        if (localVersion == null) {
          return SyncResult(
            success: false,
            syncedCount: 0,
            failedCount: 1,
            conflicts: [],
            errorMessage: 'Versión local no disponible',
          );
        }
        resolvedTask = localVersion;
        break;
      case ConflictResolutionStrategy.lastWriteWins:
        final localUpdated = localVersion?.updatedAt ?? DateTime(1970);
        final remoteUpdated = remoteVersion?.updatedAt ?? DateTime(1970);
        resolvedTask = localUpdated.isAfter(remoteUpdated) 
            ? localVersion! 
            : remoteVersion!;
        break;
      case ConflictResolutionStrategy.manual:
        return SyncResult(
          success: false,
          syncedCount: 0,
          failedCount: 0,
          conflicts: [],
          errorMessage: 'Estrategia manual requiere intervención del usuario',
        );
    }

    try {
      await remoteDataSource.updateTask(resolvedTask as TaskModel);
      await localDataSource.updateTask(resolvedTask as TaskModel);
      await localDataSource.updateTaskSyncStatus(
        taskId,
        AppConstants.syncStatusSynced,
      );
      await _recordSyncOperation(taskId, 'resolve_conflict', true);
      return SyncResult(
        success: true,
        syncedCount: 1,
        failedCount: 0,
        conflicts: [],
      );
    } catch (e) {
      return SyncResult(
        success: false,
        syncedCount: 0,
        failedCount: 1,
        conflicts: [],
        errorMessage: 'Error al resolver conflicto: $e',
      );
    }
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    return await localDataSource.getLastSyncTime();
  }

  @override
  Future<void> clearSyncQueue() async {
    await localDataSource.clearPendingSyncTasks();
  }

  Future<_SyncSingleResult> _syncSingleTask(TaskEntity task) async {
    try {
      final remoteTask = await remoteDataSource.getTaskById(task.id);
      
      if (remoteTask != null) {
        final hasConflict = _detectConflict(task, remoteTask);
        if (hasConflict) {
          return _SyncSingleResult(
            success: false,
            conflict: SyncConflict(
              taskId: task.id,
              localVersion: task,
              remoteVersion: remoteTask,
              conflictType: 'update_update',
            ),
          );
        }
      }

      final taskModel = task as TaskModel;
      if (task.syncStatus == AppConstants.syncStatusPending) {
        await remoteDataSource.createTask(taskModel);
      } else {
        await remoteDataSource.updateTask(taskModel);
      }
      return _SyncSingleResult(success: true);
    } on ConflictException catch (e) {
      return _SyncSingleResult(
        success: false,
        conflict: SyncConflict(
          taskId: task.id,
          localVersion: task,
          remoteVersion: e.remoteData as TaskEntity?,
          conflictType: e.conflictType,
        ),
      );
    } on ServerException catch (e) {
      if (e.statusCode == 409) {
        return _SyncSingleResult(
          success: false,
          conflict: SyncConflict(
            taskId: task.id,
            localVersion: task,
            remoteVersion: null,
            conflictType: 'server_conflict',
          ),
        );
      }
      return _SyncSingleResult(
        success: false,
        errorMessage: e.message,
      );
    } catch (e) {
      return _SyncSingleResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  bool _detectConflict(TaskEntity local, TaskEntity remote) {
    if (local.version != remote.version) {
      final localUpdated = local.updatedAt.millisecondsSinceEpoch;
      final remoteUpdated = remote.updatedAt.millisecondsSinceEpoch;
      if (localUpdated != remoteUpdated) {
        return true;
      }
    }
    return false;
  }

  Future<void> _fetchRemoteChanges() async {
    try {
      final lastSync = await getLastSyncTime();
      final remoteTasks = await remoteDataSource.getTasksSince(lastSync);
      
      for (final remoteTask in remoteTasks) {
        final localTask = await localDataSource.getTaskById(remoteTask.id);
        if (localTask == null) {
          await localDataSource.insertTask(remoteTask);
        } else if (localTask.syncStatus == AppConstants.syncStatusSynced) {
          await localDataSource.updateTask(remoteTask);
        } else if (localTask.syncStatus == AppConstants.syncStatusPending) {
          final hasConflict = _detectConflict(localTask, remoteTask);
          if (hasConflict) {
            await localDataSource.updateTaskSyncStatus(
              remoteTask.id,
              AppConstants.syncStatusConflict,
            );
          } else {
            await localDataSource.updateTask(remoteTask);
          }
        }
      }
      
      await localDataSource.updateLastSyncTime(DateTime.now());
    } catch (e) {
      // Log error pero no falla la sincronización
    }
  }

  Future<void> _recordSyncOperation(
    String entityId,
    String operation,
    bool success,
  ) async {
    final syncStatus = SyncStatusModel(
      id: uuid.v4(),
      entityType: 'task',
      entityId: entityId,
      operation: operation,
      status: success ? 'success' : 'failed',
      timestamp: DateTime.now(),
      retryCount: 0,
    );
    await localDataSource.insertSyncStatus(syncStatus);
  }
}

class _SyncSingleResult {
  final bool success;
  final SyncConflict? conflict;
  final String? errorMessage;

  _SyncSingleResult({
    required this.success,
    this.conflict,
    this.errorMessage,
  });
}

class SyncResult extends Equatable {
  final bool success;
  final int syncedCount;
  final int failedCount;
  final List<SyncConflict> conflicts;
  final String? errorMessage;

  const SyncResult({
    required this.success,
    required this.syncedCount,
    required this.failedCount,
    required this.conflicts,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        success,
        syncedCount,
        failedCount,
        conflicts,
        errorMessage,
      ];
}

class SyncConflict extends Equatable {
  final String taskId;
  final TaskEntity localVersion;
  final TaskEntity? remoteVersion;
  final String conflictType;

  const SyncConflict({
    required this.taskId,
    required this.localVersion,
    this.remoteVersion,
    required this.conflictType,
  });

  @override
  List<Object?> get props => [
        taskId,
        localVersion,
        remoteVersion,
        conflictType,
      ];
}

enum ConflictResolutionStrategy {
  server,
  client,
  manual,
  lastWriteWins,
}


// === ARCHIVO: lib/presentation/bloc/task/task_event.dart ===
import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  final bool forceRefresh;
  final bool fromRemote;

  const LoadTasksEvent({
    this.forceRefresh = false,
    this.fromRemote = false,
  });

  @override
  List<Object?> get props => [forceRefresh, fromRemote];
}

class LoadTaskByIdEvent extends TaskEvent {
  final String taskId;

  const LoadTaskByIdEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;

  const AddTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  final bool syncImmediately;

  const UpdateTaskEvent({
    required this.task,
    this.syncImmediately = false,
  });

  @override
  List<Object?> get props => [task, syncImmediately];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  final bool hardDelete;

  const DeleteTaskEvent({
    required this.taskId,
    this.hardDelete = false,
  });

  @override
  List<Object?> get props => [taskId, hardDelete];
}

class RefreshTasksEvent extends TaskEvent {
  final String? filterStatus;
  final String? filterPriority;

  const RefreshTasksEvent({
    this.filterStatus,
    this.filterPriority,
  });

  @override
  List<Object?> get props => [filterStatus, filterPriority];
}

class FilterTasksEvent extends TaskEvent {
  final String? status;
  final String? priority;
  final String? searchQuery;
  final DateTime? dueDateFrom;
  final DateTime? dueDateTo;

  const FilterTasksEvent({
    this.status,
    this.priority,
    this.searchQuery,
    this.dueDateFrom,
    this.dueDateTo,
  });

  @override
  List<Object?> get props => [status, priority, searchQuery, dueDateFrom, dueDateTo];
}

class ClearFiltersEvent extends TaskEvent {
  const ClearFiltersEvent();
}

class SyncTaskEvent extends TaskEvent {
  final String taskId;

  const SyncTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class SyncAllTasksEvent extends TaskEvent {
  const SyncAllTasksEvent();
}

class ResolveTaskConflictEvent extends TaskEvent {
  final String taskId;
  final String resolutionStrategy;

  const ResolveTaskConflictEvent({
    required this.taskId,
    required this.resolutionStrategy,
  });

  @override
  List<Object?> get props => [taskId, resolutionStrategy];
}

class SelectTaskEvent extends TaskEvent {
  final String taskId;

  const SelectTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class DeselectTaskEvent extends TaskEvent {
  final String taskId;

  const DeselectTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class ClearSelectionEvent extends TaskEvent {
  const ClearSelectionEvent();
}

class BulkUpdateTasksEvent extends TaskEvent {
  final List<String> taskIds;
  final Map<String, dynamic> updates;

  const BulkUpdateTasksEvent({
    required this.taskIds,
    required this.updates,
  });

  @override
  List<Object?> get props => [taskIds, updates];
}

class BulkDeleteTasksEvent extends TaskEvent {
  final List<String> taskIds;

  const BulkDeleteTasksEvent({required this.taskIds});

  @override
  List<Object?> get props => [taskIds];
}

class RetryFailedSyncEvent extends TaskEvent {
  const RetryFailedSyncEvent();
}

// === ARCHIVO: lib/presentation/bloc/task/task_state.dart ===
import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  final List<TaskEntity> tasks;
  final List<TaskEntity> filteredTasks;
  final Set<String> selectedTaskIds;
  final bool isLoading;
  final bool isSyncing;
  final String? errorMessage;
  final String? errorCode;
  final DateTime? lastSyncTime;
  final TaskFilter currentFilter;
  final bool hasReachedMax;
  final int totalCount;

  const TaskState({
    this.tasks = const [],
    this.filteredTasks = const [],
    this.selectedTaskIds = const {},
    this.isLoading = false,
    this.isSyncing = false,
    this.errorMessage,
    this.errorCode,
    this.lastSyncTime,
    this.currentFilter = const TaskFilter(),
    this.hasReachedMax = false,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [
        tasks,
        filteredTasks,
        selectedTaskIds,
        isLoading,
        isSyncing,
        errorMessage,
        errorCode,
        lastSyncTime,
        currentFilter,
        hasReachedMax,
        totalCount,
      ];

  TaskState copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  });
}

class TaskInitial extends TaskState {
  const TaskInitial() : super();
}

class TaskLoading extends TaskState {
  const TaskLoading({
    super.tasks,
    super.filteredTasks,
    super.selectedTaskIds,
    super.currentFilter,
  }) : super(isLoading: true);
}

class TaskLoaded extends TaskState {
  const TaskLoaded({
    required super.tasks,
    required super.filteredTasks,
    super.selectedTaskIds,
    super.isSyncing,
    super.errorMessage,
    super.lastSyncTime,
    super.currentFilter,
    super.hasReachedMax,
    super.totalCount,
  });

  @override
  TaskLoaded copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      currentFilter: currentFilter ?? this.currentFilter,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class TaskOperationSuccess extends TaskState {
  final String operation;
  final TaskEntity? affectedTask;
  final List<String>? affectedTaskIds;

  const TaskOperationSuccess({
    required this.operation,
    super.tasks,
    super.filteredTasks,
    super.selectedTaskIds,
    super.isSyncing,
    super.lastSyncTime,
    super.currentFilter,
    this.affectedTask,
    this.affectedTaskIds,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        operation,
        affectedTask,
        affectedTaskIds,
      ];

  @override
  TaskOperationSuccess copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  }) {
    return TaskOperationSuccess(
      operation: operation,
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      currentFilter: currentFilter ?? this.currentFilter,
      affectedTask: affectedTask,
      affectedTaskIds: affectedTaskIds,
    );
  }
}

class TaskError extends TaskState {
  const TaskError({
    required String message,
    String? code,
    super.tasks,
    super.filteredTasks,
    super.selectedTaskIds,
    super.currentFilter,
  }) : super(
          errorMessage: message,
          errorCode: code,
          isLoading: false,
        );

  @override
  TaskError copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  }) {
    return TaskError(
      message: errorMessage ?? this.errorMessage ?? 'Unknown error',
      code: errorCode ?? this.errorCode,
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

class TaskFilter extends Equatable {
  final String? status;
  final String? priority;
  final String? searchQuery;
  final DateTime? dueDateFrom;
  final DateTime? dueDateTo;
  final bool showCompleted;
  final bool showPending;
  final bool showInProgress;

  const TaskFilter({
    this.status,
    this.priority,
    this.searchQuery,
    this.dueDateFrom,
    this.dueDateTo,
    this.showCompleted = true,
    this.showPending = true,
    this.showInProgress = true,
  });

  bool get hasActiveFilters =>
      status != null ||
      priority != null ||
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      dueDateFrom != null ||
      dueDateTo != null;

  @override
  List<Object?> get props => [
        status,
        priority,
        searchQuery,
        dueDateFrom,
        dueDateTo,
        showCompleted,
        showPending,
        showInProgress,
      ];

  TaskFilter copyWith({
    String? status,
    String? priority,
    String? searchQuery,
    DateTime? dueDateFrom,
    DateTime? dueDateTo,
    bool? showCompleted,
    bool? showPending,
    bool? showInProgress,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearSearchQuery = false,
    bool clearDueDateFrom = false,
    bool clearDueDateTo = false,
  }) {
    return TaskFilter(
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      dueDateFrom: clearDueDateFrom ? null : (dueDateFrom ?? this.dueDateFrom),
      dueDateTo: clearDueDateTo ? null : (dueDateTo ?? this.dueDateTo),
      showCompleted: showCompleted ?? this.showCompleted,
      showPending: showPending ?? this.showPending,
      showInProgress: showInProgress ?? this.showInProgress,
    );
  }
}

extension TaskStateCopyWith on TaskState {
  TaskState copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  }) {
    if (this is TaskInitial) {
      return TaskLoaded(
        tasks: tasks ?? const [],
        filteredTasks: filteredTasks ?? const [],
        selectedTaskIds: selectedTaskIds ?? const {},
        isLoading: isLoading ?? false,
        isSyncing: isSyncing ?? false,
        lastSyncTime: lastSyncTime,
        currentFilter: currentFilter ?? const TaskFilter(),
        hasReachedMax: hasReachedMax ?? false,
        totalCount: totalCount ?? 0,
      );
    }
    if (this is TaskLoading) {
      return TaskLoading(
        tasks: tasks ?? this.tasks,
        filteredTasks: filteredTasks ?? this.filteredTasks,
        selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
        currentFilter: currentFilter ?? this.currentFilter,
      );
    }
    if (this is TaskLoaded) {
      return TaskLoaded(
        tasks: tasks ?? this.tasks,
        filteredTasks: filteredTasks ?? this.filteredTasks,
        selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
        isLoading: isLoading ?? this.isLoading,
        isSyncing: isSyncing ?? this.isSyncing,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        errorCode: clearError ? null : (errorCode ?? this.errorCode),
        lastSyncTime: lastSyncTime ?? this.lastSyncTime,
        currentFilter: currentFilter ?? this.currentFilter,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        totalCount: totalCount ?? this.totalCount,
      );
    }
    if (this is TaskOperationSuccess) {
      return TaskOperationSuccess(
        operation: (this as TaskOperationSuccess).operation,
        tasks: tasks ?? this.tasks,
        filteredTasks: filteredTasks ?? this.filteredTasks,
        selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
        isLoading: isLoading ?? this.isLoading,
        isSyncing: isSyncing ?? this.isSyncing,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        errorCode: clearError ? null : (errorCode ?? this.errorCode),
        lastSyncTime: lastSyncTime ?? this.lastSyncTime,
        currentFilter: currentFilter ?? this.currentFilter,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        totalCount: totalCount ?? this.totalCount,
      );
    }
    return TaskError(
      message: errorMessage ?? this.errorMessage ?? 'Unknown error',
      code: errorCode ?? this.errorCode,
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

// === ARCHIVO: lib/presentation/bloc/task/task_bloc.dart ===
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../../domain/usecases/get_local_tasks.dart';
import '../../../domain/usecases/save_task_local.dart';
import '../../../domain/usecases/sync_tasks.dart';
import '../../../domain/usecases/resolve_conflict.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetLocalTasks getLocalTasks;
  final SaveTaskLocal saveTaskLocal;
  final SyncTasks syncTasks;
  final ResolveConflict resolveConflict;
  final TaskRepository taskRepository;
  final NetworkInfo networkInfo;

  static const int _pageSize = 20;
  int _currentPage = 0;

  TaskBloc({
    required this.getLocalTasks,
    required this.saveTaskLocal,
    required this.syncTasks,
    required this.resolveConflict,
    required this.taskRepository,
    required this.networkInfo,
  }) : super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadTaskByIdEvent>(_onLoadTaskById);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<RefreshTasksEvent>(_onRefreshTasks);
    on<FilterTasksEvent>(_onFilterTasks);
    on<ClearFiltersEvent>(_onClearFilters);
    on<SyncTaskEvent>(_onSyncTask);
    on<SyncAllTasksEvent>(_onSyncAllTasks);
    on<ResolveTaskConflictEvent>(_onResolveConflict);
    on<SelectTaskEvent>(_onSelectTask);
    on<DeselectTaskEvent>(_onDeselectTask);
    on<ClearSelectionEvent>(_onClearSelection);
    on<BulkUpdateTasksEvent>(_onBulkUpdateTasks);
    on<BulkDeleteTasksEvent>(_onBulkDeleteTasks);
    on<RetryFailedSyncEvent>(_onRetryFailedSync);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      final isConnected = await networkInfo.isConnected;
      final List<TaskEntity> tasks;

      if (event.fromRemote && isConnected) {
        tasks = await taskRepository.getRemoteTasks();
      } else {
        tasks = await getLocalTasks(
          page: _currentPage,
          pageSize: _pageSize,
        );
      }

      final allTasks = event.forceRefresh ? tasks : [...state.tasks, ...tasks];
      final hasReachedMax = tasks.length < _pageSize;

      final filteredTasks = _applyFilters(allTasks, state.currentFilter);

      emit(TaskLoaded(
        tasks: allTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: state.selectedTaskIds,
        hasReachedMax: hasReachedMax,
        totalCount: allTasks.length,
        lastSyncTime: isConnected ? DateTime.now() : state.lastSyncTime,
        currentFilter: state.currentFilter,
      ));
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al cargar las tareas: ${e.toString()}',
        code: 'LOAD_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onLoadTaskById(
    LoadTaskByIdEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        emit(TaskOperationSuccess(
          operation: 'LOADED',
          affectedTask: task,
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          selectedTaskIds: state.selectedTaskIds,
          currentFilter: state.currentFilter,
        ));
      } else {
        emit(TaskError(
          message: 'Tarea no encontrada',
          code: 'NOT_FOUND',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al cargar la tarea: ${e.toString()}',
        code: 'LOAD_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      await saveTaskLocal(task: event.task);

      final updatedTasks = [event.task, ...state.tasks];
      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

      emit(TaskOperationSuccess(
        operation: 'CREATED',
        affectedTask: event.task,
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: state.selectedTaskIds,
        currentFilter: state.currentFilter,
      ));

      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        add(const SyncAllTasksEvent());
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al crear la tarea: ${e.toString()}',
        code: 'CREATE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      await saveTaskLocal(task: event.task);

      final updatedTasks = state.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();

      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

      emit(TaskOperationSuccess(
        operation: 'UPDATED',
        affectedTask: event.task,
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: state.selectedTaskIds,
        currentFilter: state.currentFilter,
      ));

      final isConnected = await networkInfo.isConnected;
      if (event.syncImmediately && isConnected) {
        add(SyncTaskEvent(taskId: event.task.id));
      } else if (!isConnected) {
        add(const SyncAllTasksEvent());
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al actualizar la tarea: ${e.toString()}',
        code: 'UPDATE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      await taskRepository.deleteTask(event.taskId, hard: event.hardDelete);

      final updatedTasks = state.tasks
          .where((task) => task.id != event.taskId)
          .toList();

      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);
      final updatedSelection = Set<String>.from(state.selectedTaskIds)
        ..remove(event.taskId);

      emit(TaskOperationSuccess(
        operation: 'DELETED',
        affectedTaskIds: [event.taskId],
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: updatedSelection,
        currentFilter: state.currentFilter,
      ));
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al eliminar la tarea: ${e.toString()}',
        code: 'DELETE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onRefreshTasks(
    RefreshTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    _currentPage = 0;
    add(LoadTasksEvent(
      forceRefresh: true,
      fromRemote: false,
    ));

    if (event.filterStatus != null || event.filterPriority != null) {
      add(FilterTasksEvent(
        status: event.filterStatus,
        priority: event.filterPriority,
      ));
    }
  }

  Future<void> _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final newFilter = TaskFilter(
      status: event.status,
      priority: event.priority,
      searchQuery: event.searchQuery,
      dueDateFrom: event.dueDateFrom,
      dueDateTo: event.dueDateTo,
    );

    final filteredTasks = _applyFilters(state.tasks, newFilter);

    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      lastSyncTime: state.lastSyncTime,
      currentFilter: newFilter,
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onClearFilters(
    ClearFiltersEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: state.tasks,
      selectedTaskIds: state.selectedTaskIds,
      lastSyncTime: state.lastSyncTime,
      currentFilter: const TaskFilter(),
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onSyncTask(
    SyncTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(currentState.copyWith(isSyncing: true));
    }

    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        emit(TaskError(
          message: 'No hay conexión a internet para sincronizar',
          code: 'NO_CONNECTION',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
        return;
      }

      final result = await syncTasks(taskIds: [event.taskId]);

      if (result.isSuccess) {
        final updatedTasks = await getLocalTasks(
          page: 0,
          pageSize: state.totalCount,
        );
        final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

        emit(TaskLoaded(
          tasks: updatedTasks,
          filteredTasks: filteredTasks,
          selectedTaskIds: state.selectedTaskIds,
          isSyncing: false,
          lastSyncTime: DateTime.now(),
          currentFilter: state.currentFilter,
          totalCount: updatedTasks.length,
        ));
      } else {
        emit(TaskError(
          message: result.error?.userFriendlyMessage ?? 'Error de sincronización',
          code: result.error?.failureType ?? 'SYNC_ERROR',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al sincronizar la tarea: ${e.toString()}',
        code: 'SYNC_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onSyncAllTasks(
    SyncAllTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(currentState.copyWith(isSyncing: true));
    }

    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        emit(TaskError(
          message: 'No hay conexión a internet para sincronizar',
          code: 'NO_CONNECTION',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
        return;
      }

      final taskIds = state.tasks.map((t) => t.id).toList();
      final result = await syncTasks(taskIds: taskIds);

      if (result.isSuccess) {
        final updatedTasks = await getLocalTasks(
          page: 0,
          pageSize: state.totalCount,
        );
        final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

        emit(TaskLoaded(
          tasks: updatedTasks,
          filteredTasks: filteredTasks,
          selectedTaskIds: state.selectedTaskIds,
          isSyncing: false,
          lastSyncTime: DateTime.now(),
          currentFilter: state.currentFilter,
          totalCount: updatedTasks.length,
        ));
      } else {
        emit(TaskError(
          message: result.error?.userFriendlyMessage ?? 'Error de sincronización',
          code: result.error?.failureType ?? 'SYNC_ERROR',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al sincronizar las tareas: ${e.toString()}',
        code: 'SYNC_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onResolveConflict(
    ResolveTaskConflictEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      final result = await resolveConflict(
        entityId: event.taskId,
        strategy: event.resolutionStrategy,
      );

      if (result.isSuccess) {
        final updatedTasks = await getLocalTasks(
          page: 0,
          pageSize: state.totalCount,
        );
        final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

        emit(TaskOperationSuccess(
          operation: 'CONFLICT_RESOLVED',
          tasks: updatedTasks,
          filteredTasks: filteredTasks,
          selectedTaskIds: state.selectedTaskIds,
          currentFilter: state.currentFilter,
        ));
      } else {
        emit(TaskError(
          message: result.error?.userFriendlyMessage ?? 'Error al resolver conflicto',
          code: result.error?.failureType ?? 'CONFLICT_ERROR',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al resolver el conflicto: ${e.toString()}',
        code: 'CONFLICT_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onSelectTask(
    SelectTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final updatedSelection = Set<String>.from(state.selectedTaskIds)
      ..add(event.taskId);

    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: updatedSelection,
      lastSyncTime: state.lastSyncTime,
      currentFilter: state.currentFilter,
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onDeselectTask(
    DeselectTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final updatedSelection = Set<String>.from(state.selectedTaskIds)
      ..remove(event.taskId);

    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: updatedSelection,
      lastSyncTime: state.lastSyncTime,
      currentFilter: state.currentFilter,
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onClearSelection(
    ClearSelectionEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: const {},
      lastSyncTime: state.lastSyncTime,
      currentFilter: state.currentFilter,
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onBulkUpdateTasks(
    BulkUpdateTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      for (final taskId in event.taskIds) {
        final task = state.tasks.firstWhere((t) => t.id == taskId);
        final updatedTask = task.copyWith(
          ...event.updates.map((key, value) => MapEntry(
            key == 'status' ? 'status' : key,
            value,
          )),
        );
        await saveTaskLocal(task: updatedTask);
      }

      final updatedTasks = state.tasks.map((task) {
        if (event.taskIds.contains(task.id)) {
          return task.copyWith(
            ...event.updates.map((key, value) => MapEntry(key, value)),
          );
        }
        return task;
      }).toList();

      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

      emit(TaskOperationSuccess(
        operation: 'BULK_UPDATED',
        affectedTaskIds: event.taskIds,
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: state.selectedTaskIds,
        currentFilter: state.currentFilter,
      ));

      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        add(const SyncAllTasksEvent());
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error en actualización masiva: ${e.toString()}',
        code: 'BULK_UPDATE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onBulkDeleteTasks(
    BulkDeleteTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      for (final taskId in event.taskIds) {
        await taskRepository.deleteTask(taskId, hard: true);
      }

      final updatedTasks = state.tasks
          .where((task) => !event.taskIds.contains(task.id))
          .toList();

      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

      emit(TaskOperationSuccess(
        operation: 'BULK_DELETED',
        affectedTaskIds: event.taskIds,
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: const {},
        currentFilter: state.currentFilter,
      ));
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error en eliminación masiva: ${e.toString()}',
        code: 'BULK_DELETE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onRetryFailedSync(
    RetryFailedSyncEvent event,
    Emitter<TaskState> emit,
  ) async {
    final failedTasks = state.tasks
        .where((task) => task.syncStatus == 'failed')
        .map((task) => task.id)
        .toList();

    if (failedTasks.isEmpty) {
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      final result = await syncTasks(taskIds: failedTasks);
      if (result.isSuccess) {
        add(const LoadTasksEvent(forceRefresh: true));
      }
    }
  }

  List<TaskEntity> _applyFilters(
    List<TaskEntity> tasks,
    TaskFilter filter,
  ) {
    var filtered = tasks;

    if (filter.status != null) {
      filtered = filtered.where((t) => t.status == filter.status).toList();
    }

    if (filter.priority != null) {
      filtered = filtered.where((t) => t.priority == filter.priority).toList();
    }

    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(query) ||
            (t.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (filter.dueDateFrom != null) {
      filtered = filtered.where((t) {
        return t.dueDate != null && t.dueDate!.isAfter(filter.dueDateFrom!);
      }).toList();
    }

    if (filter.dueDateTo != null) {
      filtered = filtered.where((t) {
        return t.dueDate != null && t.dueDate!.isBefore(filter.dueDateTo!);
      }).toList();
    }

    if (!filter.showCompleted) {
      filtered = filtered.where((t) => t.status != 'completed').toList();
    }

    if (!filter.showPending) {
      filtered = filtered.where((t) => t.status != 'pending').toList();
    }

    if (!filter.showInProgress) {
      filtered = filtered.where((t) => t.status != 'in_progress').toList();
    }

    return filtered;
  }
}


// === ARCHIVO: lib/presentation/bloc/sync/sync_event.dart ===
import 'package:equatable/equatable.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

class ConnectionChangedEvent extends SyncEvent {
  final bool isConnected;
  final String? connectionType;

  const ConnectionChangedEvent({
    required this.isConnected,
    this.connectionType,
  });

  @override
  List<Object?> get props => [isConnected, connectionType];
}

class SyncRequestedEvent extends SyncEvent {
  final bool forceFullSync;

  const SyncRequestedEvent({
    this.forceFullSync = false,
  });

  @override
  List<Object?> get props => [forceFullSync];
}

class SyncStartedEvent extends SyncEvent {
  final int pendingItemsCount;

  const SyncStartedEvent({
    required this.pendingItemsCount,
  });

  @override
  List<Object?> get props => [pendingItemsCount];
}

class SyncProgressEvent extends SyncEvent {
  final int processedItems;
  final int totalItems;
  final String? currentItemId;

  const SyncProgressEvent({
    required this.processedItems,
    required this.totalItems,
    this.currentItemId,
  });

  double get progressPercentage =>
      totalItems > 0 ? (processedItems / totalItems) * 100 : 0;

  @override
  List<Object?> get props => [processedItems, totalItems, currentItemId];
}

class SyncCompletedEvent extends SyncEvent {
  final int syncedItemsCount;
  final Duration syncDuration;
  final List<String>? conflictIds;

  const SyncCompletedEvent({
    required this.syncedItemsCount,
    required this.syncDuration,
    this.conflictIds,
  });

  @override
  List<Object?> get props => [syncedItemsCount, syncDuration, conflictIds];
}

class SyncFailedEvent extends SyncEvent {
  final String errorMessage;
  final String? errorCode;
  final int retryCount;
  final bool canRetry;

  const SyncFailedEvent({
    required this.errorMessage,
    this.errorCode,
    this.retryCount = 0,
    this.canRetry = true,
  });

  @override
  List<Object?> get props => [errorMessage, errorCode, retryCount, canRetry];
}

class ConflictDetectedEvent extends SyncEvent {
  final String entityId;
  final String entityType;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final String conflictType;

  const ConflictDetectedEvent({
    required this.entityId,
    required this.entityType,
    required this.localVersion,
    required this.remoteVersion,
    required this.conflictType,
  });

  @override
  List<Object?> get props =>
      [entityId, entityType, localVersion, remoteVersion, conflictType];
}

class ConflictResolvedEvent extends SyncEvent {
  final String entityId;
  final String resolutionStrategy;
  final dynamic resolvedVersion;

  const ConflictResolvedEvent({
    required this.entityId,
    required this.resolutionStrategy,
    required this.resolvedVersion,
  });

  @override
  List<Object?> get props => [entityId, resolutionStrategy, resolvedVersion];
}

class SyncStatusCheckEvent extends SyncEvent {
  const SyncStatusCheckEvent();
}

class RetrySyncEvent extends SyncEvent {
  const RetrySyncEvent();
}

// === ARCHIVO: lib/presentation/bloc/sync/sync_state.dart ===
import 'package:equatable/equatable.dart';
import '../../../domain/entities/sync_status_entity.dart';

abstract class SyncState extends Equatable {
  final bool isConnected;
  final String? connectionType;
  final DateTime? lastSyncTime;
  final int pendingChangesCount;

  const SyncState({
    required this.isConnected,
    this.connectionType,
    this.lastSyncTime,
    this.pendingChangesCount = 0,
  });

  @override
  List<Object?> get props => [
        isConnected,
        connectionType,
        lastSyncTime,
        pendingChangesCount,
      ];
}

class SyncInitial extends SyncState {
  const SyncInitial()
      : super(
          isConnected: false,
          pendingChangesCount: 0,
        );
}

class SyncOffline extends SyncState {
  const SyncOffline({
    super.lastSyncTime,
    super.pendingChangesCount,
  }) : super(isConnected: false, connectionType: null);

  @override
  List<Object?> get props => [
        ...super.props,
        'offline',
      ];
}

class SyncOnline extends SyncState {
  const SyncOnline({
    super.connectionType,
    super.lastSyncTime,
    super.pendingChangesCount,
  }) : super(isConnected: true);

  bool get hasPendingChanges => pendingChangesCount > 0;

  @override
  List<Object?> get props => [
        ...super.props,
        'online',
      ];
}

class SyncInProgress extends SyncState {
  final int totalItems;
  final int processedItems;
  final String? currentItemId;
  final String? currentOperation;
  final DateTime startTime;

  const SyncInProgress({
    required super.isConnected,
    super.connectionType,
    required this.totalItems,
    required this.processedItems,
    this.currentItemId,
    this.currentOperation,
    required this.startTime,
    super.lastSyncTime,
    super.pendingChangesCount,
  });

  double get progressPercentage =>
      totalItems > 0 ? (processedItems / totalItems) * 100 : 0;

  Duration get elapsedTime => DateTime.now().difference(startTime);

  @override
  List<Object?> get props => [
        ...super.props,
        totalItems,
        processedItems,
        currentItemId,
        currentOperation,
        startTime,
      ];
}

class SyncCompleted extends SyncState {
  final int syncedItemsCount;
  final Duration syncDuration;
  final List<String>? conflictIds;
  final bool hasConflicts;

  const SyncCompleted({
    required this.syncedItemsCount,
    required this.syncDuration,
    this.conflictIds,
    super.lastSyncTime,
    super.pendingChangesCount = 0,
  })  : hasConflicts = conflictIds != null && conflictIds.isNotEmpty,
        super(isConnected: true);

  @override
  List<Object?> get props => [
        ...super.props,
        syncedItemsCount,
        syncDuration,
        conflictIds,
        hasConflicts,
      ];
}

class SyncFailure extends SyncState {
  final String errorMessage;
  final String? errorCode;
  final int retryCount;
  final bool canRetry;
  final List<SyncStatusEntity>? failedItems;

  const SyncFailure({
    required this.errorMessage,
    this.errorCode,
    this.retryCount = 0,
    this.canRetry = true,
    this.failedItems,
    super.isConnected,
    super.connectionType,
    super.lastSyncTime,
    super.pendingChangesCount,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        errorMessage,
        errorCode,
        retryCount,
        canRetry,
        failedItems,
      ];
}

class SyncConflict extends SyncState {
  final String entityId;
  final String entityType;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final String conflictType;
  final List<SyncStatusEntity> pendingSyncItems;

  const SyncConflict({
    required this.entityId,
    required this.entityType,
    required this.localVersion,
    required this.remoteVersion,
    required this.conflictType,
    required this.pendingSyncItems,
    super.isConnected,
    super.connectionType,
    super.lastSyncTime,
    super.pendingChangesCount,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        entityId,
        entityType,
        localVersion,
        remoteVersion,
        conflictType,
        pendingSyncItems,
      ];
}

class SyncWaitingForRetry extends SyncState {
  final DateTime? nextRetryAt;
  final int currentRetryCount;
  final String lastError;

  const SyncWaitingForRetry({
    this.nextRetryAt,
    this.currentRetryCount = 0,
    required this.lastError,
    super.isConnected,
    super.connectionType,
    super.lastSyncTime,
    super.pendingChangesCount,
  });

  Duration? get timeUntilRetry =>
      nextRetryAt != null ? nextRetryAt!.difference(DateTime.now()) : null;

  bool get canRetryNow =>
      nextRetryAt == null || DateTime.now().isAfter(nextRetryAt!);

  @override
  List<Object?> get props => [
        ...super.props,
        nextRetryAt,
        currentRetryCount,
        lastError,
      ];
}

// === ARCHIVO: lib/presentation/bloc/sync/sync_bloc.dart ===
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/network/network_info.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/usecases/sync_tasks.dart';
import '../../../domain/usecases/resolve_conflict.dart';
import '../../../domain/repositories/sync_repository.dart';
import '../../../domain/entities/sync_status_entity.dart';
import '../../../core/constants/app_constants.dart';
import 'sync_event.dart';
import 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final NetworkInfo networkInfo;
  final SyncTasks syncTasksUseCase;
  final ResolveConflict resolveConflictUseCase;
  final SyncRepository syncRepository;

  StreamSubscription<bool>? _connectivitySubscription;
  Timer? _retryTimer;
  Timer? _periodicSyncTimer;
  int _retryCount = 0;
  DateTime? _lastSyncTime;

  SyncBloc({
    required this.networkInfo,
    required this.syncTasksUseCase,
    required this.resolveConflictUseCase,
    required this.syncRepository,
  }) : super(const SyncInitial()) {
    on<SyncStatusCheckEvent>(_onSyncStatusCheck);
    on<ConnectionChangedEvent>(_onConnectionChanged);
    on<SyncRequestedEvent>(_onSyncRequested);
    on<SyncStartedEvent>(_onSyncStarted);
    on<SyncProgressEvent>(_onSyncProgress);
    on<SyncCompletedEvent>(_onSyncCompleted);
    on<SyncFailedEvent>(_onSyncFailed);
    on<ConflictDetectedEvent>(_onConflictDetected);
    on<ConflictResolvedEvent>(_onConflictResolved);
    on<RetrySyncEvent>(_onRetrySync);

    _initializeConnectivityListener();
    _initializePeriodicSync();
  }

  void _initializeConnectivityListener() {
    _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
      (isConnected) {
        add(ConnectionChangedEvent(
          isConnected: isConnected,
          connectionType: isConnected ? 'network' : null,
        ));
      },
    );
  }

  void _initializePeriodicSync() {
    if (AppConstants.enableAutoSync) {
      _periodicSyncTimer = Timer.periodic(
        AppConstants.networkCheckInterval,
        (_) => _checkAndSync(),
      );
    }
  }

  Future<void> _checkAndSync() async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected && AppConstants.enableAutoSync) {
      final pendingCount = await _getPendingChangesCount();
      if (pendingCount > 0) {
        add(const SyncRequestedEvent());
      }
    }
  }

  Future<int> _getPendingChangesCount() async {
    try {
      final pendingItems = await syncRepository.getPendingSyncItems();
      return pendingItems.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _onSyncStatusCheck(
    SyncStatusCheckEvent event,
    Emitter<SyncState> emit,
  ) async {
    try {
      final isConnected = await networkInfo.isConnected;
      final pendingCount = await _getPendingChangesCount();

      if (isConnected) {
        final connectivityResult = await networkInfo.connectivityResult;
        emit(SyncOnline(
          connectionType: connectivityResult.name,
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: pendingCount,
        ));
      } else {
        emit(SyncOffline(
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: pendingCount,
        ));
      }
    } catch (e) {
      emit(SyncFailure(
        errorMessage: 'Failed to check sync status: ${e.toString()}',
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
      ));
    }
  }

  Future<void> _onConnectionChanged(
    ConnectionChangedEvent event,
    Emitter<SyncState> emit,
  ) async {
    if (event.isConnected) {
      final pendingCount = await _getPendingChangesCount();
      emit(SyncOnline(
        connectionType: event.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: pendingCount,
      ));

      if (pendingCount > 0 && AppConstants.enableAutoSync) {
        add(const SyncRequestedEvent());
      }
    } else {
      emit(SyncOffline(
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    }
  }

  Future<void> _onSyncRequested(
    SyncRequestedEvent event,
    Emitter<SyncState> emit,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      emit(SyncOffline(
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
      return;
    }

    try {
      final pendingCount = await _getPendingChangesCount();
      if (pendingCount == 0) {
        emit(SyncOnline(
          connectionType: state.connectionType,
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: 0,
        ));
        return;
      }

      add(SyncStartedEvent(pendingItemsCount: pendingCount));

      final result = await syncTasksUseCase(
        forceFullSync: event.forceFullSync,
      );

      result.fold(
        (failure) {
          add(SyncFailedEvent(
            errorMessage: failure.userFriendlyMessage,
            errorCode: failure.code,
            retryCount: _retryCount,
            canRetry: failure.isRecoverable,
          ));
        },
        (syncResult) {
          _lastSyncTime = DateTime.now();
          _retryCount = 0;

          add(SyncCompletedEvent(
            syncedItemsCount: syncResult.syncedCount,
            syncDuration: syncResult.duration,
            conflictIds: syncResult.conflictIds,
          ));
        },
      );
    } catch (e) {
      add(SyncFailedEvent(
        errorMessage: 'Sync failed: ${e.toString()}',
        retryCount: _retryCount,
        canRetry: true,
      ));
    }
  }

  Future<void> _onSyncStarted(
    SyncStartedEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(SyncInProgress(
      isConnected: state.isConnected,
      connectionType: state.connectionType,
      totalItems: event.pendingItemsCount,
      processedItems: 0,
      currentOperation: 'Initializing sync...',
      startTime: DateTime.now(),
      lastSyncTime: _lastSyncTime,
      pendingChangesCount: event.pendingItemsCount,
    ));
  }

  Future<void> _onSyncProgress(
    SyncProgressEvent event,
    Emitter<SyncState> emit,
  ) async {
    if (state is SyncInProgress) {
      final currentState = state as SyncInProgress;
      emit(SyncInProgress(
        isConnected: currentState.isConnected,
        connectionType: currentState.connectionType,
        totalItems: event.totalItems,
        processedItems: event.processedItems,
        currentItemId: event.currentItemId,
        currentOperation: 'Syncing item ${event.processedItems}/${event.totalItems}',
        startTime: currentState.startTime,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: currentState.pendingChangesCount,
      ));
    }
  }

  Future<void> _onSyncCompleted(
    SyncCompletedEvent event,
    Emitter<SyncState> emit,
  ) async {
    final pendingCount = await _getPendingChangesCount();

    if (event.conflictIds != null && event.conflictIds!.isNotEmpty) {
      emit(SyncCompleted(
        syncedItemsCount: event.syncedItemsCount,
        syncDuration: event.syncDuration,
        conflictIds: event.conflictIds,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: pendingCount,
      ));
    } else {
      emit(SyncCompleted(
        syncedItemsCount: event.syncedItemsCount,
        syncDuration: event.syncDuration,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: pendingCount,
      ));
    }
  }

  Future<void> _onSyncFailed(
    SyncFailedEvent event,
    Emitter<SyncState> emit,
  ) async {
    _retryCount = event.retryCount;

    if (event.canRetry && _retryCount < AppConstants.maxRetryAttempts) {
      final nextRetry = DateTime.now().add(
        Duration(milliseconds: AppConstants.retryDelayMilliseconds),
      );

      emit(SyncWaitingForRetry(
        nextRetryAt: nextRetry,
        currentRetryCount: _retryCount,
        lastError: event.errorMessage,
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));

      _scheduleRetry(nextRetry);
    } else {
      emit(SyncFailure(
        errorMessage: event.errorMessage,
        errorCode: event.errorCode,
        retryCount: _retryCount,
        canRetry: false,
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    }
  }

  void _scheduleRetry(DateTime nextRetryAt) {
    _retryTimer?.cancel();
    final delay = nextRetryAt.difference(DateTime.now());
    if (delay.isNegative) {
      add(const RetrySyncEvent());
      return;
    }

    _retryTimer = Timer(delay, () {
      add(const RetrySyncEvent());
    });
  }

  Future<void> _onRetrySync(
    RetrySyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    add(SyncRequestedEvent(forceFullSync: false));
  }

  Future<void> _onConflictDetected(
    ConflictDetectedEvent event,
    Emitter<SyncState> emit,
  ) async {
    try {
      final pendingItems = await syncRepository.getPendingSyncItems();

      emit(SyncConflict(
        entityId: event.entityId,
        entityType: event.entityType,
        localVersion: event.localVersion,
        remoteVersion: event.remoteVersion,
        conflictType: event.conflictType,
        pendingSyncItems: pendingItems,
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    } catch (e) {
      emit(SyncFailure(
        errorMessage: 'Failed to handle conflict: ${e.toString()}',
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    }
  }

  Future<void> _onConflictResolved(
    ConflictResolvedEvent event,
    Emitter<SyncState> emit,
  ) async {
    try {
      await resolveConflictUseCase(
        entityId: event.entityId,
        resolutionStrategy: event.resolutionStrategy,
        resolvedData: event.resolvedVersion,
      );

      final pendingCount = await _getPendingChangesCount();

      if (state.isConnected) {
        emit(SyncOnline(
          connectionType: state.connectionType,
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: pendingCount,
        ));
      } else {
        emit(SyncOffline(
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: pendingCount,
        ));
      }
    } catch (e) {
      emit(SyncFailure(
        errorMessage: 'Failed to resolve conflict: ${e.toString()}',
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _retryTimer?.cancel();
    _periodicSyncTimer?.cancel();
    return super.close();
  }
}


// === ARCHIVO: lib/presentation/pages/home_page.dart ===
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

// === ARCHIVO: lib/presentation/pages/task_list_page.dart ===
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

// === ARCHIVO: lib/presentation/pages/task_detail_page.dart ===
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
// === ARCHIVO: lib/presentation/widgets/sync_indicator.dart ===
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/sync/sync_bloc.dart';
import '../bloc/sync/sync_state.dart';

enum SyncIndicatorStyle { compact, detailed, animated }

class SyncIndicator extends StatelessWidget {
  final SyncIndicatorStyle style;
  final bool showLabel;
  final double size;

  const SyncIndicator({
    super.key,
    this.style = SyncIndicatorStyle.compact,
    this.showLabel = true,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, state) {
        switch (style) {
          case SyncIndicatorStyle.compact:
            return _buildCompactIndicator(state);
          case SyncIndicatorStyle.detailed:
            return _buildDetailedIndicator(context, state);
          case SyncIndicatorStyle.animated:
            return _buildAnimatedIndicator(state);
        }
      },
    );
  }

  Widget _buildCompactIndicator(SyncState state) {
    final (icon, color, tooltip) = _getSyncData(state);
    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }

  Widget _buildDetailedIndicator(BuildContext context, SyncState state) {
    final (icon, color, tooltip) = _getSyncData(state);
    final pendingCount = state is SyncInProgress
        ? (state as SyncInProgress).pendingCount
        : 0;
    final failedCount = state is SyncFailed
        ? (state as SyncFailed).failedCount
        : 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tooltip,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              if (pendingCount > 0 || failedCount > 0)
                Text(
                  '${pendingCount > 0 ? "$pendingCount pending" : ""}'
                  '${pendingCount > 0 && failedCount > 0 ? ", " : ""}'
                  '${failedCount > 0 ? "$failedCount failed" : ""}',
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIndicator(SyncState state) {
    final (icon, color, tooltip) = _getSyncData(state);
    final isSyncing = state is SyncInProgress;

    return Tooltip(
      message: tooltip,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: isSyncing
            ? _AnimatedSyncIcon(color: color, size: size)
            : Icon(icon, color: color, size: size),
      ),
    );
  }

  (IconData, Color, String) _getSyncData(SyncState state) {
    if (state is SyncInitial) {
      return (
        Icons.cloud_queue,
        Colors.grey,
        'Not synced',
      );
    } else if (state is SyncInProgress) {
      return (
        Icons.sync,
        AppConstants.primaryColor,
        'Syncing... ${state.pendingCount} items',
      );
    } else if (state is SyncSuccess) {
      return (
        Icons.cloud_done,
        Colors.green,
        'Synced successfully',
      );
    } else if (state is SyncFailed) {
      return (
        Icons.cloud_off,
        AppConstants.errorColor,
        'Sync failed - ${state.failedCount} errors',
      );
    } else if (state is SyncOffline) {
      return (
        Icons.cloud_off,
        Colors.orange,
        'Offline - changes saved locally',
      );
    } else if (state is SyncConflict) {
      return (
        Icons.warning_amber_rounded,
        Colors.purple,
        '${state.conflictCount} conflicts need resolution',
      );
    }
    return (
      Icons.cloud_queue,
      Colors.grey,
      'Unknown status',
    );
  }
}

class _AnimatedSyncIcon extends StatefulWidget {
  final Color color;
  final double size;

  const _AnimatedSyncIcon({required this.color, required this.size});

  @override
  State<_AnimatedSyncIcon> createState() => _AnimatedSyncIconState();
}

class _AnimatedSyncIconState extends State<_AnimatedSyncIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        Icons.sync,
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}

class SyncStatusBadge extends StatelessWidget {
  final String syncStatus;
  final bool showCount;
  final int? count;

  const SyncStatusBadge({
    super.key,
    required this.syncStatus,
    this.showCount = false,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = _getStatusData();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            showCount && count != null ? '$label ($count)' : label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color, String) _getStatusData() {
    switch (syncStatus) {
      case AppConstants.syncStatusSynced:
        return (Icons.check_circle, Colors.green, 'Synced');
      case AppConstants.syncStatusPending:
        return (Icons.schedule, Colors.orange, 'Pending');
      case AppConstants.syncStatusFailed:
        return (Icons.error, AppConstants.errorColor, 'Failed');
      case AppConstants.syncStatusConflict:
        return (Icons.warning, Colors.purple, 'Conflict');
      default:
        return (Icons.help, Colors.grey, 'Unknown');
    }
  }
}

class SyncProgressIndicator extends StatelessWidget {
  final double progress;
  final String? label;
  final bool showPercentage;

  const SyncProgressIndicator({
    super.key,
    required this.progress,
    this.label,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showPercentage)
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              AppConstants.primaryColor,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
// === ARCHIVO: lib/presentation/widgets/offline_banner.dart ===
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/sync/sync_bloc.dart';
import '../bloc/sync/sync_state.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final VoidCallback? onRetry;
  final bool showRetryButton;
  final Duration? autoHideDuration;

  const OfflineBanner({
    super.key,
    required this.isOffline,
    this.onRetry,
    this.showRetryButton = true,
    this.autoHideDuration,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isOffline ? 56 : 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isOffline ? 1.0 : 0.0,
        child: Material(
          color: Colors.orange[800],
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'You are offline',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Changes will sync when connection is restored',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showRetryButton)
                    TextButton(
                      onPressed: onRetry,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OfflineBannerWithSyncStatus extends StatelessWidget {
  final bool isOffline;
  final VoidCallback? onRetry;
  final VoidCallback? onResolveConflicts;

  const OfflineBannerWithSyncStatus({
    super.key,
    required this.isOffline,
    this.onRetry,
    this.onResolveConflicts,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, syncState) {
        if (isOffline) {
          return _buildOfflineBanner();
        }

        if (syncState is SyncConflict) {
          return _buildConflictBanner(context, syncState);
        }

        if (syncState is SyncFailed) {
          return _buildFailedBanner(context, syncState);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      color: Colors.orange[800],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'No internet connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Your changes are saved locally and will sync automatically',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConflictBanner(BuildContext context, SyncConflict state) {
    return Container(
      color: Colors.purple[700],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${state.conflictCount} conflict${state.conflictCount > 1 ? 's' : ''} detected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Some items have conflicting changes that need review',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onResolveConflicts,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple[700],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Resolve',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailedBanner(BuildContext context, SyncFailed state) {
    return Container(
      color: AppConstants.errorColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.sync_problem, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sync failed',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${state.failedCount} item${state.failedCount > 1 ? 's' : ''} could not be synced',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionStatusIndicator extends StatelessWidget {
  final bool isConnected;
  final bool showLabel;
  final double iconSize;

  const ConnectionStatusIndicator({
    super.key,
    required this.isConnected,
    this.showLabel = true,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isConnected ? Colors.green : Colors.red,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 6),
          Text(
            isConnected ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 12,
              color: isConnected ? Colors.green[700] : Colors.red[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class OfflineModeDialog extends StatelessWidget {
  final VoidCallback? onContinueOffline;
  final VoidCallback? onWaitForConnection;

  const OfflineModeDialog({
    super.key,
    this.onContinueOffline,
    this.onWaitForConnection,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.orange[700]),
          const SizedBox(width: 8),
          const Text('No Connection'),
        ],
      ),
      content: const Text(
        'You are currently offline. You can continue working with local data, '
        'or wait for the connection to be restored to sync automatically.',
      ),
      actions: [
        TextButton(
          onPressed: onWaitForConnection,
          child: const Text('Wait for Connection'),
        ),
        ElevatedButton(
          onPressed: onContinueOffline,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Continue Offline'),
        ),
      ],
    );
  }
}


// === ARCHIVO: docs/arquitectura_offline_first.md ===
# Arquitectura Offline-First para Aplicación de Campo

## 1. Resumen Ejecutivo

Este documento describe la arquitectura offline-first implementada en la aplicación de campo para logística. El objetivo principal es permitir que los trabajadores realicen sus tareas en áreas remotas sin dependencia de conectividad constante, sincronizando datos cuando la conexión se restablezca.

## 2. Principios Fundamentales

### 2.1 Filosofía Offline-First
La aplicación sigue el patrón offline-first donde:
- **Los datos locales son la fuente primaria de verdad** para el usuario
- **La conectividad es un lujo**, no una necesidad
- **La sincronización ocurre en segundo plano** de forma transparente
- **Los conflictos se detectan y resuelven** de manera automática o manual

### 2.2 Objetivos de Arquitectura
- Tolerancia a fallos de red completa
- Consistencia eventual de datos garantizada
- Experiencia de usuario fluida sin importar el estado de conexión
- Capacidad de trabajo en modo completamente desconectado
- Sincronización eficiente minimizando consumo de datos

## 3. Arquitectura de Componentes

### 3.1 Capas de la Aplicación

```
┌─────────────────────────────────────────────────┐
│                 PRESENTATION                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   Pages     │  │   Widgets   │  │  Blocs  │ │
│  └─────────────┘  └─────────────┘  └─────────┘ │
├─────────────────────────────────────────────────┤
│                   DOMAIN                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │  Entities   │  │ Repositories│  │ UseCases│ │
│  └─────────────┘  └─────────────┘  └─────────┘ │
├─────────────────────────────────────────────────┤
│                    DATA                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   Models    │  │DataSources  │  │Repository│ │
│  └─────────────┘  └─────────────┘  │ Impls   │ │
│                                     └─────────┘ │
├─────────────────────────────────────────────────┤
│                 INFRASTRUCTURE                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │  SQLite DB  │  │  Dio HTTP   │  │Connectiv.│ │
│  └─────────────┘  └─────────────┘  └─────────┘ │
└─────────────────────────────────────────────────┘
```

### 3.2 Componentes Clave

#### Capa de Presentación (Presentation Layer)
- **TaskBloc**: Gestiona el estado de las tareas locales
- **SyncBloc**: Controla el estado de sincronización
- **Pages**: UI que consume los blocs
- **Widgets**: Componentes reutilizables con estado de sincronización

#### Capa de Dominio (Domain Layer)
- **TaskEntity**: Entidad de dominio representando una tarea
- **SyncStatusEntity**: Estado de sincronización de cada entidad
- **TaskRepository**: Contrato abstracto para acceso a tareas
- **UseCases**: GetLocalTasks, SaveTaskLocal, SyncTasks, ResolveConflict

#### Capa de Datos (Data Layer)
- **TaskModel**: Modelo de datos con serialización JSON
- **TaskLocalDataSource**: Acceso a SQLite
- **TaskRemoteDataSource**: Acceso a API REST via Dio
- **TaskRepositoryImpl**: Implementación del repositorio

#### Capa de Infraestructura (Infrastructure Layer)
- **DatabaseHelper**: Gestión de SQLite
- **NetworkInfo**: Detección de conectividad
- **Dio Client**: Cliente HTTP configurado

## 4. Flujo de Datos

### 4.1 Operación de Lectura
1. UI solicita tareas al TaskBloc
2. TaskBloc invoca GetLocalTasks
3. GetLocalTasks consulta TaskRepository
4. TaskRepository obtiene datos de TaskLocalDataSource (SQLite)
5. Datos se retornan a la UI inmediatamente
6. En paralelo, si hay conexión, se verifica si hay actualizaciones del servidor

### 4.2 Operación de Escritura
1. Usuario crea/modifica una tarea en la UI
2. TaskBloc envía evento SaveTaskLocal
3. SaveTaskLocal ejecuta:
   a. Guarda en SQLite con sync_status = 'pending'
   b. Registra operación en sync_status_table
4. UI se actualiza inmediatamente mostrando datos locales
5. SyncBloc detecta cambio pendiente y programa sincronización

### 4.3 Proceso de Synchronización
1. SyncBloc detecta conexión disponible
2. Invoca SyncTasks use case
3. Para cada entidad pendiente:
   a. Obtiene versión local
   b. Compara con versión del servidor
   c. Si no hay conflicto: envía al servidor
   d. Si hay conflicto: invoca ResolveConflict
4. Actualiza sync_status a 'synced' o 'failed'
5. Notifica a la UI del resultado

## 5. Manejo de Conflictos

### 5.1 Estrategia de Detección
- Cada entidad tiene campo `version` y `updated_at`
- En sincronización se comparan versiones
- Si version_local < version_server: conflicto de actualización
- Si version_local == version_server pero contenido diferente: conflicto de edición concurrente

### 5.2 Estrategias de Resolución
- **Server Wins**: Siempre prevalece el servidor
- **Client Wins**: Siempre prevalece el cliente
- **Last Write Wins**: Gana el que tenga timestamp más reciente
- **Manual**: Se presenta al usuario ambas versiones

### 5.3 Flujo de Resolución Manual
1. Se detecta conflicto
2. Se pausa sincronización automática
3. Se notifica al usuario con ambas versiones
4. Usuario selecciona la versión correcta
5. Se guarda selección y se reanuda sincronización

## 6. Gestión de Conectividad

### 6.1 Monitoreo de Estado
- NetworkInfo usa connectivity_plus para detectar cambios
- Se suscribe a cambios de conectividad en tiempo real
- Mantiene cache del último estado conocido

### 6.2 Reacción a Cambios
- **Sin conexión → Con conexión**: Inicia proceso de sincronización automáticamente
- **Con conexión → Sin conexión**: UI muestra banner de modo offline, continúa trabajo local

### 6.3 Políticas de Sincronización
- Sincronización automática cada X minutos (configurable)
- Sincronización inmediata tras cambio local
- Debounce para evitar sincronizaciones excesivas
- Retry automático con backoff exponencial

## 7. Consideraciones de Rendimiento

### 7.1 Optimización de SQLite
- Índices en columnas de sincronización
- Transacciones para operaciones múltiples
- Batch inserts para sincronización masiva
- Vacuum periódico para mantener tamaño

### 7.2 Optimización de Red
- Compresión de payloads JSON
- Solo envía campos modificados (diff)
- Pagination en respuestas grandes
- Cache de respuestas frecuentes

### 7.3 Memoria y UI
- Lazy loading de listas grandes
- Pagination en UI de tareas
- Optimización de rebuilds con equatable
- Uso de isolates para procesamiento pesado

## 8. Seguridad

### 8.1 Datos en Reposo
- SQLite con encryption (considerar en versión producción)
- No almacenar credenciales en texto plano
- Limpiar datos sensibles en logout

### 8.2 Datos en Tránsito
- HTTPS obligatorio
- Certificate pinning (configurable)
- Tokens de sesión con expiración

### 8.3 Acceso Local
- Validación de permisos de almacenamiento
- Sanitización de queries SQL
- Rate limiting en sincronización

## 9. Métricas y Monitoreo

### 9.1 Métricas de Salud
- Tiempo promedio de sincronización
- Tasa de conflictos por entidad
- Cantidad de reintentos
- Latencia de operaciones locales

### 9.2 Logs
- Nivel configurable (debug, info, warning, error)
- Tags para filtrado (sync, network, db)
- Timestamps en UTC
- Stack traces en errores

## 10. Testing

### 10.1 Estrategia de Pruebas
- **Unit Tests**: Use cases, repositories, blocs
- **Integration Tests**: Flujos completos de sincronización
- **Manual Tests**: Escenarios de conectividad variable

### 10.2 Escenarios Críticos a Probar
- Sincronización con conexión intermitente
- Conflictos de edición concurrente
- Recovery tras falla de sincronización
- Integridad de datos tras app kill
- Rendimiento con 1000+ tareas offline

## 11. Referencias

- Documentación de dependencias: sqflite, dio, flutter_bloc, connectivity_plus
- Clean Architecture por Robert C. Martin
- Offline-First Mobile Apps por Sean Newman
- OWASP MASVS para consideraciones de seguridad móvil

---
*Versión del documento: 1.0.0*
*Última actualización: 2024*
*Autor: Equipo de Arquitectura*

// === ARCHIVO: docs/diagrama_arquitectura.drawio ===
<mxfile host="app.diagrams.net" modified="2024-01-15T00:00:00.000Z" agent="Flutter" version="21.0.0" type="device">
  <diagram id="arquitectura-offline-first" name="Arquitectura Offline-First">
    <mxGraphModel dx="1200" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1200" pageHeight="900" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        
        <!-- TÍTULO PRINCIPAL -->
        <mxCell id="title" value="ARQUITECTURA OFFLINE-FIRST - APLICACIÓN DE CAMPO" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=20;fontStyle=1;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="200" y="20" width="800" height="40" as="geometry" />
        </mxCell>
        
        <!-- CAPA DE PRESENTACIÓN -->
        <mxCell id="presentation-layer" value="PRESENTATION LAYER" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#E8F4FD;strokeColor=#1E88E5;fontStyle=1;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="40" y="80" width="200" height="30" as="geometry" />
        </mxCell>
        
        <!-- TASK BLOC -->
        <mxCell id="task-bloc" value="TaskBloc&#xa;(Gestión de Estado Tareas)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#BBDEFB;strokeColor=#1976D2;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="60" y="130" width="160" height="50" as="geometry" />
        </mxCell>
        
        <!-- SYNC BLOC -->
        <mxCell id="sync-bloc" value="SyncBloc&#xa;(Gestión de Sincronización)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#BBDEFB;strokeColor=#1976D2;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="60" y="200" width="160" height="50" as="geometry" />
        </mxCell>
        
        <!-- PAGES -->
        <mxCell id="pages" value="Pages&#xa;(HomePage, TaskList, TaskDetail)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#BBDEFB;strokeColor=#1976D2;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="60" y="270" width="160" height="50" as="geometry" />
        </mxCell>
        
        <!-- WIDGETS -->
        <mxCell id="widgets" value="Widgets&#xa;(TaskCard, SyncIndicator, OfflineBanner)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#BBDEFB;strokeColor=#1976D2;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="60" y="340" width="160" height="50" as="geometry" />
        </mxCell>
        
        <!-- FLECHA PRESENTATION -> DOMAIN -->
        <mxCell id="arrow-pd1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#455A64;strokeWidth=2;" edge="1" parent="1" source="task-bloc" target="domain-layer">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- CAPA DE DOMINIO -->
        <mxCell id="domain-layer" value="DOMAIN LAYER" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#E8F5E9;strokeColor=#43A047;fontStyle=1;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="280" y="80" width="200" height="30" as="geometry" />
        </mxCell>
        
        <!-- ENTITIES -->
        <mxCell id="entities" value="Entities&#xa;• TaskEntity&#xa;• SyncStatusEntity" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#C8E6C9;strokeColor=#388E3C;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="300" y="130" width="160" height="60" as="geometry" />
        </mxCell>
        
        <!-- REPOSITORIES (CONTRACTS) -->
        <mxCell id="repositories" value="Repositories (Abstract)&#xa;• TaskRepository&#xa;• SyncRepository" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#C8E6C9;strokeColor=#388E3C;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="300" y="210" width="160" height="60" as="geometry" />
        </mxCell>
        
        <!-- USE CASES -->
        <mxCell id="usecases" value="Use Cases&#xa;• GetLocalTasks&#xa;• SaveTaskLocal&#xa;• SyncTasks&#xa;• ResolveConflict" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#C8E6C9;strokeColor=#388E3C;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="300" y="290" width="160" height="80" as="geometry" />
        </mxCell>
        
        <!-- FLECHA DOMAIN -> DATA -->
        <mxCell id="arrow-dd1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#455A64;strokeWidth=2;" edge="1" parent="1" source="repositories" target="data-layer">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- CAPA DE DATOS -->
        <mxCell id="data-layer" value="DATA LAYER" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFF3E0;strokeColor=#FB8C00;fontStyle=1;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="520" y="80" width="200" height="30" as="geometry" />
        </mxCell>
        
        <!-- MODELS -->
        <mxCell id="models" value="Models&#xa;• TaskModel&#xa;• SyncStatusModel" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE0B2;strokeColor=#F57C00;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="540" y="130" width="160" height="60" as="geometry" />
        </mxCell>
        
        <!-- LOCAL DATASOURCE -->
        <mxCell id="local-ds" value="Local DataSource&#xa;• TaskLocalDataSource&#xa;• DatabaseHelper (SQLite)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE0B2;strokeColor=#F57C00;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="540" y="210" width="160" height="60" as="geometry" />
        </mxCell>
        
        <!-- REMOTE DATASOURCE -->
        <mxCell id="remote-ds" value="Remote DataSource&#xa;• TaskRemoteDataSource (Dio)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE0B2;strokeColor=#F57C00;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="540" y="290" width="160" height="60" as="geometry" />
        </mxCell>
        
        <!-- REPOSITORY IMPLS -->
        <mxCell id="repo-impls" value="Repository Implementations&#xa;• TaskRepositoryImpl&#xa;• SyncRepositoryImpl" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE0B2;strokeColor=#F57C00;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="540" y="370" width="160" height="60" as="geometry" />
        </mxCell>
        
        <!-- FLECHA DATA -> INFRA -->
        <mxCell id="arrow-di1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#455A64;strokeWidth=2;" edge="1" parent="1" source="local-ds" target="infra-layer">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- CAPA DE INFRAESTRUCTURA -->
        <mxCell id="infra-layer" value="INFRASTRUCTURE LAYER" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FCE4EC;strokeColor=#E91E63;fontStyle=1;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="760" y="80" width="200" height="30" as="geometry" />
        </mxCell>
        
        <!-- DATABASE -->
        <mxCell id="database" value="SQLite Database&#xa;(Almacenamiento Local)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#F8BBD9;strokeColor=#D81B60;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="780" y="130" width="160" height="50" as="geometry" />
        </mxCell>
        
        <!-- NETWORK -->
        <mxCell id="network" value="Network Layer&#xa;• Dio HTTP Client&#xa;• NetworkInfo (Connectivity)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#F8BBD9;strokeColor=#D81B60;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="780" y="200" width="160" height="60" as="geometry" />
        </mxCell>
        
        <!-- EXTERNAL API -->
        <mxCell id="external-api" value="External API&#xa;(Backend Server)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#F8BBD9;strokeColor=#D81B60;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="780" y="280" width="160" height="50" as="geometry" />
        </mxCell>
        
        <!-- CONEXIONES LATERALES -->
        <mxCell id="arrow-sync1" value="Detecta&#xa;Conectividad" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#E91E63;strokeWidth=2;dashed=1;" edge="1" parent="1" source="sync-bloc" target="network">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <mxCell id="arrow-sync2" value="Sincroniza&#xa;Datos" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#43A047;strokeWidth=2;" edge="1" parent="1" source="usecases" target="repo-impls">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        
        <!-- CAJA DE FLUJO DE DATOS -->
        <mxCell id="flow-box" value="" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FAFAFA;strokeColor=#BDBDBD;" vertex="1" parent="1">
          <mxGeometry x="40" y="430" width="920" height="180" as="geometry" />
        </mxCell>
        
        <mxCell id="flow-title" value="FLUJO DE DATOS - OPERACIONES OFFLINE-FIRST" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=14;fontStyle=1;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="60" y="440" width="300" height="20" as="geometry" />
        </mxCell>
        
        <!-- FLUJO 1: LECTURA -->
        <mxCell id="flow1" value="1. READ: UI → TaskBloc → GetLocalTasks → TaskRepository → TaskLocalDataSource → SQLite → Datos Locales" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#E3F2FD;strokeColor=#2196F3;fontColor=#1565C0;" vertex="1" parent="1">
          <mxGeometry x="60" y="470" width="880" height="35" as="geometry" />
        </mxCell>
        
        <!-- FLUJO 2: ESCRITURA -->
        <mxCell id="flow2" value="2. WRITE: UI → TaskBloc → SaveTaskLocal → TaskRepository → TaskLocalDataSource → SQLite (sync_status='pending') → UI Actualizada" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#E8F5E9;strokeColor=#4CAF50;fontColor=#2E7D32;" vertex="1" parent="1">
          <mxGeometry x="60" y="515" width="880" height="35" as="geometry" />
        </mxCell>
        
        <!-- FLUJO 3: SINCRONIZACIÓN -->
        <mxCell id="flow3" value="3. SYNC: SyncBloc (conexión) → SyncTasks → Compara versiones → Envía a servidor → Actualiza sync_status" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFF3E0;strokeColor=#FF9800;fontColor=#E65100;" vertex="1" parent="1">
          <mxGeometry x="60" y="560" width="880" height="35" as="geometry" />
        </mxCell>
        
        <!-- CAJA DE CONFLICTOS -->
        <mxCell id="conflict-box" value="" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFEBEE;strokeColor=#F44336;" vertex="1" parent="1">
          <mxGeometry x="40" y="630" width="920" height="140" as="geometry" />
        </mxCell>
        
        <mxCell id="conflict-title" value="MANEJO DE CONFLICTOS" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=14;fontStyle=1;fontColor=#C62828;" vertex="1" parent="1">
          <mxGeometry x="60" y="640" width="200" height="20" as="geometry" />
        </mxCell>
        
        <!-- DETECCIÓN -->
        <mxCell id="detection" value="DETECCIÓN&#xa;• Comparar versión local vs servidor&#xa;• Comparar timestamps (updated_at)&#xa;• Marcar como 'conflict' si difieren" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFCDD2;strokeColor=#E53935;fontColor=#1A1A2E;align=center;" vertex="1" parent="1">
          <mxGeometry x="60" y="670" width="200" height="80" as="geometry" />
        </mxCell>
        
        <!-- ESTRATEGIAS -->
        <mxCell id="strategies" value="ESTRATEGIAS DE RESOLUCIÓN&#xa;• Server Wins (servidor prevalece)&#xa;• Client Wins (cliente prevalece)&#xa;• Last Write Wins (timestamp más reciente)&#xa;• Manual (usuario elige)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFCDD2;strokeColor=#E53935;fontColor=#1A1A2E;align=center;" vertex="1" parent="1">
          <mxGeometry x="280" y="670" width="280" height="80" as="geometry" />
        </mxCell>
        
        <!-- RESOLUCIÓN -->
        <mxCell id="resolution" value="RESOLUCIÓN&#xa;• ResolveConflict Use Case&#xa;• Actualizar sync_status&#xa;• Notificar a la UI&#xa;• Reanudar sincronización" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFCDD2;strokeColor=#E53935;fontColor=#1A1A2E;align=center;" vertex="1" parent="1">
          <mxGeometry x="580" y="670" width="200" height="80" as="geometry" />
        </mxCell>
        
        <!-- LEYENDA -->
        <mxCell id="legend" value="LEYENDA:&#xa;■ Capa Presentación&#xa;■ Capa Dominio&#xa;■ Capa Datos&#xa;■ Capa Infraestructura" style="text;html=1;strokeColor=#BDBDBD;fillColor=#FAFAFA;align=left;verticalAlign=top;whiteSpace=wrap;rounded=0;fontSize=11;fontColor=#616161;" vertex="1" parent="1">
          <mxGeometry x="820" y="430" width="130" height="100" as="geometry" />
        </mxCell>
        
        <!-- ESTADO DE SINCRONIZACIÓN -->
        <mxCell id="sync-status-title" value="TABLAS DE SINCRONIZACIÓN" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=12;fontStyle=1;fontColor=#1A1A2E;" vertex="1" parent="1">
          <mxGeometry x="850" y="540" width="100" height="20" as="geometry" />
        </mxCell>
        
        <mxCell id="sync-status-pending" value="pending - Pendiente de sincronizar" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#FF9800;fontColor=#FFFFFF;" vertex="1" parent="1">
          <mxGeometry x="820" y="565" width="150" height="20" as="geometry" />
        </mxCell>
        
        <mxCell id="sync-status-synced" value="synced - Sincronizado" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#4CAF50;fontColor=#FFFFFF;" vertex="1" parent="1">
          <mxGeometry x="820" y="590" width="150" height="20" as="geometry" />
        </mxCell>
        
        <mxCell id="sync-status-failed" value="failed - Error en sincronización" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#F44336;fontColor=#FFFFFF;" vertex="1" parent="1">
          <mxGeometry x="820" y="615" width="150" height="20" as="geometry" />
        </mxCell>
        
        <mxCell id="sync-status-conflict" value="conflict - Conflicto detectado" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#9C27B0;fontColor=#FFFFFF;" vertex="1" parent="1">
          <mxGeometry x="820" y="640" width="150" height="20" as="geometry" />
        </mxCell>
        
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>

// === ARCHIVO: lib/domain/repositories/task_repository.dart ===
package field_app.domain.repositories;

import 'package:field_app/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity?> getTaskById(String id);
  Future<List<TaskEntity>> getTasksByStatus(String status);
  Future<List<TaskEntity>> getTasksByPriority(String priority);
  Future<List<TaskEntity>> getPendingSyncTasks();
  Future<TaskEntity> saveTask(TaskEntity task);
  Future<void> deleteTask(String id);
  Future<void> deleteAllTasks();
  Future<int> getTaskCount();
  Future<int> getPendingSyncCount();
  Future<List<TaskEntity>> searchTasks(String query);
  Future<void> updateTaskSyncStatus(String id, String syncStatus);
  Future<void> incrementTaskVersion(String id);
  Future<List<TaskEntity>> getTasksDueSoon(Duration within);
  Future<List<TaskEntity>> getOverdueTasks();
  Future<void> batchSaveTasks(List<TaskEntity> tasks);
  Stream<List<TaskEntity>> watchTasks();
  Stream<TaskEntity?> watchTask(String id);
  Future<TaskEntity> updateTask(TaskEntity task);
  Future<void> markTaskAsConflict(String id);
  Future<void> markTaskAsSynced(String id);
  Future<TaskEntity?> getServerTaskById(String id);
  Future<List<TaskEntity>> getConflictingTasks();
  Future<void> resolveConflict(String taskId, String resolution, TaskEntity winningVersion);
  Future<void> syncTask(TaskEntity task);
}

// === ARCHIVO: lib/data/datasources/local/task_local_datasource.dart ===
package field_app.data.datasources.local;

import 'package:field_app/data/models/task_model.dart';
import 'package:field_app/data/models/sync_status_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getPendingSyncTasks();
  Future<TaskModel?> getTaskById(String id);
  Future<void> saveTask(TaskModel task);
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> markTaskAsSynced(String id);
  Future<void> markTaskAsFailed(String id, String error);
  Future<void> markTaskAsConflict(String id);
  Future<int> getPendingTasksCount();
  Future<void> clearAllTasks();
  Future<SyncStatusModel?> getSyncStatus(String entityId);
  Future<void> saveSyncStatus(SyncStatusModel status);
  Future<List<SyncStatusModel>> getAllSyncStatuses();
  Future<List<TaskModel>> getTasks();
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<void> cacheTask(TaskModel task);
  Future<void> updateTaskSyncStatus(String id, String syncStatus);
  Future<List<TaskModel>> getPendingTasks();
  Future<List<TaskModel>> searchTasks(String query);
  Future<List<TaskModel>> getTasksByStatus(String status);
  Future<List<TaskModel>> getTasksByPriority(String priority);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Uuid _uuid;

  TaskLocalDataSourceImpl({
    required this.databaseHelper,
    required Uuid uuid,
  }) : _uuid = uuid;

  Future<Database> get _db async => databaseHelper.database;

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final db = await _db;
    final maps = await db.query('tasks', where: 'is_deleted = ?', whereArgs: [0]);
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getPendingSyncTasks() async {
    final db = await _db;
    final maps = await db.query(
      'tasks',
      where: 'sync_status = ? AND is_deleted = ?',
      whereArgs: ['pending', 0],
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final db = await _db;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final db = await _db;
    await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final db = await _db;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final db = await _db;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await _db;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> markTaskAsSynced(String id) async {
    await updateTaskSyncStatus(id, 'synced');
  }

  @override
  Future<void> markTaskAsFailed(String id, String error) async {
    await updateTaskSyncStatus(id, 'failed');
  }

  @override
  Future<void> markTaskAsConflict(String id) async {
    await updateTaskSyncStatus(id, 'conflict');
  }

  @override
  Future<int> getPendingTasksCount() async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE sync_status = ? AND is_deleted = ?',
      ['pending', 0],
    );
    return result.first['count'] as int;
  }

  @override
  Future<void> clearAllTasks() async {
    final db = await _db;
    await db.delete('tasks');
  }

  @override
  Future<SyncStatusModel?> getSyncStatus(String entityId) async {
    final db = await _db;
    final maps = await db.query('sync_status', where: 'entity_id = ?', whereArgs: [entityId]);
    if (maps.isEmpty) return null;
    return SyncStatusModel.fromMap(maps.first);
  }

  @override
  Future<void> saveSyncStatus(SyncStatusModel status) async {
    final db = await _db;
    await db.insert('sync_status', status.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<SyncStatusModel>> getAllSyncStatuses() async {
    final db = await _db;
    final maps = await db.query('sync_status');
    return maps.map((map) => SyncStatusModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    return getAllTasks();
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    await saveTasks(tasks);
  }

  @override
  Future<void> cacheTask(TaskModel task) async {
    await saveTask(task);
  }

  @override
  Future<void> updateTaskSyncStatus(String id, String syncStatus) async {
    final db = await _db;
    await db.update(
      'tasks',
      {'sync_status': syncStatus, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<TaskModel>> getPendingTasks() async {
    return getPendingSyncTasks();
  }

  @override
  Future<List<TaskModel>> searchTasks(String query) async {
    final db = await _db;
    final maps = await db.query(
      'tasks',
      where: '(title LIKE ? OR description LIKE ?) AND is_deleted = ?',
      whereArgs: ['%$query%', '%$query%', 0],
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getTasksByStatus(String status) async {
    final db = await _db;
    final maps = await db.query(
      'tasks',
      where: 'status = ? AND is_deleted = ?',
      whereArgs: [status, 0],
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getTasksByPriority(String priority) async {
    final db = await _db;
    final maps = await db.query(
      'tasks',
      where: 'priority = ? AND is_deleted = ?',
      whereArgs: [priority, 0],
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }
}

// === ARCHIVO: lib/domain/repositories/sync_repository.dart ===
abstract class SyncRepository extends Equatable {
  const SyncRepository();
  Future<Either<Failure, void>> syncPendingTasks();
  Future<Either<Failure, SyncResult>> syncAllData();
  Future<Either<Failure, ConflictResolutionResult>> resolveConflict(
    String entityId,
    ConflictResolutionStrategy strategy,
  );
  Future<Either<Failure, List<SyncStatusSummary>>>> getSyncStatusSummary();
  Future<Either<Failure, void>> retryFailedSync(String entityId);
  Future<Either<Failure, void>> cancelSync(String syncId);
  Stream<SyncProgress> get syncProgressStream;
  Future<void> recordSyncOperation({
    required String entityType,
    required int totalCount,
    required int successCount,
    required int failedCount,
    required int conflictCount,
  });
}

class SyncResult extends Equatable {
  final int totalSynced;
  final int totalFailed;
  final int totalConflicts;
  final Duration syncDuration;
  final List<String> syncedEntityIds;
  final List<SyncErrorDetails> failedEntities;
  final List<ConflictDetails> conflicts;

  const SyncResult({
    required this.totalSynced,
    required this.totalFailed,
    required this.totalConflicts,
    required this.syncDuration,
    this.syncedEntityIds = const [],
    this.failedEntities = const [],
    this.conflicts = const [],
  });

  bool get hasErrors => totalFailed > 0;
  bool get hasConflicts => totalConflicts > 0;
  bool get isFullySuccessful => totalSynced > 0 && totalFailed == 0 && totalConflicts == 0;

  @override
  List<Object?> get props => [
        totalSynced,
        totalFailed,
        totalConflicts,
        syncDuration,
        syncedEntityIds,
        failedEntities,
        conflicts,
      ];
}

class SyncErrorDetails extends Equatable {
  final String entityId;
  final String entityType;
  final String errorMessage;
  final int retryCount;
  final DateTime lastAttempt;

  const SyncErrorDetails({
    required this.entityId,
    required this.entityType,
    required this.errorMessage,
    required this.retryCount,
    required this.lastAttempt,
  });

  @override
  List<Object?> get props => [entityId, entityType, errorMessage, retryCount, lastAttempt];
}

class ConflictDetails extends Equatable {
  final String entityId;
  final String entityType;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final DateTime localModifiedAt;
  final DateTime remoteModifiedAt;
  final List<String> conflictingFields;

  const ConflictDetails({
    required this.entityId,
    required this.entityType,
    required this.localData,
    required this.remoteData,
    required this.localModifiedAt,
    required this.remoteModifiedAt,
    required this.conflictingFields,
  });

  @override
  List<Object?> get props => [
        entityId,
        entityType,
        localData,
        remoteData,
        localModifiedAt,
        remoteModifiedAt,
        conflictingFields,
      ];
}

enum ConflictResolutionStrategy {}

class ConflictResolutionResult extends Equatable {
  final bool success;
  final String entityId;
  final ConflictResolutionStrategy usedStrategy;
  final Map<String, dynamic>? resolvedData;
  final String? errorMessage;

  const ConflictResolutionResult({
    required this.success,
    required this.entityId,
    required this.usedStrategy,
    this.resolvedData,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [success, entityId, usedStrategy, resolvedData, errorMessage];
}

class SyncStatusSummary extends Equatable {
  final int pendingCount;
  final int syncedCount;
  final int failedCount;
  final int conflictCount;
  final DateTime? lastSyncAt;
  final bool isSyncing;

  const SyncStatusSummary({
    required this.pendingCount,
    required this.syncedCount,
    required this.failedCount,
    required this.conflictCount,
    this.lastSyncAt,
    this.isSyncing = false,
  });

  int get totalCount => pendingCount + syncedCount + failedCount + conflictCount;

  @override
  List<Object?> get props => [
        pendingCount,
        syncedCount,
        failedCount,
        conflictCount,
        lastSyncAt,
        isSyncing,
      ];
}

class SyncProgress extends Equatable {
  final String phase;
  final int currentItem;
  final int totalItems;
  final String? currentEntityId;
  final double progressPercentage;
  final String? statusMessage;

  const SyncProgress({
    required this.phase,
    required this.currentItem,
    required this.totalItems,
    this.currentEntityId,
    required this.progressPercentage,
    this.statusMessage,
  });

  @override
  List<Object?> get props => [
        phase,
        currentItem,
        totalItems,
        currentEntityId,
        progressPercentage,
        statusMessage,
      ];
}

// === ARCHIVO: lib/data/repositories/sync_repository_impl.dart ===
package lib.data.repositories;

import 'package:field_app/data/datasources/local/task_local_datasource.dart';
import 'package:field_app/data/datasources/remote/task_remote_datasource.dart';
import 'package:field_app/domain/repositories/sync_repository.dart';
import 'package:field_app/domain/entities/task_entity.dart';
import 'package:field_app/core/network/network_info.dart';
import 'package:uuid/uuid.dart';
import 'package:either_dart/either.dart';
import 'package:field_app/core/errors/failures.dart';

class SyncRepositoryImpl implements SyncRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;

  SyncRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.uuid,
  });

  @override
  Future<Either<Failure, void>> syncPendingTasks() async {
    try {
      await syncAll();
      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SyncResult>> syncAllData() async {
    try {
      final result = await syncAll();
      return Right(result);
    } catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConflictResolutionResult>> resolveConflict(
    String entityId,
    ConflictResolutionStrategy strategy,
  ) async {
    return const Right(ConflictResolutionResult(
      success: true,
      entityId: '',
      usedStrategy: ConflictResolutionStrategy.values,
    ));
  }

  @override
  Future<Either<Failure, List<SyncStatusSummary>>> getSyncStatusSummary() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> retryFailedSync(String entityId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> cancelSync(String syncId) async {
    return const Right(null);
  }

  @override
  Stream<SyncProgress> get syncProgressStream => const Stream.empty();

  @override
  Future<void> recordSyncOperation({
    required String entityType,
    required int totalCount,
    required int successCount,
    required int failedCount,
    required int conflictCount,
  }) async {
    // Record sync operation in local database
    final status = SyncStatusModel.create(
      id: uuid.v4(),
      entityType: entityType,
      entityId: uuid.v4(),
      status: failedCount > 0 ? 'failed' : (conflictCount > 0 ? 'conflict' : 'synced'),
      version: 1,
    );
    await localDataSource.saveSyncStatus(status);
  }

  Future<SyncResult> syncAll() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return const SyncResult(
        totalSynced: 0,
        totalFailed: 0,
        totalConflicts: 0,
        syncDuration: Duration.zero,
      );
    }

    final pendingTasks = await localDataSource.getPendingSyncTasks();
    if (pendingTasks.isEmpty) {
      return const SyncResult(
        totalSynced: 0,
        totalFailed: 0,
        totalConflicts: 0,
        syncDuration: Duration.zero,
      );
    }

    int synced = 0;
    int failed = 0;
    int conflicts = 0;

    for (final task in pendingTasks) {
      try {
        await remoteDataSource.updateTask(task);
        await localDataSource.markTaskAsSynced(task.id);
        synced++;
      } catch (e) {
        failed++;
      }
    }

    return SyncResult(
      totalSynced: synced,
      totalFailed: failed,
      totalConflicts: conflicts,
      syncDuration: Duration.zero,
    );
  }

  Future<SyncResult> syncTask(String taskId) async {
    return syncAll();
  }

  Future<List<TaskEntity>> getPendingSyncItems() async {
    final tasks = await localDataSource.getPendingSyncTasks();
    return tasks.map((m) => m.toEntity()).toList();
  }

  Future<DateTime?> getLastSyncTime() async {
    return null;
  }

  Future<void> clearSyncQueue() async {
    // Implementation
  }
}

class SyncConflict extends Equatable {
  final String taskId;
  final TaskEntity localVersion;
  final TaskEntity? remoteVersion;
  final String conflictType;

  const SyncConflict({
    required this.taskId,
    required this.localVersion,
    this.remoteVersion,
    required this.conflictType,
  });

  @override
  List<Object?> get props => [taskId, localVersion, remoteVersion, conflictType];
}


// === ARCHIVO: lib/data/datasources/local/task_local_datasource.dart ===
package field_app.data.datasources.local;

import 'package:field_app/data/models/task_model.dart';
import 'package:field_app/data/models/sync_status_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getPendingSyncTasks();
  Future<TaskModel?> getTaskById(String id);
  Future<void> saveTask(TaskModel task);
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> markTaskAsSynced(String id);
  Future<void> markTaskAsFailed(String id, String error);
  Future<void> markTaskAsConflict(String id);
  Future<int> getPendingTasksCount();
  Future<void> clearAllTasks();
  Future<SyncStatusModel?> getSyncStatus(String entityId);
  Future<void> saveSyncStatus(SyncStatusModel status);
  Future<List<SyncStatusModel>> getAllSyncStatuses();
  Future<void> updateTaskSyncStatus(String id, String syncStatus);
  Future<DateTime?> getLastSyncTime();
  Future<void> clearPendingSyncTasks();
  Future<void> insertTask(TaskModel task);
  Future<void> updateLastSyncTime(DateTime time);
  Future<void> insertSyncStatus(SyncStatusModel status);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Uuid _uuid;

  TaskLocalDataSourceImpl({
    required this.databaseHelper,
    required this.uuid,
  });

  Future<Database> get _db async => await databaseHelper.database;

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final db = await _db;
    final maps = await db.query('tasks', where: 'is_deleted = ?', whereArgs: [0]);
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getPendingSyncTasks() async {
    final db = await _db;
    final maps = await db.query(
      'tasks',
      where: 'sync_status = ? AND is_deleted = ?',
      whereArgs: ['pending', 0],
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final db = await _db;
    final maps = await db.query(
      'tasks',
      where: 'id = ? AND is_deleted = ?',
      whereArgs: [id, 0],
    );
    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final db = await _db;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final db = await _db;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final db = await _db;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await _db;
    await db.update(
      'tasks',
      {'is_deleted': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markTaskAsSynced(String id) async {
    final db = await _db;
    await db.update(
      'tasks',
      {'sync_status': 'synced', 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markTaskAsFailed(String id, String error) async {
    final db = await _db;
    await db.update(
      'tasks',
      {
        'sync_status': 'failed',
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markTaskAsConflict(String id) async {
    final db = await _db;
    await db.update(
      'tasks',
      {'sync_status': 'conflict', 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> getPendingTasksCount() async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE sync_status = ? AND is_deleted = ?',
      ['pending', 0],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<void> clearAllTasks() async {
    final db = await _db;
    await db.delete('tasks');
  }

  @override
  Future<SyncStatusModel?> getSyncStatus(String entityId) async {
    final db = await _db;
    final maps = await db.query(
      'sync_status',
      where: 'entity_id = ?',
      whereArgs: [entityId],
    );
    if (maps.isEmpty) return null;
    return SyncStatusModel.fromMap(maps.first);
  }

  @override
  Future<void> saveSyncStatus(SyncStatusModel status) async {
    final db = await _db;
    await db.insert(
      'sync_status',
      status.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<SyncStatusModel>> getAllSyncStatuses() async {
    final db = await _db;
    final maps = await db.query('sync_status', orderBy: 'created_at DESC');
    return maps.map((map) => SyncStatusModel.fromMap(map)).toList();
  }

  @override
  Future<void> updateTaskSyncStatus(String id, String syncStatus) async {
    final db = await _db;
    await db.update(
      'tasks',
      {
        'sync_status': syncStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    final db = await _db;
    final maps = await db.query(
      'sync_status',
      where: 'entity_type = ?',
      whereArgs: ['_meta'],
      orderBy: 'last_sync_at DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    final lastSyncAt = maps.first['last_sync_at'];
    if (lastSyncAt == null) return null;
    return DateTime.tryParse(lastSyncAt.toString());
  }

  @override
  Future<void> clearPendingSyncTasks() async {
    final db = await _db;
    await db.update(
      'tasks',
      {'sync_status': 'synced'},
      where: 'sync_status = ?',
      whereArgs: ['pending'],
    );
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    final db = await _db;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateLastSyncTime(DateTime time) async {
    final db = await _db;
    final existing = await db.query(
      'sync_status',
      where: 'entity_id = ?',
      whereArgs: ['_last_sync'],
    );
    
    if (existing.isEmpty) {
      await db.insert('sync_status', {
        'id': '_last_sync',
        'entity_type': '_meta',
        'entity_id': '_last_sync',
        'status': 'synced',
        'version': 1,
        'last_sync_at': time.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'retry_count': 0,
      });
    } else {
      await db.update(
        'sync_status',
        {
          'last_sync_at': time.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'entity_id = ?',
        whereArgs: ['_last_sync'],
      );
    }
  }

  @override
  Future<void> insertSyncStatus(SyncStatusModel status) async {
    final db = await _db;
    await db.insert(
      'sync_status',
      status.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// === ARCHIVO: lib/data/datasources/remote/task_remote_datasource.dart ===
package field_app.data.datasources.remote;

import 'package:dio/dio.dart';
import 'package:field_app/data/models/task_model.dart';
import 'package:field_app/core/errors/exceptions.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(String id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<List<TaskModel>> syncTasks(List<TaskModel> tasks);
  Future<List<TaskModel>> getTasksSince(DateTime? since);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio _dio;

  TaskRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _dio.get('/tasks');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks');
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final response = await _dio.get('/tasks/$id');
      final data = response.data['data'] ?? response.data;
      return TaskModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/$id');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _dio.post('/tasks', data: task.toJson());
      final data = response.data['data'] ?? response.data;
      return TaskModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await _dio.put('/tasks/${task.id}', data: task.toJson());
      final data = response.data['data'] ?? response.data;
      return TaskModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/${task.id}');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _dio.delete('/tasks/$id');
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/$id');
    }
  }

  @override
  Future<List<TaskModel>> syncTasks(List<TaskModel> tasks) async {
    try {
      final response = await _dio.post(
        '/tasks/sync',
        data: {'tasks': tasks.map((t) => t.toJson()).toList()},
      );
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/sync');
    }
  }

  @override
  Future<List<TaskModel>> getTasksSince(DateTime? since) async {
    try {
      final queryParams = <String, dynamic>{};
      if (since != null) {
        queryParams['since'] = since.toIso8601String();
      }
      final response = await _dio.get('/tasks', queryParameters: queryParams);
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks');
    }
  }

  AppException _handleDioError(DioException e, String endpoint) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Timeout connecting to server',
          url: endpoint,
          isConnectionError: false,
          isTimeout: true,
          isSslError: false,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
          url: endpoint,
          isConnectionError: true,
          isTimeout: false,
          isSslError: false,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Server error';
        return ServerException(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
        );
      default:
        return NetworkException(
          message: e.message ?? 'Unknown error',
          url: endpoint,
          isConnectionError: false,
          isTimeout: false,
          isSslError: false,
        );
    }
  }
}

// === ARCHIVO: lib/domain/repositories/task_repository.dart ===
package field_app.domain.repositories;

import 'package:field_app/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity?> getTaskById(String id);
  Future<List<TaskEntity>> getTasksByStatus(String status);
  Future<List<TaskEntity>> getTasksByPriority(String priority);
  Future<List<TaskEntity>> getPendingSyncTasks();
  Future<TaskEntity> saveTask(TaskEntity task);
  Future<void> deleteTask(String id);
  Future<void> deleteAllTasks();
  Future<int> getTaskCount();
  Future<int> getPendingSyncCount();
  Future<List<TaskEntity>> searchTasks(String query);
  Future<void> updateTaskSyncStatus(String id, String syncStatus);
  Future<void> incrementTaskVersion(String id);
  Future<List<TaskEntity>> getTasksDueSoon(Duration within);
  Future<List<TaskEntity>> getOverdueTasks();
  Future<void> batchSaveTasks(List<TaskEntity> tasks);
  Stream<List<TaskEntity>> watchTasks();
  Stream<TaskEntity?> watchTask(String id);
  Future<List<TaskEntity>> getRemoteTasks();
}

// === ARCHIVO: lib/domain/repositories/sync_repository.dart ===
abstract class SyncRepository {
  Future<List<SyncStatusEntity>> getPendingSyncItems();
}

extension SyncRepositoryExtension on SyncRepository {
  Future<List<SyncStatusEntity>> getPendingSyncItems() async {
    // Default implementation - override in implementation class
    return [];
  }
}

```
