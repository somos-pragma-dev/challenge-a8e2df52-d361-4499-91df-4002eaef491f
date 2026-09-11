# Implementación de una app de campo offline-first

La aplicación de campo debe permitir a los agentes realizar operaciones de manera eficiente tanto en línea como sin conexión. Los agentes deben poder registrar transacciones, consultar datos y sincronizar la información cuando vuelvan a tener conectividad. La aplicación debe manejar la sincronización de datos de manera idempotente para evitar duplicados y mantener la consistencia de la información.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | Arquitectura offline-first en Flutter |
| **Nivel** | senior-l2 |
| **Tipo** | practical |
| **Tiempo estimado** | 40 horas |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Obtener el proyecto base funcional enviando el Código Base a un asistente de IA, que lo analizará, corregirá errores y generará un ZIP listo para usar.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Asegúrate de tener instalado para ejecutar el proyecto: Un IDE o editor de código.
- Copia todo el contenido del campo **Código Base** de este reto — incluyendo el texto de instrucciones que aparece al inicio.
- Abre un asistente de IA (Claude en claude.ai, ChatGPT o Gemini — se recomienda Claude), pega el contenido copiado en el chat y envíalo.
- El asistente analizará los archivos, corregirá errores y generará un archivo ZIP descargable. Descárgalo y extráelo en la carpeta donde quieras trabajar.
- Verifica que el proyecto arranca sin errores.

**Entregable:** El proyecto compila/arranca sin errores.

<details>
<summary>Pistas de conocimiento</summary>

- Copia el Código Base completo incluyendo el texto de instrucciones al inicio — esas instrucciones le indican al asistente exactamente qué hacer con los archivos.
- Si el asistente no genera el ZIP automáticamente al terminar el análisis, escríbele: "genera el ZIP ahora".
- Si el proyecto tiene errores al arrancar, comparte el mensaje de error con el mismo asistente para que lo corrija.

</details>

### Fase 1: Diseño del modelo de datos y persistencia local

**Objetivo:** Definir el modelo de datos y la estrategia de persistencia local para la aplicación.

**Tiempo estimado:** 10 horas

**Instrucciones:**

- Identificar los datos que deben ser almacenados localmente.
- Definir el modelo de datos para las transacciones y consultas.
- Establecer una estrategia para la persistencia local que garantice la idempotencia y la consistencia.

**Entregable:** Modelo de datos y estrategia de persistencia local documentados.

<details>
<summary>Pistas de conocimiento</summary>

- Considerar el uso de un sistema de base de datos local.
- Evaluar diferentes opciones para la persistencia de datos.

</details>

### Fase 2: Implementación de la lógica de negocio y widgets

**Objetivo:** Implementar la lógica de negocio y los widgets necesarios para la interacción del usuario.

**Tiempo estimado:** 15 horas

**Instrucciones:**

- Desarrollar los widgets para la entrada y visualización de datos.
- Implementar la lógica de negocio para el registro y consulta de transacciones.
- Asegurar que la aplicación funcione correctamente tanto en línea como sin conexión.

**Entregable:** Widgets y lógica de negocio implementados y funcionales.

<details>
<summary>Pistas de conocimiento</summary>

- Utilizar patrones de diseño adecuados para la separación de la lógica de negocio y la interfaz de usuario.
- Implementar mecanismos para manejar la conectividad y la sincronización de datos.

</details>

### Fase 3: Sincronización de datos y manejo de conflictos

**Objetivo:** Implementar la sincronización de datos y el manejo de conflictos cuando la aplicación vuelve a tener conectividad.

**Tiempo estimado:** 10 horas

**Instrucciones:**

- Desarrollar la lógica para la sincronización de datos con el servidor.
- Implementar mecanismos para manejar conflictos de datos durante la sincronización.
- Asegurar que la sincronización sea idempotente y no genere duplicados.

**Entregable:** Lógica de sincronización de datos y manejo de conflictos implementados.

<details>
<summary>Pistas de conocimiento</summary>

- Utilizar técnicas de sincronización optimista o pesimista.
- Implementar mecanismos para la resolución de conflictos de datos.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es la arquitectura offline-first y por qué es importante en una aplicación de campo?
- **paraQueSirve**: ¿Para qué sirve la separación de la lógica de negocio y la interfaz de usuario en una aplicación Flutter?
- **comoSeUsa**: ¿Cómo se usa un sistema de base de datos local para la persistencia de datos en una aplicación Flutter?
- **erroresComunes**: ¿Cuáles son los errores comunes al implementar una aplicación offline-first y cómo se pueden evitar?
- **queDecisionesImplica**: ¿Qué decisiones implica la implementación de la sincronización de datos y el manejo de conflictos en una aplicación offline-first?

## Criterios de Evaluacion

- Definición clara del modelo de datos y la estrategia de persistencia local.
- Implementación funcional de los widgets y la lógica de negocio.
- Implementación efectiva de la sincronización de datos y el manejo de conflictos.

## Como trabajar con un asistente de IA

Hay dos caminos, elegi uno:

- **AGENTS.md** (recomendado) — instrucciones nativas del repo. Abri esta carpeta con tu agente local (Claude Code, Cursor, Codex, Copilot, Gemini) y las carga solo. Sabe que archivos faltan y con que comando se verifica, y completa el scaffold escribiendo en disco.
- **PROMPT_MEJORA.md** — para copiar y pegar en un chat (claude.ai, ChatGPT). Devuelve un ZIP con el proyecto. Sirve si no tenes un agente en el IDE.

Ninguno de los dos resuelve las fases del reto: eso es tu trabajo.

## Verificacion

El proyecto esta listo para trabajar cuando este comando corre sin errores:

```bash
flutter pub get && flutter analyze
```

---

*Reto generado automaticamente por Challenge Generator - Pragma*
