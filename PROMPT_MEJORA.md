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

- `lib/sync/services/sync_coordinator.dart`

### Referencias colgando en el codigo que si esta

Cada una rompe la compilacion:

- `lib/domain/usecases/sync_clients.dart` — `ClientRepository.uploadClientToServer`: Se invoca `uploadClientToServer` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/sync_clients.dart` — `ClientRepository.updateClientSyncStatus`: Se invoca `updateClientSyncStatus` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/resolve_conflicts.dart` — `ClientRepository.getConflictedClients`: Se invoca `getConflictedClients` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/resolve_conflicts.dart` — `ClientRepository.getClientFromServer`: Se invoca `getClientFromServer` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/domain/usecases/resolve_conflicts.dart` — `CreditApplicationRepository.getConflictedApplications`: Se invoca `getConflictedApplications` sobre `CreditApplicationRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/screens/application_form_screen.dart` — `ClientRepository.getAllClients`: Se invoca `getAllClients` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/screens/application_form_screen.dart` — `CreditApplicationRepository.saveApplication`: Se invoca `saveApplication` sobre `CreditApplicationRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/viewmodels/client_viewmodel.dart` — `ClientRepository.searchClients`: Se invoca `searchClients` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.syncPendingChanges`: Se invoca `syncPendingChanges` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.cancelSync`: Se invoca `cancelSync` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.getPendingItemsCount`: Se invoca `getPendingItemsCount` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.getConflicts`: Se invoca `getConflicts` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.getLastSyncTime`: Se invoca `getLastSyncTime` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.resolveConflict`: Se invoca `resolveConflict` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.forceSyncAll`: Se invoca `forceSyncAll` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.clearSyncHistory`: Se invoca `clearSyncHistory` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `test/unit/sync_test.dart` — `MockAppDatabase.getPendingClients`: Se invoca `getPendingClients` sobre `MockAppDatabase`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `test/unit/sync_test.dart` — `MockAppDatabase.updateClientsSyncStatus`: Se invoca `updateClientsSyncStatus` sobre `MockAppDatabase`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `test/unit/sync_test.dart` — `MockAppDatabase.getPendingCreditApplications`: Se invoca `getPendingCreditApplications` sobre `MockAppDatabase`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `test/unit/sync_test.dart` — `MockAppDatabase.updateCreditApplicationsSyncStatus`: Se invoca `updateCreditApplicationsSyncStatus` sobre `MockAppDatabase`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `test/unit/sync_test.dart` — `MockConnectivityService.checkConnectivity`: Se invoca `checkConnectivity` sobre `MockConnectivityService`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `test/unit/sync_test.dart` — `MockConnectivityService.startListening`: Se invoca `startListening` sobre `MockConnectivityService`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.

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
- Seniority: semi-senior
- Tipo: practical
- Título: Implementación de una aplicación offline-first
- Tiempo estimado: 3 semanas

### Fases (trabajo del HUMANO — PROHIBIDO completarlas)
No implementes estos entregables. Dejalos como hueco pedagógico. El asistente solo materializa el proyecto arrancable para que el participante pueda trabajar.
- Fase 1: Diseño del modelo de datos offline — objetivo: Definir la estructura de datos que permitirá la operación offline y la sincronización posterior. — entregable (NO resolver): Esquema de la base de datos local y reglas de sincronización definidas.
- Fase 2: Implementación de la lógica de sincronización — objetivo: Desarrollar la lógica que permita la sincronización de datos entre la aplicación y el servidor. — entregable (NO resolver): Lógica de sincronización implementada y funcional.
- Fase 3: Optimización y pruebas de la aplicación offline-first — objetivo: Optimizar el rendimiento de la aplicación y realizar pruebas exhaustivas para asegurar su funcionamiento offline y en línea. — entregable (NO resolver): Aplicación optimizada y pruebas completadas con reporte de resultados.

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
name: credit_field_app
description: Aplicación offline-first para agents de crédito
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.6.0

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.0
  drift: ^2.27.0
  drift_flutter: ^0.3.0
  sqlite3_flutter_libs: ^0.5.32
  dio: ^5.8.0
  connectivity_plus: ^6.1.4
  get_it: ^8.0.3
  dartz: ^0.10.1
  equatable: ^2.0.7
  uuid: ^4.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mocktail: ^1.0.4
  bloc_test: ^10.0.0
  drift_dev: ^2.27.0
  build_runner: ^2.4.15

flutter:
  uses-material-design: true

// === ARCHIVO: lib/main.dart ===
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

// === ARCHIVO: lib/core/config/app_config.dart ===
import 'package:equatable/equatable.dart';

class AppConfig extends Equatable {
  final String baseUrl;
  final int syncIntervalMinutes;
  final int maxRetryAttempts;
  final int retryDelaySeconds;
  final int connectionTimeoutMs;
  final int receiveTimeoutMs;
  final bool enableLogging;
  final int maxBatchSize;
  final int conflictResolutionBatchSize;

  const AppConfig({
    this.baseUrl = 'https://api.creditofield.example.com/v1',
    this.syncIntervalMinutes = 15,
    this.maxRetryAttempts = 3,
    this.retryDelaySeconds = 5,
    this.connectionTimeoutMs = 30000,
    this.receiveTimeoutMs = 30000,
    this.enableLogging = true,
    this.maxBatchSize = 100,
    this.conflictResolutionBatchSize = 50,
  });

  String get clientsEndpoint => '$baseUrl/clients';
  String get creditApplicationsEndpoint => '$baseUrl/credit-applications';
  String get syncEndpoint => '$baseUrl/sync';
  String get conflictResolutionEndpoint => '$baseUrl/sync/conflicts';

  Duration get syncInterval => Duration(minutes: syncIntervalMinutes);
  Duration get retryDelay => Duration(seconds: retryDelaySeconds);
  Duration get connectionTimeout => Duration(milliseconds: connectionTimeoutMs);
  Duration get receiveTimeout => Duration(milliseconds: receiveTimeoutMs);

  AppConfig copyWith({
    String? baseUrl,
    int? syncIntervalMinutes,
    int? maxRetryAttempts,
    int? retryDelaySeconds,
    int? connectionTimeoutMs,
    int? receiveTimeoutMs,
    bool? enableLogging,
    int? maxBatchSize,
    int? conflictResolutionBatchSize,
  }) {
    return AppConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      maxRetryAttempts: maxRetryAttempts ?? this.maxRetryAttempts,
      retryDelaySeconds: retryDelaySeconds ?? this.retryDelaySeconds,
      connectionTimeoutMs: connectionTimeoutMs ?? this.connectionTimeoutMs,
      receiveTimeoutMs: receiveTimeoutMs ?? this.receiveTimeoutMs,
      enableLogging: enableLogging ?? this.enableLogging,
      maxBatchSize: maxBatchSize ?? this.maxBatchSize,
      conflictResolutionBatchSize: conflictResolutionBatchSize ?? this.conflictResolutionBatchSize,
    );
  }

  @override
  List<Object?> get props => [
        baseUrl,
        syncIntervalMinutes,
        maxRetryAttempts,
        retryDelaySeconds,
        connectionTimeoutMs,
        receiveTimeoutMs,
        enableLogging,
        maxBatchSize,
        conflictResolutionBatchSize,
      ];
}

// === ARCHIVO: lib/core/network/connectivity_service.dart ===
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

enum ConnectionStatus { connected, disconnected, unknown }

class ConnectivityStatus extends Equatable {
  final ConnectionStatus status;
  final DateTime timestamp;
  final String? networkType;

  const ConnectivityStatus({
    required this.status,
    required this.timestamp,
    this.networkType,
  });

  bool get isConnected => status == ConnectionStatus.connected;
  bool get isDisconnected => status == ConnectionStatus.disconnected;

  @override
  List<Object?> get props => [status, timestamp, networkType];
}

class ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<ConnectivityStatus> _statusController;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        _statusController = StreamController<ConnectivityStatus>.broadcast();

  Stream<ConnectivityStatus> get statusStream => _statusController.stream;

  Future<ConnectivityStatus> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _mapConnectivityResults(results);
    } catch (e) {
      return ConnectivityStatus(
        status: ConnectionStatus.unknown,
        timestamp: DateTime.now(),
        networkType: null,
      );
    }
  }

  Future<void> startListening() async {
    final initialStatus = await checkConnectivity();
    _statusController.add(initialStatus);

    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final status = _mapConnectivityResults(results);
        _statusController.add(status);
      },
      onError: (error) {
        _statusController.add(
          ConnectivityStatus(
            status: ConnectionStatus.unknown,
            timestamp: DateTime.now(),
            networkType: null,
          ),
        );
      },
    );
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  ConnectivityStatus _mapConnectivityResults(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus(
        status: ConnectionStatus.disconnected,
        timestamp: DateTime.now(),
        networkType: 'none',
      );
    }

    final primaryResult = results.first;
    String networkType;

    switch (primaryResult) {
      case ConnectivityResult.wifi:
        networkType = 'wifi';
        break;
      case ConnectivityResult.mobile:
        networkType = 'mobile';
        break;
      case ConnectivityResult.ethernet:
        networkType = 'ethernet';
        break;
      case ConnectivityResult.vpn:
        networkType = 'vpn';
        break;
      case ConnectivityResult.other:
        networkType = 'other';
        break;
      default:
        networkType = 'unknown';
    }

    return ConnectivityStatus(
      status: ConnectionStatus.connected,
      timestamp: DateTime.now(),
      networkType: networkType,
    );
  }

  Future<bool> hasActiveConnection() async {
    final status = await checkConnectivity();
    return status.isConnected;
  }

  void dispose() {
    stopListening();
    _statusController.close();
  }
}

// === ARCHIVO: lib/core/database/app_database.dart ===
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class ClientsTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text().withLength(min: 1, max: 100)();
  TextColumn get lastName => text().withLength(min: 1, max: 100)();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().withLength(min: 10, max: 20)();
  TextColumn get address => text().nullable()();
  TextColumn get identificationNumber => text().withLength(min: 5, max: 50)();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CreditApplicationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get clientId => text().references(ClientsTable, #id)();
  RealColumn get requestedAmount => real()();
  TextColumn get purpose => text().withLength(min: 1, max: 200)();
  IntColumn get termMonths => integer()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get rejectionReason => text().nullable()();
  TextColumn get approvedAmount => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();
}

@DriftDatabase(tables: [ClientsTable, CreditApplicationsTable, SyncLogTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static AppDatabase? _instance;
  static AppDatabase get instance {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'credit_field_db');
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 1) {
          // Future migrations will be handled here
        }
      },
    );
  }

  Future<void> initialize() async {
    await database.select(database.clientsTable).get();
  }

  // Client operations
  Future<List<ClientsTableData>> getAllClients() => select(clientsTable).get();

  Stream<List<ClientsTableData>> watchAllClients() => select(clientsTable).watch();

  Future<ClientsTableData?> getClientById(String id) {
    return (select(clientsTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertClient(ClientsTableCompanion client) {
    return into(clientsTable).insert(client);
  }

  Future<bool> updateClient(ClientsTableCompanion client) {
    return update(clientsTable).replace(client);
  }

  Future<int> deleteClient(String id) {
    return (delete(clientsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<ClientsTableData>> getPendingClients() {
    return (select(clientsTable)..where((t) => t.syncStatus.equals('pending'))).get();
  }

  Stream<List<ClientsTableData>> watchPendingClients() {
    return (select(clientsTable)..where((t) => t.syncStatus.equals('pending'))).watch();
  }

  // Credit Application operations
  Future<List<CreditApplicationsTableData>> getAllCreditApplications() =>
      select(creditApplicationsTable).get();

  Stream<List<CreditApplicationsTableData>> watchAllCreditApplications() =>
      select(creditApplicationsTable).watch();

  Future<List<CreditApplicationsTableData>> getCreditApplicationsByClientId(String clientId) {
    return (select(creditApplicationsTable)..where((t) => t.clientId.equals(clientId))).get();
  }

  Future<CreditApplicationsTableData?> getCreditApplicationById(String id) {
    return (select(creditApplicationsTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertCreditApplication(CreditApplicationsTableCompanion application) {
    return into(creditApplicationsTable).insert(application);
  }

  Future<bool> updateCreditApplication(CreditApplicationsTableCompanion application) {
    return update(creditApplicationsTable).replace(application);
  }

  Future<int> deleteCreditApplication(String id) {
    return (delete(creditApplicationsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<CreditApplicationsTableData>> getPendingCreditApplications() {
    return (select(creditApplicationsTable)..where((t) => t.syncStatus.equals('pending'))).get();
  }

  Stream<List<CreditApplicationsTableData>> watchPendingCreditApplications() {
    return (select(creditApplicationsTable)..where((t) => t.syncStatus.equals('pending'))).watch();
  }

  // Sync log operations
  Future<int> insertSyncLog(SyncLogTableCompanion logEntry) {
    return into(syncLogTable).insert(logEntry);
  }

  Future<List<SyncLogTableData>> getPendingSyncLogs() {
    return (select(syncLogTable)..where((t) => t.status.equals('pending'))).get();
  }

  Future<int> updateSyncLogStatus(int id, String status, {String? errorMessage}) {
    return (update(syncLogTable)..where((t) => t.id.equals(id))).write(
      SyncLogTableCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        processedAt: Value(DateTime.now()),
      ),
    );
  }

  // Batch operations for sync
  Future<void> updateClientsSyncStatus(List<String> ids, String status) async {
    await (update(clientsTable)..where((t) => t.id.isIn(ids))).write(
      ClientsTableCompanion(
        syncStatus: Value(status),
        syncedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateCreditApplicationsSyncStatus(List<String> ids, String status) async {
    await (update(creditApplicationsTable)..where((t) => t.id.isIn(ids))).write(
      CreditApplicationsTableCompanion(
        syncStatus: Value(status),
        syncedAt: Value(DateTime.now()),
      ),
    );
  }
}

// === ARCHIVO: lib/core/error/failures.dart ===
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code, originalError];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory NetworkFailure.noConnection() => const NetworkFailure(
        message: 'No hay conexión a internet disponible',
        code: 1001,
      );

  factory NetworkFailure.timeout() => const NetworkFailure(
        message: 'La solicitud ha excedido el tiempo de espera',
        code: 1002,
      );

  factory NetworkFailure.serverError(int? statusCode) => NetworkFailure(
        message: 'Error del servidor: ${statusCode ?? 'desconocido'}',
        code: statusCode ?? 500,
      );

  factory NetworkFailure.unknown([String? details]) => NetworkFailure(
        message: details ?? 'Error de red desconocido',
        code: 1000,
      );
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory DatabaseFailure.insertError() => const DatabaseFailure(
        message: 'Error al insertar datos en la base de datos local',
        code: 2001,
      );

  factory DatabaseFailure.updateError() => const DatabaseFailure(
        message: 'Error al actualizar datos en la base de datos local',
        code: 2002,
      );

  factory DatabaseFailure.deleteError() => const DatabaseFailure(
        message: 'Error al eliminar datos de la base de datos local',
        code: 2003,
      );

  factory DatabaseFailure.queryError() => const DatabaseFailure(
        message: 'Error al consultar la base de datos local',
        code: 2004,
      );

  factory DatabaseFailure.unknown([String? details]) => DatabaseFailure(
        message: details ?? 'Error de base de datos desconocido',
        code: 2000,
      );
}

class SyncFailure extends Failure {
  final String? entityType;
  final String? entityId;

  const SyncFailure({
    required super.message,
    super.code,
    super.originalError,
    this.entityType,
    this.entityId,
  });

  factory SyncFailure.pendingChanges() => const SyncFailure(
        message: 'Hay cambios pendientes por sincronizar',
        code: 3001,
      );

  factory SyncFailure.conflictDetected(String entityType, String entityId) => SyncFailure(
        message: 'Conflicto detectado en $entityType con ID $entityId',
        code: 3002,
        entityType: entityType,
        entityId: entityId,
      );

  factory SyncFailure.uploadFailed(String entityType, String entityId) => SyncFailure(
        message: 'Error al subir $entityType con ID $entityId al servidor',
        code: 3003,
        entityType: entityType,
        entityId: entityId,
      );

  factory SyncFailure.downloadFailed() => const SyncFailure(
        message: 'Error al descargar datos del servidor',
        code: 3004,
      );

  factory SyncFailure.resolveFailed() => const SyncFailure(
        message: 'Error al resolver conflictos de sincronización',
        code: 3005,
      );

  factory SyncFailure.unknown([String? details]) => SyncFailure(
        message: details ?? 'Error de sincronización desconocido',
        code: 3000,
      );
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    super.originalError,
    this.fieldErrors,
  });

  factory ValidationFailure.required(String fieldName) => ValidationFailure(
        message: 'El campo $fieldName es requerido',
        code: 4001,
        fieldErrors: {fieldName: 'required'},
      );

  factory ValidationFailure.invalidFormat(String fieldName, String expected) => ValidationFailure(
        message: 'El campo $fieldName tiene formato inválido. Se espera: $expected',
        code: 4002,
        fieldErrors: {fieldName: 'invalid_format'},
      );

  factory ValidationFailure.invalidValue(String fieldName, String reason) => ValidationFailure(
        message: 'El campo $fieldName tiene valor inválido: $reason',
        code: 4003,
        fieldErrors: {fieldName: 'invalid_value'},
      );

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory CacheFailure.notFound() => const CacheFailure(
        message: 'Datos no encontrados en caché',
        code: 5001,
      );

  factory CacheFailure.expired() => const CacheFailure(
        message: 'Los datos en caché han expirado',
        code: 5002,
      );

  factory CacheFailure.writeError() => const CacheFailure(
        message: 'Error al escribir en caché',
        code: 5003,
      );

  factory CacheFailure.unknown([String? details]) => CacheFailure(
        message: details ?? 'Error de caché desconocido',
        code: 5000,
      );
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory UnknownFailure.fromException(dynamic error) => UnknownFailure(
        message: 'Error inesperado: ${error.toString()}',
        code: 9999,
        originalError: error,
      );
}


// === ARCHIVO: lib/domain/entities/client.dart ===
package lib.domain.entities;

import 'package:equatable/equatable.dart';

enum ClientSyncStatus { pending, synced, conflict }

class Client extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String identificationNumber;
  final ClientSyncStatus syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;

  const Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.identificationNumber,
    required this.syncStatus,
    required this.version,
    required this.lastModified,
    required this.createdAt,
    this.syncedAt,
  });

  String get fullName => '$firstName $lastName';

  bool get hasPendingSync => syncStatus == ClientSyncStatus.pending;

  bool get hasConflict => syncStatus == ClientSyncStatus.conflict;

  bool get isSynced => syncStatus == ClientSyncStatus.synced;

  Client copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? identificationNumber,
    ClientSyncStatus? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
  }) {
    return Client(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Client incrementVersion() {
    return copyWith(
      version: version + 1,
      lastModified: DateTime.now(),
    );
  }

  Client markAsPending() {
    return copyWith(
      syncStatus: ClientSyncStatus.pending,
      lastModified: DateTime.now(),
    );
  }

  Client markAsSynced() {
    return copyWith(
      syncStatus: ClientSyncStatus.synced,
      syncedAt: DateTime.now(),
    );
  }

  Client markAsConflict() {
    return copyWith(
      syncStatus: ClientSyncStatus.conflict,
      lastModified: DateTime.now(),
    );
  }

  static Client create({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address,
    required String identificationNumber,
  }) {
    final now = DateTime.now();
    return Client(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      identificationNumber: identificationNumber,
      syncStatus: ClientSyncStatus.pending,
      version: 1,
      lastModified: now,
      createdAt: now,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
        syncStatus,
        version,
        lastModified,
        createdAt,
        syncedAt,
      ];
}

// === ARCHIVO: lib/domain/entities/credit_application.dart ===
package lib.domain.entities;

import 'package:equatable/equatable.dart';

enum ApplicationStatus { pending, approved, rejected }

enum ApplicationSyncStatus { pending, synced, conflict }

class CreditApplication extends Equatable {
  final String id;
  final String clientId;
  final double requestedAmount;
  final String purpose;
  final int termMonths;
  final ApplicationStatus status;
  final ApplicationSyncStatus syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String? rejectionReason;
  final double? approvedAmount;

  const CreditApplication({
    required this.id,
    required this.clientId,
    required this.requestedAmount,
    required this.purpose,
    required this.termMonths,
    required this.status,
    required this.syncStatus,
    required this.version,
    required this.lastModified,
    required this.createdAt,
    this.syncedAt,
    this.rejectionReason,
    this.approvedAmount,
  });

  bool get hasPendingSync => syncStatus == ApplicationSyncStatus.pending;

  bool get hasConflict => syncStatus == ApplicationSyncStatus.conflict;

  bool get isSynced => syncStatus == ApplicationSyncStatus.synced;

  bool get isPending => status == ApplicationStatus.pending;

  bool get isApproved => status == ApplicationStatus.approved;

  bool get isRejected => status == ApplicationStatus.rejected;

  bool get hasApprovedAmount => approvedAmount != null && approvedAmount! > 0;

  double get approvalRate {
    if (approvedAmount == null || requestedAmount == 0) return 0.0;
    return approvedAmount! / requestedAmount;
  }

  CreditApplication copyWith({
    String? id,
    String? clientId,
    double? requestedAmount,
    String? purpose,
    int? termMonths,
    ApplicationStatus? status,
    ApplicationSyncStatus? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
    String? rejectionReason,
    double? approvedAmount,
  }) {
    return CreditApplication(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      requestedAmount: requestedAmount ?? this.requestedAmount,
      purpose: purpose ?? this.purpose,
      termMonths: termMonths ?? this.termMonths,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      approvedAmount: approvedAmount ?? this.approvedAmount,
    );
  }

  CreditApplication incrementVersion() {
    return copyWith(
      version: version + 1,
      lastModified: DateTime.now(),
    );
  }

  CreditApplication markAsPending() {
    return copyWith(
      syncStatus: ApplicationSyncStatus.pending,
      lastModified: DateTime.now(),
    );
  }

  CreditApplication markAsSynced() {
    return copyWith(
      syncStatus: ApplicationSyncStatus.synced,
      syncedAt: DateTime.now(),
    );
  }

  CreditApplication markAsConflict() {
    return copyWith(
      syncStatus: ApplicationSyncStatus.conflict,
      lastModified: DateTime.now(),
    );
  }

  CreditApplication approve(double amount) {
    return copyWith(
      status: ApplicationStatus.approved,
      approvedAmount: amount,
      syncStatus: ApplicationSyncStatus.pending,
      version: version + 1,
      lastModified: DateTime.now(),
    );
  }

  CreditApplication reject(String reason) {
    return copyWith(
      status: ApplicationStatus.rejected,
      rejectionReason: reason,
      syncStatus: ApplicationSyncStatus.pending,
      version: version + 1,
      lastModified: DateTime.now(),
    );
  }

  static CreditApplication create({
    required String id,
    required String clientId,
    required double requestedAmount,
    required String purpose,
    required int termMonths,
  }) {
    final now = DateTime.now();
    return CreditApplication(
      id: id,
      clientId: clientId,
      requestedAmount: requestedAmount,
      purpose: purpose,
      termMonths: termMonths,
      status: ApplicationStatus.pending,
      syncStatus: ApplicationSyncStatus.pending,
      version: 1,
      lastModified: now,
      createdAt: now,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clientId,
        requestedAmount,
        purpose,
        termMonths,
        status,
        syncStatus,
        version,
        lastModified,
        createdAt,
        syncedAt,
        rejectionReason,
        approvedAmount,
      ];
}

// === ARCHIVO: lib/domain/entities/sync_status.dart ===
package lib.domain.entities;

import 'package:equatable/equatable.dart';

enum SyncState { pending, syncing, synced, conflict, error }

enum SyncOperation { create, update, delete }

class SyncStatus extends Equatable {
  final String entityId;
  final String entityType;
  final SyncState state;
  final SyncOperation operation;
  final DateTime? lastSyncAttempt;
  final String? errorMessage;
  final int retryCount;
  final int version;
  final DateTime lastModified;

  const SyncStatus({
    required this.entityId,
    required this.entityType,
    required this.state,
    required this.operation,
    this.lastSyncAttempt,
    this.errorMessage,
    this.retryCount = 0,
    required this.version,
    required this.lastModified,
  });

  bool get isPending => state == SyncState.pending;

  bool get isSyncing => state == SyncState.syncing;

  bool get isSynced => state == SyncState.synced;

  bool get hasConflict => state == SyncState.conflict;

  bool get hasError => state == SyncState.error;

  bool get canRetry => retryCount < 3 && (hasError || isPending);

  bool get isStale {
    if (lastSyncAttempt == null) return true;
    final staleDuration = const Duration(hours: 24);
    return DateTime.now().difference(lastSyncAttempt!) > staleDuration;
  }

  SyncStatus copyWith({
    String? entityId,
    String? entityType,
    SyncState? state,
    SyncOperation? operation,
    DateTime? lastSyncAttempt,
    String? errorMessage,
    int? retryCount,
    int? version,
    DateTime? lastModified,
  }) {
    return SyncStatus(
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      state: state ?? this.state,
      operation: operation ?? this.operation,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      errorMessage: errorMessage ?? this.errorMessage,
      retryCount: retryCount ?? this.retryCount,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  SyncStatus startSync() {
    return copyWith(
      state: SyncState.syncing,
      lastSyncAttempt: DateTime.now(),
    );
  }

  SyncStatus markSynced() {
    return copyWith(
      state: SyncState.synced,
      lastSyncAttempt: DateTime.now(),
      errorMessage: null,
    );
  }

  SyncStatus markConflict() {
    return copyWith(
      state: SyncState.conflict,
      lastSyncAttempt: DateTime.now(),
    );
  }

  SyncStatus markError(String message) {
    return copyWith(
      state: SyncState.error,
      lastSyncAttempt: DateTime.now(),
      errorMessage: message,
      retryCount: retryCount + 1,
    );
  }

  SyncStatus incrementRetry() {
    return copyWith(
      retryCount: retryCount + 1,
      state: SyncState.pending,
    );
  }

  static SyncStatus forCreate({
    required String entityId,
    required String entityType,
    required int version,
  }) {
    final now = DateTime.now();
    return SyncStatus(
      entityId: entityId,
      entityType: entityType,
      state: SyncState.pending,
      operation: SyncOperation.create,
      version: version,
      lastModified: now,
    );
  }

  static SyncStatus forUpdate({
    required String entityId,
    required String entityType,
    required int version,
  }) {
    final now = DateTime.now();
    return SyncStatus(
      entityId: entityId,
      entityType: entityType,
      state: SyncState.pending,
      operation: SyncOperation.update,
      version: version,
      lastModified: now,
    );
  }

  static SyncStatus forDelete({
    required String entityId,
    required String entityType,
  }) {
    final now = DateTime.now();
    return SyncStatus(
      entityId: entityId,
      entityType: entityType,
      state: SyncState.pending,
      operation: SyncOperation.delete,
      version: 0,
      lastModified: now,
    );
  }

  @override
  List<Object?> get props => [
        entityId,
        entityType,
        state,
        operation,
        lastSyncAttempt,
        errorMessage,
        retryCount,
        version,
        lastModified,
      ];
}


// === ARCHIVO: lib/domain/repositories/client_repository.dart ===
package domain.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/client.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getClients();
  
  Future<Either<Failure, Client>> getClientById(String id);
  
  Future<Either<Failure, Client>> saveClient(Client client);
  
  Future<Either<Failure, void>> deleteClient(String id);
  
  Future<Either<Failure, List<Client>>> getPendingClients();
  
  Stream<List<Client>> watchAllClients();
  
  Stream<List<Client>> watchPendingClients();
}

class ClientFilter extends Equatable {
  final String? searchQuery;
  final ClientSyncStatus? syncStatus;
  final DateTime? fromDate;
  final DateTime? toDate;

  const ClientFilter({
    this.searchQuery,
    this.syncStatus,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [searchQuery, syncStatus, fromDate, toDate];
}

enum ClientSyncStatus {
  pending,
  synced,
  conflict,
}

// === ARCHIVO: lib/domain/repositories/credit_application_repository.dart ===
package domain.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/credit_application.dart';

abstract class CreditApplicationRepository {
  Future<Either<Failure, List<CreditApplication>>> getCreditApplications();
  
  Future<Either<Failure, CreditApplication>> getCreditApplicationById(String id);
  
  Future<Either<Failure, List<CreditApplication>>> getCreditApplicationsByClientId(String clientId);
  
  Future<Either<Failure, CreditApplication>> saveCreditApplication(CreditApplication application);
  
  Future<Either<Failure, void>> deleteCreditApplication(String id);
  
  Future<Either<Failure, List<CreditApplication>>> getPendingCreditApplications();
  
  Stream<List<CreditApplication>> watchAllCreditApplications();
  
  Stream<List<CreditApplication>> watchPendingCreditApplications();
  
  Future<Either<Failure, CreditApplication>> approveApplication(String id, double approvedAmount);
  
  Future<Either<Failure, CreditApplication>> rejectApplication(String id, String reason);
}

class CreditApplicationFilter extends Equatable {
  final String? clientId;
  final ApplicationSyncStatus? syncStatus;
  final ApplicationStatus? status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final double? minAmount;
  final double? maxAmount;

  const CreditApplicationFilter({
    this.clientId,
    this.syncStatus,
    this.status,
    this.fromDate,
    this.toDate,
    this.minAmount,
    this.maxAmount,
  });

  @override
  List<Object?> get props => [
        clientId,
        syncStatus,
        status,
        fromDate,
        toDate,
        minAmount,
        maxAmount,
      ];
}

enum ApplicationSyncStatus {
  pending,
  synced,
  conflict,
}

enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  approved,
  rejected,
}

// === ARCHIVO: lib/domain/usecases/save_client.dart ===
package domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../core/error/failures.dart';
import '../entities/client.dart';
import '../entities/sync_status.dart';
import '../repositories/client_repository.dart';

class SaveClient {
  final ClientRepository repository;
  final Uuid _uuid;

  SaveClient(this.repository) : _uuid = const Uuid();

  Future<Either<Failure, Client>> call(SaveClientParams params) async {
    final now = DateTime.now();
    
    final clientId = params.id ?? _uuid.v4();
    
    final validationResult = _validateClientParams(params);
    if (validationResult != null) {
      return Left(validationResult);
    }

    final client = Client(
      id: clientId,
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phone: params.phone,
      address: params.address,
      identificationNumber: params.identificationNumber,
      syncStatus: SyncStatus.pending,
      version: 1,
      lastModified: now,
      createdAt: now,
      syncedAt: null,
    );

    return repository.saveClient(client);
  }

  ValidationFailure? _validateClientParams(SaveClientParams params) {
    if (params.firstName == null || params.firstName!.trim().isEmpty) {
      return const ValidationFailure.required('firstName');
    }
    if (params.lastName == null || params.lastName!.trim().isEmpty) {
      return const ValidationFailure.required('lastName');
    }
    if (params.phone == null || params.phone!.trim().isEmpty) {
      return const ValidationFailure.required('phone');
    }
    if (params.identificationNumber == null || params.identificationNumber!.trim().isEmpty) {
      return const ValidationFailure.required('identificationNumber');
    }
    if (params.email != null && params.email!.isNotEmpty) {
      if (!_isValidEmail(params.email!)) {
        return ValidationFailure.invalidFormat('email', 'a valid email format');
      }
    }
    return null;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}

class SaveClientParams extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;
  final String? email;
  final String phone;
  final String? address;
  final String identificationNumber;

  const SaveClientParams({
    this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phone,
    this.address,
    required this.identificationNumber,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
      ];
}

class UpdateClient {
  final ClientRepository repository;

  UpdateClient(this.repository);

  Future<Either<Failure, Client>> call(UpdateClientParams params) async {
    final existingResult = await repository.getClientById(params.id);
    
    return existingResult.fold(
      (failure) => Left(failure),
      (existingClient) async {
        final now = DateTime.now();
        final updatedClient = existingClient.copyWith(
          firstName: params.firstName,
          lastName: params.lastName,
          email: params.email,
          phone: params.phone,
          address: params.address,
          identificationNumber: params.identificationNumber,
          syncStatus: SyncStatus.pending,
          version: existingClient.version + 1,
          lastModified: now,
        );
        
        return repository.saveClient(updatedClient);
      },
    );
  }
}

class UpdateClientParams extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String phone;
  final String? address;
  final String identificationNumber;

  const UpdateClientParams({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phone,
    this.address,
    required this.identificationNumber,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
      ];
}


// === ARCHIVO: lib/domain/usecases/sync_clients.dart ===
package credit_field_app.domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../entities/client.dart';
import '../entities/sync_status.dart';
import '../repositories/client_repository.dart';

class SyncClientsParams extends Equatable {
  final bool forceFullSync;
  final int? batchSize;

  const SyncClientsParams({
    this.forceFullSync = false,
    this.batchSize,
  });

  @override
  List<Object?> get props => [forceFullSync, batchSize];
}

class SyncClientsResult extends Equatable {
  final int totalProcessed;
  final int successfullySynced;
  final int failedSync;
  final int conflictsDetected;
  final List<String> failedClientIds;
  final List<String> conflictClientIds;

  const SyncClientsResult({
    required this.totalProcessed,
    required this.successfullySynced,
    required this.failedSync,
    required this.conflictsDetected,
    required this.failedClientIds,
    required this.conflictClientIds,
  });

  bool get hasErrors => failedSync > 0 || conflictsDetected > 0;
  bool get hasConflicts => conflictsDetected > 0;
  double get successRate =>
      totalProcessed > 0 ? (successfullySynced / totalProcessed) * 100 : 0;

  @override
  List<Object?> get props => [
        totalProcessed,
        successfullySynced,
        failedSync,
        conflictsDetected,
        failedClientIds,
        conflictClientIds,
      ];
}

class SyncClients {
  final ClientRepository clientRepository;

  SyncClients({required this.clientRepository});

  Future<Either<Failure, SyncClientsResult>> call(SyncClientsParams params) async {
    try {
      final pendingClientsResult = await clientRepository.getPendingClients();
      
      return pendingClientsResult.fold(
        (failure) => Left(failure),
        (pendingClients) async {
          if (pendingClients.isEmpty) {
            return const Right(SyncClientsResult(
              totalProcessed: 0,
              successfullySynced: 0,
              failedSync: 0,
              conflictsDetected: 0,
              failedClientIds: [],
              conflictClientIds: [],
            ));
          }

          final batchSize = params.batchSize ?? pendingClients.length;
          final clientsToProcess = params.forceFullSync
              ? pendingClients
              : pendingClients.take(batchSize).toList();

          int successfullySynced = 0;
          int failedSync = 0;
          int conflictsDetected = 0;
          final List<String> failedClientIds = [];
          final List<String> conflictClientIds = [];

          for (final client in clientsToProcess) {
            final syncResult = await _syncSingleClient(client);
            
            syncResult.fold(
              (failure) {
                failedSync++;
                failedClientIds.add(client.id);
              },
              (result) {
                if (result == _SyncClientOutcome.synced) {
                  successfullySynced++;
                } else if (result == _SyncClientOutcome.conflict) {
                  conflictsDetected++;
                  conflictClientIds.add(client.id);
                } else {
                  failedSync++;
                  failedClientIds.add(client.id);
                }
              },
            );
          }

          return Right(SyncClientsResult(
            totalProcessed: clientsToProcess.length,
            successfullySynced: successfullySynced,
            failedSync: failedSync,
            conflictsDetected: conflictsDetected,
            failedClientIds: failedClientIds,
            conflictClientIds: conflictClientIds,
          ));
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<Either<Failure, _SyncClientOutcome>> _syncSingleClient(Client client) async {
    try {
      final uploadResult = await clientRepository.uploadClientToServer(client);

      return uploadResult.fold(
        (failure) async {
          if (failure is SyncFailure && 
              failure.message.contains('conflict')) {
            await clientRepository.updateClientSyncStatus(
              client.id,
              SyncStatus.conflict,
            );
            return const Right(_SyncClientOutcome.conflict);
          }
          
          await clientRepository.updateClientSyncStatus(
            client.id,
            SyncStatus.pending,
          );
          return const Right(_SyncClientOutcome.failed);
        },
        (serverVersion) async {
          final updatedClient = client.copyWith(
            syncStatus: SyncStatus.synced,
            version: serverVersion,
            syncedAt: DateTime.now(),
          );
          
          await clientRepository.saveClient(updatedClient);
          return const Right(_SyncClientOutcome.synced);
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }
}

enum _SyncClientOutcome {
  synced,
  conflict,
  failed,
}

// === ARCHIVO: lib/domain/usecases/resolve_conflicts.dart ===
package credit_field_app.domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../entities/client.dart';
import '../entities/credit_application.dart';
import '../entities/sync_status.dart';
import '../repositories/client_repository.dart';
import '../repositories/credit_application_repository.dart';

enum ConflictResolutionStrategy {
  lastWriteWins,
  serverWins,
  clientWins,
  manual,
}

class ConflictResolutionParams extends Equatable {
  final ConflictResolutionStrategy strategy;
  final bool resolveAllAutomatically;
  final List<String>? specificClientIds;
  final List<String>? specificApplicationIds;

  const ConflictResolutionParams({
    this.strategy = ConflictResolutionStrategy.lastWriteWins,
    this.resolveAllAutomatically = false,
    this.specificClientIds,
    this.specificApplicationIds,
  });

  @override
  List<Object?> get props => [
        strategy,
        resolveAllAutomatically,
        specificClientIds,
        specificApplicationIds,
      ];
}

class ConflictInfo extends Equatable {
  final String entityType;
  final String entityId;
  final dynamic localVersion;
  final dynamic serverVersion;
  final DateTime localLastModified;
  final DateTime serverLastModified;
  final Map<String, dynamic>? localData;
  final Map<String, dynamic>? serverData;

  const ConflictInfo({
    required this.entityType,
    required this.entityId,
    required this.localVersion,
    required this.serverVersion,
    required this.localLastModified,
    required this.serverLastModified,
    this.localData,
    this.serverData,
  });

  bool get localIsNewer => localLastModified.isAfter(serverLastModified);
  bool get serverIsNewer => serverLastModified.isAfter(localLastModified);

  @override
  List<Object?> get props => [
        entityType,
        entityId,
        localVersion,
        serverVersion,
        localLastModified,
        serverLastModified,
        localData,
        serverData,
      ];
}

class ConflictResolutionResult extends Equatable {
  final int totalConflicts;
  final int resolved;
  final int failed;
  final int skipped;
  final List<String> resolvedClientIds;
  final List<String> resolvedApplicationIds;
  final List<ConflictInfo> unresolvedConflicts;

  const ConflictResolutionResult({
    required this.totalConflicts,
    required this.resolved,
    required this.failed,
    required this.skipped,
    required this.resolvedClientIds,
    required this.resolvedApplicationIds,
    required this.unresolvedConflicts,
  });

  bool get hasUnresolved => unresolvedConflicts.isNotEmpty;
  double get resolutionRate =>
      totalConflicts > 0 ? (resolved / totalConflicts) * 100 : 0;

  @override
  List<Object?> get props => [
        totalConflicts,
        resolved,
        failed,
        skipped,
        resolvedClientIds,
        resolvedApplicationIds,
        unresolvedConflicts,
      ];
}

class ResolveConflicts {
  final ClientRepository clientRepository;
  final CreditApplicationRepository creditApplicationRepository;

  ResolveConflicts({
    required this.clientRepository,
    required this.creditApplicationRepository,
  });

  Future<Either<Failure, ConflictResolutionResult>> call(
    ConflictResolutionParams params,
  ) async {
    try {
      final List<ConflictInfo> allConflicts = [];
      final List<String> resolvedClientIds = [];
      final List<String> resolvedApplicationIds = [];
      final List<ConflictInfo> unresolvedConflicts = [];

      final clientsResult = await _getConflictedClients(params);
      final applicationsResult = await _getConflictedApplications(params);

      clientsResult.fold(
        (failure) => Left(failure),
        (clientConflicts) => allConflicts.addAll(clientConflicts),
      );

      applicationsResult.fold(
        (failure) => Left(failure),
        (applicationConflicts) => allConflicts.addAll(applicationConflicts),
      );

      if (allConflicts.isEmpty) {
        return const Right(ConflictResolutionResult(
          totalConflicts: 0,
          resolved: 0,
          failed: 0,
          skipped: 0,
          resolvedClientIds: [],
          resolvedApplicationIds: [],
          unresolvedConflicts: [],
        ));
      }

      int resolved = 0;
      int failed = 0;
      int skipped = 0;

      for (final conflict in allConflicts) {
        if (params.strategy == ConflictResolutionStrategy.manual &&
            !params.resolveAllAutomatically) {
          skipped++;
          unresolvedConflicts.add(conflict);
          continue;
        }

        final resolutionResult = await _resolveSingleConflict(
          conflict,
          params.strategy,
        );

        resolutionResult.fold(
          (failure) {
            failed++;
            unresolvedConflicts.add(conflict);
          },
          (success) {
            resolved++;
            if (conflict.entityType == 'client') {
              resolvedClientIds.add(conflict.entityId);
            } else if (conflict.entityType == 'credit_application') {
              resolvedApplicationIds.add(conflict.entityId);
            }
          },
        );
      }

      return Right(ConflictResolutionResult(
        totalConflicts: allConflicts.length,
        resolved: resolved,
        failed: failed,
        skipped: skipped,
        resolvedClientIds: resolvedClientIds,
        resolvedApplicationIds: resolvedApplicationIds,
        unresolvedConflicts: unresolvedConflicts,
      ));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<Either<Failure, List<ConflictInfo>>> _getConflictedClients(
    ConflictResolutionParams params,
  ) async {
    final pendingResult = await clientRepository.getConflictedClients();

    return pendingResult.fold(
      (failure) => Left(failure),
      (clients) {
        final conflicts = <ConflictInfo>[];
        for (final client in clients) {
          if (params.specificClientIds != null &&
              !params.specificClientIds!.contains(client.id)) {
            continue;
          }

          final serverDataResult = 
              await clientRepository.getClientFromServer(client.id);

          serverDataResult.fold(
            (failure) {},
            (serverClient) {
              if (serverClient != null && 
                  serverClient.version > client.version) {
                conflicts.add(ConflictInfo(
                  entityType: 'client',
                  entityId: client.id,
                  localVersion: client.version,
                  serverVersion: serverClient.version,
                  localLastModified: client.lastModified,
                  serverLastModified: serverClient.lastModified,
                  localData: _clientToMap(client),
                  serverData: _clientToMap(serverClient),
                ));
              }
            },
          );
        }
        return Right(conflicts);
      },
    );
  }

  Future<Either<Failure, List<ConflictInfo>>> _getConflictedApplications(
    ConflictResolutionParams params,
  ) async {
    final pendingResult = 
        await creditApplicationRepository.getConflictedApplications();

    return pendingResult.fold(
      (failure) => Left(failure),
      (applications) {
        final conflicts = <ConflictInfo>[];
        for (final application in applications) {
          if (params.specificApplicationIds != null &&
              !params.specificApplicationIds!.contains(application.id)) {
            continue;
          }

          final serverDataResult = await creditApplicationRepository
              .getCreditApplicationFromServer(application.id);

          serverDataResult.fold(
            (failure) {},
            (serverApplication) {
              if (serverApplication != null &&
                  serverApplication.version > application.version) {
                conflicts.add(ConflictInfo(
                  entityType: 'credit_application',
                  entityId: application.id,
                  localVersion: application.version,
                  serverVersion: serverApplication.version,
                  localLastModified: application.lastModified,
                  serverLastModified: serverApplication.lastModified,
                  localData: _applicationToMap(application),
                  serverData: _applicationToMap(serverApplication),
                ));
              }
            },
          );
        }
        return Right(conflicts);
      },
    );
  }

  Future<Either<Failure, bool>> _resolveSingleConflict(
    ConflictInfo conflict,
    ConflictResolutionStrategy strategy,
  ) async {
    try {
      final winnerData = _determineWinner(conflict, strategy);

      if (conflict.entityType == 'client') {
        return await _resolveClientConflict(conflict.entityId, winnerData);
      } else if (conflict.entityType == 'credit_application') {
        return await _resolveApplicationConflict(
            conflict.entityId, winnerData);
      }

      return const Right(false);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Map<String, dynamic> _determineWinner(
    ConflictInfo conflict,
    ConflictResolutionStrategy strategy,
  ) {
    switch (strategy) {
      case ConflictResolutionStrategy.lastWriteWins:
        return conflict.localIsNewer 
            ? conflict.localData! 
            : conflict.serverData!;
      case ConflictResolutionStrategy.serverWins:
        return conflict.serverData!;
      case ConflictResolutionStrategy.clientWins:
        return conflict.localData!;
      case ConflictResolutionStrategy.manual:
        return conflict.localData!;
    }
  }

  Future<Either<Failure, bool>> _resolveClientConflict(
    String clientId,
    Map<String, dynamic> winnerData,
  ) async {
    try {
      final clientResult = await clientRepository.getClientById(clientId);

      return clientResult.fold(
        (failure) => Left(failure),
        (client) async {
          if (client == null) {
            return const Right(false);
          }

          final updatedClient = client.copyWith(
            firstName: winnerData['firstName'] as String? ?? client.firstName,
            lastName: winnerData['lastName'] as String? ?? client.lastName,
            email: winnerData['email'] as String? ?? client.email,
            phone: winnerData['phone'] as String? ?? client.phone,
            address: winnerData['address'] as String? ?? client.address,
            identificationNumber: winnerData['identificationNumber'] 
                as String? ?? client.identificationNumber,
            syncStatus: SyncStatus.synced,
            version: winnerData['version'] as int? ?? (client.version + 1),
            syncedAt: DateTime.now(),
          );

          await clientRepository.saveClient(updatedClient);
          return const Right(true);
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<Either<Failure, bool>> _resolveApplicationConflict(
    String applicationId,
    Map<String, dynamic> winnerData,
  ) async {
    try {
      final applicationResult = 
          await creditApplicationRepository.getCreditApplicationById(applicationId);

      return applicationResult.fold(
        (failure) => Left(failure),
        (application) async {
          if (application == null) {
            return const Right(false);
          }

          final updatedApplication = application.copyWith(
            requestedAmount: winnerData['requestedAmount'] 
                as double? ?? application.requestedAmount,
            purpose: winnerData['purpose'] as String? ?? application.purpose,
            termMonths: winnerData['termMonths'] as int? ?? application.termMonths,
            status: winnerData['status'] as String? ?? application.status,
            syncStatus: SyncStatus.synced,
            version: winnerData['version'] as int? ?? (application.version + 1),
            syncedAt: DateTime.now(),
          );

          await creditApplicationRepository
              .saveCreditApplication(updatedApplication);
          return const Right(true);
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Map<String, dynamic> _clientToMap(Client client) {
    return {
      'id': client.id,
      'firstName': client.firstName,
      'lastName': client.lastName,
      'email': client.email,
      'phone': client.phone,
      'address': client.address,
      'identificationNumber': client.identificationNumber,
      'version': client.version,
      'lastModified': client.lastModified.toIso8601String(),
    };
  }

  Map<String, dynamic> _applicationToMap(CreditApplication application) {
    return {
      'id': application.id,
      'clientId': application.clientId,
      'requestedAmount': application.requestedAmount,
      'purpose': application.purpose,
      'termMonths': application.termMonths,
      'status': application.status,
      'version': application.version,
      'lastModified': application.lastModified.toIso8601String(),
    };
  }
}


// === ARCHIVO: lib/data/models/client_model.dart ===
package credit_field_app.data.models;

import 'package:equatable/equatable.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/sync_status.dart';

class ClientModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String identificationNumber;
  final SyncStatus syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;

  const ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.identificationNumber,
    required this.syncStatus,
    required this.version,
    required this.lastModified,
    required this.createdAt,
    this.syncedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      identificationNumber: json['identificationNumber'] as String,
      syncStatus: _parseSyncStatus(json['syncStatus'] as String?),
      version: json['version'] as int? ?? 1,
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      syncedAt: json['syncedAt'] != null
          ? DateTime.parse(json['syncedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'identificationNumber': identificationNumber,
      'syncStatus': syncStatus.name,
      'version': version,
      'lastModified': lastModified.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }

  factory ClientModel.fromEntity(Client entity) {
    return ClientModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      identificationNumber: entity.identificationNumber,
      syncStatus: entity.syncStatus,
      version: entity.version,
      lastModified: entity.lastModified,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
    );
  }

  Client toEntity() {
    return Client(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      identificationNumber: identificationNumber,
      syncStatus: syncStatus,
      version: version,
      lastModified: lastModified,
      createdAt: createdAt,
      syncedAt: syncedAt,
    );
  }

  ClientModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? identificationNumber,
    SyncStatus? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  static SyncStatus _parseSyncStatus(String? status) {
    switch (status) {
      case 'synced':
        return SyncStatus.synced;
      case 'conflict':
        return SyncStatus.conflict;
      case 'pending':
      default:
        return SyncStatus.pending;
    }
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
        syncStatus,
        version,
        lastModified,
        createdAt,
        syncedAt,
      ];
}

// === ARCHIVO: lib/data/models/credit_application_model.dart ===
package credit_field_app.data.models;

import 'package:equatable/equatable.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/entities/sync_status.dart';

enum ApplicationStatus { pending, approved, rejected, underReview }

class CreditApplicationModel extends Equatable {
  final String id;
  final String clientId;
  final double requestedAmount;
  final String purpose;
  final int termMonths;
  final ApplicationStatus status;
  final SyncStatus syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String? rejectionReason;
  final double? approvedAmount;

  const CreditApplicationModel({
    required this.id,
    required this.clientId,
    required this.requestedAmount,
    required this.purpose,
    required this.termMonths,
    required this.status,
    required this.syncStatus,
    required this.version,
    required this.lastModified,
    required this.createdAt,
    this.syncedAt,
    this.rejectionReason,
    this.approvedAmount,
  });

  factory CreditApplicationModel.fromJson(Map<String, dynamic> json) {
    return CreditApplicationModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      purpose: json['purpose'] as String,
      termMonths: json['termMonths'] as int,
      status: _parseApplicationStatus(json['status'] as String?),
      syncStatus: _parseSyncStatus(json['syncStatus'] as String?),
      version: json['version'] as int? ?? 1,
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      syncedAt: json['syncedAt'] != null
          ? DateTime.parse(json['syncedAt'] as String)
          : null,
      rejectionReason: json['rejectionReason'] as String?,
      approvedAmount: json['approvedAmount'] != null
          ? (json['approvedAmount'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'requestedAmount': requestedAmount,
      'purpose': purpose,
      'termMonths': termMonths,
      'status': status.name,
      'syncStatus': syncStatus.name,
      'version': version,
      'lastModified': lastModified.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'approvedAmount': approvedAmount,
    };
  }

  factory CreditApplicationModel.fromEntity(CreditApplication entity) {
    return CreditApplicationModel(
      id: entity.id,
      clientId: entity.clientId,
      requestedAmount: entity.requestedAmount,
      purpose: entity.purpose,
      termMonths: entity.termMonths,
      status: _mapEntityStatus(entity.status),
      syncStatus: entity.syncStatus,
      version: entity.version,
      lastModified: entity.lastModified,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
      rejectionReason: entity.rejectionReason,
      approvedAmount: entity.approvedAmount,
    );
  }

  CreditApplication toEntity() {
    return CreditApplication(
      id: id,
      clientId: clientId,
      requestedAmount: requestedAmount,
      purpose: purpose,
      termMonths: termMonths,
      status: _mapModelStatus(status),
      syncStatus: syncStatus,
      version: version,
      lastModified: lastModified,
      createdAt: createdAt,
      syncedAt: syncedAt,
      rejectionReason: rejectionReason,
      approvedAmount: approvedAmount,
    );
  }

  CreditApplicationModel copyWith({
    String? id,
    String? clientId,
    double? requestedAmount,
    String? purpose,
    int? termMonths,
    ApplicationStatus? status,
    SyncStatus? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
    String? rejectionReason,
    double? approvedAmount,
  }) {
    return CreditApplicationModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      requestedAmount: requestedAmount ?? this.requestedAmount,
      purpose: purpose ?? this.purpose,
      termMonths: termMonths ?? this.termMonths,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      approvedAmount: approvedAmount ?? this.approvedAmount,
    );
  }

  static ApplicationStatus _parseApplicationStatus(String? status) {
    switch (status) {
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'underReview':
        return ApplicationStatus.underReview;
      case 'pending':
      default:
        return ApplicationStatus.pending;
    }
  }

  static SyncStatus _parseSyncStatus(String? status) {
    switch (status) {
      case 'synced':
        return SyncStatus.synced;
      case 'conflict':
        return SyncStatus.conflict;
      case 'pending':
      default:
        return SyncStatus.pending;
    }
  }

  static ApplicationStatus _mapEntityStatus(
      CreditApplicationStatus entityStatus) {
    switch (entityStatus) {
      case CreditApplicationStatus.approved:
        return ApplicationStatus.approved;
      case CreditApplicationStatus.rejected:
        return ApplicationStatus.rejected;
      case CreditApplicationStatus.underReview:
        return ApplicationStatus.underReview;
      case CreditApplicationStatus.pending:
        return ApplicationStatus.pending;
    }
  }

  static CreditApplicationStatus _mapModelStatus(ApplicationStatus modelStatus) {
    switch (modelStatus) {
      case ApplicationStatus.approved:
        return CreditApplicationStatus.approved;
      case ApplicationStatus.rejected:
        return CreditApplicationStatus.rejected;
      case ApplicationStatus.underReview:
        return CreditApplicationStatus.underReview;
      case ApplicationStatus.pending:
        return CreditApplicationStatus.pending;
    }
  }

  @override
  List<Object?> get props => [
        id,
        clientId,
        requestedAmount,
        purpose,
        termMonths,
        status,
        syncStatus,
        version,
        lastModified,
        createdAt,
        syncedAt,
        rejectionReason,
        approvedAmount,
      ];
}

// === ARCHIVO: lib/data/datasources/local/client_local_datasource.dart ===
package credit_field_app.data.datasources.local;

import 'package:drift/drift.dart';
import 'package:dartz/dartz.dart';
import '../../../core/database/app_database.dart';
import '../../../core/error/failures.dart';
import '../../models/client_model.dart';
import '../../../domain/entities/sync_status.dart';

abstract class ClientLocalDataSource {
  Future<Either<Failure, List<ClientModel>>> getAllClients();
  Stream<Either<Failure, List<ClientModel>>> watchAllClients();
  Future<Either<Failure, ClientModel?>> getClientById(String id);
  Future<Either<Failure, ClientModel>> saveClient(ClientModel client);
  Future<Either<Failure, bool>> updateClient(ClientModel client);
  Future<Either<Failure, int>> deleteClient(String id);
  Future<Either<Failure, List<ClientModel>>> getPendingClients();
  Stream<Either<Failure, List<ClientModel>>> watchPendingClients();
  Future<Either<Failure, void>> updateSyncStatus(
      List<String> ids, SyncStatus status);
}

class ClientLocalDataSourceImpl implements ClientLocalDataSource {
  final AppDatabase _database;

  ClientLocalDataSourceImpl(this._database);

  @override
  Future<Either<Failure, List<ClientModel>>> getAllClients() async {
    try {
      final clients = await _database.getAllClients();
      return Right(clients.map(_mapToModel).toList());
    } catch (e) {
      return Left(DatabaseFailure.queryError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ClientModel>>> watchAllClients() {
    return _database.watchAllClients().map((clients) {
      try {
        return Right<Failure, List<ClientModel>>(
            clients.map(_mapToModel).toList());
      } catch (e) {
        return Left<Failure, List<ClientModel>>(
            DatabaseFailure.queryError(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, ClientModel?>> getClientById(String id) async {
    try {
      final client = await _database.getClientById(id);
      if (client == null) {
        return const Right(null);
      }
      return Right(_mapToModel(client));
    } catch (e) {
      return Left(DatabaseFailure.queryError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClientModel>> saveClient(ClientModel client) async {
    try {
      final existingClient = await _database.getClientById(client.id);
      final now = DateTime.now();

      final companion = ClientsTableCompanion(
        id: Value(client.id),
        firstName: Value(client.firstName),
        lastName: Value(client.lastName),
        email: Value(client.email),
        phone: Value(client.phone),
        address: Value(client.address),
        identificationNumber: Value(client.identificationNumber),
        syncStatus: Value(client.syncStatus.name),
        version: Value(client.version),
        lastModified: Value(now),
        createdAt: Value(existingClient?.createdAt ?? now),
        syncedAt: Value(
            client.syncStatus == SyncStatus.synced ? now : client.syncedAt),
      );

      if (existingClient != null) {
        final updated = await _database.updateClient(companion);
        if (!updated) {
          return Left(DatabaseFailure.updateError());
        }
      } else {
        final id = await _database.insertClient(companion);
        if (id == 0) {
          return Left(DatabaseFailure.insertError());
        }
      }

      final savedClient = await _database.getClientById(client.id);
      if (savedClient == null) {
        return Left(DatabaseFailure.queryError('Client not found after save'));
      }

      return Right(_mapToModel(savedClient));
    } catch (e) {
      return Left(DatabaseFailure.insertError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateClient(ClientModel client) async {
    try {
      final now = DateTime.now();
      final companion = ClientsTableCompanion(
        id: Value(client.id),
        firstName: Value(client.firstName),
        lastName: Value(client.lastName),
        email: Value(client.email),
        phone: Value(client.phone),
        address: Value(client.address),
        identificationNumber: Value(client.identificationNumber),
        syncStatus: Value(client.syncStatus.name),
        version: Value(client.version + 1),
        lastModified: Value(now),
        createdAt: Value(client.createdAt),
        syncedAt: Value(client.syncedAt),
      );

      final result = await _database.updateClient(companion);
      if (!result) {
        return Left(DatabaseFailure.updateError());
      }
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure.updateError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteClient(String id) async {
    try {
      final result = await _database.deleteClient(id);
      if (result == 0) {
        return Left(DatabaseFailure.deleteError('Client not found'));
      }
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure.deleteError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClientModel>>> getPendingClients() async {
    try {
      final clients = await _database.getPendingClients();
      return Right(clients.map(_mapToModel).toList());
    } catch (e) {
      return Left(DatabaseFailure.queryError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ClientModel>>> watchPendingClients() {
    return _database.watchPendingClients().map((clients) {
      try {
        return Right<Failure, List<ClientModel>>(
            clients.map(_mapToModel).toList());
      } catch (e) {
        return Left<Failure, List<ClientModel>>(
            DatabaseFailure.queryError(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> updateSyncStatus(
      List<String> ids, SyncStatus status) async {
    try {
      await _database.updateClientsSyncStatus(
        ids,
        status.name,
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure.updateError(e.toString()));
    }
  }

  ClientModel _mapToModel(ClientsTableData data) {
    return ClientModel(
      id: data.id,
      firstName: data.firstName,
      lastName: data.lastName,
      email: data.email,
      phone: data.phone,
      address: data.address,
      identificationNumber: data.identificationNumber,
      syncStatus: _parseSyncStatus(data.syncStatus),
      version: data.version,
      lastModified: data.lastModified,
      createdAt: data.createdAt,
      syncedAt: data.syncedAt,
    );
  }

  SyncStatus _parseSyncStatus(String status) {
    switch (status) {
      case 'synced':
        return SyncStatus.synced;
      case 'conflict':
        return SyncStatus.conflict;
      case 'pending':
      default:
        return SyncStatus.pending;
    }
  }
}


// === ARCHIVO: lib/data/datasources/local/credit_application_local_datasource.dart ===
package lib.data.datasources.local;

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../models/credit_application_model.dart';
import '../../../core/database/app_database.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/credit_application.dart';

abstract class CreditApplicationLocalDatasource {
  Future<Either<Failure, List<CreditApplicationModel>>> getAllApplications();
  Stream<List<CreditApplicationModel>> watchAllApplications();
  Future<Either<Failure, CreditApplicationModel>> getApplicationById(String id);
  Future<Either<Failure, List<CreditApplicationModel>>> getApplicationsByClientId(String clientId);
  Future<Either<Failure, String>> saveApplication(CreditApplicationModel application);
  Future<Either<Failure, bool>> updateApplication(CreditApplicationModel application);
  Future<Either<Failure, bool>> deleteApplication(String id);
  Future<Either<Failure, List<CreditApplicationModel>>> getPendingApplications();
  Stream<List<CreditApplicationModel>> watchPendingApplications();
  Future<Either<Failure, void>> updateSyncStatus(String id, String status);
  Future<Either<Failure, void>> markAsSynced(String id, DateTime syncedAt);
}

class CreditApplicationLocalDatasourceImpl implements CreditApplicationLocalDatasource {
  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  CreditApplicationLocalDatasourceImpl(this._database);

  @override
  Future<Either<Failure, List<CreditApplicationModel>>> getAllApplications() async {
    try {
      final applications = await _database.getAllCreditApplications();
      final models = applications.map(_mapToModel).toList();
      return Right(models);
    } catch (e) {
      return Left(DatabaseFailure.queryError('Error al obtener solicitudes: $e'));
    }
  }

  @override
  Stream<List<CreditApplicationModel>> watchAllApplications() {
    return _database.watchAllCreditApplications().map(
      (applications) => applications.map(_mapToModel).toList(),
    );
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> getApplicationById(String id) async {
    try {
      final application = await _database.getCreditApplicationById(id);
      if (application == null) {
        return const Left(DatabaseFailure.notFound());
      }
      return Right(_mapToModel(application));
    } catch (e) {
      return Left(DatabaseFailure.queryError('Error al obtener solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplicationModel>>> getApplicationsByClientId(String clientId) async {
    try {
      final applications = await _database.getCreditApplicationsByClientId(clientId);
      final models = applications.map(_mapToModel).toList();
      return Right(models);
    } catch (e) {
      return Left(DatabaseFailure.queryError('Error al obtener solicitudes del cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> saveApplication(CreditApplicationModel application) async {
    try {
      final id = application.id.isEmpty ? _uuid.v4() : application.id;
      final now = DateTime.now();
      
      final companion = CreditApplicationsTableCompanion.insert(
        id: id,
        clientId: application.clientId,
        requestedAmount: application.requestedAmount,
        purpose: application.purpose,
        termMonths: application.termMonths,
        status: application.status,
        syncStatus: const Value('pending'),
        version: const Value(1),
        lastModified: now,
        createdAt: now,
        syncedAt: const Value(null),
        rejectionReason: Value(application.rejectionReason),
        approvedAmount: Value(application.approvedAmount),
      );
      
      await _database.insertCreditApplication(companion);
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure.insertError('Error al guardar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateApplication(CreditApplicationModel application) async {
    try {
      final existing = await _database.getCreditApplicationById(application.id);
      if (existing == null) {
        return const Left(DatabaseFailure.notFound());
      }

      final now = DateTime.now();
      final newVersion = existing.version + 1;
      final needsSync = application.syncStatus == 'pending' || 
                        (existing.syncStatus == 'synced' && application.syncStatus == 'pending');

      final companion = CreditApplicationsTableCompanion(
        id: Value(application.id),
        clientId: Value(application.clientId),
        requestedAmount: Value(application.requestedAmount),
        purpose: Value(application.purpose),
        termMonths: Value(application.termMonths),
        status: Value(application.status),
        syncStatus: Value(needsSync ? 'pending' : existing.syncStatus),
        version: Value(newVersion),
        lastModified: Value(now),
        createdAt: Value(existing.createdAt),
        syncedAt: Value(existing.syncedAt),
        rejectionReason: Value(application.rejectionReason),
        approvedAmount: Value(application.approvedAmount),
      );

      final result = await _database.updateCreditApplication(companion);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure.updateError('Error al actualizar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteApplication(String id) async {
    try {
      final count = await _database.deleteCreditApplication(id);
      return Right(count > 0);
    } catch (e) {
      return Left(DatabaseFailure.deleteError('Error al eliminar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplicationModel>>> getPendingApplications() async {
    try {
      final applications = await _database.getPendingCreditApplications();
      final models = applications.map(_mapToModel).toList();
      return Right(models);
    } catch (e) {
      return Left(DatabaseFailure.queryError('Error al obtener solicitudes pendientes: $e'));
    }
  }

  @override
  Stream<List<CreditApplicationModel>> watchPendingApplications() {
    return _database.watchPendingCreditApplications().map(
      (applications) => applications.map(_mapToModel).toList(),
    );
  }

  @override
  Future<Either<Failure, void>> updateSyncStatus(String id, String status) async {
    try {
      final existing = await _database.getCreditApplicationById(id);
      if (existing == null) {
        return const Left(DatabaseFailure.notFound());
      }

      final companion = CreditApplicationsTableCompanion(
        id: Value(id),
        clientId: Value(existing.clientId),
        requestedAmount: Value(existing.requestedAmount),
        purpose: Value(existing.purpose),
        termMonths: Value(existing.termMonths),
        status: Value(existing.status),
        syncStatus: Value(status),
        version: Value(existing.version),
        lastModified: Value(existing.lastModified),
        createdAt: Value(existing.createdAt),
        syncedAt: Value(existing.syncedAt),
        rejectionReason: Value(existing.rejectionReason),
        approvedAmount: Value(existing.approvedAmount),
      );

      await _database.updateCreditApplication(companion);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure.updateError('Error al actualizar estado de sincronización: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsSynced(String id, DateTime syncedAt) async {
    try {
      final existing = await _database.getCreditApplicationById(id);
      if (existing == null) {
        return const Left(DatabaseFailure.notFound());
      }

      final companion = CreditApplicationsTableCompanion(
        id: Value(id),
        clientId: Value(existing.clientId),
        requestedAmount: Value(existing.requestedAmount),
        purpose: Value(existing.purpose),
        termMonths: Value(existing.termMonths),
        status: Value(existing.status),
        syncStatus: const Value('synced'),
        version: Value(existing.version),
        lastModified: Value(existing.lastModified),
        createdAt: Value(existing.createdAt),
        syncedAt: Value(syncedAt),
        rejectionReason: Value(existing.rejectionReason),
        approvedAmount: Value(existing.approvedAmount),
      );

      await _database.updateCreditApplication(companion);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure.updateError('Error al marcar como sincronizado: $e'));
    }
  }

  CreditApplicationModel _mapToModel(CreditApplicationsTableData data) {
    return CreditApplicationModel(
      id: data.id,
      clientId: data.clientId,
      requestedAmount: data.requestedAmount,
      purpose: data.purpose,
      termMonths: data.termMonths,
      status: data.status,
      syncStatus: data.syncStatus,
      version: data.version,
      lastModified: data.lastModified,
      createdAt: data.createdAt,
      syncedAt: data.syncedAt,
      rejectionReason: data.rejectionReason,
      approvedAmount: data.approvedAmount,
    );
  }
}

// === ARCHIVO: lib/data/datasources/remote/client_remote_datasource.dart ===
package lib.data.datasources.remote;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../models/client_model.dart';
import '../../../core/config/app_config.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/connectivity_service.dart';

abstract class ClientRemoteDatasource {
  Future<Either<Failure, List<ClientModel>>> fetchAllClients();
  Future<Either<Failure, ClientModel>> fetchClientById(String id);
  Future<Either<Failure, ClientModel>> createClient(ClientModel client);
  Future<Either<Failure, ClientModel>> updateClient(ClientModel client);
  Future<Either<Failure, bool>> deleteClient(String id);
  Future<Either<Failure, List<ClientModel>>> syncClients(List<ClientModel> clients);
  Future<Either<Failure, Map<String, dynamic>>> resolveConflicts(
    String entityType,
    List<Map<String, dynamic>> conflicts,
  );
}

class ClientRemoteDatasourceImpl implements ClientRemoteDatasource {
  final Dio _dio;
  final AppConfig _appConfig;
  final ConnectivityService _connectivityService;

  ClientRemoteDatasourceImpl(
    this._dio,
    this._appConfig,
    this._connectivityService,
  ) {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _appConfig.baseUrl,
      connectTimeout: _appConfig.connectionTimeout,
      receiveTimeout: _appConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (_appConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  @override
  Future<Either<Failure, List<ClientModel>>> fetchAllClients() async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get(_appConfig.clientsEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        final clients = data.map((json) => ClientModel.fromJson(json)).toList();
        return Right(clients);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener clientes: $e'));
    }
  }

  @override
  Future<Either<Failure, ClientModel>> fetchClientById(String id) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get('${_appConfig.clientsEndpoint}/$id');
      
      if (response.statusCode == 200) {
        final client = ClientModel.fromJson(response.data['data'] ?? response.data);
        return Right(client);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, ClientModel>> createClient(ClientModel client) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.post(
        _appConfig.clientsEndpoint,
        data: client.toJson(),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final createdClient = ClientModel.fromJson(response.data['data'] ?? response.data);
        return Right(createdClient);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al crear cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, ClientModel>> updateClient(ClientModel client) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.put(
        '${_appConfig.clientsEndpoint}/${client.id}',
        data: client.toJson(),
      );
      
      if (response.statusCode == 200) {
        final updatedClient = ClientModel.fromJson(response.data['data'] ?? response.data);
        return Right(updatedClient);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al actualizar cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteClient(String id) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.delete('${_appConfig.clientsEndpoint}/$id');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(true);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al eliminar cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ClientModel>>> syncClients(List<ClientModel> clients) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final batchSize = _appConfig.maxBatchSize;
      final List<ClientModel> syncedClients = [];

      for (var i = 0; i < clients.length; i += batchSize) {
        final batch = clients.skip(i).take(batchSize).toList();
        final payload = batch.map((c) => c.toJson()).toList();

        final response = await _dio.post(
          _appConfig.syncEndpoint,
          data: {'clients': payload},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'] ?? response.data['clients'] ?? [];
          syncedClients.addAll(data.map((json) => ClientModel.fromJson(json)));
        } else if (response.statusCode == 409) {
          return Left(SyncFailure.conflictDetected('client', batch.first.id));
        } else {
          return Left(NetworkFailure.serverError(response.statusCode));
        }
      }

      return Right(syncedClients);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return Left(SyncFailure.conflictDetected('client', ''));
      }
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al sincronizar clientes: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resolveConflicts(
    String entityType,
    List<Map<String, dynamic>> conflicts,
  ) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.post(
        _appConfig.conflictResolutionEndpoint,
        data: {
          'entityType': entityType,
          'conflicts': conflicts,
        },
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al resolver conflictos: $e'));
    }
  }

  Failure _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure.timeout();
      case DioExceptionType.connectionError:
        return NetworkFailure.noConnection();
      case DioExceptionType.badResponse:
        return NetworkFailure.serverError(e.response?.statusCode);
      default:
        return NetworkFailure.unknown(e.message);
    }
  }
}

// === ARCHIVO: lib/data/datasources/remote/credit_application_remote_datasource.dart ===
package lib.data.datasources.remote;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../models/credit_application_model.dart';
import '../../../core/config/app_config.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/connectivity_service.dart';

abstract class CreditApplicationRemoteDatasource {
  Future<Either<Failure, List<CreditApplicationModel>>> fetchAllApplications();
  Future<Either<Failure, CreditApplicationModel>> fetchApplicationById(String id);
  Future<Either<Failure, CreditApplicationModel>> fetchApplicationsByClientId(String clientId);
  Future<Either<Failure, CreditApplicationModel>> createApplication(CreditApplicationModel application);
  Future<Either<Failure, CreditApplicationModel>> updateApplication(CreditApplicationModel application);
  Future<Either<Failure, bool>> deleteApplication(String id);
  Future<Either<Failure, List<CreditApplicationModel>>> syncApplications(List<CreditApplicationModel> applications);
  Future<Either<Failure, Map<String, dynamic>>> resolveConflicts(
    String entityType,
    List<Map<String, dynamic>> conflicts,
  );
}

class CreditApplicationRemoteDatasourceImpl implements CreditApplicationRemoteDatasource {
  final Dio _dio;
  final AppConfig _appConfig;
  final ConnectivityService _connectivityService;

  CreditApplicationRemoteDatasourceImpl(
    this._dio,
    this._appConfig,
    this._connectivityService,
  ) {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _appConfig.baseUrl,
      connectTimeout: _appConfig.connectionTimeout,
      receiveTimeout: _appConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (_appConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplicationModel>>> fetchAllApplications() async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get(_appConfig.creditApplicationsEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        final applications = data.map((json) => CreditApplicationModel.fromJson(json)).toList();
        return Right(applications);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener solicitudes: $e'));
    }
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> fetchApplicationById(String id) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get('${_appConfig.creditApplicationsEndpoint}/$id');
      
      if (response.statusCode == 200) {
        final application = CreditApplicationModel.fromJson(response.data['data'] ?? response.data);
        return Right(application);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> fetchApplicationsByClientId(String clientId) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get(
        _appConfig.creditApplicationsEndpoint,
        queryParameters: {'clientId': clientId},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        if (data.isEmpty) {
          return const Left(DatabaseFailure.notFound());
        }
        final application = CreditApplicationModel.fromJson(data.first);
        return Right(application);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener solicitudes del cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> createApplication(CreditApplicationModel application) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.post(
        _appConfig.creditApplicationsEndpoint,
        data: application.toJson(),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final createdApplication = CreditApplicationModel.fromJson(response.data['data'] ?? response.data);
        return Right(createdApplication);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al crear solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> updateApplication(CreditApplicationModel application) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.put(
        '${_appConfig.creditApplicationsEndpoint}/${application.id}',
        data: application.toJson(),
      );
      
      if (response.statusCode == 200) {
        final updatedApplication = CreditApplicationModel.fromJson(response.data['data'] ?? response.data);
        return Right(updatedApplication);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al actualizar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteApplication(String id) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.delete('${_appConfig.creditApplicationsEndpoint}/$id');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(true);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al eliminar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplicationModel>>> syncApplications(
    List<CreditApplicationModel> applications,
  ) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final batchSize = _appConfig.maxBatchSize;
      final List<CreditApplicationModel> syncedApplications = [];

      for (var i = 0; i < applications.length; i += batchSize) {
        final batch = applications.skip(i).take(batchSize).toList();
        final payload = batch.map((a) => a.toJson()).toList();

        final response = await _dio.post(
          _appConfig.syncEndpoint,
          data: {'creditApplications': payload},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = 
            response.data['data'] ?? 
            response.data['creditApplications'] ?? 
            [];
          syncedApplications.addAll(
            data.map((json) => CreditApplicationModel.fromJson(json)),
          );
        } else if (response.statusCode == 409) {
          return Left(SyncFailure.conflictDetected('credit_application', batch.first.id));
        } else {
          return Left(NetworkFailure.serverError(response.statusCode));
        }
      }

      return Right(syncedApplications);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return Left(SyncFailure.conflictDetected('credit_application', ''));
      }
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al sincronizar solicitudes: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resolveConflicts(
    String entityType,
    List<Map<String, dynamic>> conflicts,
  ) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.post(
        _appConfig.conflictResolutionEndpoint,
        data: {
          'entityType': entityType,
          'conflicts': conflicts,
        },
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al resolver conflictos: $e'));
    }
  }

  Failure _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure.timeout();
      case DioExceptionType.connectionError:
        return NetworkFailure.noConnection();
      case DioExceptionType.badResponse:
        return NetworkFailure.serverError(e.response?.statusCode);
      default:
        return NetworkFailure.unknown(e.message);
    }
  }
}


// === ARCHIVO: lib/data/repositories/client_repository_impl.dart ===
package data.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/local/client_local_datasource.dart';
import '../datasources/remote/client_remote_datasource.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDatasource localDatasource;
  final ClientRemoteDatasource remoteDatasource;
  final ConnectivityService connectivityService;
  final AppConfig appConfig;
  final AppDatabase database;

  ClientRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.connectivityService,
    required this.appConfig,
    required this.database,
  });

  @override
  Future<Either<Failure, List<Client>>> getClients() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          final remoteClients = await remoteDatasource.getClients();
          final clientModels = remoteClients.map((m) => ClientModel.fromRemote(m)).toList();
          
          for (final model in clientModels) {
            await localDatasource.saveClient(model.copyWith(
              syncStatus: SyncStatusEnum.synced,
              syncedAt: DateTime.now(),
            ));
          }
          
          final localClients = await localDatasource.getClients();
          return Right(localClients.map((m) => m.toEntity()).toList());
        } catch (e) {
          final localClients = await localDatasource.getClients();
          return Right(localClients.map((m) => m.toEntity()).toList());
        }
      } else {
        final localClients = await localDatasource.getClients();
        return Right(localClients.map((m) => m.toEntity()).toList());
      }
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> getClientById(String id) async {
    try {
      final clientModel = await localDatasource.getClientById(id);
      if (clientModel == null) {
        return Left(CacheFailure.notFound());
      }
      return Right(clientModel.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> saveClient(Client client) async {
    try {
      final clientModel = ClientModel.fromEntity(client);
      final clientWithSync = clientModel.copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: 1,
        lastModified: DateTime.now(),
      );
      
      await localDatasource.saveClient(clientWithSync);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.createClient(clientModel.toRemote());
          await localDatasource.updateClientSyncStatus(
            client.id,
            SyncStatusEnum.synced,
            DateTime.now(),
          );
          final updatedClient = await localDatasource.getClientById(client.id);
          if (updatedClient != null) {
            return Right(updatedClient.toEntity());
          }
        } catch (e) {
          await _queueForSync(client.id, 'client');
        }
      } else {
        await _queueForSync(client.id, 'client');
      }
      
      return Right(clientWithSync.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.insertError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> updateClient(Client client) async {
    try {
      final existingClient = await localDatasource.getClientById(client.id);
      if (existingClient == null) {
        return Left(CacheFailure.notFound());
      }
      
      final updatedModel = ClientModel.fromEntity(client).copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: existingClient.version + 1,
        lastModified: DateTime.now(),
      );
      
      await localDatasource.updateClient(updatedModel);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.updateClient(client.id, updatedModel.toRemote());
          await localDatasource.updateClientSyncStatus(
            client.id,
            SyncStatusEnum.synced,
            DateTime.now(),
          );
        } catch (e) {
          await _queueForSync(client.id, 'client');
        }
      } else {
        await _queueForSync(client.id, 'client');
      }
      
      final finalClient = await localDatasource.getClientById(client.id);
      if (finalClient != null) {
        return Right(finalClient.toEntity());
      }
      return Left(CacheFailure.notFound());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.updateError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClient(String id) async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.deleteClient(id);
        } catch (e) {
          await _queueForSync(id, 'client_delete');
        }
      } else {
        await _queueForSync(id, 'client_delete');
      }
      
      await localDatasource.deleteClient(id);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.deleteError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Client>>> getPendingClients() async {
    try {
      final pendingClients = await localDatasource.getPendingClients();
      return Right(pendingClients.map((m) => m.toEntity()).toList());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> syncClients() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final pendingClients = await localDatasource.getPendingClients();
      final syncedIds = <String>[];
      
      for (final client in pendingClients) {
        try {
          if (client.syncStatus == SyncStatusEnum.pending) {
            await remoteDatasource.createClient(client.toRemote());
          } else if (client.syncStatus == SyncStatusEnum.conflict) {
            final serverVersion = await remoteDatasource.getClientById(client.id);
            if (serverVersion != null) {
              final resolved = await _resolveConflict(client, serverVersion);
              await remoteDatasource.updateClient(client.id, resolved.toRemote());
            }
          }
          syncedIds.add(client.id);
        } catch (e) {
          continue;
        }
      }
      
      if (syncedIds.isNotEmpty) {
        await database.updateClientsSyncStatus(
          syncedIds,
          SyncStatusEnum.synced.name,
        );
      }
      
      return const Right(null);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on SyncFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<void> _queueForSync(String entityId, String entityType) async {
    await database.insertSyncLog(SyncLogTableCompanion.insert(
      entityType: entityType,
      entityId: entityId,
      operation: 'create',
      payload: '',
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now(),
    ));
  }

  Future<ClientModel> _resolveConflict(
    ClientModel local,
    ClientModel remote,
  ) async {
    if (local.lastModified.isAfter(remote.lastModified)) {
      return local;
    }
    final merged = local.copyWith(
      firstName: remote.firstName,
      lastName: remote.lastName,
      email: remote.email,
      phone: remote.phone,
      address: remote.address,
      version: remote.version + 1,
      syncStatus: SyncStatusEnum.synced,
      syncedAt: DateTime.now(),
    );
    await localDatasource.updateClient(merged);
    return merged;
  }
}

// === ARCHIVO: lib/data/repositories/credit_application_repository_impl.dart ===
package data.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/credit_application_repository.dart';
import '../datasources/local/credit_application_local_datasource.dart';
import '../datasources/remote/credit_application_remote_datasource.dart';
import '../models/credit_application_model.dart';

class CreditApplicationRepositoryImpl implements CreditApplicationRepository {
  final CreditApplicationLocalDatasource localDatasource;
  final CreditApplicationRemoteDatasource remoteDatasource;
  final ConnectivityService connectivityService;
  final AppConfig appConfig;
  final AppDatabase database;

  CreditApplicationRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.connectivityService,
    required this.appConfig,
    required this.database,
  });

  @override
  Future<Either<Failure, List<CreditApplication>>> getCreditApplications() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          final remoteApplications = await remoteDatasource.getCreditApplications();
          final applicationModels = remoteApplications
              .map((m) => CreditApplicationModel.fromRemote(m))
              .toList();
          
          for (final model in applicationModels) {
            await localDatasource.saveApplication(model.copyWith(
              syncStatus: SyncStatusEnum.synced,
              syncedAt: DateTime.now(),
            ));
          }
          
          final localApplications = await localDatasource.getApplications();
          return Right(localApplications.map((m) => m.toEntity()).toList());
        } catch (e) {
          final localApplications = await localDatasource.getApplications();
          return Right(localApplications.map((m) => m.toEntity()).toList());
        }
      } else {
        final localApplications = await localDatasource.getApplications();
        return Right(localApplications.map((m) => m.toEntity()).toList());
      }
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplication>>> getApplicationsByClientId(
    String clientId,
  ) async {
    try {
      final applications = await localDatasource.getApplicationsByClientId(clientId);
      return Right(applications.map((m) => m.toEntity()).toList());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> getApplicationById(String id) async {
    try {
      final applicationModel = await localDatasource.getApplicationById(id);
      if (applicationModel == null) {
        return Left(CacheFailure.notFound());
      }
      return Right(applicationModel.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> saveApplication(
    CreditApplication application,
  ) async {
    try {
      final applicationModel = CreditApplicationModel.fromEntity(application);
      final applicationWithSync = applicationModel.copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      await localDatasource.saveApplication(applicationWithSync);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.createApplication(applicationModel.toRemote());
          await localDatasource.updateApplicationSyncStatus(
            application.id,
            SyncStatusEnum.synced,
            DateTime.now(),
          );
          final updatedApplication = await localDatasource.getApplicationById(application.id);
          if (updatedApplication != null) {
            return Right(updatedApplication.toEntity());
          }
        } catch (e) {
          await _queueForSync(application.id, 'credit_application');
        }
      } else {
        await _queueForSync(application.id, 'credit_application');
      }
      
      return Right(applicationWithSync.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.insertError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> updateApplication(
    CreditApplication application,
  ) async {
    try {
      final existingApplication = await localDatasource.getApplicationById(application.id);
      if (existingApplication == null) {
        return Left(CacheFailure.notFound());
      }
      
      final updatedModel = CreditApplicationModel.fromEntity(application).copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: existingApplication.version + 1,
        lastModified: DateTime.now(),
      );
      
      await localDatasource.updateApplication(updatedModel);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.updateApplication(application.id, updatedModel.toRemote());
          await localDatasource.updateApplicationSyncStatus(
            application.id,
            SyncStatusEnum.synced,
            DateTime.now(),
          );
        } catch (e) {
          await _queueForSync(application.id, 'credit_application');
        }
      } else {
        await _queueForSync(application.id, 'credit_application');
      }
      
      final finalApplication = await localDatasource.getApplicationById(application.id);
      if (finalApplication != null) {
        return Right(finalApplication.toEntity());
      }
      return Left(CacheFailure.notFound());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.updateError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteApplication(String id) async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.deleteApplication(id);
        } catch (e) {
          await _queueForSync(id, 'credit_application_delete');
        }
      } else {
        await _queueForSync(id, 'credit_application_delete');
      }
      
      await localDatasource.deleteApplication(id);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.deleteError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplication>>> getPendingApplications() async {
    try {
      final pendingApplications = await localDatasource.getPendingApplications();
      return Right(pendingApplications.map((m) => m.toEntity()).toList());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> syncApplications() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final pendingApplications = await localDatasource.getPendingApplications();
      final syncedIds = <String>[];
      
      for (final application in pendingApplications) {
        try {
          if (application.syncStatus == SyncStatusEnum.pending) {
            await remoteDatasource.createApplication(application.toRemote());
          } else if (application.syncStatus == SyncStatusEnum.conflict) {
            final serverVersion = await remoteDatasource.getApplicationById(application.id);
            if (serverVersion != null) {
              final resolved = await _resolveConflict(application, serverVersion);
              await remoteDatasource.updateApplication(application.id, resolved.toRemote());
            }
          }
          syncedIds.add(application.id);
        } catch (e) {
          continue;
        }
      }
      
      if (syncedIds.isNotEmpty) {
        await database.updateCreditApplicationsSyncStatus(
          syncedIds,
          SyncStatusEnum.synced.name,
        );
      }
      
      return const Right(null);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on SyncFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<void> _queueForSync(String entityId, String entityType) async {
    await database.insertSyncLog(SyncLogTableCompanion.insert(
      entityType: entityType,
      entityId: entityId,
      operation: 'create',
      payload: '',
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now(),
    ));
  }

  Future<CreditApplicationModel> _resolveConflict(
    CreditApplicationModel local,
    CreditApplicationModel remote,
  ) async {
    if (local.lastModified.isAfter(remote.lastModified)) {
      return local;
    }
    final merged = local.copyWith(
      requestedAmount: remote.requestedAmount,
      purpose: remote.purpose,
      termMonths: remote.termMonths,
      status: remote.status,
      approvedAmount: remote.approvedAmount,
      version: remote.version + 1,
      syncStatus: SyncStatusEnum.synced,
      syncedAt: DateTime.now(),
    );
    await localDatasource.updateApplication(merged);
    return merged;
  }
}

// === ARCHIVO: lib/presentation/screens/client_list_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/client_repository.dart';
import '../../core/network/connectivity_service.dart';
import '../widgets/client_card.dart';
import '../widgets/sync_indicator.dart';
import '../viewmodels/client_viewmodel.dart';

abstract class ClientListEvent extends Equatable {
  const ClientListEvent();
  @override
  List<Object?> get props => [];
}

class LoadClients extends ClientListEvent {
  const LoadClients();
}

class RefreshClients extends ClientListEvent {
  const RefreshClients();
}

class SyncClientsRequested extends ClientListEvent {
  const SyncClientsRequested();
}

class ClientListState extends Equatable {
  final List<Client> clients;
  final bool isLoading;
  final String? errorMessage;
  final bool isSyncing;
  final int pendingCount;
  final bool isConnected;
  final DateTime? lastSyncTime;

  const ClientListState({
    this.clients = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isSyncing = false,
    this.pendingCount = 0,
    this.isConnected = true,
    this.lastSyncTime,
  });

  ClientListState copyWith({
    List<Client>? clients,
    bool? isLoading,
    String? errorMessage,
    bool? isSyncing,
    int? pendingCount,
    bool? isConnected,
    DateTime? lastSyncTime,
  }) {
    return ClientListState(
      clients: clients ?? this.clients,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      isConnected: isConnected ?? this.isConnected,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  List<Object?> get props => [
        clients,
        isLoading,
        errorMessage,
        isSyncing,
        pendingCount,
        isConnected,
        lastSyncTime,
      ];
}

class ClientListBloc extends Bloc<ClientListEvent, ClientListState> {
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;

  ClientListBloc({
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ClientListState()) {
    on<LoadClients>(_onLoadClients);
    on<RefreshClients>(_onRefreshClients);
    on<SyncClientsRequested>(_onSyncClientsRequested);
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final clientsResult = await _clientRepository.getAllClients();
      final pendingResult = await _clientRepository.getPendingClients();
      final isConnected = await _connectivityService.hasActiveConnection();

      clientsResult.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (clients) => emit(state.copyWith(
          isLoading: false,
          clients: clients,
          pendingCount: pendingResult.length,
          isConnected: isConnected,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar clientes: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefreshClients(
    RefreshClients event,
    Emitter<ClientListState> emit,
  ) async {
    add(const LoadClients());
  }

  Future<void> _onSyncClientsRequested(
    SyncClientsRequested event,
    Emitter<ClientListState> emit,
  ) async {
    if (!state.isConnected) {
      emit(state.copyWith(
        errorMessage: 'Sin conexión. No se puede sincronizar.',
      ));
      return;
    }

    emit(state.copyWith(isSyncing: true, errorMessage: null));

    try {
      final syncResult = await _clientRepository.syncClients();

      syncResult.fold(
        (failure) => emit(state.copyWith(
          isSyncing: false,
          errorMessage: 'Error de sincronización: ${failure.message}',
        )),
        (syncedCount) {
          final pendingResult = _clientRepository.getPendingClients();
          pendingResult.then((pending) {
            add(const LoadClients());
          });
          emit(state.copyWith(
            isSyncing: false,
            lastSyncTime: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isSyncing: false,
        errorMessage: 'Error al sincronizar: ${e.toString()}',
      ));
    }
  }
}

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClientListBloc>().add(const LoadClients());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          BlocBuilder<ClientListBloc, ClientListState>(
            builder: (context, state) {
              return SyncIndicator(
                pendingCount: state.pendingCount,
                isSyncing: state.isSyncing,
                isConnected: state.isConnected,
                onSyncPressed: () {
                  context.read<ClientListBloc>().add(const SyncClientsRequested());
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ClientListBloc, ClientListState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red.shade700,
                action: SnackBarAction(
                  label: 'Reintentar',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<ClientListBloc>().add(const LoadClients());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.clients.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.clients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay clientes registrados',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para agregar el primer cliente',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ClientListBloc>().add(const RefreshClients());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.clients.length,
              itemBuilder: (context, index) {
                final client = state.clients[index];
                return ClientCard(
                  client: client,
                  onTap: () => _navigateToClientForm(context, client: client),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToClientForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToClientForm(BuildContext context, {Client? client}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClientFormScreen(client: client),
      ),
    ).then((_) {
      context.read<ClientListBloc>().add(const LoadClients());
    });
  }
}

class ClientFormScreen extends StatelessWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// === ARCHIVO: lib/presentation/screens/client_form_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import 'package:dartz/dartz.dart';

abstract class ClientFormEvent extends Equatable {
  const ClientFormEvent();
  @override
  List<Object?> get props => [];
}

class SaveClientRequested extends ClientFormEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String identificationNumber;

  const SaveClientRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.identificationNumber,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
      ];
}

class UpdateClientRequested extends ClientFormEvent {
  final Client client;

  const UpdateClientRequested({required this.client});

  @override
  List<Object?> get props => [client];
}

class ValidateField extends ClientFormEvent {
  final String fieldName;
  final String value;

  const ValidateField({required this.fieldName, required this.value});

  @override
  List<Object?> get props => [fieldName, value];
}

class ResetForm extends ClientFormEvent {
  const ResetForm();
}

class ClientFormState extends Equatable {
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final Client? savedClient;
  final bool isOffline;

  const ClientFormState({
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.savedClient,
    this.isOffline = false,
  });

  ClientFormState copyWith({
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    Client? savedClient,
    bool? isOffline,
  }) {
    return ClientFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      savedClient: savedClient ?? this.savedClient,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSaved,
        errorMessage,
        fieldErrors,
        savedClient,
        isOffline,
      ];
}

class ClientFormBloc extends Bloc<ClientFormEvent, ClientFormState> {
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;

  ClientFormBloc({
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ClientFormState()) {
    on<SaveClientRequested>(_onSaveClient);
    on<UpdateClientRequested>(_onUpdateClient);
    on<ValidateField>(_onValidateField);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onSaveClient(
    SaveClientRequested event,
    Emitter<ClientFormState> emit,
  ) async {
    final validationErrors = _validateClientData(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      phone: event.phone,
      identificationNumber: event.identificationNumber,
    );

    if (validationErrors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: validationErrors));
      return;
    }

    emit(state.copyWith(isLoading: true, fieldErrors: {}));

    try {
      final isConnected = await _connectivityService.hasActiveConnection();
      final client = Client(
        id: '',
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phone: event.phone,
        address: event.address,
        identificationNumber: event.identificationNumber,
        syncStatus: isConnected ? 'synced' : 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final result = await _clientRepository.saveClient(client);

      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (savedClient) => emit(state.copyWith(
          isLoading: false,
          isSaved: true,
          savedClient: savedClient,
          isOffline: !isConnected,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al guardar cliente: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateClient(
    UpdateClientRequested event,
    Emitter<ClientFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final isConnected = await _connectivityService.hasActiveConnection();
      final updatedClient = event.client.copyWith(
        syncStatus: isConnected ? 'pending' : 'pending',
        version: event.client.version + 1,
        lastModified: DateTime.now(),
      );

      final result = await _clientRepository.updateClient(updatedClient);

      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (client) => emit(state.copyWith(
          isLoading: false,
          isSaved: true,
          savedClient: client,
          isOffline: !isConnected,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al actualizar cliente: ${e.toString()}',
      ));
    }
  }

  void _onValidateField(
    ValidateField event,
    Emitter<ClientFormState> emit,
  ) {
    final errors = Map<String, String>.from(state.fieldErrors);
    final error = _validateSingleField(event.fieldName, event.value);
    if (error != null) {
      errors[event.fieldName] = error;
    } else {
      errors.remove(event.fieldName);
    }
    emit(state.copyWith(fieldErrors: errors));
  }

  void _onResetForm(ResetForm event, Emitter<ClientFormState> emit) {
    emit(const ClientFormState());
  }

  Map<String, String> _validateClientData({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String identificationNumber,
  }) {
    final errors = <String, String>{};

    final firstNameError = _validateSingleField('firstName', firstName);
    if (firstNameError != null) errors['firstName'] = firstNameError;

    final lastNameError = _validateSingleField('lastName', lastName);
    if (lastNameError != null) errors['lastName'] = lastNameError;

    final emailError = _validateSingleField('email', email);
    if (emailError != null) errors['email'] = emailError;

    final phoneError = _validateSingleField('phone', phone);
    if (phoneError != null) errors['phone'] = phoneError;

    final idError = _validateSingleField('identificationNumber', identificationNumber);
    if (idError != null) errors['identificationNumber'] = idError;

    return errors;
  }

  String? _validateSingleField(String fieldName, String value) {
    if (value.trim().isEmpty) {
      return 'El campo $fieldName es requerido';
    }

    switch (fieldName) {
      case 'email':
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Ingrese un correo electrónico válido';
        }
        break;
      case 'phone':
        final phoneRegex = RegExp(r'^[0-9]{10,15}$');
        if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
          return 'Ingrese un número de teléfono válido';
        }
        break;
      case 'identificationNumber':
        if (value.length < 5 || value.length > 20) {
          return 'La identificación debe tener entre 5 y 20 caracteres';
        }
        break;
      case 'firstName':
      case 'lastName':
        if (value.length < 2) {
          return 'El nombre debe tener al menos 2 caracteres';
        }
        if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
          return 'Solo se permiten letras y espacios';
        }
        break;
    }

    return null;
  }
}

class ClientFormScreen extends StatefulWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _identificationController;

  bool get isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.client?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.client?.lastName ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _addressController = TextEditingController(text: widget.client?.address ?? '');
    _identificationController = TextEditingController(text: widget.client?.identificationNumber ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _identificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientFormBloc(
        clientRepository: context.read<ClientRepository>(),
        connectivityService: context.read<ConnectivityService>(),
      ),
      child: BlocConsumer<ClientFormBloc, ClientFormState>(
        listener: (context, state) {
          if (state.isSaved) {
            final message = state.isOffline
                ? 'Cliente guardado offline. Se sincronizará cuando haya conexión.'
                : 'Cliente guardado correctamente.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green.shade700,
              ),
            );
            Navigator.of(context).pop(true);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Editar Cliente' : 'Nuevo Cliente'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _firstNameController,
                      label: 'Nombre',
                      icon: Icons.person,
                      error: state.fieldErrors['firstName'],
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _lastNameController,
                      label: 'Apellido',
                      icon: Icons.person_outline,
                      error: state.fieldErrors['lastName'],
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _identificationController,
                      label: 'Número de Identificación',
                      icon: Icons.badge,
                      error: state.fieldErrors['identificationNumber'],
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      error: state.fieldErrors['email'],
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Teléfono',
                      icon: Icons.phone,
                      error: state.fieldErrors['phone'],
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Dirección',
                      icon: Icons.home,
                      error: state.fieldErrors['address'],
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () => _saveClient(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEditing ? 'Actualizar Cliente' : 'Guardar Cliente'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? error,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        errorText: error,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
    );
  }

  void _saveClient(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final bloc = context.read<ClientFormBloc>();
      if (isEditing && widget.client != null) {
        final updatedClient = widget.client!.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          identificationNumber: _identificationController.text.trim(),
        );
        bloc.add(UpdateClientRequested(client: updatedClient));
      } else {
        bloc.add(SaveClientRequested(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          identificationNumber: _identificationController.text.trim(),
        ));
      }
    }
  }
}

// === ARCHIVO: lib/presentation/screens/application_form_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/repositories/client_repository.dart';
import '../../domain/repositories/credit_application_repository.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';

abstract class ApplicationFormEvent extends Equatable {
  const ApplicationFormEvent();
  @override
  List<Object?> get props => [];
}

class LoadClientsForSelection extends ApplicationFormEvent {
  const LoadClientsForSelection();
}

class SubmitApplicationRequested extends ApplicationFormEvent {
  final String clientId;
  final double requestedAmount;
  final String purpose;
  final int termMonths;

  const SubmitApplicationRequested({
    required this.clientId,
    required this.requestedAmount,
    required this.purpose,
    required this.termMonths,
  });

  @override
  List<Object?> get props => [clientId, requestedAmount, purpose, termMonths];
}

class ValidateAmount extends ApplicationFormEvent {
  final String amount;

  const ValidateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class ValidateTerm extends ApplicationFormEvent {
  final String term;

  const ValidateTerm(this.term);

  @override
  List<Object?> get props => [term];
}

class ApplicationFormState extends Equatable {
  final List<Client> availableClients;
  final bool isLoading;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final CreditApplication? submittedApplication;
  final bool isOffline;
  final double? validatedAmount;
  final int? validatedTerm;

  const ApplicationFormState({
    this.availableClients = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.submittedApplication,
    this.isOffline = false,
    this.validatedAmount,
    this.validatedTerm,
  });

  ApplicationFormState copyWith({
    List<Client>? availableClients,
    bool? isLoading,
    bool? isSubmitting,
    bool? isSubmitted,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    CreditApplication? submittedApplication,
    bool? isOffline,
    double? validatedAmount,
    int? validatedTerm,
  }) {
    return ApplicationFormState(
      availableClients: availableClients ?? this.availableClients,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      submittedApplication: submittedApplication ?? this.submittedApplication,
      isOffline: isOffline ?? this.isOffline,
      validatedAmount: validatedAmount ?? this.validatedAmount,
      validatedTerm: validatedTerm ?? this.validatedTerm,
    );
  }

  @override
  List<Object?> get props => [
        availableClients,
        isLoading,
        isSubmitting,
        isSubmitted,
        errorMessage,
        fieldErrors,
        submittedApplication,
        isOffline,
        validatedAmount,
        validatedTerm,
      ];
}

class ApplicationFormBloc extends Bloc<ApplicationFormEvent, ApplicationFormState> {
  final CreditApplicationRepository _applicationRepository;
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;

  static const double minAmount = 1000.0;
  static const double maxAmount = 500000.0;
  static const List<int> validTerms = [6, 12, 18, 24, 36, 48, 60];

  ApplicationFormBloc({
    required CreditApplicationRepository applicationRepository,
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _applicationRepository = applicationRepository,
        _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ApplicationFormState()) {
    on<LoadClientsForSelection>(_onLoadClients);
    on<SubmitApplicationRequested>(_onSubmitApplication);
    on<ValidateAmount>(_onValidateAmount);
    on<ValidateTerm>(_onValidateTerm);
  }

  Future<void> _onLoadClients(
    LoadClientsForSelection event,
    Emitter<ApplicationFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _clientRepository.getAllClients();
      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (clients) => emit(state.copyWith(
          isLoading: false,
          availableClients: clients,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar clientes: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSubmitApplication(
    SubmitApplicationRequested event,
    Emitter<ApplicationFormState> emit,
  ) async {
    final validationErrors = _validateApplicationData(
      clientId: event.clientId,
      amount: event.requestedAmount,
      termMonths: event.termMonths,
    );

    if (validationErrors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: validationErrors));
      return;
    }

    emit(state.copyWith(isSubmitting: true, fieldErrors: {}));

    try {
      final isConnected = await _connectivityService.hasActiveConnection();
      final application = CreditApplication(
        id: '',
        clientId: event.clientId,
        requestedAmount: event.requestedAmount,
        purpose: event.purpose,
        termMonths: event.termMonths,
        status: 'pending',
        syncStatus: isConnected ? 'synced' : 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final result = await _applicationRepository.saveApplication(application);

      result.fold(
        (failure) => emit(state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        )),
        (savedApplication) => emit(state.copyWith(
          isSubmitting: false,
          isSubmitted: true,
          submittedApplication: savedApplication,
          isOffline: !isConnected,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Error al enviar solicitud: ${e.toString()}',
      ));
    }
  }

  void _onValidateAmount(
    ValidateAmount event,
    Emitter<ApplicationFormState> emit,
  ) {
    final errors = Map<String, String>.from(state.fieldErrors);
    final amount = double.tryParse(event.amount);

    if (amount == null) {
      errors['amount'] = 'Ingrese un monto válido';
    } else if (amount < minAmount) {
      errors['amount'] = 'El monto mínimo es \$${minAmount.toStringAsFixed(0)}';
    } else if (amount > maxAmount) {
      errors['amount'] = 'El monto máximo es \$${maxAmount.toStringAsFixed(0)}';
    } else {
      errors.remove('amount');
      emit(state.copyWith(
        fieldErrors: errors,
        validatedAmount: amount,
      ));
      return;
    }

    emit(state.copyWith(fieldErrors: errors));
  }

  void _onValidateTerm(
    ValidateTerm event,
    Emitter<ApplicationFormState> emit,
  ) {
    final errors = Map<String, String>.from(state.fieldErrors);
    final term = int.tryParse(event.term);

    if (term == null) {
      errors['term'] = 'Ingrese un plazo válido';
    } else if (!validTerms.contains(term)) {
      errors['term'] = 'Plazo no válido. Seleccione: ${validTerms.join(", ")} meses';
    } else {
      errors.remove('term');
      emit(state.copyWith(
        fieldErrors: errors,
        validatedTerm: term,
      ));
      return;
    }

    emit(state.copyWith(fieldErrors: errors));
  }

  Map<String, String> _validateApplicationData({
    required String clientId,
    required double amount,
    required int termMonths,
  }) {
    final errors = <String, String>{};

    if (clientId.isEmpty) {
      errors['client'] = 'Debe seleccionar un cliente';
    }

    if (amount < minAmount) {
      errors['amount'] = 'El monto mínimo es \$${minAmount.toStringAsFixed(0)}';
    } else if (amount > maxAmount) {
      errors['amount'] = 'El monto máximo es \$${maxAmount.toStringAsFixed(0)}';
    }

    if (!validTerms.contains(termMonths)) {
      errors['term'] = 'Plazo no válido';
    }

    return errors;
  }
}

class ApplicationFormScreen extends StatefulWidget {
  final String? clientId;

  const ApplicationFormScreen({super.key, this.clientId});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClientId;
  late TextEditingController _amountController;
  late TextEditingController _purposeController;
  int? _selectedTerm;

  final List<String> _purposes = [
    'Consumo',
    'Negocio',
    'Vivienda',
    'Vehículo',
    'Educación',
    'Salud',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _selectedClientId = widget.clientId;
    _amountController = TextEditingController();
    _purposeController = TextEditingController();
    _selectedTerm = 12;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApplicationFormBloc(
        applicationRepository: context.read<CreditApplicationRepository>(),
        clientRepository: context.read<ClientRepository>(),
        connectivityService: context.read<ConnectivityService>(),
      )..add(const LoadClientsForSelection()),
      child: BlocConsumer<ApplicationFormBloc, ApplicationFormState>(
        listener: (context, state) {
          if (state.isSubmitted) {
            final message = state.isOffline
                ? 'Solicitud guardada offline. Se sincronizará cuando haya conexión.'
                : 'Solicitud enviada correctamente.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green.shade700,
              ),
            );
            Navigator.of(context).pop(true);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Nueva Solicitud de Crédito'),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildClientDropdown(context, state),
                          const SizedBox(height: 16),
                          _buildAmountField(context),
                          const SizedBox(height: 16),
                          _buildPurposeDropdown(),
                          const SizedBox(height: 16),
                          _buildTermDropdown(),
                          const SizedBox(height: 16),
                          _buildTermInfo(),
                          const SizedBox(height: 24),
                          _buildSubmitButton(context, state),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildClientDropdown(BuildContext context, ApplicationFormState state) {
    return DropdownButtonFormField<String>(
      value: _selectedClientId,
      decoration: InputDecoration(
        labelText: 'Cliente',
        prefixIcon: const Icon(Icons.person),
        border: const OutlineInputBorder(),
        errorText: state.fieldErrors['client'],
      ),
      items: state.availableClients.map((client) {
        return DropdownMenuItem(
          value: client.id,
          child: Text('${client.firstName} ${client.lastName}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedClientId = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Debe seleccionar un cliente';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField(BuildContext context) {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'Monto Solicitado',
        prefixIcon: const Icon(Icons.attach_money),
        border: const OutlineInputBorder(),
        hintText: 'Entre \$1,000 y \$500,000',
        errorText: context.select<ApplicationFormBloc, ApplicationFormState>(
                  (bloc) => bloc.state.fieldErrors['amount'],
                ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d{0,2}')),
      ],
      onChanged: (value) {
        context.read<ApplicationFormBloc>().add(ValidateAmount(value));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese el monto solicitado';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount < 1000 || amount > 500000) {
          return 'Monto debe estar entre \$1,000 y \$500,000';
        }
        return null;
      },
    );
  }

  Widget _buildPurposeDropdown() {
    return DropdownButtonFormField<String>(
      value: _purposeController.text.isNotEmpty ? _purposeController.text : null,
      decoration: const InputDecoration(
        labelText: 'Finalidad',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      items: _purposes.map((purpose) {
        return DropdownMenuItem(
          value: purpose,
          child: Text(purpose),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _purposeController.text = value ?? '';
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione la finalidad del crédito';
        }
        return null;
      },
    );
  }

  Widget _buildTermDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedTerm,
      decoration: const InputDecoration(
        labelText: 'Plazo (meses)',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      items: ApplicationFormBloc.validTerms.map((term) {
        return DropdownMenuItem(
          value: term,
          child: Text('$term meses'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedTerm = value;
        });
        if (value != null) {
          context.read<ApplicationFormBloc>().add(ValidateTerm(value.toString()));
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Seleccione el plazo';
        }
        return null;
      },
    );
  }

  Widget _buildTermInfo() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Los plazos disponibles son: 6, 12, 18, 24, 36, 48 y 60 meses. '
                'Seleccione el que mejor se adapte a su capacidad de pago.',
                style: TextStyle(color: Colors.blue.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, ApplicationFormState state) {
    return ElevatedButton(
      onPressed: state.isSubmitting ? null : () => _submitApplication(context),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: state.isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Enviar Solicitud'),
    );
  }

  void _submitApplication(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.parse(_amountController.text);
      context.read<ApplicationFormBloc>().add(
            SubmitApplicationRequested(
              clientId: _selectedClientId!,
              requestedAmount: amount,
              purpose: _purposeController.text,
              termMonths: _selectedTerm!,
            ),
          );
    }
  }
}


// === ARCHIVO: lib/presentation/screens/sync_status_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/database/app_database.dart';
import '../widgets/client_card.dart';
import '../widgets/sync_indicator.dart';

class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({super.key});

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen> {
  late final AppDatabase _database;
  late final ConnectivityService _connectivityService;
  List<ClientsTableData> _pendingClients = [];
  List<CreditApplicationsTableData> _pendingApplications = [];
  bool _isLoading = true;
  String _syncStatus = 'idle';
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    try {
      _database = context.read<AppDatabase>();
      _connectivityService = context.read<ConnectivityService>();
      await _loadPendingData();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadPendingData() async {
    try {
      final pendingClients = await _database.getPendingClients();
      final pendingApps = await _database.getPendingCreditApplications();
      if (mounted) {
        setState(() {
          _pendingClients = pendingClients;
          _pendingApplications = pendingApps;
        });
      }
    } catch (e) {
      debugPrint('Error loading pending data: $e');
    }
  }

  Future<void> _triggerSync() async {
    final connectivityStatus = await _connectivityService.checkConnectivity();
    if (!connectivityStatus.isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay conexión disponible para sincronizar'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _syncStatus = 'syncing');

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _syncStatus = 'completed';
          _lastSyncTime = DateTime.now();
        });
        await _loadPendingData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sincronización completada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _syncStatus = 'error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en sincronización: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Sincronización'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _triggerSync,
            tooltip: 'Sincronizar ahora',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPendingData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConnectivityCard(),
                    const SizedBox(height: 16),
                    _buildSyncSummaryCard(),
                    const SizedBox(height: 24),
                    _buildPendingSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildConnectivityCard() {
    return StreamBuilder<ConnectivityStatus>(
      stream: _connectivityService.statusStream,
      initialData: ConnectivityStatus(
        status: ConnectionStatus.unknown,
        timestamp: DateTime.now(),
      ),
      builder: (context, snapshot) {
        final status = snapshot.data;
        final isConnected = status?.isConnected ?? false;
        final statusColor = isConnected ? Colors.green : Colors.red;
        final statusText = isConnected ? 'Conectado' : 'Sin conexión';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  isConnected ? Icons.wifi : Icons.wifi_off,
                  color: statusColor,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado de Red',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSyncSummaryCard() {
    final totalPending = _pendingClients.length + _pendingApplications.length;
    final statusColor = _syncStatus == 'completed'
        ? Colors.green
        : _syncStatus == 'error'
            ? Colors.red
            : _syncStatus == 'syncing'
                ? Colors.blue
                : Colors.grey;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SyncIndicator(status: _getSyncStatusType()),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Resumen de Sincronización',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildSummaryRow(
              'Clientes pendientes',
              _pendingClients.length.toString(),
              Icons.people,
            ),
            _buildSummaryRow(
              'Solicitudes pendientes',
              _pendingApplications.length.toString(),
              Icons.description,
            ),
            _buildSummaryRow(
              'Total pendientes',
              totalPending.toString(),
              Icons.pending_actions,
            ),
            if (_lastSyncTime != null)
              _buildSummaryRow(
                'Última sincronización',
                _formatDateTime(_lastSyncTime!),
                Icons.access_time,
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _syncStatus == 'syncing' ? null : _triggerSync,
                icon: _syncStatus == 'syncing'
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                label: Text(
                  _syncStatus == 'syncing'
                      ? 'Sincronizando...'
                      : 'Sincronizar ahora',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingSection() {
    if (_pendingClients.isEmpty && _pendingApplications.isEmpty) {
      return Card(
        color: Colors.green[50],
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Text(
                'Todo sincronizado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pendientes por sincronizar',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (_pendingClients.isNotEmpty) ...[
          Text(
            'Clientes (${_pendingClients.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ..._pendingClients.map((client) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClientCard(
                  client: client,
                  onTap: () => _showClientDetails(client),
                ),
              )),
          const SizedBox(height: 16),
        ],
        if (_pendingApplications.isNotEmpty) ...[
          Text(
            'Solicitudes de crédito (${_pendingApplications.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ..._pendingApplications.map((app) => Card(
                child: ListTile(
                  leading: const SyncIndicator(status: SyncStatusType.pending),
                  title: Text('Solicitud: ${app.id.substring(0, 8)}...'),
                  subtitle: Text('Monto: \$${app.requestedAmount}'),
                  trailing: Text(app.status),
                ),
              )),
        ],
      ],
    );
  }

  void _showClientDetails(ClientsTableData client) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${client.firstName} ${client.lastName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Email', client.email),
            _buildDetailRow('Teléfono', client.phone),
            _buildDetailRow('Identificación', client.identificationNumber),
            _buildDetailRow('Dirección', client.address),
            _buildDetailRow('Estado sync', client.syncStatus),
            _buildDetailRow('Versión', client.version.toString()),
            _buildDetailRow('Última modificación', _formatDateTime(client.lastModified)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  SyncStatusType _getSyncStatusType() {
    switch (_syncStatus) {
      case 'syncing':
        return SyncStatusType.pending;
      case 'completed':
        return SyncStatusType.synced;
      case 'error':
        return SyncStatusType.conflict;
      default:
        return SyncStatusType.pending;
    }
  }
}

// === ARCHIVO: lib/presentation/widgets/client_card.dart ===
import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';
import 'sync_indicator.dart';

class ClientCard extends StatelessWidget {
  final ClientsTableData client;
  final VoidCallback? onTap;
  final VoidCallback? onSyncTap;
  final bool showSyncAction;

  const ClientCard({
    super.key,
    required this.client,
    this.onTap,
    this.onSyncTap,
    this.showSyncAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildAvatar(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildName(context),
                    const SizedBox(height: 4),
                    _buildIdentification(),
                    const SizedBox(height: 4),
                    _buildContactInfo(),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SyncIndicator(status: _parseSyncStatus(client.syncStatus)),
                  if (showSyncAction) ...[
                    const SizedBox(height: 8),
                    _buildSyncButton(context),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final initials = _getInitials();
    final colorScheme = Theme.of(context).colorScheme;
    
    return CircleAvatar(
      radius: 24,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        initials,
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Text(
      '${client.firstName} ${client.lastName}',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildIdentification() {
    return Row(
      children: [
        const Icon(Icons.badge, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          client.identificationNumber,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Row(
      children: [
        if (client.phone.isNotEmpty) ...[
          const Icon(Icons.phone, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              client.phone,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        if (client.email.isNotEmpty) ...[
          const SizedBox(width: 8),
          const Icon(Icons.email, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              client.email,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSyncButton(BuildContext context) {
    final isPending = client.syncStatus == 'pending';
    return InkWell(
      onTap: onSyncTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPending ? Colors.orange.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPending ? Colors.orange : Colors.green,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPending ? Icons.cloud_upload : Icons.cloud_done,
              size: 14,
              color: isPending ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 4),
            Text(
              isPending ? 'Subir' : 'Sincronizado',
              style: TextStyle(
                fontSize: 11,
                color: isPending ? Colors.orange : Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    final firstInitial = client.firstName.isNotEmpty 
        ? client.firstName[0].toUpperCase() 
        : '';
    final lastInitial = client.lastName.isNotEmpty 
        ? client.lastName[0].toUpperCase() 
        : '';
    return '$firstInitial$lastInitial';
  }

  SyncStatusType _parseSyncStatus(String status) {
    switch (status.toLowerCase()) {
      case 'synced':
        return SyncStatusType.synced;
      case 'conflict':
        return SyncStatusType.conflict;
      case 'pending':
      default:
        return SyncStatusType.pending;
    }
  }
}

class ClientCardSkeleton extends StatelessWidget {
  const ClientCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 150,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 100,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === ARCHIVO: lib/presentation/widgets/sync_indicator.dart ===
import 'package:flutter/material.dart';

enum SyncStatusType {
  synced,
  pending,
  conflict,
}

class SyncIndicator extends StatelessWidget {
  final SyncStatusType status;
  final double size;
  final bool showLabel;
  final bool animate;

  const SyncIndicator({
    super.key,
    required this.status,
    this.size = 24,
    this.showLabel = false,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(config),
          const SizedBox(width: 8),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return _buildIcon(config);
  }

  Widget _buildIcon(StatusConfig config) {
    if (animate && status == SyncStatusType.pending) {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(config.color),
        ),
      );
    }

    return Tooltip(
      message: config.tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: config.color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          config.icon,
          size: size * 0.6,
          color: config.color,
        ),
      ),
    );
  }

  StatusConfig _getStatusConfig() {
    switch (status) {
      case SyncStatusType.synced:
        return StatusConfig(
          icon: Icons.cloud_done,
          color: const Color(0xFF4CAF50),
          label: 'Sincronizado',
          tooltip: 'Datos sincronizados con el servidor',
        );
      case SyncStatusType.pending:
        return StatusConfig(
          icon: Icons.cloud_upload,
          color: const Color(0xFFFF9800),
          label: 'Pendiente',
          tooltip: 'Esperando para sincronizar',
        );
      case SyncStatusType.conflict:
        return StatusConfig(
          icon: Icons.warning,
          color: const Color(0xFFF44336),
          label: 'Conflicto',
          tooltip: 'Conflicto de datos detectado',
        );
    }
  }
}

class StatusConfig {
  final IconData icon;
  final Color color;
  final String label;
  final String tooltip;

  const StatusConfig({
    required this.icon,
    required this.color,
    required this.label,
    required this.tooltip,
  });
}

class SyncStatusBadge extends StatelessWidget {
  final int pendingCount;
  final int syncedCount;
  final int conflictCount;

  const SyncStatusBadge({
    super.key,
    required this.pendingCount,
    required this.syncedCount,
    required this.conflictCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCountBadge(
            count: pendingCount,
            status: SyncStatusType.pending,
          ),
          const SizedBox(width: 8),
          _buildCountBadge(
            count: syncedCount,
            status: SyncStatusType.synced,
          ),
          if (conflictCount > 0) ...[
            const SizedBox(width: 8),
            _buildCountBadge(
              count: conflictCount,
              status: SyncStatusType.conflict,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountBadge({required int count, required SyncStatusType status}) {
    final config = _getConfigForStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 14, color: config.color),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              color: config.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  StatusConfig _getConfigForStatus(SyncStatusType status) {
    switch (status) {
      case SyncStatusType.synced:
        return const StatusConfig(
          icon: Icons.cloud_done,
          color: Color(0xFF4CAF50),
          label: 'Sincronizado',
          tooltip: '',
        );
      case SyncStatusType.pending:
        return const StatusConfig(
          icon: Icons.cloud_upload,
          color: Color(0xFFFF9800),
          label: 'Pendiente',
          tooltip: '',
        );
      case SyncStatusType.conflict:
        return const StatusConfig(
          icon: Icons.warning,
          color: Color(0xFFF44336),
          label: 'Conflicto',
          tooltip: '',
        );
    }
  }
}


// === ARCHIVO: lib/presentation/viewmodels/client_viewmodel.dart ===
package credit_field_app.presentation.viewmodels;

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:credit_field_app/core/error/failures.dart';
import 'package:credit_field_app/core/network/connectivity_service.dart';
import 'package:credit_field_app/domain/entities/client.dart';
import 'package:credit_field_app/domain/repositories/client_repository.dart';

part 'client_viewmodel_event.dart';
part 'client_viewmodel_state.dart';

class ClientViewModel extends Bloc<ClientViewModelEvent, ClientViewModelState> {
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;
  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;

  ClientViewModel({
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ClientViewModelState()) {
    on<LoadClients>(_onLoadClients);
    on<LoadClientById>(_onLoadClientById);
    on<SaveClient>(_onSaveClient);
    on<DeleteClient>(_onDeleteClient);
    on<UpdateClient>(_onUpdateClient);
    on<SearchClients>(_onSearchClients);
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<RefreshClients>(_onRefreshClients);

    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) => add(ConnectivityChanged(status)),
    );
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.loading));
    
    final result = await _clientRepository.getClients();
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (clients) => emit(state.copyWith(
        status: ClientViewModelStatus.loaded,
        clients: clients,
      )),
    );
  }

  Future<void> _onLoadClientById(
    LoadClientById event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.loading));
    
    final result = await _clientRepository.getClientById(event.clientId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (client) => emit(state.copyWith(
        status: ClientViewModelStatus.loaded,
        selectedClient: client,
      )),
    );
  }

  Future<void> _onSaveClient(
    SaveClient event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.saving));
    
    final result = await _clientRepository.saveClient(event.client);
    await result.fold(
      (failure) async => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (savedClient) async {
        final updatedClients = List<Client>.from(state.clients)..add(savedClient);
        emit(state.copyWith(
          status: ClientViewModelStatus.saved,
          clients: updatedClients,
          selectedClient: savedClient,
        ));
        
        if (state.isOnline) {
          add(const SyncClients());
        }
      },
    );
  }

  Future<void> _onUpdateClient(
    UpdateClient event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.saving));
    
    final result = await _clientRepository.updateClient(event.client);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (updatedClient) {
        final updatedClients = state.clients.map((c) {
          return c.id == updatedClient.id ? updatedClient : c;
        }).toList();
        emit(state.copyWith(
          status: ClientViewModelStatus.saved,
          clients: updatedClients,
          selectedClient: updatedClient,
        ));
        
        if (state.isOnline) {
          add(const SyncClients());
        }
      },
    );
  }

  Future<void> _onDeleteClient(
    DeleteClient event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.loading));
    
    final result = await _clientRepository.deleteClient(event.clientId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedClients = state.clients
            .where((c) => c.id != event.clientId)
            .toList();
        emit(state.copyWith(
          status: ClientViewModelStatus.deleted,
          clients: updatedClients,
        ));
      },
    );
  }

  Future<void> _onSearchClients(
    SearchClients event,
    Emitter<ClientViewModelState> emit,
  ) async {
    emit(state.copyWith(status: ClientViewModelStatus.loading));
    
    final result = await _clientRepository.searchClients(event.query);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (clients) => emit(state.copyWith(
        status: ClientViewModelStatus.loaded,
        clients: clients,
      )),
    );
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ClientViewModelState> emit,
  ) {
    final isOnline = event.status.isConnected;
    emit(state.copyWith(isOnline: isOnline));
    
    if (isOnline && state.hasPendingChanges) {
      add(const SyncClients());
    }
  }

  Future<void> _onRefreshClients(
    RefreshClients event,
    Emitter<ClientViewModelState> emit,
  ) async {
    if (!state.isOnline) {
      emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: 'No hay conexión para actualizar desde el servidor',
      ));
      return;
    }
    
    emit(state.copyWith(status: ClientViewModelStatus.syncing));
    
    final result = await _clientRepository.syncClients();
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClientViewModelStatus.error,
        errorMessage: failure.message,
      )),
      (syncedClients) => emit(state.copyWith(
        status: ClientViewModelStatus.loaded,
        clients: syncedClients,
      )),
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}

class SyncClients extends ClientViewModelEvent {
  const SyncClients();
}

// === ARCHIVO: lib/presentation/viewmodels/client_viewmodel_event.dart ===
part of 'client_viewmodel.dart';

abstract class ClientViewModelEvent extends Equatable {
  const ClientViewModelEvent();

  @override
  List<Object?> get props => [];
}

class LoadClients extends ClientViewModelEvent {
  const LoadClients();
}

class LoadClientById extends ClientViewModelEvent {
  final String clientId;

  const LoadClientById(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

class SaveClient extends ClientViewModelEvent {
  final Client client;

  const SaveClient(this.client);

  @override
  List<Object?> get props => [client];
}

class UpdateClient extends ClientViewModelEvent {
  final Client client;

  const UpdateClient(this.client);

  @override
  List<Object?> get props => [client];
}

class DeleteClient extends ClientViewModelEvent {
  final String clientId;

  const DeleteClient(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

class SearchClients extends ClientViewModelEvent {
  final String query;

  const SearchClients(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshClients extends ClientViewModelEvent {
  const RefreshClients();
}

class ConnectivityChanged extends ClientViewModelEvent {
  final ConnectivityStatus status;

  const ConnectivityChanged(this.status);

  @override
  List<Object?> get props => [status];
}

// === ARCHIVO: lib/presentation/viewmodels/client_viewmodel_state.dart ===
part of 'client_viewmodel.dart';

enum ClientViewModelStatus {
  initial,
  loading,
  loaded,
  saving,
  saved,
  deleting,
  deleted,
  syncing,
  error,
}

class ClientViewModelState extends Equatable {
  final ClientViewModelStatus status;
  final List<Client> clients;
  final Client? selectedClient;
  final String? errorMessage;
  final bool isOnline;
  final bool hasPendingChanges;

  const ClientViewModelState({
    this.status = ClientViewModelStatus.initial,
    this.clients = const [],
    this.selectedClient,
    this.errorMessage,
    this.isOnline = false,
    this.hasPendingChanges = false,
  });

  ClientViewModelState copyWith({
    ClientViewModelStatus? status,
    List<Client>? clients,
    Client? selectedClient,
    String? errorMessage,
    bool? isOnline,
    bool? hasPendingChanges,
  }) {
    return ClientViewModelState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
      selectedClient: selectedClient ?? this.selectedClient,
      errorMessage: errorMessage ?? this.errorMessage,
      isOnline: isOnline ?? this.isOnline,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
    );
  }

  @override
  List<Object?> get props => [
        status,
        clients,
        selectedClient,
        errorMessage,
        isOnline,
        hasPendingChanges,
      ];
}

// === ARCHIVO: lib/presentation/viewmodels/sync_viewmodel.dart ===
package credit_field_app.presentation.viewmodels;

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:credit_field_app/core/error/failures.dart';
import 'package:credit_field_app/core/network/connectivity_service.dart';
import 'package:credit_field_app/domain/entities/sync_status.dart';
import 'package:credit_field_app/sync/services/sync_coordinator.dart';

part 'sync_viewmodel_event.dart';
part 'sync_viewmodel_state.dart';

class SyncViewModel extends Bloc<SyncViewModelEvent, SyncViewModelState> {
  final SyncCoordinator _syncCoordinator;
  final ConnectivityService _connectivityService;
  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;
  Timer? _periodicSyncTimer;

  SyncViewModel({
    required SyncCoordinator syncCoordinator,
    required ConnectivityService connectivityService,
  })  : _syncCoordinator = syncCoordinator,
        _connectivityService = connectivityService,
        super(const SyncViewModelState()) {
    on<StartSync>(_onStartSync);
    on<StopSync>(_onStopSync);
    on<CheckSyncStatus>(_onCheckSyncStatus);
    on<ResolveConflict>(_onResolveConflict);
    on<SyncConnectivityChanged>(_onConnectivityChanged);
    on<StartPeriodicSync>(_onStartPeriodicSync);
    on<StopPeriodicSync>(_onStopPeriodicSync);
    on<ForceSyncAll>(_onForceSyncAll);
    on<ClearSyncHistory>(_onClearSyncHistory);

    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) => add(SyncConnectivityChanged(status)),
    );

    _initializeSync();
  }

  Future<void> _initializeSync() async {
    final status = await _connectivityService.checkConnectivity();
    final isOnline = status.isConnected;
    
    add(const CheckSyncStatus());
    
    if (isOnline) {
      add(const StartSync());
    }
  }

  Future<void> _onStartSync(
    StartSync event,
    Emitter<SyncViewModelState> emit,
  ) async {
    if (state.isSyncing) return;
    
    emit(state.copyWith(
      status: SyncViewModelStatus.syncing,
      isSyncing: true,
    ));

    try {
      final result = await _syncCoordinator.syncPendingChanges();
      
      result.fold(
        (failure) => emit(state.copyWith(
          status: SyncViewModelStatus.error,
          isSyncing: false,
          errorMessage: failure.message,
          lastError: failure,
        )),
        (syncResult) {
          final conflicts = syncResult.conflicts;
          final syncedCount = syncResult.syncedCount;
          final failedCount = syncResult.failedCount;

          if (conflicts.isNotEmpty) {
            emit(state.copyWith(
              status: SyncViewModelStatus.conflictDetected,
              isSyncing: false,
              pendingConflicts: conflicts,
              lastSyncResult: syncResult,
            ));
          } else {
            emit(state.copyWith(
              status: SyncViewModelStatus.synced,
              isSyncing: false,
              syncedCount: syncedCount,
              failedCount: failedCount,
              lastSyncResult: syncResult,
              lastSyncTime: DateTime.now(),
            ));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        isSyncing: false,
        errorMessage: 'Error inesperado durante la sincronización: $e',
      ));
    }
  }

  Future<void> _onStopSync(
    StopSync event,
    Emitter<SyncViewModelState> emit,
  ) async {
    await _syncCoordinator.cancelSync();
    emit(state.copyWith(
      status: SyncViewModelStatus.idle,
      isSyncing: false,
    ));
  }

  Future<void> _onCheckSyncStatus(
    CheckSyncStatus event,
    Emitter<SyncViewModelState> emit,
  ) async {
    emit(state.copyWith(status: SyncViewModelStatus.checking));

    try {
      final pendingItems = await _syncCoordinator.getPendingItemsCount();
      final conflicts = await _syncCoordinator.getConflicts();
      final lastSync = await _syncCoordinator.getLastSyncTime();

      emit(state.copyWith(
        status: SyncViewModelStatus.idle,
        pendingItemsCount: pendingItems,
        pendingConflicts: conflicts,
        lastSyncTime: lastSync,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        errorMessage: 'Error al verificar estado de sincronización: $e',
      ));
    }
  }

  Future<void> _onResolveConflict(
    ResolveConflict event,
    Emitter<SyncViewModelState> emit,
  ) async {
    emit(state.copyWith(
      status: SyncViewModelStatus.resolving,
      isResolvingConflict: true,
    ));

    try {
      final result = await _syncCoordinator.resolveConflict(
        event.conflictId,
        event.resolution,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: SyncViewModelStatus.error,
          isResolvingConflict: false,
          errorMessage: failure.message,
        )),
        (resolved) {
          final updatedConflicts = state.pendingConflicts
              .where((c) => c.id != event.conflictId)
              .toList();

          emit(state.copyWith(
            status: updatedConflicts.isEmpty
                ? SyncViewModelStatus.synced
                : SyncViewModelStatus.conflictDetected,
            isResolvingConflict: false,
            pendingConflicts: updatedConflicts,
            lastConflictResolution: result,
          ));

          if (state.isOnline && updatedConflicts.isEmpty) {
            add(const StartSync());
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        isResolvingConflict: false,
        errorMessage: 'Error al resolver conflicto: $e',
      ));
    }
  }

  void _onConnectivityChanged(
    SyncConnectivityChanged event,
    Emitter<SyncViewModelState> emit,
  ) {
    final isOnline = event.status.isConnected;
    emit(state.copyWith(isOnline: isOnline));

    if (isOnline && state.pendingItemsCount > 0 && !state.isSyncing) {
      add(const StartSync());
    }
  }

  void _onStartPeriodicSync(
    StartPeriodicSync event,
    Emitter<SyncViewModelState> emit,
  ) {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(
      event.interval,
      (_) => add(const StartSync()),
    );
    emit(state.copyWith(isPeriodicSyncEnabled: true));
  }

  void _onStopPeriodicSync(
    StopPeriodicSync event,
    Emitter<SyncViewModelState> emit,
  ) {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
    emit(state.copyWith(isPeriodicSyncEnabled: false));
  }

  Future<void> _onForceSyncAll(
    ForceSyncAll event,
    Emitter<SyncViewModelState> emit,
  ) async {
    if (!state.isOnline) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        errorMessage: 'No hay conexión para sincronización',
      ));
      return;
    }

    emit(state.copyWith(
      status: SyncViewModelStatus.syncing,
      isSyncing: true,
    ));

    try {
      final result = await _syncCoordinator.forceSyncAll();
      
      result.fold(
        (failure) => emit(state.copyWith(
          status: SyncViewModelStatus.error,
          isSyncing: false,
          errorMessage: failure.message,
        )),
        (syncResult) => emit(state.copyWith(
          status: SyncViewModelStatus.synced,
          isSyncing: false,
          syncedCount: syncResult.syncedCount,
          failedCount: syncResult.failedCount,
          lastSyncTime: DateTime.now(),
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        isSyncing: false,
        errorMessage: 'Error en sincronización forzada: $e',
      ));
    }
  }

  Future<void> _onClearSyncHistory(
    ClearSyncHistory event,
    Emitter<SyncViewModelState> emit,
  ) async {
    await _syncCoordinator.clearSyncHistory();
    emit(state.copyWith(
      syncedCount: 0,
      failedCount: 0,
      pendingItemsCount: 0,
      pendingConflicts: [],
    ));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
    return super.close();
  }
}

// === ARCHIVO: lib/presentation/viewmodels/sync_viewmodel_event.dart ===
part of 'sync_viewmodel.dart';

abstract class SyncViewModelEvent extends Equatable {
  const SyncViewModelEvent();

  @override
  List<Object?> get props => [];
}

class StartSync extends SyncViewModelEvent {
  const StartSync();
}

class StopSync extends SyncViewModelEvent {
  const StopSync();
}

class CheckSyncStatus extends SyncViewModelEvent {
  const CheckSyncStatus();
}

class ResolveConflict extends SyncViewModelEvent {
  final String conflictId;
  final ConflictResolution resolution;

  const ResolveConflict({
    required this.conflictId,
    required this.resolution,
  });

  @override
  List<Object?> get props => [conflictId, resolution];
}

class SyncConnectivityChanged extends SyncViewModelEvent {
  final ConnectivityStatus status;

  const SyncConnectivityChanged(this.status);

  @override
  List<Object?> get props => [status];
}

class StartPeriodicSync extends SyncViewModelEvent {
  final Duration interval;

  const StartPeriodicSync({this.interval = const Duration(minutes: 5)});

  @override
  List<Object?> get props => [interval];
}

class StopPeriodicSync extends SyncViewModelEvent {
  const StopPeriodicSync();
}

class ForceSyncAll extends SyncViewModelEvent {
  const ForceSyncAll();
}

class ClearSyncHistory extends SyncViewModelEvent {
  const ClearSyncHistory();
}

// === ARCHIVO: lib/presentation/viewmodels/sync_viewmodel_state.dart ===
part of 'sync_viewmodel.dart';

enum SyncViewModelStatus {
  initial,
  checking,
  idle,
  syncing,
  synced,
  conflictDetected,
  resolving,
  error,
}

class SyncResult extends Equatable {
  final int syncedCount;
  final int failedCount;
  final List<SyncConflict> conflicts;
  final DateTime timestamp;

  const SyncResult({
    required this.syncedCount,
    required this.failedCount,
    required this.conflicts,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [syncedCount, failedCount, conflicts, timestamp];
}

class SyncConflict extends Equatable {
  final String id;
  final String entityType;
  final String entityId;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final DateTime detectedAt;

  const SyncConflict({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.localVersion,
    required this.remoteVersion,
    required this.detectedAt,
  });

  @override
  List<Object?> get props => [
        id,
        entityType,
        entityId,
        localVersion,
        remoteVersion,
        detectedAt,
      ];
}

enum ConflictResolution { useLocal, useRemote, merge }

class SyncViewModelState extends Equatable {
  final SyncViewModelStatus status;
  final bool isSyncing;
  final bool isResolvingConflict;
  final bool isOnline;
  final bool isPeriodicSyncEnabled;
  final int pendingItemsCount;
  final int syncedCount;
  final int failedCount;
  final List<SyncConflict> pendingConflicts;
  final DateTime? lastSyncTime;
  final String? errorMessage;
  final Failure? lastError;
  final SyncResult? lastSyncResult;
  final dynamic lastConflictResolution;

  const SyncViewModelState({
    this.status = SyncViewModelStatus.initial,
    this.isSyncing = false,
    this.isResolvingConflict = false,
    this.isOnline = false,
    this.isPeriodicSyncEnabled = false,
    this.pendingItemsCount = 0,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.pendingConflicts = const [],
    this.lastSyncTime,
    this.errorMessage,
    this.lastError,
    this.lastSyncResult,
    this.lastConflictResolution,
  });

  SyncViewModelState copyWith({
    SyncViewModelStatus? status,
    bool? isSyncing,
    bool? isResolvingConflict,
    bool? isOnline,
    bool? isPeriodicSyncEnabled,
    int? pendingItemsCount,
    int? syncedCount,
    int? failedCount,
    List<SyncConflict>? pendingConflicts,
    DateTime? lastSyncTime,
    String? errorMessage,
    Failure? lastError,
    SyncResult? lastSyncResult,
    dynamic lastConflictResolution,
  }) {
    return SyncViewModelState(
      status: status ?? this.status,
      isSyncing: isSyncing ?? this.isSyncing,
      isResolvingConflict: isResolvingConflict ?? this.isResolvingConflict,
      isOnline: isOnline ?? this.isOnline,
      isPeriodicSyncEnabled: isPeriodicSyncEnabled ?? this.isPeriodicSyncEnabled,
      pendingItemsCount: pendingItemsCount ?? this.pendingItemsCount,
      syncedCount: syncedCount ?? this.syncedCount,
      failedCount: failedCount ?? this.failedCount,
      pendingConflicts: pendingConflicts ?? this.pendingConflicts,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      errorMessage: errorMessage ?? this.errorMessage,
      lastError: lastError ?? this.lastError,
      lastSyncResult: lastSyncResult ?? this.lastSyncResult,
      lastConflictResolution: lastConflictResolution ?? this.lastConflictResolution,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isSyncing,
        isResolvingConflict,
        isOnline,
        isPeriodicSyncEnabled,
        pendingItemsCount,
        syncedCount,
        failedCount,
        pendingConflicts,
        lastSyncTime,
        errorMessage,
        lastError,
        lastSyncResult,
        lastConflictResolution,
      ];
}

library sync;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/repositories/client_repository.dart';
import '../../domain/repositories/credit_application_repository.dart';

part 'sync_coordinator.g.dart';

enum SyncState { idle, syncing, error, completed }

class SyncResult extends Equatable {
  final int uploadedClients;
  final int downloadedClients;
  final int uploadedApplications;
  final int downloadedApplications;
  final int conflictsResolved;
  final List<String> errors;

  const SyncResult({
    this.uploadedClients = 0,
    this.downloadedClients = 0,
    this.uploadedApplications = 0,
    this.downloadedApplications = 0,
    this.conflictsResolved = 0,
    this.errors = const [],
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasConflicts => conflictsResolved > 0;

  @override
  List<Object?> get props => [
        uploadedClients,
        downloadedClients,
        uploadedApplications,
        downloadedApplications,
        conflictsResolved,
        errors,
      ];
}

class SyncProgress extends Equatable {
  final SyncState state;
  final String currentOperation;
  final double progress;
  final String? errorMessage;

  const SyncProgress({
    this.state = SyncState.idle,
    this.currentOperation = '',
    this.progress = 0.0,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [state, currentOperation, progress, errorMessage];
}

class SyncCoordinator {
  final AppDatabase database;
  final ClientRepository clientRepository;
  final CreditApplicationRepository creditApplicationRepository;
  final ConnectivityService connectivityService;
  final AppConfig config;

  final _progressController = StreamController<SyncProgress>.broadcast();
  bool _isSyncing = false;

  SyncCoordinator({
    required this.database,
    required this.clientRepository,
    required this.creditApplicationRepository,
    required this.connectivityService,
    required this.config,
  });

  Stream<SyncProgress> get progressStream => _progressController.stream;
  bool get isSyncing => _isSyncing;

  Future<Either<Failure, SyncResult>> executeFullSync() async {
    if (_isSyncing) {
      return const Left(SyncFailure(
        message: 'Sincronización ya en progreso',
      ));
    }

    final connectivity = await connectivityService.checkConnectivity();
    if (!connectivity.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    _isSyncing = true;
    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Iniciando sincronización...',
      progress: 0.0,
    ));

    try {
      final result = await _performSync();
      _isSyncing = false;
      return result;
    } catch (e) {
      _isSyncing = false;
      _progressController.add(SyncProgress(
        state: SyncState.error,
        currentOperation: 'Error de sincronización',
        errorMessage: e.toString(),
      ));
      return Left(SyncFailure.unknown(e.toString()));
    }
  }

  Future<Either<Failure, SyncResult>> _performSync() async {
    final errors = <String>[];
    var uploadedClients = 0;
    var downloadedClients = 0;
    var uploadedApplications = 0;
    var downloadedApplications = 0;
    var conflictsResolved = 0;

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Subiendo clientes pendientes...',
      progress: 0.1,
    ));

    final uploadClientsResult = await _uploadPendingClients();
    uploadClientsResult.fold(
      (failure) => errors.add('Error uploading clients: ${failure.message}'),
      (count) => uploadedClients = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Descargando clientes del servidor...',
      progress: 0.3,
    ));

    final downloadClientsResult = await _downloadClients();
    downloadClientsResult.fold(
      (failure) => errors.add('Error downloading clients: ${failure.message}'),
      (count) => downloadedClients = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Subiendo solicitudes de crédito...',
      progress: 0.5,
    ));

    final uploadAppsResult = await _uploadPendingApplications();
    uploadAppsResult.fold(
      (failure) => errors.add('Error uploading applications: ${failure.message}'),
      (count) => uploadedApplications = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Descargando solicitudes de crédito...',
      progress: 0.7,
    ));

    final downloadAppsResult = await _downloadApplications();
    downloadAppsResult.fold(
      (failure) => errors.add('Error downloading applications: ${failure.message}'),
      (count) => downloadedApplications = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Resolviendo conflictos...',
      progress: 0.9,
    ));

    final conflictResult = await _resolvePendingConflicts();
    conflictResult.fold(
      (failure) => errors.add('Error resolving conflicts: ${failure.message}'),
      (count) => conflictsResolved = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.completed,
      currentOperation: 'Sincronización completada',
      progress: 1.0,
    ));

    return Right(SyncResult(
      uploadedClients: uploadedClients,
      downloadedClients: downloadedClients,
      uploadedApplications: uploadedApplications,
      downloadedApplications: downloadedApplications,
      conflictsResolved: conflictsResolved,
      errors: errors,
    ));
  }

  Future<Either<Failure, int>> _uploadPendingClients() async {
    try {
      final pendingClients = await database.getPendingClients();
      if (pendingClients.isEmpty) {
        return const Right(0);
      }

      var uploaded = 0;
      final batchSize = config.maxBatchSize;

      for (var i = 0; i < pendingClients.length; i += batchSize) {
        final batch = pendingClients.skip(i).take(batchSize).toList();
        
        for (final clientData in batch) {
          final client = Client(
            id: clientData.id,
            firstName: clientData.firstName,
            lastName: clientData.lastName,
            email: clientData.email,
            phone: clientData.phone,
            address: clientData.address,
            identificationNumber: clientData.identificationNumber,
            syncStatus: _mapSyncStatus(clientData.syncStatus),
            version: clientData.version,
            lastModified: clientData.lastModified,
            createdAt: clientData.createdAt,
            syncedAt: clientData.syncedAt,
          );

          final result = await clientRepository.syncClient(client);
          result.fold(
            (failure) async {
              await database.insertSyncLog(SyncLogTableCompanion.insert(
                entityType: 'client',
                entityId: client.id,
                operation: 'upload',
                payload: client.toString(),
                status: 'failed',
                retryCount: 0,
                createdAt: DateTime.now(),
              ));
            },
            (syncedClient) async {
              await database.updateClientsSyncStatus(
                [client.id],
                'synced',
              );
              uploaded++;
            },
          );
        }
      }

      return Right(uploaded);
    } catch (e) {
      return Left(SyncFailure.uploadFailed('client', 'batch'));
    }
  }

  Future<Either<Failure, int>> _downloadClients() async {
    try {
      final result = await clientRepository.getRemoteClients();
      
      return result.fold(
        (failure) => Left(failure),
        (remoteClients) async {
          var downloaded = 0;
          
          for (final remoteClient in remoteClients) {
            final localClient = await database.getClientById(remoteClient.id);
            
            if (localClient == null) {
              await database.insertClient(ClientsTableCompanion.insert(
                id: remoteClient.id,
                firstName: remoteClient.firstName,
                lastName: remoteClient.lastName,
                email: remoteClient.email,
                phone: remoteClient.phone,
                address: remoteClient.address,
                identificationNumber: remoteClient.identificationNumber,
                syncStatus: const Value('synced'),
                version: remoteClient.version,
                lastModified: remoteClient.lastModified,
                createdAt: remoteClient.createdAt,
                syncedAt: DateTime.now(),
              ));
              downloaded++;
            } else if (remoteClient.version > localClient.version) {
              await database.updateClient(ClientsTableCompanion(
                id: Value(remoteClient.id),
                firstName: Value(remoteClient.firstName),
                lastName: Value(remoteClient.lastName),
                email: Value(remoteClient.email),
                phone: Value(remoteClient.phone),
                address: Value(remoteClient.address),
                identificationNumber: Value(remoteClient.identificationNumber),
                syncStatus: const Value('synced'),
                version: remoteClient.version,
                lastModified: remoteClient.lastModified,
                syncedAt: Value(DateTime.now()),
              ));
              downloaded++;
            }
          }
          
          return Right(downloaded);
        },
      );
    } catch (e) {
      return Left(SyncFailure.downloadFailed());
    }
  }

  Future<Either<Failure, int>> _uploadPendingApplications() async {
    try {
      final pendingApps = await database.getPendingCreditApplications();
      if (pendingApps.isEmpty) {
        return const Right(0);
      }

      var uploaded = 0;

      for (final appData in pendingApps) {
        final application = CreditApplication(
          id: appData.id,
          clientId: appData.clientId,
          requestedAmount: appData.requestedAmount,
          purpose: appData.purpose,
          termMonths: appData.termMonths,
          status: appData.status,
          syncStatus: _mapSyncStatus(appData.syncStatus),
          version: appData.version,
          lastModified: appData.lastModified,
          createdAt: appData.createdAt,
          syncedAt: appData.syncedAt,
          rejectionReason: appData.rejectionReason,
          approvedAmount: appData.approvedAmount,
        );

        final result = await creditApplicationRepository.syncApplication(application);
        result.fold(
          (failure) async {
            await database.insertSyncLog(SyncLogTableCompanion.insert(
              entityType: 'credit_application',
              entityId: application.id,
              operation: 'upload',
              payload: application.toString(),
              status: 'failed',
              retryCount: 0,
              createdAt: DateTime.now(),
            ));
          },
          (syncedApp) async {
            await database.updateCreditApplicationsSyncStatus(
              [application.id],
              'synced',
            );
            uploaded++;
          },
        );
      }

      return Right(uploaded);
    } catch (e) {
      return Left(SyncFailure.uploadFailed('credit_application', 'batch'));
    }
  }

  Future<Either<Failure, int>> _downloadApplications() async {
    try {
      final result = await creditApplicationRepository.getRemoteApplications();
      
      return result.fold(
        (failure) => Left(failure),
        (remoteApps) async {
          var downloaded = 0;
          
          for (final remoteApp in remoteApps) {
            final localApp = await database.getCreditApplicationById(remoteApp.id);
            
            if (localApp == null) {
              await database.insertCreditApplication(CreditApplicationsTableCompanion.insert(
                id: remoteApp.id,
                clientId: remoteApp.clientId,
                requestedAmount: remoteApp.requestedAmount,
                purpose: remoteApp.purpose,
                termMonths: remoteApp.termMonths,
                status: remoteApp.status,
                syncStatus: const Value('synced'),
                version: remoteApp.version,
                lastModified: remoteApp.lastModified,
                createdAt: remoteApp.createdAt,
                syncedAt: DateTime.now(),
                rejectionReason: remoteApp.rejectionReason,
                approvedAmount: remoteApp.approvedAmount,
              ));
              downloaded++;
            } else if (remoteApp.version > localApp.version) {
              await database.updateCreditApplication(CreditApplicationsTableCompanion(
                id: Value(remoteApp.id),
                clientId: Value(remoteApp.clientId),
                requestedAmount: Value(remoteApp.requestedAmount),
                purpose: Value(remoteApp.purpose),
                termMonths: Value(remoteApp.termMonths),
                status: Value(remoteApp.status),
                syncStatus: const Value('synced'),
                version: remoteApp.version,
                lastModified: remoteApp.lastModified,
                syncedAt: Value(DateTime.now()),
                rejectionReason: Value(remoteApp.rejectionReason),
                approvedAmount: Value(remoteApp.approvedAmount),
              ));
              downloaded++;
            }
          }
          
          return Right(downloaded);
        },
      );
    } catch (e) {
      return Left(SyncFailure.downloadFailed());
    }
  }

  Future<Either<Failure, int>> _resolvePendingConflicts() async {
    return const Right(0);
  }

  SyncStatus _mapSyncStatus(String dbStatus) {
    switch (dbStatus) {
      case 'pending':
        return SyncStatus.pending;
      case 'synced':
        return SyncStatus.synced;
      case 'conflict':
        return SyncStatus.conflict;
      default:
        return SyncStatus.pending;
    }
  }

  Future<void> schedulePeriodicSync() async {
    while (_isSyncing) {
      await Future.delayed(config.syncInterval);
    }
    
    await executeFullSync();
  }

  void dispose() {
    _progressController.close();
  }
}
// === ARCHIVO: lib/sync/services/conflict_resolver.dart ===
library conflict_resolver;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/repositories/client_repository.dart';
import '../../domain/repositories/credit_application_repository.dart';

enum ConflictStrategy { serverWins, clientWins, manual, merge }

class ConflictInfo extends Equatable {
  final String entityType;
  final String entityId;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final DateTime localLastModified;
  final DateTime remoteLastModified;
  final List<String> conflictingFields;

  const ConflictInfo({
    required this.entityType,
    required this.entityId,
    required this.localVersion,
    required this.remoteVersion,
    required this.localLastModified,
    required this.remoteLastModified,
    required this.conflictingFields,
  });

  @override
  List<Object?> get props => [
        entityType,
        entityId,
        localVersion,
        remoteVersion,
        localLastModified,
        remoteLastModified,
        conflictingFields,
      ];
}

class ConflictResolutionResult extends Equatable {
  final String entityType;
  final String entityId;
  final bool resolved;
  final ConflictStrategy strategyUsed;
  final dynamic resolvedEntity;
  final String? errorMessage;

  const ConflictResolutionResult({
    required this.entityType,
    required this.entityId,
    required this.resolved,
    required this.strategyUsed,
    this.resolvedEntity,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        entityType,
        entityId,
        resolved,
        strategyUsed,
        resolvedEntity,
        errorMessage,
      ];
}

class ConflictResolver {
  final ClientRepository clientRepository;
  final CreditApplicationRepository creditApplicationRepository;
  final AppDatabase database;

  ConflictResolver({
    required this.clientRepository,
    required this.creditApplicationRepository,
    required this.database,
  });

  Future<Either<Failure, List<ConflictInfo>>> detectConflicts() async {
    try {
      final conflicts = <ConflictInfo>[];

      final pendingClients = await database.getPendingClients();
      for (final clientData in pendingClients) {
        final remoteResult = await clientRepository.getRemoteClient(clientData.id);
        
        remoteResult.fold(
          (failure) {},
          (remoteClient) {
            if (remoteClient != null && remoteClient.version > clientData.version) {
              conflicts.add(ConflictInfo(
                entityType: 'client',
                entityId: clientData.id,
                localVersion: clientData.version,
                remoteVersion: remoteClient.version,
                localLastModified: clientData.lastModified,
                remoteLastModified: remoteClient.lastModified,
                conflictingFields: _findConflictingFields(
                  clientData,
                  remoteClient,
                ),
              ));
            }
          },
        );
      }

      final pendingApps = await database.getPendingCreditApplications();
      for (final appData in pendingApps) {
        final remoteResult = await creditApplicationRepository.getRemoteApplication(appData.id);
        
        remoteResult.fold(
          (failure) {},
          (remoteApp) {
            if (remoteApp != null && remoteApp.version > appData.version) {
              conflicts.add(ConflictInfo(
                entityType: 'credit_application',
                entityId: appData.id,
                localVersion: appData.version,
                remoteVersion: remoteApp.version,
                localLastModified: appData.lastModified,
                remoteLastModified: remoteApp.lastModified,
                conflictingFields: _findConflictingFieldsApp(
                  appData,
                  remoteApp,
                ),
              ));
            }
          },
        );
      }

      return Right(conflicts);
    } catch (e) {
      return Left(SyncFailure.unknown(e.toString()));
    }
  }

  List<String> _findConflictingFields(
    ClientsTableData local,
    Client remote,
  ) {
    final fields = <String>[];
    
    if (local.firstName != remote.firstName) fields.add('firstName');
    if (local.lastName != remote.lastName) fields.add('lastName');
    if (local.email != remote.email) fields.add('email');
    if (local.phone != remote.phone) fields.add('phone');
    if (local.address != remote.address) fields.add('address');
    
    return fields;
  }

  List<String> _findConflictingFieldsApp(
    CreditApplicationsTableData local,
    CreditApplication remote,
  ) {
    final fields = <String>[];
    
    if (local.requestedAmount != remote.requestedAmount) fields.add('requestedAmount');
    if (local.purpose != remote.purpose) fields.add('purpose');
    if (local.termMonths != remote.termMonths) fields.add('termMonths');
    if (local.status != remote.status) fields.add('status');
    if (local.approvedAmount != remote.approvedAmount) fields.add('approvedAmount');
    
    return fields;
  }

  Future<Either<Failure, ConflictResolutionResult>> resolveConflict(
    ConflictInfo conflict,
    ConflictStrategy strategy,
  ) async {
    try {
      switch (conflict.entityType) {
        case 'client':
          return _resolveClientConflict(conflict, strategy);
        case 'credit_application':
          return _resolveApplicationConflict(conflict, strategy);
        default:
          return Left(SyncFailure.unknown('Unknown entity type: ${conflict.entityType}'));
      }
    } catch (e) {
      return Left(SyncFailure.resolveFailed());
    }
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveClientConflict(
    ConflictInfo conflict,
    ConflictStrategy strategy,
  ) async {
    switch (strategy) {
      case ConflictStrategy.serverWins:
        return _resolveClientServerWins(conflict);
      case ConflictStrategy.clientWins:
        return _resolveClientClientWins(conflict);
      case ConflictStrategy.merge:
        return _resolveClientMerge(conflict);
      case ConflictStrategy.manual:
        return Left(SyncFailure.unknown('Manual resolution requires user interaction'));
    }
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveClientServerWins(
    ConflictInfo conflict,
  ) async {
    final remoteResult = await clientRepository.getRemoteClient(conflict.entityId);
    
    return remoteResult.fold(
      (failure) => Left(failure),
      (remoteClient) async {
        if (remoteClient == null) {
          return const ConflictResolutionResult(
            entityType: 'client',
            entityId: '',
            resolved: false,
            strategyUsed: ConflictStrategy.serverWins,
            errorMessage: 'Remote client not found',
          );
        }

        await database.updateClient(ClientsTableCompanion(
          id: Value(remoteClient.id),
          firstName: Value(remoteClient.firstName),
          lastName: Value(remoteClient.lastName),
          email: Value(remoteClient.email),
          phone: Value(remoteClient.phone),
          address: Value(remoteClient.address),
          identificationNumber: Value(remoteClient.identificationNumber),
          syncStatus: const Value('synced'),
          version: remoteClient.version,
          lastModified: remoteClient.lastModified,
          syncedAt: Value(DateTime.now()),
        ));

        return ConflictResolutionResult(
          entityType: 'client',
          entityId: conflict.entityId,
          resolved: true,
          strategyUsed: ConflictStrategy.serverWins,
          resolvedEntity: remoteClient,
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveClientClientWins(
    ConflictInfo conflict,
  ) async {
    final localClient = await database.getClientById(conflict.entityId);
    
    if (localClient == null) {
      return const ConflictResolutionResult(
        entityType: 'client',
        entityId: '',
        resolved: false,
        strategyUsed: ConflictStrategy.clientWins,
        errorMessage: 'Local client not found',
      );
    }

    final client = Client(
      id: localClient.id,
      firstName: localClient.firstName,
      lastName: localClient.lastName,
      email: localClient.email,
      phone: localClient.phone,
      address: localClient.address,
      identificationNumber: localClient.identificationNumber,
      syncStatus: SyncStatus.pending,
      version: localClient.version + 1,
      lastModified: DateTime.now(),
      createdAt: localClient.createdAt,
      syncedAt: localClient.syncedAt,
    );

    final syncResult = await clientRepository.syncClient(client);
    
    return syncResult.fold(
      (failure) => Left(failure),
      (syncedClient) async {
        await database.updateClientsSyncStatus([client.id], 'synced');
        
        return ConflictResolutionResult(
          entityType: 'client',
          entityId: conflict.entityId,
          resolved: true,
          strategyUsed: ConflictStrategy.clientWins,
          resolvedEntity: syncedClient,
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveClientMerge(
    ConflictInfo conflict,
  ) async {
    final localClient = await database.getClientById(conflict.entityId);
    final remoteResult = await clientRepository.getRemoteClient(conflict.entityId);
    
    if (localClient == null) {
      return const ConflictResolutionResult(
        entityType: 'client',
        entityId: '',
        resolved: false,
        strategyUsed: ConflictStrategy.merge,
        errorMessage: 'Local client not found',
      );
    }

    return remoteResult.fold(
      (failure) => Left(failure),
      (remoteClient) async {
        if (remoteClient == null) {
          return const ConflictResolutionResult(
            entityType: 'client',
            entityId: '',
            resolved: false,
            strategyUsed: ConflictStrategy.merge,
            errorMessage: 'Remote client not found',
          );
        }

        final mergedClient = Client(
          id: localClient.id,
          firstName: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.firstName
              : remoteClient.firstName,
          lastName: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.lastName
              : remoteClient.lastName,
          email: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.email
              : remoteClient.email,
          phone: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.phone
              : remoteClient.phone,
          address: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.address
              : remoteClient.address,
          identificationNumber: localClient.identificationNumber,
          syncStatus: SyncStatus.pending,
          version: (localClient.version > remoteClient.version 
              ? localClient.version 
              : remoteClient.version) + 1,
          lastModified: DateTime.now(),
          createdAt: localClient.createdAt,
          syncedAt: localClient.syncedAt,
        );

        final syncResult = await clientRepository.syncClient(mergedClient);
        
        return syncResult.fold(
          (failure) => Left(failure),
          (synced) async {
            await database.updateClientsSyncStatus([mergedClient.id], 'synced');
            
            return ConflictResolutionResult(
              entityType: 'client',
              entityId: conflict.entityId,
              resolved: true,
              strategyUsed: ConflictStrategy.merge,
              resolvedEntity: mergedClient,
            );
          },
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveApplicationConflict(
    ConflictInfo conflict,
    ConflictStrategy strategy,
  ) async {
    switch (strategy) {
      case ConflictStrategy.serverWins:
        return _resolveAppServerWins(conflict);
      case ConflictStrategy.clientWins:
        return _resolveAppClientWins(conflict);
      case ConflictStrategy.merge:
        return _resolveAppMerge(conflict);
      case ConflictStrategy.manual:
        return Left(SyncFailure.unknown('Manual resolution requires user interaction'));
    }
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveAppServerWins(
    ConflictInfo conflict,
  ) async {
    final remoteResult = await creditApplicationRepository.getRemoteApplication(conflict.entityId);
    
    return remoteResult.fold(
      (failure) => Left(failure),
      (remoteApp) async {
        if (remoteApp == null) {
          return const ConflictResolutionResult(
            entityType: 'credit_application',
            entityId: '',
            resolved: false,
            strategyUsed: ConflictStrategy.serverWins,
            errorMessage: 'Remote application not found',
          );
        }

        await database.updateCreditApplication(CreditApplicationsTableCompanion(
          id: Value(remoteApp.id),
          clientId: Value(remoteApp.clientId),
          requestedAmount: Value(remoteApp.requestedAmount),
          purpose: Value(remoteApp.purpose),
          termMonths: Value(remoteApp.termMonths),
          status: Value(remoteApp.status),
          syncStatus: const Value('synced'),
          version: remoteApp.version,
          lastModified: remoteApp.lastModified,
          syncedAt: Value(DateTime.now()),
          rejectionReason: Value(remoteApp.rejectionReason),
          approvedAmount: Value(remoteApp.approvedAmount),
        ));

        return ConflictResolutionResult(
          entityType: 'credit_application',
          entityId: conflict.entityId,
          resolved: true,
          strategyUsed: ConflictStrategy.serverWins,
          resolvedEntity: remoteApp,
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveAppClientWins(
    ConflictInfo conflict,
  ) async {
    final localApp = await database.getCreditApplicationById(conflict.entityId);
    
    if (localApp == null) {
      return const ConflictResolutionResult(
        entityType: 'credit_application',
        entityId: '',
        resolved: false,
        strategyUsed: ConflictStrategy.clientWins,
        errorMessage: 'Local application not found',
      );
    }

    final app = CreditApplication(
      id: localApp.id,
      clientId: localApp.clientId,
      requestedAmount: localApp.requestedAmount,
      purpose: localApp.purpose,
      termMonths: localApp.termMonths,
      status: localApp.status,
      syncStatus: SyncStatus.pending,
      version: localApp.version + 1,
      lastModified: DateTime.now(),
      createdAt: localApp.createdAt,
      syncedAt: localApp.syncedAt,
      rejectionReason: localApp.rejectionReason,
      approvedAmount: localApp.approvedAmount,
    );

    final syncResult = await creditApplicationRepository.syncApplication(app);
    
    return syncResult.fold(
      (failure) => Left(failure),
      (syncedApp) async {
        await database.updateCreditApplicationsSyncStatus([app.id], 'synced');
        
        return ConflictResolutionResult(
          entityType: 'credit_application',
          entityId: conflict.entityId,
          resolved: true,
          strategyUsed: ConflictStrategy.clientWins,
          resolvedEntity: syncedApp,
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveAppMerge(
    ConflictInfo conflict,
  ) async {
    final localApp = await database.getCreditApplicationById(conflict.entityId);
    final remoteResult = await creditApplicationRepository.getRemoteApplication(conflict.entityId);
    
    if (localApp == null) {
      return const ConflictResolutionResult(
        entityType: 'credit_application',
        entityId: '',
        resolved: false,
        strategyUsed: ConflictStrategy.merge,
        errorMessage: 'Local application not found',
      );
    }

    return remoteResult.fold(
      (failure) => Left(failure),
      (remoteApp) async {
        if (remoteApp == null) {
          return const ConflictResolutionResult(
            entityType: 'credit_application',
            entityId: '',
            resolved: false,
            strategyUsed: ConflictStrategy.merge,
            errorMessage: 'Remote application not found',
          );
        }

        final mergedApp = CreditApplication(
          id: localApp.id,
          clientId: localApp.clientId,
          requestedAmount: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.requestedAmount
              : remoteApp.requestedAmount,
          purpose: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.purpose
              : remoteApp.purpose,
          termMonths: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.termMonths
              : remoteApp.termMonths,
          status: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.status
              : remoteApp.status,
          syncStatus: SyncStatus.pending,
          version: (localApp.version > remoteApp.version 
              ? localApp.version 
              : remoteApp.version) + 1,
          lastModified: DateTime.now(),
          createdAt: localApp.createdAt,
          syncedAt: localApp.syncedAt,
          rejectionReason: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.rejectionReason
              : remoteApp.rejectionReason,
          approvedAmount: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.approvedAmount
              : remoteApp.approvedAmount,
        );

        final syncResult = await creditApplicationRepository.syncApplication(mergedApp);
        
        return syncResult.fold(
          (failure) => Left(failure),
          (synced) async {
            await database.updateCreditApplicationsSyncStatus([mergedApp.id], 'synced');
            
            return ConflictResolutionResult(
              entityType: 'credit_application',
              entityId: conflict.entityId,
              resolved: true,
              strategyUsed: ConflictStrategy.merge,
              resolvedEntity: mergedApp,
            );
          },
        );
      },
    );
  }

  Future<Either<Failure, List<ConflictResolutionResult>>> resolveAllConflicts(
    ConflictStrategy defaultStrategy,
  ) async {
    final conflictsResult = await detectConflicts();
    
    return conflictsResult.fold(
      (failure) => Left(failure),
      (conflicts) async {
        final results = <ConflictResolutionResult>[];
        
        for (final conflict in conflicts) {
          final result = await resolveConflict(conflict, defaultStrategy);
          result.fold(
            (failure) {},
            (resolution) => results.add(resolution),
          );
        }
        
        return Right(results);
      },
    );
  }
}
// === ARCHIVO: lib/sync/handlers/sync_handler.dart ===
library sync_handler;

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../services/conflict_resolver.dart';
import '../services/sync_coordinator.dart';

enum SyncEventType {
  connectivityChanged,
  syncRequested,
  syncCompleted,
  syncFailed,
  conflictDetected,
  backgroundSync,
}

class SyncEvent extends Equatable {
  final SyncEventType type;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  const SyncEvent({
    required this.type,
    required this.timestamp,
    this.data,
  });

  @override
  List<Object?> get props => [type, timestamp, data];
}

class SyncHandlerState extends Equatable {
  final bool isOnline;
  final bool isSyncing;
  final bool hasPendingChanges;
  final bool hasConflicts;
  final int pendingCount;
  final int conflictCount;
  final DateTime? lastSyncTime;
  final String? lastError;

  const SyncHandlerState({
    this.isOnline = false,
    this.isSyncing = false,
    this.hasPendingChanges = false,
    this.hasConflicts = false,
    this.pendingCount = 0,
    this.conflictCount = 0,
    this.lastSyncTime,
    this.lastError,
  });

  SyncHandlerState copyWith({
    bool? isOnline,
    bool? isSyncing,
    bool? hasPendingChanges,
    bool? hasConflicts,
    int? pendingCount,
    int? conflictCount,
    DateTime? lastSyncTime,
    String? lastError,
  }) {
    return SyncHandlerState(
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
      hasConflicts: hasConflicts ?? this.hasConflicts,
      pendingCount: pendingCount ?? this.pendingCount,
      conflictCount: conflictCount ?? this.conflictCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      lastError: lastError,
    );
  }

  @override
  List<Object?> get props => [
        isOnline,
        isSyncing,
        hasPendingChanges,
        hasConflicts,
        pendingCount,
        conflictCount,
        lastSyncTime,
        lastError,
      ];
}

class SyncHandler {
  final SyncCoordinator syncCoordinator;
  final ConflictResolver conflictResolver;
  final ConnectivityService connectivityService;
  final AppConfig config;

  final _eventController = StreamController<SyncEvent>.broadcast();
  final _stateController = StreamController<SyncHandlerState>.broadcast();
  
  Timer? _periodicSyncTimer;
  StreamSubscription? _connectivitySubscription;
  SyncHandlerState _currentState = const SyncHandlerState();

  SyncHandler({
    required this.syncCoordinator,
    required this.conflictResolver,
    required this.connectivityService,
    required this.config,
  }) {
    _init();
  }

  void _init() {
    _connectivitySubscription = connectivityService.statusStream.listen(
      _onConnectivityChanged,
    );
  }

  Stream<SyncEvent> get eventStream => _eventController.stream;
  Stream<SyncHandlerState> get stateStream => _stateController.stream;
  SyncHandlerState get currentState => _currentState;

  void _onConnectivityChanged(ConnectivityStatus status) {
    final wasOffline = !_currentState.isOnline;
    final isNowOnline = status.isConnected;
    
    _updateState(_currentState.copyWith(
      isOnline: isNowOnline,
    ));

    _eventController.add(SyncEvent(
      type: SyncEventType.connectivityChanged,
      timestamp: DateTime.now(),
      data: {
        'wasOffline': wasOffline,
        'isOnline': isNowOnline,
      },
    ));

    if (wasOffline && isNowOnline && _currentState.hasPendingChanges) {
      _triggerAutoSync();
    }
  }

  void _updateState(SyncHandlerState newState) {
    _currentState = newState;
    _stateController.add(_currentState);
  }

  void startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(
      config.syncInterval,
      (_) => _triggerAutoSync(),
    );
  }

  void stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }

  Future<void> _triggerAutoSync() async {
    if (_currentState.isSyncing || !_currentState.isOnline) {
      return;
    }

    await handleSyncRequested();
  }

  Future<Either<Failure, void>> handleSyncRequested() async {
    if (_currentState.isSyncing) {
      return const Left(SyncFailure(
        message: 'Sincronización ya en progreso',
      ));
    }

    if (!_currentState.isOnline) {
      return Left(NetworkFailure.noConnection());
    }

    _updateState(_currentState.copyWith(
      isSyncing: true,
      lastError: null,
    ));

    _eventController.add(SyncEvent(
      type: SyncEventType.syncRequested,
      timestamp: DateTime.now(),
    ));

    try {
      final conflictsResult = await conflictResolver.detectConflicts();
      
      await conflictsResult.fold(
        (failure) async {},
        (conflicts) async {
          if (conflicts.isNotEmpty) {
            _updateState(_currentState.copyWith(
              hasConflicts: true,
              conflictCount: conflicts.length,
            ));

            _eventController.add(SyncEvent(
              type: SyncEventType.conflictDetected,
              timestamp: DateTime.now(),
              data: {
                'count': conflicts.length,
                'conflicts': conflicts,
              },
            ));

            await conflictResolver.resolveAllConflicts(
              ConflictStrategy.serverWins,
            );
          }
        },
      );

      final result = await syncCoordinator.executeFullSync();
      
      return result.fold(
        (failure) {
          _updateState(_currentState.copyWith(
            isSyncing: false,
            lastError: failure.message,
          ));

          _eventController.add(SyncEvent(
            type: SyncEventType.syncFailed,
            timestamp: DateTime.now(),
            data: {'error': failure.message},
          ));

          return Left(failure);
        },
        (syncResult) {
          _updateState(_currentState.copyWith(
            isSyncing: false,
            hasPendingChanges: syncResult.uploadedClients > 0 || 
                               syncResult.uploadedApplications > 0,
            pendingCount: 0,
            hasConflicts: syncResult.hasConflicts,
            conflictCount: syncResult.conflictsResolved,
            lastSyncTime: DateTime.now(),
          ));

          _eventController.add(SyncEvent(
            type: SyncEventType.syncCompleted,
            timestamp: DateTime.now(),
            data: {
              'uploadedClients': syncResult.uploadedClients,
              'downloadedClients': syncResult.downloadedClients,
              'uploadedApplications': syncResult.uploadedApplications,
              'downloadedApplications': syncResult.downloadedApplications,
              'conflictsResolved': syncResult.conflictsResolved,
            },
          ));

          return const Right(null);
        },
      );
    } catch (e) {
      _updateState(_currentState.copyWith(
        isSyncing: false,
        lastError: e.toString(),
      ));

      _eventController.add(SyncEvent(
        type: SyncEventType.syncFailed,
        timestamp: DateTime.now(),
        data: {'error': e.toString()},
      ));

      return Left(SyncFailure.unknown(e.toString()));
    }
  }

  Future<void> refreshPendingCount() async {
    // Esta funcionalidad se implementaría consultando la base de datos
    // para obtener la cantidad de registros pendientes
  }

  void handleBackgroundSync() {
    _eventController.add(SyncEvent(
      type: SyncEventType.backgroundSync,
      timestamp: DateTime.now(),
    ));

    if (!_currentState.isSyncing && _currentState.isOnline) {
      handleSyncRequested();
    }
  }

  void dispose() {
    _periodicSyncTimer?.cancel();
    _connectivitySubscription?.cancel();
    _eventController.close();
    _stateController.close();
  }
}

// === ARCHIVO: test/unit/database_test.dart ===
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:credit_field_app/core/database/app_database.dart';
import 'package:credit_field_app/core/error/failures.dart';

void main() {
  late AppDatabase database;

  setUpAll(() async {
    database = AppDatabase._internal();
    await database.initialize();
  });

  tearDownAll(() async {
    await database.close();
  });

  group('Client Operations', () {
    test('should insert a new client and retrieve it', () async {
      final clientId = 'test-client-${DateTime.now().millisecondsSinceEpoch}';
      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Juan',
        lastName: 'Pérez',
        email: const Value('juan.perez@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Calle Principal 123'),
        identificationNumber: const Value('ABC123456'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      final insertResult = await database.insertClient(clientCompanion);
      expect(insertResult, greaterThan(0));

      final retrievedClient = await database.getClientById(clientId);
      expect(retrievedClient, isNotNull);
      expect(retrievedClient!.firstName, equals('Juan'));
      expect(retrievedClient.lastName, equals('Pérez'));
      expect(retrievedClient.syncStatus, equals('pending'));

      await database.deleteClient(clientId);
    });

    test('should update an existing client', () async {
      final clientId = 'test-client-update-${DateTime.now().millisecondsSinceEpoch}';
      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'María',
        lastName: 'Gómez',
        email: const Value('maria.gomez@test.com'),
        phone: const Value('+521234567891'),
        address: const Value('Avenida Secundaria 456'),
        identificationNumber: const Value('DEF789012'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      await database.insertClient(clientCompanion);

      final updatedCompanion = ClientsTableCompanion(
        id: Value(clientId),
        firstName: const Value('María Actualizada'),
        lastName: const Value('Gómez Actualizado'),
        email: Value('maria.updated@test.com'),
        phone: const Value('+521234567892'),
        address: const Value('Nueva Dirección 789'),
        identificationNumber: const Value('DEF789012'),
        syncStatus: const Value('pending'),
        version: const Value(2),
        lastModified: Value(DateTime.now()),
        createdAt: Value(DateTime.now()),
        syncedAt: const Value(null),
      );

      final updateResult = await database.updateClient(updatedCompanion);
      expect(updateResult, isTrue);

      final updatedClient = await database.getClientById(clientId);
      expect(updatedClient!.firstName, equals('María Actualizada'));
      expect(updatedClient.version, equals(2));

      await database.deleteClient(clientId);
    });

    test('should delete a client', () async {
      final clientId = 'test-client-delete-${DateTime.now().millisecondsSinceEpoch}';
      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Carlos',
        lastName: 'López',
        email: const Value('carlos.lopez@test.com'),
        phone: const Value('+521234567893'),
        address: const Value('Calle Test 111'),
        identificationNumber: const Value('GHI345678'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      await database.insertClient(clientCompanion);
      final deleteResult = await database.deleteClient(clientId);
      expect(deleteResult, equals(1));

      final deletedClient = await database.getClientById(clientId);
      expect(deletedClient, isNull);
    });

    test('should retrieve all pending clients', () async {
      final clientId1 = 'test-pending-1-${DateTime.now().millisecondsSinceEpoch}';
      final clientId2 = 'test-pending-2-${DateTime.now().millisecondsSinceEpoch}';
      final clientId3 = 'test-synced-${DateTime.now().millisecondsSinceEpoch}';

      final companion1 = ClientsTableCompanion.insert(
        id: clientId1,
        firstName: 'Pending',
        lastName: 'One',
        email: const Value('pending1@test.com'),
        phone: const Value('+521111111111'),
        address: const Value('Address 1'),
        identificationNumber: const Value('P1'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      final companion2 = ClientsTableCompanion.insert(
        id: clientId2,
        firstName: 'Pending',
        lastName: 'Two',
        email: const Value('pending2@test.com'),
        phone: const Value('+521222222222'),
        address: const Value('Address 2'),
        identificationNumber: const Value('P2'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      final companion3 = ClientsTableCompanion.insert(
        id: clientId3,
        firstName: 'Synced',
        lastName: 'One',
        email: const Value('synced@test.com'),
        phone: const Value('+523333333333'),
        address: const Value('Address 3'),
        identificationNumber: const Value('S1'),
        syncStatus: 'synced',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: Value(DateTime.now()),
      );

      await database.insertClient(companion1);
      await database.insertClient(companion2);
      await database.insertClient(companion3);

      final pendingClients = await database.getPendingClients();
      expect(pendingClients.length, equals(2));
      expect(pendingClients.every((c) => c.syncStatus == 'pending'), isTrue);

      await database.deleteClient(clientId1);
      await database.deleteClient(clientId2);
      await database.deleteClient(clientId3);
    });

    test('should update clients sync status in batch', () async {
      final clientId1 = 'test-batch-1-${DateTime.now().millisecondsSinceEpoch}';
      final clientId2 = 'test-batch-2-${DateTime.now().millisecondsSinceEpoch}';

      final companion1 = ClientsTableCompanion.insert(
        id: clientId1,
        firstName: 'Batch',
        lastName: 'One',
        email: const Value('batch1@test.com'),
        phone: const Value('+521111111111'),
        address: const Value('Address 1'),
        identificationNumber: const Value('B1'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      final companion2 = ClientsTableCompanion.insert(
        id: clientId2,
        firstName: 'Batch',
        lastName: 'Two',
        email: const Value('batch2@test.com'),
        phone: const Value('+521222222222'),
        address: const Value('Address 2'),
        identificationNumber: const Value('B2'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      await database.insertClient(companion1);
      await database.insertClient(companion2);

      await database.updateClientsSyncStatus([clientId1, clientId2], 'synced');

      final client1 = await database.getClientById(clientId1);
      final client2 = await database.getClientById(clientId2);

      expect(client1!.syncStatus, equals('synced'));
      expect(client2!.syncStatus, equals('synced'));

      await database.deleteClient(clientId1);
      await database.deleteClient(clientId2);
    });
  });

  group('Credit Application Operations', () {
    test('should insert and retrieve credit application', () async {
      final clientId = 'test-client-for-app-${DateTime.now().millisecondsSinceEpoch}';
      final appId = 'test-app-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Test',
        lastName: 'Client',
        email: const Value('test@client.com'),
        phone: const Value('+521234567890'),
        address: const Value('Test Address'),
        identificationNumber: const Value('TC'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );
      await database.insertClient(clientCompanion);

      final appCompanion = CreditApplicationsTableCompanion.insert(
        id: appId,
        clientId: clientId,
        requestedAmount: 50000.0,
        purpose: 'Personal',
        termMonths: 24,
        status: 'pending',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(null),
      );

      final insertResult = await database.insertCreditApplication(appCompanion);
      expect(insertResult, greaterThan(0));

      final retrievedApp = await database.getCreditApplicationById(appId);
      expect(retrievedApp, isNotNull);
      expect(retrievedApp!.requestedAmount, equals(50000.0));
      expect(retrievedApp.termMonths, equals(24));

      await database.deleteCreditApplication(appId);
      await database.deleteClient(clientId);
    });

    test('should retrieve applications by client id', () async {
      final clientId = 'test-client-apps-${DateTime.now().millisecondsSinceEpoch}';
      final appId1 = 'test-app-1-${DateTime.now().millisecondsSinceEpoch}';
      final appId2 = 'test-app-2-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Multi',
        lastName: 'App Client',
        email: const Value('multi@app.com'),
        phone: const Value('+521234567890'),
        address: const Value('Address'),
        identificationNumber: const Value('MAC'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );
      await database.insertClient(clientCompanion);

      await database.insertCreditApplication(CreditApplicationsTableCompanion.insert(
        id: appId1,
        clientId: clientId,
        requestedAmount: 10000.0,
        purpose: 'Business',
        termMonths: 12,
        status: 'approved',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(10000.0),
      ));

      await database.insertCreditApplication(CreditApplicationsTableCompanion.insert(
        id: appId2,
        clientId: clientId,
        requestedAmount: 25000.0,
        purpose: 'Home',
        termMonths: 36,
        status: 'pending',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(null),
      ));

      final applications = await database.getCreditApplicationsByClientId(clientId);
      expect(applications.length, equals(2));

      await database.deleteCreditApplication(appId1);
      await database.deleteCreditApplication(appId2);
      await database.deleteClient(clientId);
    });

    test('should get pending credit applications', () async {
      final clientId = 'test-client-pending-${DateTime.now().millisecondsSinceEpoch}';
      final appId = 'test-app-pending-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Pending',
        lastName: 'App Client',
        email: const Value('pending@app.com'),
        phone: const Value('+521234567890'),
        address: const Value('Address'),
        identificationNumber: const Value('PAC'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );
      await database.insertClient(clientCompanion);

      await database.insertCreditApplication(CreditApplicationsTableCompanion.insert(
        id: appId,
        clientId: clientId,
        requestedAmount: 15000.0,
        purpose: 'Education',
        termMonths: 18,
        status: 'pending',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(null),
      ));

      final pendingApps = await database.getPendingCreditApplications();
      expect(pendingApps.any((app) => app.id == appId), isTrue);

      await database.deleteCreditApplication(appId);
      await database.deleteClient(clientId);
    });
  });

  group('Sync Log Operations', () {
    test('should insert and retrieve sync log', () async {
      final logCompanion = SyncLogTableCompanion.insert(
        entityType: 'client',
        entityId: 'sync-test-entity-${DateTime.now().millisecondsSinceEpoch}',
        operation: 'create',
        payload: '{"name": "Test Entity"}',
        status: 'pending',
        retryCount: 0,
        errorMessage: const Value(null),
        createdAt: DateTime.now(),
        processedAt: const Value(null),
      );

      final insertResult = await database.insertSyncLog(logCompanion);
      expect(insertResult, greaterThan(0));
    });

    test('should retrieve pending sync logs', () async {
      final logCompanion = SyncLogTableCompanion.insert(
        entityType: 'credit_application',
        entityId: 'sync-test-ca-${DateTime.now().millisecondsSinceEpoch}',
        operation: 'update',
        payload: '{"status": "approved"}',
        status: 'pending',
        retryCount: 0,
        errorMessage: const Value(null),
        createdAt: DateTime.now(),
        processedAt: const Value(null),
      );

      await database.insertSyncLog(logCompanion);
      final pendingLogs = await database.getPendingSyncLogs();
      expect(pendingLogs.isNotEmpty, isTrue);
    });
  });
}


// === ARCHIVO: test/unit/sync_test.dart ===
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:credit_field_app/core/database/app_database.dart';
import 'package:credit_field_app/core/network/connectivity_service.dart';
import 'package:credit_field_app/core/error/failures.dart';
import 'package:credit_field_app/domain/entities/client.dart';
import 'package:credit_field_app/domain/entities/credit_application.dart';
import 'package:credit_field_app/domain/entities/sync_status.dart' as domain;
import 'package:drift/drift.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late MockAppDatabase mockDatabase;
  late MockConnectivityService mockConnectivityService;

  setUpAll(() {
    registerFallbackValue(ClientsTableCompanion.insert(
      id: 'fallback',
      firstName: 'Fallback',
      lastName: 'User',
      email: const Value('fallback@test.com'),
      phone: const Value('+521234567890'),
      address: const Value('Fallback Address'),
      identificationNumber: const Value('FALLBACK'),
      syncStatus: 'pending',
      version: 1,
      lastModified: DateTime.now(),
      createdAt: DateTime.now(),
      syncedAt: const Value(null),
    ));

    registerFallbackValue(CreditApplicationsTableCompanion.insert(
      id: 'fallback-app',
      clientId: 'fallback-client',
      requestedAmount: 1000.0,
      purpose: 'Test',
      termMonths: 12,
      status: 'pending',
      syncStatus: 'pending',
      version: 1,
      lastModified: DateTime.now(),
      createdAt: DateTime.now(),
      syncedAt: const Value(null),
      rejectionReason: const Value(null),
      approvedAmount: const Value(null),
    ));
  });

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockConnectivityService = MockConnectivityService();
  });

  group('Database Sync Status Operations', () {
    test('should get pending clients from database', () async {
      final mockClients = [
        _createMockClientData('pending-1', 'Pending One'),
        _createMockClientData('pending-2', 'Pending Two'),
      ];

      when(() => mockDatabase.getPendingClients())
          .thenAnswer((_) async => mockClients);

      final result = await mockDatabase.getPendingClients();

      expect(result.length, equals(2));
      expect(result.every((c) => c.syncStatus == 'pending'), isTrue);
      verify(() => mockDatabase.getPendingClients()).called(1);
    });

    test('should update client sync status to synced', () async {
      const clientId = 'client-to-sync';

      when(() => mockDatabase.updateClientsSyncStatus([clientId], 'synced'))
          .thenAnswer((_) async {});

      await mockDatabase.updateClientsSyncStatus([clientId], 'synced');

      verify(() => mockDatabase.updateClientsSyncStatus([clientId], 'synced'))
          .called(1);
    });

    test('should update client sync status to conflict', () async {
      const clientId = 'client-conflict';

      when(() => mockDatabase.updateClientsSyncStatus([clientId], 'conflict'))
          .thenAnswer((_) async {});

      await mockDatabase.updateClientsSyncStatus([clientId], 'conflict');

      verify(() => mockDatabase.updateClientsSyncStatus([clientId], 'conflict'))
          .called(1);
    });

    test('should get pending credit applications', () async {
      final mockApps = [
        _createMockApplicationData('pending-app-1', 50000.0),
        _createMockApplicationData('pending-app-2', 75000.0),
      ];

      when(() => mockDatabase.getPendingCreditApplications())
          .thenAnswer((_) async => mockApps);

      final result = await mockDatabase.getPendingCreditApplications();

      expect(result.length, equals(2));
      verify(() => mockDatabase.getPendingCreditApplications()).called(1);
    });

    test('should update credit applications sync status', () async {
      const appId1 = 'app-to-sync-1';
      const appId2 = 'app-to-sync-2';

      when(() => mockDatabase.updateCreditApplicationsSyncStatus(
            [appId1, appId2],
            'synced',
          )).thenAnswer((_) async {});

      await mockDatabase.updateCreditApplicationsSyncStatus(
        [appId1, appId2],
        'synced',
      );

      verify(() => mockDatabase.updateCreditApplicationsSyncStatus(
            [appId1, appId2],
            'synced',
          )).called(1);
    });
  });

  group('Connectivity Service Integration', () {
    test('should return connected status', () async {
      final connectedStatus = ConnectivityStatus(
        status: ConnectionStatus.connected,
        timestamp: DateTime.now(),
        networkType: 'wifi',
      );

      when(() => mockConnectivityService.checkConnectivity())
          .thenAnswer((_) async => connectedStatus);

      final result = await mockConnectivityService.checkConnectivity();

      expect(result.isConnected, isTrue);
      expect(result.status, equals(ConnectionStatus.connected));
    });

    test('should return disconnected status', () async {
      final disconnectedStatus = ConnectivityStatus(
        status: ConnectionStatus.disconnected,
        timestamp: DateTime.now(),
        networkType: null,
      );

      when(() => mockConnectivityService.checkConnectivity())
          .thenAnswer((_) async => disconnectedStatus);

      final result = await mockConnectivityService.checkConnectivity();

      expect(result.isDisconnected, isTrue);
      expect(result.status, equals(ConnectionStatus.disconnected));
    });

    test('should listen to connectivity changes', () async {
      final controller = StreamController<ConnectivityStatus>.broadcast();

      when(() => mockConnectivityService.statusStream)
          .thenAnswer((_) => controller.stream);

      when(() => mockConnectivityService.startListening())
          .thenAnswer((_) async {});

      await mockConnectivityService.startListening();

      verify(() => mockConnectivityService.startListening()).called(1);

      controller.add(ConnectivityStatus(
        status: ConnectionStatus.connected,
        timestamp: DateTime.now(),
        networkType: 'wifi',
      ));

      await controller.close();
    });
  });

  group('Sync Status Entity', () {
    test('should create pending sync status', () {
      final status = domain.SyncStatus.pending;

      expect(status.value, equals('pending'));
      expect(status.isPending, isTrue);
      expect(status.isSynced, isFalse);
      expect(status.isConflict, isFalse);
    });

    test('should create synced sync status', () {
      final status = domain.SyncStatus.synced;

      expect(status.value, equals('synced'));
      expect(status.isSynced, isTrue);
      expect(status.isPending, isFalse);
    });

    test('should create conflict sync status', () {
      final status = domain.SyncStatus.conflict;

      expect(status.value, equals('conflict'));
      expect(status.isConflict, isTrue);
      expect(status.isPending, isFalse);
    });

    test('should parse sync status from string', () {
      expect(domain.SyncStatus.parse('pending'), equals(domain.SyncStatus.pending));
      expect(domain.SyncStatus.parse('synced'), equals(domain.SyncStatus.synced));
      expect(domain.SyncStatus.parse('conflict'), equals(domain.SyncStatus.conflict));
    });
  });

  group('Conflict Detection', () {
    test('should detect version mismatch', () {
      const localVersion = 1;
      const remoteVersion = 2;

      final hasConflict = remoteVersion > localVersion;

      expect(hasConflict, isTrue);
    });

    test('should not detect conflict when versions match', () {
      const localVersion = 2;
      const remoteVersion = 2;

      final hasConflict = remoteVersion > localVersion;

      expect(hasConflict, isFalse);
    });

    test('should not detect conflict when local is newer', () {
      const localVersion = 3;
      const remoteVersion = 2;

      final hasConflict = remoteVersion > localVersion;

      expect(hasConflict, isFalse);
    });
  });

  group('Retry Logic', () {
    test('should calculate exponential backoff', () {
      const baseDelay = 1000;
      const maxRetries = 3;

      final delays = List.generate(maxRetries, (index) {
        return baseDelay * (1 << index);
      });

      expect(delays[0], equals(1000));
      expect(delays[1], equals(2000));
      expect(delays[2], equals(4000));
    });

    test('should respect max retry attempts', () {
      const maxRetries = 5;
      var currentRetry = 0;

      final shouldRetry = currentRetry < maxRetries;

      expect(shouldRetry, isTrue);

      currentRetry = maxRetries;
      final shouldRetryAfterMax = currentRetry < maxRetries;

      expect(shouldRetryAfterMax, isFalse);
    });
  });
}

ClientsTableData _createMockClientData(String id, String name) {
  return ClientsTableData(
    id: id,
    firstName: name,
    lastName: 'LastName',
    email: '$id@test.com',
    phone: '+521234567890',
    address: 'Test Address',
    identificationNumber: id,
    syncStatus: 'pending',
    version: 1,
    lastModified: DateTime.now(),
    createdAt: DateTime.now(),
    syncedAt: null,
  );
}

CreditApplicationsTableData _createMockApplicationData(String id, double amount) {
  return CreditApplicationsTableData(
    id: id,
    clientId: 'client-$id',
    requestedAmount: amount,
    purpose: 'Test Purpose',
    termMonths: 12,
    status: 'pending',
    syncStatus: 'pending',
    version: 1,
    lastModified: DateTime.now(),
    createdAt: DateTime.now(),
    syncedAt: null,
    rejectionReason: null,
    approvedAmount: null,
  );
}


// === ARCHIVO: test/integration/offline_flow_test.dart ===
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:credit_field_app/core/database/app_database.dart';
import 'package:credit_field_app/core/network/connectivity_service.dart';
import 'package:credit_field_app/domain/entities/sync_status.dart' as domain;

void main() {
  late AppDatabase database;
  late ConnectivityService connectivityService;

  setUpAll(() async {
    database = AppDatabase._internal();
    await database.initialize();
    connectivityService = ConnectivityService();
  });

  setUp(() async {
    await database.deleteAllClients();
    await database.deleteAllCreditApplications();
    final syncLogs = await database.getPendingSyncLogs();
    for (final log in syncLogs) {
      await database.deleteSyncLog(log.id);
    }
  });

  tearDownAll(() async {
    connectivityService.dispose();
    await database.close();
  });

  group('Offline-First Flow: Complete Scenario', () {
    test('should create client offline and queue for sync', () async {
      final clientId = 'offline-client-${DateTime.now().millisecondsSinceEpoch}';
      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Offline',
        lastName: 'User',
        email: const Value('offline@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Offline Address'),
        identificationNumber: const Value('OFFLINE001'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      await database.insertClient(clientCompanion);

      final savedClient = await database.getClientById(clientId);
      expect(savedClient, isNotNull);
      expect(savedClient!.syncStatus, equals('pending'));
      expect(savedClient.version, equals(1));

      final pendingClients = await database.getPendingClients();
      expect(pendingClients.any((c) => c.id == clientId), isTrue);
    });

    test('should create credit application offline', () async {
      final clientId = 'client-for-app-${DateTime.now().millisecondsSinceEpoch}';
      final appId = 'offline-app-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'App',
        lastName: 'Owner',
        email: const Value('appowner@test.com'),
        phone: const Value('+521234567891'),
        address: const Value('App Owner Address'),
        identificationNumber: const Value('APPOWNER001'),
        syncStatus: 'synced',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: Value(DateTime.now()),
      );
      await database.insertClient(clientCompanion);

      final appCompanion = CreditApplicationsTableCompanion.insert(
        id: appId,
        clientId: clientId,
        requestedAmount: 100000.0,
        purpose: 'Business Loan',
        termMonths: 36,
        status: 'pending',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(null),
      );

      await database.insertCreditApplication(appCompanion);

      final savedApp = await database.getCreditApplicationById(appId);
      expect(savedApp, isNotNull);
      expect(savedApp!.syncStatus, equals('pending'));
      expect(savedApp.requestedAmount, equals(100000.0));

      final pendingApps = await database.getPendingCreditApplications();
      expect(pendingApps.any((a) => a.id == appId), isTrue);
    });

    test('should update client while offline and preserve pending status', () async {
      final clientId = 'update-offline-${DateTime.now().millisecondsSinceEpoch}';

      final originalCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Original',
        lastName: 'Name',
        email: const Value('original@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Original Address'),
        identificationNumber: const Value('ORIGINAL001'),
        syncStatus: 'synced',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: Value(DateTime.now()),
      );
      await database.insertClient(originalCompanion);

      final updatedCompanion = ClientsTableCompanion(
        id: Value(clientId),
        firstName: const Value('Updated Name'),
        lastName: const Value('Updated LastName'),
        email: const Value('updated@test.com'),
        phone: const Value('+521234567891'),
        address: const Value('Updated Address'),
        identificationNumber: const Value('ORIGINAL001'),
        syncStatus: const Value('pending'),
        version: const Value(2),
        lastModified: Value(DateTime.now()),
        createdAt: Value(DateTime.now()),
        syncedAt: const Value(null),
      );
      await database.updateClient(updatedCompanion);

      final updatedClient = await database.getClientById(clientId);
      expect(updatedClient!.firstName, equals('Updated Name'));
      expect(updatedClient.syncStatus, equals('pending'));
      expect(updatedClient.version, equals(2));
    });

    test('should mark entities as synced after successful sync', () async {
      final clientId = 'sync-complete-${DateTime.now().millisecondsSinceEpoch}';
      final appId = 'app-sync-complete-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'ToSync',
        lastName: 'Client',
        email: const Value('tosync@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('ToSync Address'),
        identificationNumber: const Value('TOSYNC001'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );
      await database.insertClient(clientCompanion);

      final appCompanion = CreditApplicationsTableCompanion.insert(
        id: appId,
        clientId: clientId,
        requestedAmount: 50000.0,
        purpose: 'Personal Loan',
        termMonths: 24,
        status: 'approved',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(50000.0),
      );
      await database.insertCreditApplication(appCompanion);

      final syncTime = DateTime.now();
      await database.updateClientsSyncStatus([clientId], 'synced');
      await database.updateCreditApplicationsSyncStatus([appId], 'synced');

      final syncedClient = await database.getClientById(clientId);
      expect(syncedClient!.syncStatus, equals('synced'));

      final syncedApp = await database.getCreditApplicationById(appId);
      expect(syncedApp!.syncStatus, equals('synced'));

      final pendingClients = await database.getPendingClients();
      expect(pendingClients.any((c) => c.id == clientId), isFalse);

      final pendingApps = await database.getPendingCreditApplications();
      expect(pendingApps.any((a) => a.id == appId), isFalse);
    });

    test('should detect conflict when remote version is newer', () async {
      final clientId = 'conflict-test-${DateTime.now().millisecondsSinceEpoch}';

      final localCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Local Version',
        lastName: 'Client',
        email: const Value('local@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Local Address'),
        identificationNumber: const Value('LOCAL001'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );
      await database.insertClient(localCompanion);

      const remoteVersion = 2;
      const remoteLastModified = '2024-01-15T10:00:00Z';

      final hasConflict = remoteVersion > 1;
      expect(hasConflict, isTrue);

      if (hasConflict) {
        await database.updateClientsSyncStatus([clientId], 'conflict');
      }

      final conflictedClient = await database.getClientById(clientId);
      expect(conflictedClient!.syncStatus, equals('conflict'));
    });

    test('should handle batch sync of multiple entities', () async {
      final clientIds = List.generate(
        5,
        (i) => 'batch-client-${DateTime.now().millisecondsSinceEpoch}-$i',
      );

      for (var i = 0; i < clientIds.length; i++) {
        final companion = ClientsTableCompanion.insert(
          id: clientIds[i],
          firstName: 'Batch Client $i',
          lastName: 'Batch LastName',
          email: Value('batch$i@test.com'),
          phone: Value('+52123456789$i'),
          address: Value('Batch Address $i'),
          identificationNumber: Value('BATCH00$i'),
          syncStatus: 'pending',
          version: 1,
          lastModified: DateTime.now(),
          createdAt: DateTime.now(),
          syncedAt: const Value(null),
        );
        await database.insertClient(companion);
      }

      final pendingBefore = await database.getPendingClients();
      expect(pendingBefore.length, greaterThanOrEqualTo(5));

      await database.updateClientsSyncStatus(clientIds, 'synced');

      final pendingAfter = await database.getPendingClients();
      final syncedClients = pendingAfter.where((c) => clientIds.contains(c.id)).toList();
      expect(syncedClients.length, equals(0));

      for (final id in clientIds) {
        await database.deleteClient(id);
      }
    });

    test('should maintain data integrity after sync operations', () async {
      final clientId = 'integrity-test-${DateTime.now().millisecondsSinceEpoch}';
      final appIds = List.generate(
        3,
        (i) => 'integrity-app-${DateTime.now().millisecondsSinceEpoch}-$i',
      );

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Integrity',
        lastName: 'Client',
        email: const Value('integrity@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Integrity Address'),
        identificationNumber: const Value('INTEGRITY001'),
        syncStatus: 'synced',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: Value(DateTime.now()),
      );
      await database.insertClient(clientCompanion);

      for (var i = 0; i < appIds.length; i++) {
        final appCompanion = CreditApplicationsTableCompanion.insert(
          id: appIds[i],
          clientId: clientId,
          requestedAmount: 10000.0 * (i + 1),
          purpose: 'Loan ${i + 1}',
          termMonths: 12 * (i + 1),
          status: 'pending',
          syncStatus: 'pending',
          version: 1,
          lastModified: DateTime.now(),
          createdAt: DateTime.now(),
          syncedAt: const Value(null),
          rejectionReason: const Value(null),
          approvedAmount: const Value(null),
        );
        await database.insertCreditApplication(appCompanion);
      }

      await database.updateCreditApplicationsSyncStatus(appIds, 'synced');

      final clientAfterSync = await database.getClientById(clientId);
      expect(clientAfterSync, isNotNull);
      expect(clientAfterSync!.id, equals(clientId));

      final appsForClient = await database.getCreditApplicationsByClientId(clientId);
      expect(appsForClient.length, equals(3));
      expect(appsForClient.every((a) => a.syncStatus == 'synced'), isTrue);

      final totalAmount = appsForClient.fold<double>(
        0,
        (sum, app) => sum + app.requestedAmount,
      );
      expect(totalAmount, equals(60000.0));

      await database.deleteCreditApplication(appIds[0]);
      await database.deleteCreditApplication(appIds[1]);
      await database.deleteCreditApplication(appIds[2]);
      await database.deleteClient(clientId);
    });

    test('should handle offline scenario: no connection, data queued locally', () async {
      final status = await connectivityService.checkConnectivity();

      if (status.isDisconnected) {
        final clientId = 'offline-queue-${DateTime.now().millisecondsSinceEpoch}';
        final clientCompanion = ClientsTableCompanion.insert(
          id: clientId,
          firstName: 'Queued',
          lastName: 'Offline',
          email: const Value('queued@test.com'),
          phone: const Value('+521234567890'),
          address: const Value('Queued Address'),
          identificationNumber: const Value('QUEUED001'),
          syncStatus: 'pending',
          version: 1,
          lastModified: DateTime.now(),
          createdAt: DateTime.now(),
          syncedAt: const Value(null),
        );

        await database.insertClient(clientCompanion);

        final savedClient = await database.getClientById(clientId);
        expect(savedClient!.syncStatus, equals('pending'));

        final pendingClients = await database.getPendingClients();
        expect(pendingClients.any((c) => c.id == clientId), isTrue);

        await database.deleteClient(clientId);
      } else {
        expect(true, isTrue);
      }
    });
  });
}

extension _DatabaseExtensions on AppDatabase {
  Future<void> deleteAllClients() async {
    final clients = await getAllClients();
    for (final client in clients) {
      await deleteClient(client.id);
    }
  }

  Future<void> deleteAllCreditApplications() async {
    final apps = await getAllCreditApplications();
    for (final app in apps) {
      await deleteCreditApplication(app.id);
    }
  }

  Future<void> deleteSyncLog(int id) async {
    await customStatement('DELETE FROM sync_log WHERE id = ?', [id]);
  }
}

// === ARCHIVO: lib/domain/repositories/client_repository.dart ===
package domain.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../entities/client.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getClients();
  Future<Either<Failure, Client>> getClientById(String id);
  Future<Either<Failure, Client>> saveClient(Client client);
  Future<Either<Failure, void>> deleteClient(String id);
  Future<Either<Failure, List<Client>>> getPendingClients();
  Stream<List<Client>> watchAllClients();
  Stream<List<Client>> watchPendingClients();
  
  Future<Either<Failure, Client>> uploadClientToServer(Client client);
  Future<Either<Failure, void>> updateClientSyncStatus(String id, dynamic status);
  Future<Either<Failure, List<Client>>> getConflictedClients();
  Future<Either<Failure, Client?>> getClientFromServer(String id);
}

class ClientFilter extends Equatable {
  final String? searchQuery;
  final dynamic syncStatus;
  final DateTime? fromDate;
  final DateTime? toDate;
  const ClientFilter({
    this.searchQuery,
    this.syncStatus,
    this.fromDate,
    this.toDate,
  });
  @override
  List<Object?> get props => [searchQuery, syncStatus, fromDate, toDate];
}

// === ARCHIVO: lib/domain/repositories/credit_application_repository.dart ===
package domain.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../entities/credit_application.dart';

abstract class CreditApplicationRepository {
  Future<Either<Failure, List<CreditApplication>>> getCreditApplications();
  Future<Either<Failure, CreditApplication>> getCreditApplicationById(String id);
  Future<Either<Failure, List<CreditApplication>>> getCreditApplicationsByClientId(String clientId);
  Future<Either<Failure, CreditApplication>> saveCreditApplication(CreditApplication application);
  Future<Either<Failure, void>> deleteCreditApplication(String id);
  Future<Either<Failure, List<CreditApplication>>> getPendingCreditApplications();
  Stream<List<CreditApplication>> watchAllCreditApplications();
  Stream<List<CreditApplication>> watchPendingCreditApplications();
  Future<Either<Failure, CreditApplication>> approveApplication(String id, double approvedAmount);
  Future<Either<Failure, CreditApplication>> rejectApplication(String id, String reason);
  
  Future<Either<Failure, List<CreditApplication>>> getConflictedApplications();
  Future<Either<Failure, CreditApplication?>> getCreditApplicationFromServer(String id);
}

class CreditApplicationFilter extends Equatable {
  final String? clientId;
  final dynamic syncStatus;
  final dynamic status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final double? minAmount;
  final double? maxAmount;
  const CreditApplicationFilter({
    this.clientId,
    this.syncStatus,
    this.status,
    this.fromDate,
    this.toDate,
    this.minAmount,
    this.maxAmount,
  });
  @override
  List<Object?> get props => [clientId, syncStatus, status, fromDate, toDate, minAmount, maxAmount];
}

// === ARCHIVO: lib/data/models/client_model.dart ===
package credit_field_app.data.models;

import 'package:equatable/equatable.dart';

import '../../domain/entities/client.dart' as entity;
import '../../domain/entities/sync_status.dart';

class ClientModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String identificationNumber;
  final SyncStatus syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;

  const ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.identificationNumber,
    required this.syncStatus,
    required this.version,
    required this.lastModified,
    required this.createdAt,
    this.syncedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      identificationNumber: json['identificationNumber'] as String? ?? '',
      syncStatus: _parseSyncStatus(json['syncStatus'] as String?),
      version: json['version'] as int? ?? 1,
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      syncedAt: json['syncedAt'] != null
          ? DateTime.parse(json['syncedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'identificationNumber': identificationNumber,
      'syncStatus': syncStatus.name,
      'version': version,
      'lastModified': lastModified.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }

  factory ClientModel.fromEntity(entity.Client client) {
    return ClientModel(
      id: client.id,
      firstName: client.firstName,
      lastName: client.lastName,
      email: client.email,
      phone: client.phone,
      address: client.address,
      identificationNumber: client.identificationNumber,
      syncStatus: _mapEntitySyncStatus(client.syncStatus),
      version: client.version,
      lastModified: client.lastModified,
      createdAt: client.createdAt,
      syncedAt: client.syncedAt,
    );
  }

  entity.Client toEntity() {
    return entity.Client(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      identificationNumber: identificationNumber,
      syncStatus: _mapModelSyncStatus(syncStatus),
      version: version,
      lastModified: lastModified,
      createdAt: createdAt,
      syncedAt: syncedAt,
    );
  }

  Map<String, dynamic> toRemote() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'identificationNumber': identificationNumber,
      'version': version,
      'lastModified': lastModified.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ClientModel.fromRemote(Map<String, dynamic> json) {
    return ClientModel.fromJson(json);
  }

  ClientModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? identificationNumber,
    SyncStatus? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  static SyncStatus _parseSyncStatus(String? status) {
    switch (status) {
      case 'synced':
        return SyncStatus.synced;
      case 'conflict':
        return SyncStatus.conflict;
      case 'pending':
      default:
        return SyncStatus.pending;
    }
  }

  static SyncStatus _mapEntitySyncStatus(entity.ClientSyncStatus status) {
    switch (status) {
      case entity.ClientSyncStatus.synced:
        return SyncStatus.synced;
      case entity.ClientSyncStatus.conflict:
        return SyncStatus.conflict;
      case entity.ClientSyncStatus.pending:
      default:
        return SyncStatus.pending;
    }
  }

  static entity.ClientSyncStatus _mapModelSyncStatus(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return entity.ClientSyncStatus.synced;
      case SyncStatus.conflict:
        return entity.ClientSyncStatus.conflict;
      case SyncStatus.pending:
      default:
        return entity.ClientSyncStatus.pending;
    }
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
        syncStatus,
        version,
        lastModified,
        createdAt,
        syncedAt,
      ];
}

// === ARCHIVO: lib/data/repositories/client_repository_impl.dart ===
package data.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/local/client_local_datasource.dart';
import '../datasources/remote/client_remote_datasource.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDatasource localDatasource;
  final ClientRemoteDatasource remoteDatasource;
  final ConnectivityService connectivityService;
  final AppConfig appConfig;
  final AppDatabase database;

  ClientRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.connectivityService,
    required this.appConfig,
    required this.database,
  });

  @override
  Future<Either<Failure, List<Client>>> getClients() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          final remoteClients = await remoteDatasource.fetchAllClients();
          final clientModels = remoteClients.map((m) => ClientModel.fromRemote(m)).toList();
          
          for (final model in clientModels) {
            await localDatasource.saveClient(model.copyWith(
              syncStatus: SyncStatus.synced,
              syncedAt: DateTime.now(),
            ));
          }
          
          final localClients = await localDatasource.getAllClients();
          return Right(localClients.map((m) => m.toEntity()).toList());
        } catch (e) {
          final localClients = await localDatasource.getAllClients();
          return Right(localClients.map((m) => m.toEntity()).toList());
        }
      } else {
        final localClients = await localDatasource.getAllClients();
        return Right(localClients.map((m) => m.toEntity()).toList());
      }
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> getClientById(String id) async {
    try {
      final clientModel = await localDatasource.getClientById(id);
      if (clientModel == null) {
        return Left(CacheFailure.notFound());
      }
      return Right(clientModel.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> saveClient(Client client) async {
    try {
      final clientModel = ClientModel.fromEntity(client);
      final clientWithSync = clientModel.copyWith(
        syncStatus: SyncStatus.pending,
        version: 1,
        lastModified: DateTime.now(),
      );
      
      await localDatasource.saveClient(clientWithSync);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.createClient(clientModel.toRemote());
          await localDatasource.updateSyncStatus(
            [client.id],
            SyncStatus.synced,
          );
          final updatedClient = await localDatasource.getClientById(client.id);
          if (updatedClient != null) {
            return Right(updatedClient.toEntity());
          }
        } catch (e) {
          await _queueForSync(client.id, 'client');
        }
      } else {
        await _queueForSync(client.id, 'client');
      }
      
      return Right(clientWithSync.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.insertError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClient(String id) async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.deleteClient(id);
        } catch (e) {
          await _queueForSync(id, 'client_delete');
        }
      } else {
        await _queueForSync(id, 'client_delete');
      }
      
      await localDatasource.deleteClient(id);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.deleteError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Client>>> getPendingClients() async {
    try {
      final pendingClients = await localDatasource.getPendingClients();
      return Right(pendingClients.map((m) => m.toEntity()).toList());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> uploadClientToServer(Client client) async {
    try {
      final clientModel = ClientModel.fromEntity(client);
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final result = await remoteDatasource.createClient(clientModel.toRemote());
      return result.fold(
        (failure) => Left(failure),
        (serverModel) async {
          final updatedModel = clientModel.copyWith(
            syncStatus: SyncStatus.synced,
            version: client.version + 1,
            syncedAt: DateTime.now(),
          );
          await localDatasource.updateClient(updatedModel);
          return Right(updatedModel.toEntity());
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateClientSyncStatus(String id, dynamic status) async {
    try {
      final syncStatus = status is SyncStatus 
          ? status 
          : SyncStatus.values.firstWhere(
              (s) => s.name == status.toString(),
              orElse: () => SyncStatus.pending,
            );
      await localDatasource.updateSyncStatus([id], syncStatus);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Client>>> getConflictedClients() async {
    try {
      final allClients = await localDatasource.getAllClients();
      final conflictedClients = allClients
          .where((c) => c.syncStatus == SyncStatus.conflict)
          .map((m) => m.toEntity())
          .toList();
      return Right(conflictedClients);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client?>> getClientFromServer(String id) async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final result = await remoteDatasource.fetchClientById(id);
      return result.fold(
        (failure) => Left(failure),
        (serverModel) async {
          final model = ClientModel.fromRemote(serverModel);
          return Right(model.toEntity());
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Stream<List<Client>> watchAllClients() {
    return localDatasource.watchAllClients().map(
      (clients) => clients.map((m) => m.toEntity()).toList(),
    );
  }

  @override
  Stream<List<Client>> watchPendingClients() {
    return localDatasource.watchPendingClients().map(
      (clients) => clients.map((m) => m.toEntity()).toList(),
    );
  }

  Future<void> _queueForSync(String entityId, String entityType) async {
    await database.insertSyncLog(SyncLogTableCompanion.insert(
      entityType: entityType,
      entityId: entityId,
      operation: 'create',
      payload: '',
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now(),
    ));
  }
}

// === ARCHIVO: lib/data/repositories/credit_application_repository_impl.dart ===
package data.repositories;

import 'package:dartz/dartz.dart';

import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/credit_application_repository.dart';
import '../datasources/local/credit_application_local_datasource.dart';
import '../datasources/remote/credit_application_remote_datasource.dart';
import '../models/credit_application_model.dart';

class CreditApplicationRepositoryImpl implements CreditApplicationRepository {
  final CreditApplicationLocalDatasource localDatasource;
  final CreditApplicationRemoteDatasource remoteDatasource;
  final ConnectivityService connectivityService;
  final AppConfig appConfig;
  final AppDatabase database;

  CreditApplicationRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.connectivityService,
    required this.appConfig,
    required this.database,
  });

  @override
  Future<Either<Failure, List<CreditApplication>>> getCreditApplications() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          final remoteApps = await remoteDatasource.fetchAllApplications();
          for (final app in remoteApps) {
            final model = CreditApplicationModel.fromJson(app);
            await localDatasource.updateApplication(model.copyWith(
              syncStatus: _mapSyncStatus(SyncStatus.synced),
            ));
          }
        } catch (e) {
          // Fallback to local
        }
      }
      
      final localApps = await localDatasource.getAllApplications();
      return Right(localApps.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplication>>> getApplicationsByClientId(
      String clientId) async {
    try {
      final apps = await localDatasource.getApplicationsByClientId(clientId);
      return Right(apps.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> getApplicationById(String id) async {
    try {
      final app = await localDatasource.getApplicationById(id);
      if (app == null) {
        return Left(CacheFailure.notFound());
      }
      return Right(app.toEntity());
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> saveCreditApplication(
      CreditApplication application) async {
    try {
      final model = CreditApplicationModel.fromEntity(application);
      await localDatasource.saveApplication(model.copyWith(
        syncStatus: 'pending',
      ));
      return Right(application);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> updateApplication(
      CreditApplication application) async {
    try {
      final model = CreditApplicationModel.fromEntity(application);
      await localDatasource.updateApplication(model);
      return Right(application);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteApplication(String id) async {
    try {
      await localDatasource.deleteApplication(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplication>>> getPendingApplications() async {
    try {
      final apps = await localDatasource.getPendingApplications();
      return Right(apps.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Stream<List<CreditApplication>> watchAllCreditApplications() {
    return localDatasource.watchAllApplications().map(
      (apps) => apps.map((m) => m.toEntity()).toList(),
    );
  }

  @override
  Stream<List<CreditApplication>> watchPendingCreditApplications() {
    return localDatasource.watchPendingApplications().map(
      (apps) => apps.map((m) => m.toEntity()).toList(),
    );
  }

  @override
  Future<Either<Failure, CreditApplication>> approveApplication(
      String id, double approvedAmount) async {
    try {
      final app = await localDatasource.getApplicationById(id);
      if (app == null) {
        return Left(CacheFailure.notFound());
      }
      
      final updated = app.copyWith(
        status: 'approved',
        approvedAmount: approvedAmount,
      );
      await localDatasource.updateApplication(updated);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> rejectApplication(
      String id, String reason) async {
    try {
      final app = await localDatasource.getApplicationById(id);
      if (app == null) {
        return Left(CacheFailure.notFound());
      }
      
      final updated = app.copyWith(
        status: 'rejected',
        rejectionReason: reason,
      );
      await localDatasource.updateApplication(updated);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplication>>> getConflictedApplications() async {
    try {
      final allApps = await localDatasource.getAllApplications();
      final conflictedApps = allApps
          .where((a) => a.syncStatus == 'conflict')
          .map((m) => m.toEntity())
          .toList();
      return Right(conflictedApps);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication?>> getCreditApplicationFromServer(String id) async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final result = await remoteDatasource.fetchApplicationById(id);
      return result.fold(
        (failure) => Left(failure),
        (serverModel) async {
          final model = CreditApplicationModel.fromJson(serverModel);
          return Right(model.toEntity());
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<Either<Failure, void>> syncApplications() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final pendingApps = await localDatasource.getPendingApplications();
      final syncedIds = <String>[];
      
      for (final app in pendingApps) {
        try {
          if (app.syncStatus == 'pending') {
            await remoteDatasource.createApplication(
              CreditApplicationModel.fromEntity(app.toEntity()).toJson(),
            );
          } else if (app.syncStatus == 'conflict') {
            final serverVersion = await remoteDatasource.fetchApplicationById(app.id);
            if (serverVersion != null) {
              final resolved = await _resolveApplicationConflict(
                app,
                CreditApplicationModel.fromJson(serverVersion),
              );
              await remoteDatasource.updateApplication(
                CreditApplicationModel.fromEntity(resolved.toEntity()).toJson(),
              );
            }
          }
          syncedIds.add(app.id);
        } catch (e) {
          continue;
        }
      }
      
      if (syncedIds.isNotEmpty) {
        await database.updateCreditApplicationsSyncStatus(
          syncedIds,
          SyncStatus.synced.name,
        );
      }
      
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<void> _queueForSync(String entityId, String entityType) async {
    await database.insertSyncLog(SyncLogTableCompanion.insert(
      entityType: entityType,
      entityId: entityId,
      operation: 'create',
      payload: '',
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now(),
    ));
  }

  Future<CreditApplicationModel> _resolveApplicationConflict(
    CreditApplicationModel local,
    CreditApplicationModel remote,
  ) async {
    if (local.lastModified.isAfter(remote.lastModified)) {
      return local;
    }
    final merged = local.copyWith(
      requestedAmount: remote.requestedAmount,
      purpose: remote.purpose,
      termMonths: remote.termMonths,
      status: remote.status.name,
      version: remote.version + 1,
      syncStatus: 'synced',
      syncedAt: DateTime.now(),
    );
    await localDatasource.updateApplication(merged);
    return merged;
  }

  String _mapSyncStatus(SyncStatus status) {
    return status.name;
  }
}


// === ARCHIVO: lib/data/repositories/credit_application_repository_impl.dart ===
package data.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/credit_application_repository.dart';
import '../datasources/local/credit_application_local_datasource.dart';
import '../datasources/remote/credit_application_remote_datasource.dart';
import '../models/credit_application_model.dart';

class CreditApplicationRepositoryImpl implements CreditApplicationRepository {
  final CreditApplicationLocalDatasource localDatasource;
  final CreditApplicationRemoteDatasource remoteDatasource;
  final ConnectivityService connectivityService;
  final AppConfig appConfig;
  final AppDatabase database;

  CreditApplicationRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.connectivityService,
    required this.appConfig,
    required this.database,
  });

  @override
  Future<Either<Failure, List<CreditApplication>>> getCreditApplications() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          final remoteResult = await remoteDatasource.fetchAllApplications();
          return remoteResult.fold(
            (failure) async {
              final localApplications = await localDatasource.getAllApplications();
              return Right(localApplications.map((m) => m.toEntity()).toList());
            },
            (applicationModels) async {
              for (final model in applicationModels) {
                await localDatasource.saveApplication(model.copyWith(
                  syncStatus: SyncStatusEnum.synced,
                  syncedAt: DateTime.now(),
                ));
              }
              final localApplications = await localDatasource.getAllApplications();
              return Right(localApplications.map((m) => m.toEntity()).toList());
            },
          );
        } catch (e) {
          final localApplications = await localDatasource.getAllApplications();
          return Right(localApplications.map((m) => m.toEntity()).toList());
        }
      } else {
        final localApplications = await localDatasource.getAllApplications();
        return Right(localApplications.map((m) => m.toEntity()).toList());
      }
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplication>>> getApplicationsByClientId(
    String clientId,
  ) async {
    try {
      final applications = await localDatasource.getApplicationsByClientId(clientId);
      return Right(applications.map((m) => m.toEntity()).toList());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> getApplicationById(String id) async {
    try {
      final applicationModel = await localDatasource.getApplicationById(id);
      if (applicationModel == null) {
        return Left(CacheFailure.notFound());
      }
      return Right(applicationModel.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> saveApplication(
    CreditApplication application,
  ) async {
    try {
      final applicationModel = CreditApplicationModel.fromEntity(application);
      final applicationWithSync = applicationModel.copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      await localDatasource.saveApplication(applicationWithSync);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.createApplication(applicationModel);
          await localDatasource.updateSyncStatus(
            application.id,
            SyncStatusEnum.synced.name,
          );
          final updatedApplication = await localDatasource.getApplicationById(application.id);
          if (updatedApplication != null) {
            return Right(updatedApplication.toEntity());
          }
        } catch (e) {
          await _queueForSync(application.id, 'credit_application');
        }
      } else {
        await _queueForSync(application.id, 'credit_application');
      }
      
      return Right(applicationWithSync.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.insertError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> updateApplication(
    CreditApplication application,
  ) async {
    try {
      final existingApplication = await localDatasource.getApplicationById(application.id);
      if (existingApplication == null) {
        return Left(CacheFailure.notFound());
      }
      
      final updatedModel = CreditApplicationModel.fromEntity(application).copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: existingApplication.version + 1,
        lastModified: DateTime.now(),
      );
      
      await localDatasource.updateApplication(updatedModel);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.updateApplication(application.id, updatedModel);
          await localDatasource.updateSyncStatus(
            application.id,
            SyncStatusEnum.synced.name,
          );
        } catch (e) {
          await _queueForSync(application.id, 'credit_application');
        }
      } else {
        await _queueForSync(application.id, 'credit_application');
      }
      
      final finalApplication = await localDatasource.getApplicationById(application.id);
      if (finalApplication != null) {
        return Right(finalApplication.toEntity());
      }
      return Left(CacheFailure.notFound());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.updateError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteApplication(String id) async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.deleteApplication(id);
        } catch (e) {
          await _queueForSync(id, 'credit_application_delete');
        }
      } else {
        await _queueForSync(id, 'credit_application_delete');
      }
      
      await localDatasource.deleteApplication(id);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.deleteError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplication>>> getPendingApplications() async {
    try {
      final pendingApplications = await localDatasource.getPendingApplications();
      return Right(pendingApplications.map((m) => m.toEntity()).toList());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> syncApplications() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final pendingApplications = await localDatasource.getPendingApplications();
      final syncedIds = <String>[];
      
      for (final application in pendingApplications) {
        try {
          if (application.syncStatus == SyncStatusEnum.pending) {
            await remoteDatasource.createApplication(application);
          } else if (application.syncStatus == SyncStatusEnum.conflict) {
            final serverResult = await remoteDatasource.fetchApplicationById(application.id);
            serverResult.fold(
              (failure) => continue,
              (serverVersion) async {
                final resolved = await _resolveConflict(application, serverVersion);
                await remoteDatasource.updateApplication(application.id, resolved);
              },
            );
          }
          syncedIds.add(application.id);
        } catch (e) {
          continue;
        }
      }
      
      if (syncedIds.isNotEmpty) {
        await database.updateCreditApplicationsSyncStatus(
          syncedIds,
          SyncStatusEnum.synced.name,
        );
      }
      
      return const Right(null);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on SyncFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<void> _queueForSync(String entityId, String entityType) async {
    await database.insertSyncLog(SyncLogTableCompanion.insert(
      entityType: entityType,
      entityId: entityId,
      operation: 'create',
      payload: '',
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now(),
    ));
  }

  Future<CreditApplicationModel> _resolveConflict(
    CreditApplicationModel local,
    CreditApplicationModel remote,
  ) async {
    if (local.lastModified.isAfter(remote.lastModified)) {
      return local;
    }
    final merged = local.copyWith(
      requestedAmount: remote.requestedAmount,
      purpose: remote.purpose,
      termMonths: remote.termMonths,
      status: remote.status,
      approvedAmount: remote.approvedAmount,
      version: remote.version + 1,
      syncStatus: SyncStatusEnum.synced,
      syncedAt: DateTime.now(),
    );
    await localDatasource.updateApplication(merged);
    return merged;
  }
}

// === ARCHIVO: lib/data/models/credit_application_model.dart ===
package credit_field_app.data.models;

import 'package:equatable/equatable.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/entities/sync_status.dart';

enum ApplicationStatus { pending, approved, rejected, underReview }

class CreditApplicationModel extends Equatable {
  final String id;
  final String clientId;
  final double requestedAmount;
  final String purpose;
  final int termMonths;
  final ApplicationStatus status;
  final SyncStatusEnum syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String? rejectionReason;
  final double? approvedAmount;

  const CreditApplicationModel({
    required this.id,
    required this.clientId,
    required this.requestedAmount,
    required this.purpose,
    required this.termMonths,
    required this.status,
    required this.syncStatus,
    required this.version,
    required this.lastModified,
    required this.createdAt,
    this.syncedAt,
    this.rejectionReason,
    this.approvedAmount,
  });

  factory CreditApplicationModel.fromJson(Map<String, dynamic> json) {
    return CreditApplicationModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      purpose: json['purpose'] as String,
      termMonths: json['termMonths'] as int,
      status: _parseApplicationStatus(json['status'] as String?),
      syncStatus: _parseSyncStatus(json['syncStatus'] as String?),
      version: json['version'] as int,
      lastModified: DateTime.parse(json['lastModified'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      syncedAt: json['syncedAt'] != null 
          ? DateTime.parse(json['syncedAt'] as String) 
          : null,
      rejectionReason: json['rejectionReason'] as String?,
      approvedAmount: json['approvedAmount'] != null 
          ? (json['approvedAmount'] as num).toDouble() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'requestedAmount': requestedAmount,
      'purpose': purpose,
      'termMonths': termMonths,
      'status': _mapModelStatus(status),
      'syncStatus': syncStatus.name,
      'version': version,
      'lastModified': lastModified.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'approvedAmount': approvedAmount,
    };
  }

  factory CreditApplicationModel.fromEntity(CreditApplication entity) {
    return CreditApplicationModel(
      id: entity.id,
      clientId: entity.clientId,
      requestedAmount: entity.requestedAmount,
      purpose: entity.purpose,
      termMonths: entity.termMonths,
      status: _mapEntityStatus(entity.status),
      syncStatus: _parseSyncStatus(entity.syncStatus.name),
      version: entity.version,
      lastModified: entity.lastModified,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
      rejectionReason: entity.rejectionReason,
      approvedAmount: entity.approvedAmount,
    );
  }

  CreditApplication toEntity() {
    return CreditApplication(
      id: id,
      clientId: clientId,
      requestedAmount: requestedAmount,
      purpose: purpose,
      termMonths: termMonths,
      status: _mapModelStatusToEntity(status),
      syncStatus: ApplicationSyncStatus.values.firstWhere(
        (e) => e.name == syncStatus.name,
        orElse: () => ApplicationSyncStatus.pending,
      ),
      version: version,
      lastModified: lastModified,
      createdAt: createdAt,
      syncedAt: syncedAt,
      rejectionReason: rejectionReason,
      approvedAmount: approvedAmount,
    );
  }

  CreditApplicationModel copyWith({
    String? id,
    String? clientId,
    double? requestedAmount,
    String? purpose,
    int? termMonths,
    ApplicationStatus? status,
    SyncStatusEnum? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
    String? rejectionReason,
    double? approvedAmount,
  }) {
    return CreditApplicationModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      requestedAmount: requestedAmount ?? this.requestedAmount,
      purpose: purpose ?? this.purpose,
      termMonths: termMonths ?? this.termMonths,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      approvedAmount: approvedAmount ?? this.approvedAmount,
    );
  }

  static ApplicationStatus _parseApplicationStatus(String? status) {
    switch (status) {
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'underReview':
        return ApplicationStatus.underReview;
      default:
        return ApplicationStatus.pending;
    }
  }

  static SyncStatusEnum _parseSyncStatus(String? status) {
    switch (status) {
      case 'synced':
        return SyncStatusEnum.synced;
      case 'conflict':
        return SyncStatusEnum.conflict;
      default:
        return SyncStatusEnum.pending;
    }
  }

  static ApplicationStatus _mapEntityStatus(ApplicationStatus entityStatus) {
    switch (entityStatus) {
      case ApplicationStatus.pending:
        return ApplicationStatus.pending;
      case ApplicationStatus.approved:
        return ApplicationStatus.approved;
      case ApplicationStatus.rejected:
        return ApplicationStatus.rejected;
      case ApplicationStatus.underReview:
        return ApplicationStatus.underReview;
    }
  }

  static ApplicationStatus _mapModelStatusToEntity(ApplicationStatus modelStatus) {
    switch (modelStatus) {
      case ApplicationStatus.pending:
        return ApplicationStatus.pending;
      case ApplicationStatus.approved:
        return ApplicationStatus.approved;
      case ApplicationStatus.rejected:
        return ApplicationStatus.rejected;
      case ApplicationStatus.underReview:
        return ApplicationStatus.underReview;
    }
  }

  static String _mapModelStatus(ApplicationStatus modelStatus) {
    return modelStatus.name;
  }
}

// === ARCHIVO: lib/domain/entities/sync_status.dart ===
package lib.domain.entities;

import 'package:equatable/equatable.dart';

enum SyncState { pending, syncing, synced, conflict, error }
enum SyncOperation { create, update, delete }

enum SyncStatusEnum { pending, synced, conflict }

class SyncStatus extends Equatable {
  final String entityId;
  final String entityType;
  final SyncState state;
  final SyncOperation operation;
  final DateTime? lastSyncAttempt;
  final String? errorMessage;
  final int retryCount;
  final int version;
  final DateTime lastModified;

  const SyncStatus({
    required this.entityId,
    required this.entityType,
    required this.state,
    required this.operation,
    this.lastSyncAttempt,
    this.errorMessage,
    required this.retryCount,
    required this.version,
    required this.lastModified,
  });

  bool get isPending => state == SyncState.pending;
  bool get isSyncing => state == SyncState.syncing;
  bool get isSynced => state == SyncState.synced;
  bool get hasConflict => state == SyncState.conflict;
  bool get hasError => state == SyncState.error;
  bool get canRetry => retryCount < 3 && (hasError || hasConflict);

  SyncStatus copyWith({
    String? entityId,
    String? entityType,
    SyncState? state,
    SyncOperation? operation,
    DateTime? lastSyncAttempt,
    String? errorMessage,
    int? retryCount,
    int? version,
    DateTime? lastModified,
  }) {
    return SyncStatus(
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      state: state ?? this.state,
      operation: operation ?? this.operation,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      errorMessage: errorMessage ?? this.errorMessage,
      retryCount: retryCount ?? this.retryCount,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  SyncStatus startSync() {
    return copyWith(
      state: SyncState.syncing,
      lastSyncAttempt: DateTime.now(),
    );
  }

  SyncStatus markSynced() {
    return copyWith(
      state: SyncState.synced,
      lastSyncAttempt: DateTime.now(),
    );
  }

  SyncStatus markConflict() {
    return copyWith(state: SyncState.conflict);
  }

  SyncStatus markError(String message) {
    return copyWith(
      state: SyncState.error,
      errorMessage: message,
    );
  }

  SyncStatus incrementRetry() {
    return copyWith(retryCount: retryCount + 1);
  }

  static SyncStatus forCreate(String entityId, String entityType) {
    return SyncStatus(
      entityId: entityId,
      entityType: entityType,
      state: SyncState.pending,
      operation: SyncOperation.create,
      retryCount: 0,
      version: 1,
      lastModified: DateTime.now(),
    );
  }

  static SyncStatus forUpdate(String entityId, String entityType, int version) {
    return SyncStatus(
      entityId: entityId,
      entityType: entityType,
      state: SyncState.pending,
      operation: SyncOperation.update,
      retryCount: 0,
      version: version,
      lastModified: DateTime.now(),
    );
  }

  static SyncStatus forDelete(String entityId, String entityType) {
    return SyncStatus(
      entityId: entityId,
      entityType: entityType,
      state: SyncState.pending,
      operation: SyncOperation.delete,
      retryCount: 0,
      version: 0,
      lastModified: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        entityId,
        entityType,
        state,
        operation,
        lastSyncAttempt,
        errorMessage,
        retryCount,
        version,
        lastModified,
      ];
}

// === ARCHIVO: lib/domain/repositories/client_repository.dart ===
package domain.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/client.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getClients();
  Future<Either<Failure, Client>> getClientById(String id);
  Future<Either<Failure, Client>> saveClient(Client client);
  Future<Either<Failure, Client>> updateClient(Client client);
  Future<Either<Failure, void>> deleteClient(String id);
  Future<Either<Failure, List<Client>>> getPendingClients();
  Future<Either<Failure, void>> syncClients();
  Stream<List<Client>> watchAllClients();
  Stream<List<Client>> watchPendingClients();
}

class ClientFilter extends Equatable {
  final String? searchQuery;
  final ClientSyncStatus? syncStatus;
  final DateTime? fromDate;
  final DateTime? toDate;

  const ClientFilter({
    this.searchQuery,
    this.syncStatus,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [searchQuery, syncStatus, fromDate, toDate];
}

enum ClientSyncStatus { pending, synced, conflict }

// === ARCHIVO: lib/data/repositories/client_repository_impl.dart ===
package data.repositories;

import 'package:dartz/dartz.dart';
import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/local/client_local_datasource.dart';
import '../datasources/remote/client_remote_datasource.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDatasource localDatasource;
  final ClientRemoteDatasource remoteDatasource;
  final ConnectivityService connectivityService;
  final AppConfig appConfig;
  final AppDatabase database;

  ClientRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.connectivityService,
    required this.appConfig,
    required this.database,
  });

  @override
  Future<Either<Failure, List<Client>>> getClients() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          final remoteResult = await remoteDatasource.fetchAllClients();
          return remoteResult.fold(
            (failure) async {
              final localResult = await localDatasource.getAllClients();
              return localResult.fold(
                (failure) => Left(failure),
                (models) => Right(models.map((m) => m.toEntity()).toList()),
              );
            },
            (clientModels) async {
              for (final model in clientModels) {
                await localDatasource.saveClient(model.copyWith(
                  syncStatus: SyncStatusEnum.synced,
                  syncedAt: DateTime.now(),
                ));
              }
              final localResult = await localDatasource.getAllClients();
              return localResult.fold(
                (failure) => Left(failure),
                (models) => Right(models.map((m) => m.toEntity()).toList()),
              );
            },
          );
        } catch (e) {
          final localResult = await localDatasource.getAllClients();
          return localResult.fold(
            (failure) => Left(failure),
            (models) => Right(models.map((m) => m.toEntity()).toList()),
          );
        }
      } else {
        final localResult = await localDatasource.getAllClients();
        return localResult.fold(
          (failure) => Left(failure),
          (models) => Right(models.map((m) => m.toEntity()).toList()),
        );
      }
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> getClientById(String id) async {
    try {
      final result = await localDatasource.getClientById(id);
      return result.fold(
        (failure) => Left(failure),
        (model) => model != null 
            ? Right(model.toEntity()) 
            : Left(CacheFailure.notFound()),
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> saveClient(Client client) async {
    try {
      final clientModel = ClientModel.fromEntity(client);
      final modelWithSync = clientModel.copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      await localDatasource.saveClient(modelWithSync);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.createClient(clientModel);
          await localDatasource.updateSyncStatus(
            [client.id],
            SyncStatusEnum.synced,
          );
          final updatedResult = await localDatasource.getClientById(client.id);
          return updatedResult.fold(
            (failure) => Left(failure),
            (model) => Right(model.toEntity()),
          );
        } catch (e) {
          await _queueForSync(client.id, 'client');
        }
      } else {
        await _queueForSync(client.id, 'client');
      }
      
      return Right(modelWithSync.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.insertError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> updateClient(Client client) async {
    try {
      final existingResult = await localDatasource.getClientById(client.id);
      final existing = existingResult.fold<ClientModel?>(
        (failure) => null,
        (model) => model,
      );
      
      if (existing == null) {
        return Left(CacheFailure.notFound());
      }
      
      final updatedModel = ClientModel.fromEntity(client).copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: existing.version + 1,
        lastModified: DateTime.now(),
      );
      
      await localDatasource.updateClient(updatedModel);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.updateClient(updatedModel);
          await localDatasource.updateSyncStatus(
            [client.id],
            SyncStatusEnum.synced,
          );
        } catch (e) {
          await _queueForSync(client.id, 'client');
        }
      } else {
        await _queueForSync(client.id, 'client');
      }
      
      final finalResult = await localDatasource.getClientById(client.id);
      return finalResult.fold(
        (failure) => Left(failure),
        (model) => Right(model.toEntity()),
      );
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.updateError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClient(String id) async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.deleteClient(id);
        } catch (e) {
          await _queueForSync(id, 'client_delete');
        }
      } else {
        await _queueForSync(id, 'client_delete');
      }
      
      await localDatasource.deleteClient(id);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.deleteError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Client>>> getPendingClients() async {
    try {
      final result = await localDatasource.getPendingClients();
      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((m) => m.toEntity()).toList()),
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> syncClients() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final pendingResult = await localDatasource.getPendingClients();
      final pendingClients = pendingResult.fold(
        (failure) => <ClientModel>[],
        (models) => models,
      );
      
      final syncedIds = <String>[];
      
      for (final client in pendingClients) {
        try {
          if (client.syncStatus == SyncStatusEnum.pending) {
            await remoteDatasource.createClient(client);
          } else if (client.syncStatus == SyncStatusEnum.conflict) {
            final serverResult = await remoteDatasource.fetchClientById(client.id);
            serverResult.fold(
              (failure) => null,
              (serverVersion) async {
                final resolved = await _resolveConflict(client, serverVersion);
                await remoteDatasource.updateClient(resolved);
              },
            );
          }
          syncedIds.add(client.id);
        } catch (e) {
          continue;
        }
      }
      
      if (syncedIds.isNotEmpty) {
        await database.updateClientsSyncStatus(
          syncedIds,
          SyncStatusEnum.synced.name,
        );
      }
      
      return const Right(null);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on SyncFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Stream<List<Client>> watchAllClients() {
    return localDatasource.watchAllClients().map(
      (result) => result.fold(
        (failure) => [],
        (models) => models.map((m) => m.toEntity()).toList(),
      ),
    );
  }

  @override
  Stream<List<Client>> watchPendingClients() {
    return localDatasource.watchPendingClients().map(
      (result) => result.fold(
        (failure) => [],
        (models) => models.map((m) => m.toEntity()).toList(),
      ),
    );
  }

  Future<void> _queueForSync(String entityId, String entityType) async {
    await database.insertSyncLog(SyncLogTableCompanion.insert(
      entityType: entityType,
      entityId: entityId,
      operation: 'create',
      payload: '',
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now(),
    ));
  }

  Future<ClientModel> _resolveConflict(
    ClientModel local,
    ClientModel remote,
  ) async {
    if (local.lastModified.isAfter(remote.lastModified)) {
      return local;
    }
    final merged = local.copyWith(
      firstName: remote.firstName,
      lastName: remote.lastName,
      email: remote.email,
      phone: remote.phone,
      address: remote.address,
      identificationNumber: remote.identificationNumber,
      version: remote.version + 1,
      syncStatus: SyncStatusEnum.synced,
      syncedAt: DateTime.now(),
    );
    await localDatasource.updateClient(merged);
    return merged;
  }
}

// === ARCHIVO: lib/presentation/screens/client_list_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/client_repository.dart';
import '../../core/network/connectivity_service.dart';
import '../widgets/client_card.dart';
import '../widgets/sync_indicator.dart';
import '../viewmodels/client_viewmodel.dart';

abstract class ClientListEvent extends Equatable {
  const ClientListEvent();
  @override
  List<Object?> get props => [];
}

class LoadClients extends ClientListEvent {
  const LoadClients();
}

class RefreshClients extends ClientListEvent {
  const RefreshClients();
}

class SyncClientsRequested extends ClientListEvent {
  const SyncClientsRequested();
}

class ClientListState extends Equatable {
  final List<Client> clients;
  final bool isLoading;
  final String? errorMessage;
  final bool isSyncing;
  final int pendingCount;
  final bool isConnected;
  final DateTime? lastSyncTime;

  const ClientListState({
    this.clients = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isSyncing = false,
    this.pendingCount = 0,
    this.isConnected = true,
    this.lastSyncTime,
  });

  ClientListState copyWith({
    List<Client>? clients,
    bool? isLoading,
    String? errorMessage,
    bool? isSyncing,
    int? pendingCount,
    bool? isConnected,
    DateTime? lastSyncTime,
  }) {
    return ClientListState(
      clients: clients ?? this.clients,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      isConnected: isConnected ?? this.isConnected,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  List<Object?> get props => [
        clients,
        isLoading,
        errorMessage,
        isSyncing,
        pendingCount,
        isConnected,
        lastSyncTime,
      ];
}

class ClientListBloc extends Bloc<ClientListEvent, ClientListState> {
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;

  ClientListBloc({
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ClientListState()) {
    on<LoadClients>(_onLoadClients);
    on<RefreshClients>(_onRefreshClients);
    on<SyncClientsRequested>(_onSyncClientsRequested);
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final clientsResult = await _clientRepository.getClients();
      final pendingResult = await _clientRepository.getPendingClients();
      final isConnected = await _connectivityService.hasActiveConnection();

      clientsResult.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (clients) {
          final pending = pendingResult.fold(
            (failure) => <Client>[],
            (list) => list,
          );
          emit(state.copyWith(
            isLoading: false,
            clients: clients,
            pendingCount: pending.length,
            isConnected: isConnected,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar clientes: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefreshClients(
    RefreshClients event,
    Emitter<ClientListState> emit,
  ) async {
    add(const LoadClients());
  }

  Future<void> _onSyncClientsRequested(
    SyncClientsRequested event,
    Emitter<ClientListState> emit,
  ) async {
    if (!state.isConnected) {
      emit(state.copyWith(
        errorMessage: 'Sin conexión. No se puede sincronizar.',
      ));
      return;
    }

    emit(state.copyWith(isSyncing: true, errorMessage: null));

    try {
      final syncResult = await _clientRepository.syncClients();

      syncResult.fold(
        (failure) => emit(state.copyWith(
          isSyncing: false,
          errorMessage: 'Error de sincronización: ${failure.message}',
        )),
        (_) {
          add(const LoadClients());
          emit(state.copyWith(
            isSyncing: false,
            lastSyncTime: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isSyncing: false,
        errorMessage: 'Error al sincronizar: ${e.toString()}',
      ));
    }
  }
}

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClientListBloc>().add(const LoadClients());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          BlocBuilder<ClientListBloc, ClientListState>(
            builder: (context, state) {
              return SyncIndicator(
                pendingCount: state.pendingCount,
                isSyncing: state.isSyncing,
                isConnected: state.isConnected,
                onSyncPressed: () {
                  context.read<ClientListBloc>().add(const SyncClientsRequested());
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ClientListBloc, ClientListState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red.shade700,
                action: SnackBarAction(
                  label: 'Reintentar',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<ClientListBloc>().add(const LoadClients());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.clients.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.clients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay clientes registrados',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para agregar el primer cliente',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ClientListBloc>().add(const RefreshClients());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.clients.length,
              itemBuilder: (context, index) {
                final client = state.clients[index];
                return ClientCard(
                  client: client,
                  onTap: () => _navigateToClientForm(context, client: client),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToClientForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToClientForm(BuildContext context, {Client? client}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClientFormScreen(client: client),
      ),
    ).then((_) {
      context.read<ClientListBloc>().add(const LoadClients());
    });
  }
}

class ClientFormScreen extends StatelessWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// === ARCHIVO: lib/presentation/screens/client_form_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';

abstract class ClientFormEvent extends Equatable {
  const ClientFormEvent();
  @override
  List<Object?> get props => [];
}

class SaveClientRequested extends ClientFormEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String identificationNumber;

  const SaveClientRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.identificationNumber,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
      ];
}

class UpdateClientRequested extends ClientFormEvent {
  final Client client;

  const UpdateClientRequested({required this.client});

  @override
  List<Object?> get props => [client];
}

class ValidateField extends ClientFormEvent {
  final String fieldName;
  final String value;

  const ValidateField({required this.fieldName, required this.value});

  @override
  List<Object?> get props => [fieldName, value];
}

class ResetForm extends ClientFormEvent {
  const ResetForm();
}

class ClientFormState extends Equatable {
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final Client? savedClient;
  final bool isOffline;

  const ClientFormState({
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.savedClient,
    this.isOffline = false,
  });

  ClientFormState copyWith({
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    Client? savedClient,
    bool? isOffline,
  }) {
    return ClientFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      savedClient: savedClient ?? this.savedClient,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSaved,
        errorMessage,
        fieldErrors,
        savedClient,
        isOffline,
      ];
}

class ClientFormBloc extends Bloc<ClientFormEvent, ClientFormState> {
  final ClientRepository _clientRepository;
  final ConnectivityService _connectivityService;

  ClientFormBloc({
    required ClientRepository clientRepository,
    required ConnectivityService connectivityService,
  })  : _clientRepository = clientRepository,
        _connectivityService = connectivityService,
        super(const ClientFormState()) {
    on<SaveClientRequested>(_onSaveClient);
    on<UpdateClientRequested>(_onUpdateClient);
    on<ValidateField>(_onValidateField);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onSaveClient(
    SaveClientRequested event,
    Emitter<ClientFormState> emit,
  ) async {
    final validationErrors = _validateClientData(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      phone: event.phone,
      identificationNumber: event.identificationNumber,
    );

    if (validationErrors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: validationErrors));
      return;
    }

    emit(state.copyWith(isLoading: true, fieldErrors: {}));

    try {
      final isConnected = await _connectivityService.hasActiveConnection();
      final client = Client(
        id: '',
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phone: event.phone,
        address: event.address,
        identificationNumber: event.identificationNumber,
        syncStatus: ClientSyncStatus.pending,
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final result = await _clientRepository.saveClient(client);

      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (savedClient) => emit(state.copyWith(
          isLoading: false,
          isSaved: true,
          savedClient: savedClient,
          isOffline: !isConnected,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al guardar cliente: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateClient(
    UpdateClientRequested event,
    Emitter<ClientFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final isConnected = await _connectivityService.hasActiveConnection();
      final updatedClient = event.client.copyWith(
        syncStatus: ClientSyncStatus.pending,
        version: event.client.version + 1,
        lastModified: DateTime.now(),
      );

      final result = await _clientRepository.updateClient(updatedClient);

      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (client) => emit(state.copyWith(
          isLoading: false,
          isSaved: true,
          savedClient: client,
          isOffline: !isConnected,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al actualizar cliente: ${e.toString()}',
      ));
    }
  }

  void _onValidateField(
    ValidateField event,
    Emitter<ClientFormState> emit,
  ) {
    final errors = Map<String, String>.from(state.fieldErrors);
    final error = _validateSingleField(event.fieldName, event.value);
    if (error != null) {
      errors[event.fieldName] = error;
    } else {
      errors.remove(event.fieldName);
    }
    emit(state.copyWith(fieldErrors: errors));
  }

  void _onResetForm(ResetForm event, Emitter<ClientFormState> emit) {
    emit(const ClientFormState());
  }

  Map<String, String> _validateClientData({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String identificationNumber,
  }) {
    final errors = <String, String>{};

    final firstNameError = _validateSingleField('firstName', firstName);
    if (firstNameError != null) errors['firstName'] = firstNameError;

    final lastNameError = _validateSingleField('lastName', lastName);
    if (lastNameError != null) errors['lastName'] = lastNameError;

    final emailError = _validateSingleField('email', email);
    if (emailError != null) errors['email'] = emailError;

    final phoneError = _validateSingleField('phone', phone);
    if (phoneError != null) errors['phone'] = phoneError;

    final idError = _validateSingleField('identificationNumber', identificationNumber);
    if (idError != null) errors['identificationNumber'] = idError;

    return errors;
  }

  String? _validateSingleField(String fieldName, String value) {
    if (value.trim().isEmpty) {
      return 'El campo $fieldName es requerido';
    }

    switch (fieldName) {
      case 'email':
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Ingrese un correo electrónico válido';
        }
        break;
      case 'phone':
        final phoneRegex = RegExp(r'^[0-9]{10,15}$');
        if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
          return 'Ingrese un número de teléfono válido';
        }
        break;
      case 'identificationNumber':
        if (value.length < 5 || value.length > 20) {
          return 'La identificación debe tener entre 5 y 20 caracteres';
        }
        break;
      case 'firstName':
      case 'lastName':
        if (value.length < 2) {
          return 'El nombre debe tener al menos 2 caracteres';
        }
        if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
          return 'Solo se permiten letras y espacios';
        }
        break;
    }

    return null;
  }
}

class ClientFormScreen extends StatefulWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _identificationController;

  bool get isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.client?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.client?.lastName ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _addressController = TextEditingController(text: widget.client?.address ?? '');
    _identificationController = TextEditingController(text: widget.client?.identificationNumber ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _identificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientFormBloc(
        clientRepository: context.read<ClientRepository>(),
        connectivityService: context.read<ConnectivityService>(),
      ),
      child: BlocConsumer<ClientFormBloc, ClientFormState>(
        listener: (context, state) {
          if (state.isSaved) {
            final message = state.isOffline
                ? 'Cliente guardado offline. Se sincronizará cuando haya conexión.'
                : 'Cliente guardado correctamente.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green.shade700,
              ),
            );
            Navigator.of(context).pop(true);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Editar Cliente' : 'Nuevo Cliente'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _firstNameController,
                      label: 'Nombre',
                      icon: Icons.person,
                      error: state.fieldErrors['firstName'],
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _lastNameController,
                      label: 'Apellido',
                      icon: Icons.person_outline,
                      error: state.fieldErrors['lastName'],
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _identificationController,
                      label: 'Número de Identificación',
                      icon: Icons.badge,
                      error: state.fieldErrors['identificationNumber'],
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      error: state.fieldErrors['email'],
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Teléfono',
                      icon: Icons.phone,
                      error: state.fieldErrors['phone'],
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Dirección',
                      icon: Icons.home,
                      error: state.fieldErrors['address'],
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () => _saveClient(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEditing ? 'Actualizar Cliente' : 'Guardar Cliente'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? error,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        errorText: error,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
    );
  }

  void _saveClient(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final bloc = context.read<ClientFormBloc>();
      if (isEditing && widget.client != null) {
        final updatedClient = widget.client!.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          identificationNumber: _identificationController.text.trim(),
        );
        bloc.add(UpdateClientRequested(client: updatedClient));
      } else {
        bloc.add(SaveClientRequested(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          identificationNumber: _identificationController.text.trim(),
        ));
      }
    }
  }
}


=== ARCHIVO: lib/domain/repositories/client_repository.dart ===
package domain.repositories;

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/client.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getClients();
  Future<Either<Failure, Client>> getClientById(String id);
  Future<Either<Failure, Client>> saveClient(Client client);
  Future<Either<Failure, void>> deleteClient(String id);
  Future<Either<Failure, List<Client>>> getPendingClients();
  Stream<List<Client>> watchAllClients();
  Stream<List<Client>> watchPendingClients();
  Future<Either<Failure, List<Client>>> getRemoteClients();
  Future<Either<Failure, Client?>> getRemoteClient(String id);
  Future<Either<Failure, Client>> syncClient(Client client);
}

class ClientFilter extends Equatable {
  final String? searchQuery;
  final ClientSyncStatus? syncStatus;
  final DateTime? fromDate;
  final DateTime? toDate;

  const ClientFilter({
    this.searchQuery,
    this.syncStatus,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [searchQuery, syncStatus, fromDate, toDate];
}

enum ClientSyncStatus {
  pending,
  synced,
  conflict,
}

// === ARCHIVO: lib/domain/repositories/credit_application_repository.dart ===
package domain.repositories;

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/credit_application.dart';

abstract class CreditApplicationRepository {
  Future<Either<Failure, List<CreditApplication>>> getCreditApplications();
  Future<Either<Failure, CreditApplication>> getCreditApplicationById(String id);
  Future<Either<Failure, List<CreditApplication>>> getCreditApplicationsByClientId(String clientId);
  Future<Either<Failure, CreditApplication>> saveCreditApplication(CreditApplication application);
  Future<Either<Failure, void>> deleteCreditApplication(String id);
  Future<Either<Failure, List<CreditApplication>>> getPendingCreditApplications();
  Stream<List<CreditApplication>> watchAllCreditApplications();
  Stream<List<CreditApplication>> watchPendingCreditApplications();
  Future<Either<Failure, CreditApplication>> approveApplication(String id, double approvedAmount);
  Future<Either<Failure, CreditApplication>> rejectApplication(String id, String reason);
  Future<Either<Failure, List<CreditApplication>>> getRemoteApplications();
  Future<Either<Failure, CreditApplication?>> getRemoteApplication(String id);
  Future<Either<Failure, CreditApplication>> syncApplication(CreditApplication application);
}

class CreditApplicationFilter extends Equatable {
  final String? clientId;
  final ApplicationSyncStatus? syncStatus;
  final ApplicationStatus? status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final double? minAmount;
  final double? maxAmount;

  const CreditApplicationFilter({
    this.clientId,
    this.syncStatus,
    this.status,
    this.fromDate,
    this.toDate,
    this.minAmount,
    this.maxAmount,
  });

  @override
  List<Object?> get props => [clientId, syncStatus, status, fromDate, toDate, minAmount, maxAmount];
}

enum ApplicationSyncStatus {
  pending,
  synced,
  conflict,
}

enum ApplicationStatus {
  pending,
  approved,
  rejected,
}

// === ARCHIVO: lib/core/database/app_database.dart ===
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:equatable/equatable.dart';

part 'app_database.g.dart';

class ClientsTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get identificationNumber => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CreditApplicationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get clientId => text().references(ClientsTable, #id)();
  RealColumn get requestedAmount => real()();
  TextColumn get purpose => text()();
  IntColumn get termMonths => integer()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get rejectionReason => text().nullable()();
  RealColumn get approvedAmount => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();
}

@DriftDatabase(tables: [ClientsTable, CreditApplicationsTable, SyncLogTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static AppDatabase? _instance;

  static QueryExecutor _openConnection() {
    return NativeDatabase.memory();
  }

  static AppDatabase get instance {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  @override
  int get schemaVersion => 1;

  Future<void> initialize() async {
    await database.ensureOpen();
  }

  // Client operations
  Future<List<ClientsTableData>> getAllClients() => select(clientsTable).get();

  Stream<List<ClientsTableData>> watchAllClients() => select(clientsTable).watch();

  Future<ClientsTableData?> getClientById(String id) {
    return (select(clientsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertClient(ClientsTableCompanion client) {
    return into(clientsTable).insert(client);
  }

  Future<bool> updateClient(ClientsTableCompanion client) {
    return update(clientsTable).replace(client);
  }

  Future<int> deleteClient(String id) {
    return (delete(clientsTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<ClientsTableData>> getPendingClients() {
    return (select(clientsTable)..where((tbl) => tbl.syncStatus.equals('pending'))).get();
  }

  Stream<List<ClientsTableData>> watchPendingClients() {
    return (select(clientsTable)..where((tbl) => tbl.syncStatus.equals('pending'))).watch();
  }

  // Credit Application operations
  Future<List<CreditApplicationsTableData>> getAllCreditApplications() =>
      select(creditApplicationsTable).get();

  Stream<List<CreditApplicationsTableData>> watchAllCreditApplications() =>
      select(creditApplicationsTable).watch();

  Future<List<CreditApplicationsTableData>> getCreditApplicationsByClientId(String clientId) {
    return (select(creditApplicationsTable)..where((tbl) => tbl.clientId.equals(clientId))).get();
  }

  Future<CreditApplicationsTableData?> getCreditApplicationById(String id) {
    return (select(creditApplicationsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertCreditApplication(CreditApplicationsTableCompanion application) {
    return into(creditApplicationsTable).insert(application);
  }

  Future<bool> updateCreditApplication(CreditApplicationsTableCompanion application) {
    return update(creditApplicationsTable).replace(application);
  }

  Future<int> deleteCreditApplication(String id) {
    return (delete(creditApplicationsTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<CreditApplicationsTableData>> getPendingCreditApplications() {
    return (select(creditApplicationsTable)..where((tbl) => tbl.syncStatus.equals('pending'))).get();
  }

  Stream<List<CreditApplicationsTableData>> watchPendingCreditApplications() {
    return (select(creditApplicationsTable)..where((tbl) => tbl.syncStatus.equals('pending'))).watch();
  }

  // Sync log operations
  Future<int> insertSyncLog(SyncLogTableCompanion logEntry) {
    return into(syncLogTable).insert(logEntry);
  }

  Future<List<SyncLogTableData>> getPendingSyncLogs() {
    return (select(syncLogTable)..where((tbl) => tbl.status.equals('pending'))).get();
  }

  Future<int> updateSyncLogStatus(int id, String status, {String? errorMessage}) {
    return (update(syncLogTable)..where((tbl) => tbl.id.equals(id))).write(
      SyncLogTableCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        processedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateClientsSyncStatus(List<String> ids, String status) async {
    await (update(clientsTable)..where((tbl) => tbl.id.isIn(ids))).write(
      ClientsTableCompanion(
        syncStatus: Value(status),
        syncedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateCreditApplicationsSyncStatus(List<String> ids, String status) async {
    await (update(creditApplicationsTable)..where((tbl) => tbl.id.isIn(ids))).write(
      CreditApplicationsTableCompanion(
        syncStatus: Value(status),
        syncedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> close() async {
    await database.close();
    _instance = null;
  }
}


// === ARCHIVO: lib/core/database/app_database.dart ===
library;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'app_database.g.dart';

class ClientsTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get identificationNumber => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CreditApplicationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get clientId => text().references(ClientsTable, #id)();
  RealColumn get requestedAmount => real()();
  TextColumn get purpose => text()();
  IntColumn get termMonths => integer()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get rejectionReason => text().nullable()();
  TextColumn get approvedAmount => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();
}

@DriftDatabase(tables: [ClientsTable, CreditApplicationsTable, SyncLogTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static AppDatabase? _instance;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'credit_field_db');
  }

  static AppDatabase get instance {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  @override
  int get schemaVersion => 1;

  Future<void> initialize() async {
    await database.ensureOpen();
  }

  Future<List<ClientsTableData>> getAllClients() => select(clientsTable).get();

  Stream<List<ClientsTableData>> watchAllClients() => select(clientsTable).watch();

  Future<ClientsTableData?> getClientById(String id) {
    return (select(clientsTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertClient(ClientsTableCompanion client) {
    return into(clientsTable).insert(client);
  }

  Future<bool> updateClient(ClientsTableCompanion client) {
    return update(clientsTable).replace(client);
  }

  Future<int> deleteClient(String id) {
    return (delete(clientsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<ClientsTableData>> getPendingClients() {
    return (select(clientsTable)..where((t) => t.syncStatus.equals('pending'))).get();
  }

  Stream<List<ClientsTableData>> watchPendingClients() {
    return (select(clientsTable)..where((t) => t.syncStatus.equals('pending'))).watch();
  }

  Future<List<CreditApplicationsTableData>> getAllCreditApplications() {
    return select(creditApplicationsTable).get();
  }

  Stream<List<CreditApplicationsTableData>> watchAllCreditApplications() {
    return select(creditApplicationsTable).watch();
  }

  Future<List<CreditApplicationsTableData>> getCreditApplicationsByClientId(String clientId) {
    return (select(creditApplicationsTable)..where((t) => t.clientId.equals(clientId))).get();
  }

  Future<CreditApplicationsTableData?> getCreditApplicationById(String id) {
    return (select(creditApplicationsTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertCreditApplication(CreditApplicationsTableCompanion application) {
    return into(creditApplicationsTable).insert(application);
  }

  Future<bool> updateCreditApplication(CreditApplicationsTableCompanion application) {
    return update(creditApplicationsTable).replace(application);
  }

  Future<int> deleteCreditApplication(String id) {
    return (delete(creditApplicationsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<CreditApplicationsTableData>> getPendingCreditApplications() {
    return (select(creditApplicationsTable)..where((t) => t.syncStatus.equals('pending'))).get();
  }

  Stream<List<CreditApplicationsTableData>> watchPendingCreditApplications() {
    return (select(creditApplicationsTable)..where((t) => t.syncStatus.equals('pending'))).watch();
  }

  Future<int> insertSyncLog(SyncLogTableCompanion logEntry) {
    return into(syncLogTable).insert(logEntry);
  }

  Future<List<SyncLogTableData>> getPendingSyncLogs() {
    return (select(syncLogTable)..where((t) => t.status.equals('pending'))).get();
  }

  Future<int> updateSyncLogStatus(int id, String status, {String? errorMessage}) async {
    return (update(syncLogTable)..where((t) => t.id.equals(id))).write(
      SyncLogTableCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        processedAt: Value(status == 'completed' || status == 'failed' ? DateTime.now() : null),
      ),
    );
  }

  Future<void> updateClientsSyncStatus(List<String> ids, String status) async {
    await (update(clientsTable)..where((t) => t.id.isIn(ids))).write(
      ClientsTableCompanion(
        syncStatus: Value(status),
        syncedAt: Value(status == 'synced' ? DateTime.now() : null),
      ),
    );
  }

  Future<void> updateCreditApplicationsSyncStatus(List<String> ids, String status) async {
    await (update(creditApplicationsTable)..where((t) => t.id.isIn(ids))).write(
      CreditApplicationsTableCompanion(
        syncStatus: Value(status),
        syncedAt: Value(status == 'synced' ? DateTime.now() : null),
      ),
    );
  }

  Future<void> deleteAllClients() async {
    final clients = await getAllClients();
    for (final client in clients) {
      await deleteClient(client.id);
    }
  }

  Future<void> deleteAllCreditApplications() async {
    final apps = await getAllCreditApplications();
    for (final app in apps) {
      await deleteCreditApplication(app.id);
    }
  }

  Future<void> deleteSyncLog(int id) async {
    await (delete(syncLogTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> close() async {
    await database.close();
    _instance = null;
  }
}

```
