#!/bin/bash

# Script para reemplazar todos los usos de withOpacity con withValues

cd /home/node/.openclaw/workspace/antigravity_app

# Buscar y reemplazar .withOpacity(X) con .withValues(alpha: X)
find lib -name "*.dart" -exec sed -i 's/\.withOpacity(\([^)]*\))/\.withValues(alpha: \1)/g' {} +

echo "Reemplazo de withOpacity completado"