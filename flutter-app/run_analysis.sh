#!/bin/bash

# Script de análisis completo para BGnius VITA
cd /home/node/.openclaw/workspace/antigravity_app

echo "=== INICIANDO ANÁLISIS COMPLETO DE BGNIUS VITA ==="
echo ""

# 1. Verificar que Dart esté disponible
echo "1. Verificando Dart..."
if command -v dart &> /dev/null; then
    dart --version
else
    echo "⚠️ Dart no está disponible"
fi
echo ""

# 2. Limpiar archivos de build anteriores
echo "2. Limpiando archivos de build anteriores..."
rm -rf build/
echo "✅ Build limpiado"
echo ""

# 3. Obtener dependencias
echo "3. Obteniendo dependencias..."
if command -v dart &> /dev/null; then
    dart pub get 2>&1 | head -10
    echo "✅ Dependencias obtenidas"
else
    echo "⚠️ No se pueden obtener dependencias sin Dart"
fi
echo ""

# 4. Análisis estático
echo "4. Ejecutando análisis estático..."
if command -v dart &> /dev/null; then
    dart analyze lib/ 2>&1 | head -20
    echo "✅ Análisis estático completado"
else
    echo "⚠️ No se puede ejecutar análisis sin Dart"
fi
echo ""

# 5. Verificar estructura de archivos críticos
echo "5. Verificando estructura de archivos críticos..."
echo "📁 Archivos Dart en lib/: $(find lib -name "*.dart" | wc -l)"
echo "📁 Pantallas encontradas: $(find lib -name "*_screen.dart" | wc -l)"
echo "📁 Widgets compartidos: $(find lib/shared/widgets -name "*.dart" | wc -l)"
echo "📁 Archivos de tema: $(find lib/core/theme -name "*.dart" | wc -l)"
echo ""

# 6. Verificar imports problemáticos
echo "6. Buscando imports problemáticos..."
echo "🔍 Usos de withOpacity restantes: $(grep -r "\.withOpacity(" lib --include="*.dart" 2>/dev/null | wc -l)"
echo "🔍 Usos de textScaleFactor restantes: $(grep -r "textScaleFactor" lib --include="*.dart" 2>/dev/null | wc -l)"
echo ""

# 7. Verificar pantallas principales
echo "7. Verificando pantallas principales..."
screens=(
    "LoginScreen"
    "RegisterScreen" 
    "ForgotPasswordScreen"
    "DevicesListScreen"
    "DeviceControlScreen"
    "AddDeviceScreen"
    "DeviceEditScreen"
    "DeviceInfoScreen"
    "DeviceParametersScreen"
    "UsersScreen"
    "RegisteredUsersScreen"
    "UserRolesScreen"
    "LinkDeviceUserScreen"
    "GroupsScreen"
    "TechnicalContactScreen"
    "EventLogScreen"
    "SettingsScreen"
)

for screen in "${screens[@]}"; do
    if grep -r "class $screen" lib/ >/dev/null 2>&1; then
        echo "✅ $screen"
    else
        echo "❌ $screen"
    fi
done
echo ""

echo "=== ANÁLISIS COMPLETADO ==="