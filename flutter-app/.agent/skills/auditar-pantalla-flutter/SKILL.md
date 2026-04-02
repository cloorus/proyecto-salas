---
name: auditar-pantalla-flutter
description: Audita una pantalla de Flutter con RÚBRICA ESTRICTA y métricas objetivas. Evalúa diseño, UX, i18n y arquitectura.
---

# Skill: Auditoría Estricta de Pantalla Flutter

## Objetivo
Generar un análisis **objetivo, cuantitativo y crítico** de una pantalla. Eliminar la subjetividad mediante un sistema de puntos negativos y métricas duras.

## Workflow

### 1. Preparación
- Identificar funcionalidad principal.
- Ubicar archivo principal y widgets hijos directos.
- Verificar existencia de tests (`_test.dart`).

### 2. Ejecución de Rúbrica (Sistema de Puntos)

Cada categoría inicia con **10.0 puntos**. Se restan puntos por cada hallazgo negativo.
**Nota mínima aceptable: 8.0/10**.

#### A) Internacionalización (i18n) [Base: 10.0]
*   **-0.5** por cada string visible hardcodeado (títulos, botones, labels).
*   **-0.5** por concatenación manual de strings (`"Hola $name"`) en lugar de parámetros i18n.
*   **-2.0** si no se usa `AppLocalizations` (o `l10n`).
*   **-1.0** si hay fechas/monedas sin formatear localmente.

#### B) Arquitectura y Clean Code [Base: 10.0]
*   **-2.0** Lógica de negocio en el widget (llamadas a APIs, cálculos complejos en `build`).
*   **-2.0** Simulación de backend (`Future.delayed`) en código "final".
*   **-1.0** Método `build()` con más de 50 líneas (debe dividirse en widgets).
*   **-1.0** Widgets anidados a más de 5 niveles de profundidad (Tree Hell).
*   **-1.0** Instanciación directa de dependencias (no usar Inyección de Dependencias/Riverpod).

#### C) Diseño y Componentes [Base: 10.0]
*   **-1.0** Estilos de texto inline (`TextStyle(...)`) en lugar de `Theme` o `AppTextStyles`.
*   **-1.0** Colores hardcodeados (`Colors.red`) en lugar de `AppColors`.
*   **-1.0** Componentes UI duplicados que podrían ser un Widget reutilizable.
*   **-0.5** Ausencia de `SafeArea` o manejo de bordes de pantalla.

#### D) UX y Validaciones [Base: 10.0]
*   **-2.0** Bloqueo de UI sin indicador de carga (spinner/skeleton).
*   **-1.0** Formularios sin validación de input (vacíos, formatos incorrectos).
*   **-1.0** Falta de feedback ante errores (no muestra Snackbar/Dialog).
*   **-0.5** Teclado no se oculta al tocar fuera o enviar formulario.

#### E) Testing [Base: 10.0]
*   **-10.0** No existe archivo de test asociado (`screen_test.dart`).
*   **-5.0** Existe archivo pero está vacío o comentado.
*   **-2.0** Hay tests pero no cubren "Happy Path".

### 3. Recolección de Métricas Objetivas

Reportar obligatoriamente:
1.  **Líneas de Código (LOC):** Total del archivo principal.
2.  **Complejidad Ciclomática (Estimada):** Cantidad de `if/else`, `switch`, `loops`. (>10 es alerta).
3.  **Estado de i18n:** % de strings traducidos.
4.  **Cobertura de Tests:** Si/No.

---

## Output (Formato Obligatorio)

### Archivo: `audit_<nombre_pantalla>_strict.md`

```markdown
# 🛡️ Auditoría Estricta: <NombrePantalla>

**Fecha:** <YYYY-MM-DD>
**Archivo:** `<path>`

## 💯 Scorecard

| Categoría | Puntaje | Estado |
|-----------|:-------:|--------|
| **i18n** | **X.X** | 🟢/🟡/🔴 |
| **Arquitectura** | **X.X** | 🟢/🟡/🔴 |
| **Diseño** | **X.X** | 🟢/🟡/🔴 |
| **UX** | **X.X** | 🟢/🟡/🔴 |
| **Testing** | **X.X** | 🟢/🟡/🔴 |

**SCORE GLOBAL:** X.X / 10

---

## 📉 Desglose de Penalizaciones

### A) i18n (X.X/10)
- [ ] **-0.5**: String harcodeado línea 45: `'Texto ejemplo'`
- [ ] ...

### B) Arquitectura (X.X/10)
- [ ] **-2.0**: Uso de `Future.delayed` para simular carga.
- [ ] ...

### E) Testing (X.X/10)
- [ ] **-10.0**: No se encontraron tests unitarios ni de widget.

---

## 📊 Métricas

- **Líneas de Código:** XXX
- **Método build() más largo:** XX líneas
- **Nivel de anidamiento máx:** X

---

## 🚀 Plan de Acción (Mandatory Fixes)

Listar solo las acciones para recuperar los puntos perdidos, priorizadas por impacto en el Score.

1. ...
2. ...
```
