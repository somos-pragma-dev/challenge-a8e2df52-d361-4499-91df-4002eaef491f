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