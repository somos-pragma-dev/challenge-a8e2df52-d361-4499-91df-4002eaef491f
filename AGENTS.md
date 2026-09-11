# AGENTS.md

Instrucciones para el agente de IA que abra este repositorio (Claude Code, Cursor, Codex, Copilot, Gemini). Se cargan solas: no hay que pegar nada en ningun chat.

## Que es este repositorio

Es el codigo base de un reto de aprendizaje de Pragma: **Implementación de una app de campo offline-first**.

| | |
|---|---|
| Tema | Arquitectura offline-first en Flutter |
| Nivel | senior-l2 |
| Chapter | Móvil |
| Especialidad | Flutter |
| Stack | Dart 3.6 / Flutter 3.27 |
| Patron arquitectonico | clean_architecture |
| Tiempo estimado | 40 horas |

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

- **Fase 1 — Diseño del modelo de datos y persistencia local**: Modelo de datos y estrategia de persistencia local documentados.
- **Fase 2 — Implementación de la lógica de negocio y widgets**: Widgets y lógica de negocio implementados y funcionales.
- **Fase 3 — Sincronización de datos y manejo de conflictos**: Lógica de sincronización de datos y manejo de conflictos implementados.

Distincion operativa:

- **Arreglar** (si): import faltante, tipo que no existe, dependencia sin declarar, error de sintaxis, archivo referenciado que no existe.
- **No tocar** (no): logica de negocio incompleta, validaciones ausentes, secretos hardcodeados, APIs deprecadas que funcionan, concurrencia insegura, patrones mejorables. Eso es lo que la persona tiene que encontrar.

## Lo que falta y tenes que completar

### 1. Boilerplate del stack (1)

Sin esto el proyecto no compila ni arranca. **Es tu trabajo crearlo**, y no toca nada de lo pedagogico: es andamiaje del stack.

- [ ] **android/app/src/main/AndroidManifest.xml** — Sin el manifest embebido de Android, flutter build/run no tiene target de plataforma y no puede empaquetar el APK.

### 2. Archivos que la arquitectura declara (1 de 35)

La propuesta arquitectonica del reto los lista y no llegaron al repo. Crealos con implementacion real, respetando la capa en la que viven:

- [ ] `lib/data/datasources/local/transaction_local_datasource.dart`

### 3. Referencias colgando (4)

Salieron de un analisis estatico del codigo que SI esta en el repo. Cada una rompe la compilacion:

- [ ] `lib/domain/usecases/resolve_conflict.dart` — `TransactionRepository.getById`
      Se invoca `getById` sobre `TransactionRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/data/datasources/remote/transaction_remote_datasource.dart` — `TransactionModel.toServerMap`
      Se invoca `toServerMap` sobre `TransactionModel`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/providers/sync_provider.dart` — `SyncRepository.getSyncHistory`
      Se invoca `getSyncHistory` sobre `SyncRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- [ ] `lib/presentation/providers/sync_provider.dart` — `SyncRepository.getPendingOperationsCount`
      Se invoca `getPendingOperationsCount` sobre `SyncRepository`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.

### Presentes (34)

- `pubspec.yaml`
- `lib/main.dart`
- `lib/core/constants/app_constants.dart`
- `lib/core/errors/failures.dart`
- `lib/core/errors/exceptions.dart`
- `lib/core/network/network_info.dart`
- `lib/core/network/connectivity_service.dart`
- `lib/core/sync/sync_engine.dart`
- `lib/core/sync/conflict_resolver.dart`
- `lib/core/sync/idempotency_manager.dart`
- `lib/domain/entities/base_entity.dart`
- `lib/domain/entities/transaction.dart`
- `lib/domain/entities/sync_record.dart`
- `lib/domain/repositories/transaction_repository.dart`
- `lib/domain/repositories/sync_repository.dart`
- `lib/domain/usecases/create_transaction.dart`
- `lib/domain/usecases/get_pending_transactions.dart`
- `lib/domain/usecases/sync_transactions.dart`
- `lib/domain/usecases/resolve_conflict.dart`
- `lib/data/models/transaction_model.dart`
- `lib/data/models/sync_record_model.dart`
- `lib/data/datasources/local/database_helper.dart`
- `lib/data/datasources/local/sync_local_datasource.dart`
- `lib/data/datasources/remote/transaction_remote_datasource.dart`
- `lib/data/repositories/transaction_repository_impl.dart`
- `lib/data/repositories/sync_repository_impl.dart`
- `lib/presentation/screens/home_screen.dart`
- `lib/presentation/screens/transaction_form_screen.dart`
- `lib/presentation/screens/sync_status_screen.dart`
- `lib/presentation/widgets/transaction_tile.dart`
- `lib/presentation/widgets/connectivity_banner.dart`
- `lib/presentation/widgets/sync_progress_indicator.dart`
- `lib/presentation/providers/transaction_provider.dart`
- `lib/presentation/providers/sync_provider.dart`

### Capas del patron declarado

Cada una tiene que existir como directorio real con al menos un archivo. Codigo plano en la raiz no satisface el patron.

- `lib/core`
- `lib/core/constants`
- `lib/core/errors`
- `lib/core/network`
- `lib/core/sync`
- `lib/domain`
- `lib/domain/entities`
- `lib/domain/repositories`
- `lib/domain/usecases`
- `lib/data`
- `lib/data/datasources/local`
- `lib/data/datasources/remote`
- `lib/data/repositories`
- `lib/data/models`
- `lib/presentation`
- `lib/presentation/screens`
- `lib/presentation/widgets`
- `lib/presentation/providers`

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
