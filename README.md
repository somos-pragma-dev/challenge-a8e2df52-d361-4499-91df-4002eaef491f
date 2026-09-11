# Implementación de una aplicación offline-first

La aplicación de campo de una entidad financiera necesita operar sin conexión a internet de manera eficiente. La app debe sincronizar datos cuando la conexión sea restablecida. Los usuarios del campo (agentes de crédito) deben poder capturar información de clientes y solicitudes de crédito sin depender de la conectividad. La app debe asegurar que los datos capturados offline se envíen al servidor una vez que la conexión esté disponible, manejando conflictos y asegurando la integridad de los datos.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | Arquitectura offline-first en Flutter |
| **Nivel** | semi-senior |
| **Tipo** | practical |
| **Tiempo estimado** | 3 semanas |

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

### Fase 1: Diseño del modelo de datos offline

**Objetivo:** Definir la estructura de datos que permitirá la operación offline y la sincronización posterior.

**Tiempo estimado:** 1 semana

**Instrucciones:**

- Identificar los datos que deben ser almacenados localmente.
- Definir el esquema de la base de datos local.
- Establecer las reglas de sincronización de datos.

**Entregable:** Esquema de la base de datos local y reglas de sincronización definidas.

<details>
<summary>Pistas de conocimiento</summary>

- Considerar la frecuencia de cambios en los datos.
- Evaluar la necesidad de versionado de datos.

</details>

### Fase 2: Implementación de la lógica de sincronización

**Objetivo:** Desarrollar la lógica que permita la sincronización de datos entre la aplicación y el servidor.

**Tiempo estimado:** 1 semana

**Instrucciones:**

- Implementar la captura de datos localmente.
- Crear la lógica para detectar cambios en la conectividad.
- Desarrollar el proceso de sincronización de datos con el servidor.

**Entregable:** Lógica de sincronización implementada y funcional.

<details>
<summary>Pistas de conocimiento</summary>

- Utilizar mecanismos de detención y reintento para manejar la sincronización.
- Implementar un sistema de versionado para resolver conflictos de datos.

</details>

### Fase 3: Optimización y pruebas de la aplicación offline-first

**Objetivo:** Optimizar el rendimiento de la aplicación y realizar pruebas exhaustivas para asegurar su funcionamiento offline y en línea.

**Tiempo estimado:** 1 semana

**Instrucciones:**

- Optimizar la base de datos local para mejorar el rendimiento.
- Realizar pruebas unitarias y de integración para la lógica de sincronización.
- Simular escenarios de conectividad intermitente para probar la robustez de la aplicación.

**Entregable:** Aplicación optimizada y pruebas completadas con reporte de resultados.

<details>
<summary>Pistas de conocimiento</summary>

- Utilizar herramientas de profiling para identificar cuellos de botella.
- Implementar pruebas automáticas para asegurar la calidad del código.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es una arquitectura offline-first y por qué es importante para una aplicación de campo?
- **paraQueSirve**: ¿Cómo se utiliza una arquitectura offline-first para mejorar la experiencia del usuario en una aplicación de campo?
- **comoSeUsa**: ¿Cómo se implementa la sincronización de datos en una arquitectura offline-first?
- **erroresComunes**: ¿Cuáles son los errores comunes al implementar una arquitectura offline-first y cómo se pueden evitar?
- **queDecisionesImplica**: ¿Qué decisiones de diseño implica una arquitectura offline-first y cómo afectan al rendimiento y la usabilidad de la aplicación?

## Criterios de Evaluacion

- Definición clara del modelo de datos offline.
- Implementación funcional de la lógica de sincronización.
- Optimización del rendimiento de la aplicación.
- Pruebas exhaustivas de la aplicación en diferentes escenarios de conectividad.

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
