# AGENTS.md

Instrucciones para el agente de IA que abra este repositorio (Claude Code, Cursor, Codex, Copilot, Gemini). Se cargan solas: no hay que pegar nada en ningun chat.

## Que es este repositorio

Es el codigo base de un reto de aprendizaje de Pragma: **Implementación de una arquitectura offline-first en una aplicación de campo**.

| | |
|---|---|
| Tema | Arquitectura offline-first en Flutter |
| Nivel | junior-l3 |
| Chapter | Móvil |
| Especialidad | Flutter |
| Stack | Dart 3.6 / Flutter 3.27 |
| Patron arquitectonico | clean_architecture_mvvm |
| Tiempo estimado | 2 semanas |

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

- **Fase 1 — Diseño de la arquitectura offline-first**: Diagrama de la arquitectura propuesta y documento de diseño detallado.
- **Fase 2 — Implementación del almacenamiento local**: Código fuente que implementa el almacenamiento local de datos.
- **Fase 3 — Implementación de la sincronización de datos**: Código fuente que implementa la sincronización de datos.

Distincion operativa:

- **Arreglar** (si): import faltante, tipo que no existe, dependencia sin declarar, error de sintaxis, archivo referenciado que no existe.
- **No tocar** (no): logica de negocio incompleta, validaciones ausentes, secretos hardcodeados, APIs deprecadas que funcionan, concurrencia insegura, patrones mejorables. Eso es lo que la persona tiene que encontrar.

## Lo que falta y tenes que completar

### 1. Boilerplate del stack (1)

Sin esto el proyecto no compila ni arranca. **Es tu trabajo crearlo**, y no toca nada de lo pedagogico: es andamiaje del stack.

- [ ] **android/app/src/main/AndroidManifest.xml** — Sin el manifest embebido de Android, flutter build/run no tiene target de plataforma y no puede empaquetar el APK.

### 2. Archivos que la arquitectura declara (1 de 36)

La propuesta arquitectonica del reto los lista y no llegaron al repo. Crealos con implementacion real, respetando la capa en la que viven:

- [ ] `lib/presentation/widgets/task_card.dart`

### 3. Referencias colgando (14)

Salieron de un analisis estatico del codigo que SI esta en el repo. Cada una rompe la compilacion:

- [ ] `lib/domain/usecases/sync_tasks.dart` — `SyncRepository.recordSyncOperation`
      Se invoca `recordSyncOperation` sobre `SyncRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/sync_tasks.dart` — `TaskRepository.syncTask`
      Se invoca `syncTask` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/sync_tasks.dart` — `TaskRepository.markTaskAsConflict`
      Se invoca `markTaskAsConflict` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/sync_tasks.dart` — `TaskRepository.resolveConflict`
      Se invoca `resolveConflict` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/resolve_conflict.dart` — `TaskRepository.updateTask`
      Se invoca `updateTask` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/resolve_conflict.dart` — `TaskRepository.getServerTaskById`
      Se invoca `getServerTaskById` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/domain/usecases/resolve_conflict.dart` — `TaskRepository.getConflictingTasks`
      Se invoca `getConflictingTasks` sobre `TaskRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.cacheTasks`
      Se invoca `cacheTasks` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.getTasks`
      Se invoca `getTasks` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.cacheTask`
      Se invoca `cacheTask` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.getPendingTasks`
      Se invoca `getPendingTasks` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.searchTasks`
      Se invoca `searchTasks` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.getTasksByStatus`
      Se invoca `getTasksByStatus` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/data/repositories/task_repository_impl.dart` — `TaskLocalDataSource.getTasksByPriority`
      Se invoca `getTasksByPriority` sobre `TaskLocalDataSource`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.

### Presentes (35)

- `pubspec.yaml`
- `lib/main.dart`
- `lib/core/constants/app_constants.dart`
- `lib/core/errors/failures.dart`
- `lib/core/errors/exceptions.dart`
- `lib/core/network/network_info.dart`
- `lib/core/utils/date_utils.dart`
- `lib/domain/entities/task_entity.dart`
- `lib/domain/entities/sync_status_entity.dart`
- `lib/domain/repositories/task_repository.dart`
- `lib/domain/repositories/sync_repository.dart`
- `lib/domain/usecases/get_local_tasks.dart`
- `lib/domain/usecases/save_task_local.dart`
- `lib/domain/usecases/sync_tasks.dart`
- `lib/domain/usecases/resolve_conflict.dart`
- `lib/data/models/task_model.dart`
- `lib/data/models/sync_status_model.dart`
- `lib/data/datasources/local/task_local_datasource.dart`
- `lib/data/datasources/local/database_helper.dart`
- `lib/data/datasources/remote/task_remote_datasource.dart`
- `lib/data/repositories/task_repository_impl.dart`
- `lib/data/repositories/sync_repository_impl.dart`
- `lib/presentation/bloc/task/task_event.dart`
- `lib/presentation/bloc/task/task_state.dart`
- `lib/presentation/bloc/task/task_bloc.dart`
- `lib/presentation/bloc/sync/sync_event.dart`
- `lib/presentation/bloc/sync/sync_state.dart`
- `lib/presentation/bloc/sync/sync_bloc.dart`
- `lib/presentation/pages/home_page.dart`
- `lib/presentation/pages/task_list_page.dart`
- `lib/presentation/pages/task_detail_page.dart`
- `lib/presentation/widgets/sync_indicator.dart`
- `lib/presentation/widgets/offline_banner.dart`
- `docs/arquitectura_offline_first.md`
- `docs/diagrama_arquitectura.drawio`

### Capas del patron declarado

Cada una tiene que existir como directorio real con al menos un archivo. Codigo plano en la raiz no satisface el patron.

- `lib/core`
- `lib/core/constants`
- `lib/core/errors`
- `lib/core/network`
- `lib/core/utils`
- `lib/data/datasources/local`
- `lib/data/datasources/remote`
- `lib/data/models`
- `lib/data/repositories`
- `lib/domain/entities`
- `lib/domain/repositories`
- `lib/domain/usecases`
- `lib/presentation/bloc`
- `lib/presentation/pages`
- `lib/presentation/widgets`
- `docs`

## Verificacion

```bash
flutter pub get && flutter analyze
```

Ese comando pasando es la definicion de "terminado" para vos.

## Convenciones que tenes que respetar

- Un solo ecosistema: no declares librerias de otro lenguaje ni mezcles gestores de paquetes.
- Toda libreria que uses tiene que estar declarada en el manifiesto de dependencias.
- Todo import declarado tiene que usarse; todo tipo usado tiene que existir o venir de una dependencia declarada.
- El patron es **clean_architecture_mvvm**: los contratos (interfaces, puertos) los define la capa interna y los implementa la externa, nunca al revés.
- Los archivos que crees llevan implementacion real, no stubs: sin `TODO`, sin cuerpos vacios, sin `// getters y setters`.

## Contexto del candidato

Sirve para calibrar el nivel del codigo, no para resolver las fases.

- Perfil: Chapter Movil, Especialidad Desarrollador, Tecnología Flutter, Semi Senior
- Brecha que el reto ataca: Mezcla logica de negocio con widgets
- Mision: Liderar la app de campo offline-first

---

*Generado por Challenge Generator — Pragma. `README.md` tiene el enunciado completo del reto para la persona. `PROMPT_MEJORA.md` es la variante para pegar en un chat, si se prefiere ese flujo.*
