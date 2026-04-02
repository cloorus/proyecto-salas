# Auditoría - Register Screen

**Pantalla:** Crear Usuario (Register)
**Archivo:** `lib/features/auth/presentation/screens/register_screen.dart`
**Mockup de referencia:** `docs/pantallas/4_crear_usuario.png`
**Fecha:** 2026-02-01

---

## 📊 Resumen Ejecutivo

| Aspecto | Calificación | Comentarios |
|---------|--------------|-------------|
| **Diseño** | 7/10 | Sigue mockup pero usa padding fijo en vez de responsive |
| **Componentes** | 6/10 | Usa `AuthInputField` pero tiene Dropdowns inline duplicados |
| **UX** | 8/10 | Loading states y feedback implementados correctamente |
| **Validaciones** | 8/10 | Usa `Validators` centralizados con i18n |
| **i18n** | 9/10 | Usa `AppLocalizations`, pocos colores hardcodeados |
| **Testing** | 7/10 | Existen tests para UseCase y Notifier |
| **Arquitectura** | 5/10 | ⚠️ **CRÍTICO:** Falta provider con DI |

**Calificación general:** 7.1/10

---

## 🏗️ Análisis Arquitectónico

### Clean Architecture
**Estado:** ⚠️ Parcial

**Estructura de capas:**
- Data Layer: ✅ - `AuthRepositoryImpl`, `AuthRemoteDataSourceMock` implementados
- Domain Layer: ✅ - `RegisterUseCase`, `User` entity, `AuthRepository` interface
- Presentation Layer: ⚠️ - `RegisterNotifier` existe pero **FALTA el provider con DI**

### Patrones de Diseño
**Identificados:**
1. Repository Pattern - ✅ Implementado correctamente
2. Use Case Pattern - ✅ `RegisterUseCase` con `Either<Failure, User>`
3. StateNotifier Pattern - ✅ `RegisterNotifier` con estado inmutable

**Faltantes:**
1. Repository Pattern - ✅
2. Use Case Pattern - ✅
3. **Dependency Injection - ❌ CRÍTICO: Provider NO conectado**

### Principios SOLID
| Principio | Cumplimiento | Observaciones |
|-----------|--------------|---------------|
| SRP | 8/10 | Notifier separado de Screen |
| OCP | 7/10 | UseCase extensible |
| LSP | 8/10 | Interfaces respetadas |
| ISP | 7/10 | AuthRepository tiene métodos específicos |
| DIP | 4/10 | ❌ Screen depende de provider inexistente |

### Testabilidad
- Acoplamiento: **Alto** (provider no inyectado)
- Inyección de dependencias: **No** (falta `registerNotifierProvider`)
- Mockeable: **Parcial** (UseCase sí, Notifier no conectado)

**Calificación Arquitectónica:** 5.5/10

---

## ✅ Puntos Fuertes

### 1. Internacionalización Completa
- ✅ Todos los textos usan `AppLocalizations.of(context)!`
- ✅ Mensajes de error localizados
- ✅ Labels y hints desde `l10n`

### 2. Uso de Componentes Compartidos
- ✅ `AuthInputField` reutilizado para todos los campos de texto
- ✅ `SnackbarHelper` para feedback

### 3. Manejo de Estado
- ✅ `ref.watch()` y `ref.read()` correctamente usados
- ✅ `ref.listen()` para errores con auto-clear
- ✅ Estados `isLoading` deshabilitan inputs

### 4. Validaciones
- ✅ `Form` + `GlobalKey<FormState>`
- ✅ Validators centralizados con context para i18n
- ✅ Validación de passwords match en `_handleRegister()`

---

## ⚠️ Áreas de Mejora

### 1. FALTA `registerNotifierProvider` - 🔴 ALTA PRIORIDAD

**Problema:** El archivo `register_provider.dart` define `RegisterNotifier` y `RegisterState` pero **NO** define el provider. La pantalla usa `registerNotifierProvider` (líneas 66, 67, 98, 99, 102) que no existe.

**Código actual (`register_provider.dart` líneas 31-83):**
```dart
class RegisterNotifier extends StateNotifier<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterNotifier(this.registerUseCase) : super(const RegisterState());
  // ... métodos
}
// ❌ TERMINA AQUÍ - FALTA EL PROVIDER
```

**Recomendación:** Agregar al final de `register_provider.dart`:
```dart
/// Provider del register state (CON DEPENDENCY INJECTION)
final registerNotifierProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(
    ref.read(registerUseCaseProvider), // ✅ Inyección de dependencia
  );
});
```

---

### 2. Dropdowns Inline Duplicados - 🟡 MEDIA PRIORIDAD

**Problema:** Los dropdowns de País, Idioma y Prefijo telefónico tienen código duplicado (líneas 182-289, 324-380).

**Código actual (líneas 182-233 para País):**
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      l10n.registerCountryLabel,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF333333), // ❌ Hardcoded
      ),
    ),
    const SizedBox(height: 8),
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)), // ❌ Hardcoded
        // ... más código duplicado
      ),
      // ... DropdownButton repetido 3 veces
    ),
  ],
),
```

**Recomendación:** Crear componente `AuthDropdownField`:
```dart
class AuthDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  // ...
}
```

---

### 3. Colores Hardcodeados - 🟡 MEDIA PRIORIDAD

**Problema:** Varios colores no usan `AppColors` (líneas 128, 131, 155, 191, 197, 251, 264, etc.)

**Código actual:**
```dart
color: const Color(0xFF333333),  // Debería ser AppColors.textPrimary
color: const Color(0xFFE0E0E0),  // Debería ser AppColors.inputBorder
color: const Color(0xFF999999),  // Debería ser AppColors.textHint
color: const Color(0xFF673AB7),  // Debería ser AppColors.primaryPurple
color: const Color(0xFF0A3057),  // Debería ser AppColors.primaryDark
```

---

### 4. Layout No Responsivo - 🟡 MEDIA PRIORIDAD

**Problema:** Usa padding fijo (`horizontal: 20, vertical: 16`) en lugar del patrón responsive de Login.

**Código actual (línea 114):**
```dart
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
```

**Recomendación:** Usar `LayoutBuilder` como en `login_screen.dart`:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    final screenWidth = constraints.maxWidth;
    final contentWidth = screenWidth > 700 ? 850.0 : screenWidth * 0.90;
    final horizontalPadding = (screenWidth - contentWidth) / 2;
    // ...
  },
)
```

---

### 5. Checkbox Inline - 🟢 BAJA PRIORIDAD

**Problema:** El checkbox de términos (líneas 402-431) no usa `LabeledCheckbox` como Login.

**Código actual:**
```dart
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(/* ... */),
  child: GestureDetector(
    onTap: /* ... */,
    child: Row(
      children: [
        Checkbox(/* ... */),
        Expanded(child: Text(/* ... */)),
      ],
    ),
  ),
),
```

**Recomendación:** Usar o extender `LabeledCheckbox` del sistema de componentes.

---

## 🧪 Casos de Uso

### Caso 1: Registro Exitoso
**Flujo:**
1. Usuario llena todos los campos
2. Acepta términos y condiciones
3. Presiona "Vincular Usuario"
4. Sistema valida formulario
5. Muestra loading
6. Llama a `RegisterUseCase`
7. Muestra snackbar de éxito
8. Navega a `/`

**Estado:** ⚠️ (Depende de que el provider esté conectado)

### Caso 2: Validación de Passwords
**Flujo:**
1. Usuario ingresa contraseñas diferentes
2. Presiona "Vincular Usuario"
3. Sistema muestra error "Las contraseñas no coinciden"

**Estado:** ✅

### Caso 3: Sin Aceptar Términos
**Flujo:**
1. Usuario llena campos sin marcar checkbox
2. Presiona botón
3. Sistema muestra error

**Estado:** ✅

---

## 📝 Mensajes y Validaciones

### Mensajes de la Pantalla
| Línea | Texto | Tipo | i18n |
|-------|-------|------|------|
| 126 | `l10n.registerTitle` | Título | ✅ |
| 147 | `l10n.registerNameLabel` | Label | ✅ |
| 148 | `l10n.registerNameHint` | Hint | ✅ |
| 158 | `l10n.registerEmailLabel` | Label | ✅ |
| 159 | `l10n.registerEmailHint` | Hint | ✅ |
| 170 | `l10n.registerAddressLabel` | Label | ✅ |
| 171 | `l10n.registerAddressHint` | Hint | ✅ |
| 186 | `l10n.registerCountryLabel` | Label | ✅ |
| 207 | `l10n.registerCountryHint` | Hint | ✅ |
| 240 | `l10n.registerLanguageLabel` | Label | ✅ |
| 261 | `l10n.registerLanguageHint` | Hint | ✅ |
| 295 | `l10n.registerPasswordLabel` | Label | ✅ |
| 296 | `l10n.registerPasswordHint` | Hint | ✅ |
| 310 | `l10n.registerConfirmPasswordLabel` | Label | ✅ |
| 311 | `l10n.registerConfirmPasswordHint` | Hint | ✅ |
| 333 | `l10n.registerPhonePrefixLabel` | Label | ✅ |
| 354 | `'+57'` | Hint | ❌ Hardcoded |
| 388 | `l10n.registerPhoneLabel` | Label | ✅ |
| 389 | `l10n.registerPhoneHint` | Hint | ✅ |
| 420 | `l10n.registerAcceptTerms` | Label | ✅ |
| 460 | `l10n.registerButton` | Botón | ✅ |
| 477 | `l10n.registerAlreadyHaveAccount` | Texto | ✅ |
| 485 | `l10n.registerLoginLink` | Link | ✅ |

---

## 🎯 Recomendaciones Priorizadas

### Alta Prioridad 🔴
1. **Agregar `registerNotifierProvider`** - Sin esto, la pantalla NO compila
2. **Importar provider en `auth_providers.dart`** - Centralizar DI

### Media Prioridad 🟡
3. **Crear `AuthDropdownField`** - Eliminar duplicación de código (3 instancias)
4. **Reemplazar colores hardcodeados** - Usar `AppColors` consistentemente
5. **Implementar layout responsivo** - Seguir patrón de `login_screen.dart`

### Baja Prioridad 🟢
6. **Usar `LabeledCheckbox`** - Consistencia con Login
7. **Agregar `semanticsLabel`** - Accesibilidad
8. **Extraer hint `'+57'` a i18n** - Completar internacionalización

---

## 📦 Componentes a Crear

### 1. AuthDropdownField
**Ubicación:** `lib/shared/widgets/auth_dropdown_field.dart`

**Props:**
```dart
class AuthDropdownField<T> extends StatelessWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final double? labelFontSize;

  const AuthDropdownField({
    super.key,
    this.label,
    required this.hint,
    this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
    this.enabled = true,
    this.labelFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.montserrat(
              fontSize: labelFontSize ?? 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.circular(12),
            color: enabled ? Colors.white : Colors.grey.shade100,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  hint,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: AppColors.textHint,
                  ),
                ),
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      itemLabel(item),
                      style: GoogleFonts.montserrat(fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 📊 Métricas de Código

```
Líneas totales:     508
Líneas de UI:       ~400 (79%)
Componentes inline: 4 (3 dropdowns + 1 checkbox)
Strings hardcodeados: 1 ('+57')
Colores hardcodeados: 12
```

**Deuda técnica estimada:** 3-4 horas

---

## ✅ Checklist de Implementación

### Inmediata
- [ ] Agregar `registerNotifierProvider` en `register_provider.dart`
- [ ] Exportar provider en `auth_providers.dart` o importar correctamente

### Corto Plazo (1 semana)
- [ ] Crear componente `AuthDropdownField`
- [ ] Reemplazar dropdowns inline con el nuevo componente
- [ ] Migrar colores hardcodeados a `AppColors`

### Mediano Plazo (2-4 semanas)
- [ ] Implementar layout responsivo con `LayoutBuilder`
- [ ] Migrar checkbox a `LabeledCheckbox`
- [ ] Agregar tests de widget

---

## 📸 Comparación con Mockup

**Mockup:** `docs/pantallas/4_crear_usuario.png`

### Elementos Correctos ✅
- Título "Crear Usuario" con logo
- Campos: Nombre, Correo, Dirección, País, Idioma, Contraseña, Repetir, Prefijo+Teléfono
- Checkbox "Declaración de conformidad"
- Botón "Vincular Usuario"

### Diferencias Menores ⚠️
- Mockup muestra campos más simples (sin sombras neumórficas)
- Mockup no muestra el link "Ya tienes cuenta? Inicia Sesión"
- Espaciado ligeramente diferente

**Fidelidad al diseño:** 85%

---

## 🎓 Conclusión

La pantalla de Register tiene una buena base con i18n completa y uso de componentes compartidos (`AuthInputField`). Sin embargo, presenta un **problema crítico**: el `registerNotifierProvider` no está definido, lo cual impide la compilación y rompe la arquitectura Clean.

Las prioridades son claras: primero conectar el provider con inyección de dependencias siguiendo el patrón de `login_provider.dart`, y luego refactorizar los dropdowns duplicados en un componente reutilizable.

**Prioridad de refactoring:** Alta

**Tiempo estimado de mejora:** 3-4 horas

**Riesgo actual:** Alto (no compila sin el provider)
