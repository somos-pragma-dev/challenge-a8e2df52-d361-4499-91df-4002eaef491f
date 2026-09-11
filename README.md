# Implementación de una arquitectura offline-first en una aplicación de campo

La aplicación de campo de una compañía de logística necesita funcionar sin conexión a internet para que los trabajadores puedan continuar sus tareas en áreas remotas. La arquitectura debe permitir la sincronización de datos cuando la conexión se restablezca, manejando conflictos y asegurando la consistencia de la información.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | Arquitectura offline-first en Flutter |
| **Nivel** | junior-l3 |
| **Tipo** | practical |
| **Tiempo estimado** | 2 semanas |

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

### Fase 1: Diseño de la arquitectura offline-first

**Objetivo:** Definir la estructura de la aplicación que permita el funcionamiento sin conexión y la sincronización de datos al recuperar la conexión.

**Tiempo estimado:** 3 días

**Instrucciones:**

- Identificar los componentes clave de la arquitectura (almacenamiento local, sincronización de datos, manejo de conflictos).
- Establecer criterios de aceptación para la fase de diseño.

**Entregable:** Diagrama de la arquitectura propuesta y documento de diseño detallado.

<details>
<summary>Pistas de conocimiento</summary>

- Considerar patrones de arquitectura comunes para aplicaciones offline-first.
- Evaluar diferentes estrategias para el manejo de conflictos de datos.

</details>

### Fase 2: Implementación del almacenamiento local

**Objetivo:** Implementar el almacenamiento local de datos para permitir el funcionamiento de la aplicación sin conexión.

**Tiempo estimado:** 5 días

**Instrucciones:**

- Seleccionar una solución de almacenamiento local adecuada para Flutter.
- Implementar la persistencia de datos críticos para el funcionamiento offline de la aplicación.
- Establecer criterios de aceptación para la implementación del almacenamiento local.

**Entregable:** Código fuente que implementa el almacenamiento local de datos.

<details>
<summary>Pistas de conocimiento</summary>

- Investigar y seleccionar una solución de almacenamiento local que se integre bien con Flutter.
- Considerar la eficiencia y el rendimiento del almacenamiento local.

</details>

### Fase 3: Implementación de la sincronización de datos

**Objetivo:** Implementar la sincronización de datos entre el almacenamiento local y el servidor cuando la conexión se restablezca.

**Tiempo estimado:** 5 días

**Instrucciones:**

- Diseñar y implementar un mecanismo de sincronización de datos.
- Manejar conflictos de datos durante la sincronización.
- Establecer criterios de aceptación para la implementación de la sincronización de datos.

**Entregable:** Código fuente que implementa la sincronización de datos.

<details>
<summary>Pistas de conocimiento</summary>

- Investigar y seleccionar un mecanismo de sincronización de datos adecuado para Flutter.
- Considerar diferentes estrategias para el manejo de conflictos de datos durante la sincronización.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es una arquitectura offline-first y por qué es importante para una aplicación de campo?
- **paraQueSirve**: ¿Para qué sirve el almacenamiento local en una arquitectura offline-first?
- **comoSeUsa**: ¿Cómo se usa un mecanismo de sincronización de datos en una arquitectura offline-first?
- **erroresComunes**: ¿Cuáles son los errores comunes al implementar una arquitectura offline-first y cómo se pueden evitar?
- **queDecisionesImplica**: ¿Qué decisiones implica el diseño de una arquitectura offline-first para una aplicación de campo?

## Criterios de Evaluacion

- Definición clara de la arquitectura offline-first.
- Implementación efectiva del almacenamiento local de datos.
- Implementación efectiva de la sincronización de datos.
- Manejo adecuado de conflictos de datos durante la sincronización.

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
