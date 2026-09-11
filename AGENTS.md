# AGENTS.md

Instrucciones para el agente de IA que abra este repositorio (Claude Code, Cursor, Codex, Copilot, Gemini). Se cargan solas: no hay que pegar nada en ningun chat.

## Que es este repositorio

Es el codigo base de un reto de aprendizaje de Pragma: **Implementación de una aplicación offline-first**.

| | |
|---|---|
| Tema | Arquitectura offline-first en Flutter |
| Nivel | semi-senior |
| Chapter | Móvil |
| Especialidad | Flutter |
| Stack | Dart / Flutter 3.27 |
| Patron arquitectonico | clean_architecture |
| Tiempo estimado | 3 semanas |

## Tu tarea

Dejar este proyecto en estado **verificable**: que el comando de verificacion corra sin errores. Escribi los archivos en disco, en este repositorio. No generes ZIPs ni archivos adjuntos.

En orden:

1. Corre `flutter pub get && flutter analyze` y mira que falla.
2. Completa lo que falte de la lista de abajo: manifiesto de dependencias, punto de entrada, capa de interfaz y las capas del patron declarado.
3. Arregla SOLO los errores que impiden compilar o arrancar.
4. Volve a correr `flutter pub get && flutter analyze` hasta que pase.
5. Pará ahí.

## Regla dura: las fases son trabajo del humano

**PROHIBIDO implementar los entregables de las fases.** El valor del reto esta en que la persona los resuelva. Tu trabajo es que tenga un proyecto que arranca; el hueco pedagogico se queda como esta.

No resuelvas nada de esto:

- **Fase 1 — Diseño del modelo de datos offline**: Esquema de la base de datos local y reglas de sincronización definidas.
- **Fase 2 — Implementación de la lógica de sincronización**: Lógica de sincronización implementada y funcional.
- **Fase 3 — Optimización y pruebas de la aplicación offline-first**: Aplicación optimizada y pruebas completadas con reporte de resultados.

Distincion operativa:

- **Arreglar** (si): import faltante, tipo que no existe, dependencia sin declarar, error de sintaxis, archivo referenciado que no existe.
- **No tocar** (no): logica de negocio incompleta, validaciones ausentes, secretos hardcodeados, APIs deprecadas que funcionan, concurrencia insegura, patrones mejorables. Eso es lo que la persona tiene que encontrar.

## Lo que falta y tenes que completar

### 1. Boilerplate del stack (1)

Sin esto el proyecto no compila ni arranca. **Es tu trabajo crearlo**, y no toca nada de lo pedagogico: es andamiaje del stack.

- [ ] **android/app/src/main/AndroidManifest.xml** — Sin el manifest embebido de Android, flutter build/run no tiene target de plataforma y no puede empaquetar el APK.

### 2. Archivos que la arquitectura declara (1 de 36)

La propuesta arquitectonica del reto los lista y no llegaron al repo. Crealos con implementacion real, respetando la capa en la que viven:

- [ ] `lib/sync/services/sync_coordinator.dart`

### 3. Referencias colgando (22)

Salieron de un analisis estatico del codigo que SI esta en el repo. Cada una rompe la compilacion:

- [ ] `lib/domain/usecases/sync_clients.dart` — `ClientRepository.uploadClientToServer`
      Se invoca `uploadClientToServer` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/sync_clients.dart` — `ClientRepository.updateClientSyncStatus`
      Se invoca `updateClientSyncStatus` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/resolve_conflicts.dart` — `ClientRepository.getConflictedClients`
      Se invoca `getConflictedClients` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/resolve_conflicts.dart` — `ClientRepository.getClientFromServer`
      Se invoca `getClientFromServer` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/resolve_conflicts.dart` — `CreditApplicationRepository.getConflictedApplications`
      Se invoca `getConflictedApplications` sobre `CreditApplicationRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/screens/application_form_screen.dart` — `ClientRepository.getAllClients`
      Se invoca `getAllClients` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/screens/application_form_screen.dart` — `CreditApplicationRepository.saveApplication`
      Se invoca `saveApplication` sobre `CreditApplicationRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/viewmodels/client_viewmodel.dart` — `ClientRepository.searchClients`
      Se invoca `searchClients` sobre `ClientRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.syncPendingChanges`
      Se invoca `syncPendingChanges` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.cancelSync`
      Se invoca `cancelSync` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.getPendingItemsCount`
      Se invoca `getPendingItemsCount` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.getConflicts`
      Se invoca `getConflicts` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.getLastSyncTime`
      Se invoca `getLastSyncTime` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.resolveConflict`
      Se invoca `resolveConflict` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.forceSyncAll`
      Se invoca `forceSyncAll` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/viewmodels/sync_viewmodel.dart` — `SyncCoordinator.clearSyncHistory`
      Se invoca `clearSyncHistory` sobre `SyncCoordinator`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `test/unit/sync_test.dart` — `MockAppDatabase.getPendingClients`
      Se invoca `getPendingClients` sobre `MockAppDatabase`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `test/unit/sync_test.dart` — `MockAppDatabase.updateClientsSyncStatus`
      Se invoca `updateClientsSyncStatus` sobre `MockAppDatabase`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `test/unit/sync_test.dart` — `MockAppDatabase.getPendingCreditApplications`
      Se invoca `getPendingCreditApplications` sobre `MockAppDatabase`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `test/unit/sync_test.dart` — `MockAppDatabase.updateCreditApplicationsSyncStatus`
      Se invoca `updateCreditApplicationsSyncStatus` sobre `MockAppDatabase`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `test/unit/sync_test.dart` — `MockConnectivityService.checkConnectivity`
      Se invoca `checkConnectivity` sobre `MockConnectivityService`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `test/unit/sync_test.dart` — `MockConnectivityService.startListening`
      Se invoca `startListening` sobre `MockConnectivityService`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.

### Presentes (39)

- `pubspec.yaml`
- `lib/main.dart`
- `lib/core/config/app_config.dart`
- `lib/core/network/connectivity_service.dart`
- `lib/core/database/app_database.dart`
- `lib/core/error/failures.dart`
- `lib/domain/entities/client.dart`
- `lib/domain/entities/credit_application.dart`
- `lib/domain/entities/sync_status.dart`
- `lib/domain/repositories/client_repository.dart`
- `lib/domain/repositories/credit_application_repository.dart`
- `lib/domain/usecases/save_client.dart`
- `lib/domain/usecases/sync_clients.dart`
- `lib/domain/usecases/resolve_conflicts.dart`
- `lib/data/models/client_model.dart`
- `lib/data/models/credit_application_model.dart`
- `lib/data/datasources/local/client_local_datasource.dart`
- `lib/data/datasources/local/credit_application_local_datasource.dart`
- `lib/data/datasources/remote/client_remote_datasource.dart`
- `lib/data/datasources/remote/credit_application_remote_datasource.dart`
- `lib/data/repositories/client_repository_impl.dart`
- `lib/data/repositories/credit_application_repository_impl.dart`
- `lib/presentation/screens/client_list_screen.dart`
- `lib/presentation/screens/client_form_screen.dart`
- `lib/presentation/screens/application_form_screen.dart`
- `lib/presentation/screens/sync_status_screen.dart`
- `lib/presentation/widgets/client_card.dart`
- `lib/presentation/widgets/sync_indicator.dart`
- `lib/presentation/viewmodels/client_viewmodel.dart`
- `lib/presentation/viewmodels/client_viewmodel_event.dart`
- `lib/presentation/viewmodels/client_viewmodel_state.dart`
- `lib/presentation/viewmodels/sync_viewmodel.dart`
- `lib/presentation/viewmodels/sync_viewmodel_event.dart`
- `lib/presentation/viewmodels/sync_viewmodel_state.dart`
- `lib/sync/services/conflict_resolver.dart`
- `lib/sync/handlers/sync_handler.dart`
- `test/unit/database_test.dart`
- `test/unit/sync_test.dart`
- `test/integration/offline_flow_test.dart`

### Capas del patron declarado

Cada una tiene que existir como directorio real con al menos un archivo. Codigo plano en la raiz no satisface el patron.

- `lib/core`
- `lib/core/config`
- `lib/core/network`
- `lib/core/database`
- `lib/core/error`
- `lib/domain`
- `lib/domain/entities`
- `lib/domain/repositories`
- `lib/domain/usecases`
- `lib/data`
- `lib/data/models`
- `lib/data/datasources/local`
- `lib/data/datasources/remote`
- `lib/data/repositories`
- `lib/presentation`
- `lib/presentation/screens`
- `lib/presentation/widgets`
- `lib/presentation/viewmodels`
- `lib/sync`
- `lib/sync/services`
- `lib/sync/handlers`
- `test/unit`
- `test/integration`

## Verificacion

```bash
flutter pub get && flutter analyze
```

Ese comando pasando es la definicion de "terminado" para vos.

## Convenciones que tenes que respetar

- Un solo ecosistema: no declares librerias de otro lenguaje ni mezcles gestores de paquetes.
- Toda libreria que uses tiene que estar declarada en el manifiesto de dependencias.
- Todo import declarado tiene que usarse; todo tipo usado tiene que existir o venir de una dependencia declarada.
- El patron es **clean_architecture**: los contratos (interfaces, puertos) los define la capa interna y los implementa la externa, nunca al revés.
- Los archivos que crees llevan implementacion real, no stubs: sin `TODO`, sin cuerpos vacios, sin `// getters y setters`.

## Contexto del candidato

Sirve para calibrar el nivel del codigo, no para resolver las fases.

- Perfil: Chapter Movil, Especialidad Desarrollador, Tecnología Flutter, Semi Senior
- Brecha que el reto ataca: Mezcla logica de negocio con widgets
- Mision: Liderar la app de campo offline-first

---

*Generado por Challenge Generator — Pragma. `README.md` tiene el enunciado completo del reto para la persona. `PROMPT_MEJORA.md` es la variante para pegar en un chat, si se prefiere ese flujo.*
