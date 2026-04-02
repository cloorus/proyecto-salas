# Mandamientos de Diseño e Implementación - BGnius VITA

Estos son los principios ("Mandamientos") que deben guiar la creación de interfaces y componentes en BGnius VITA.

1. Consistencia visual: usa componentes desde `lib/shared/widgets/index.dart` siempre que sea posible.
2. Espaciado y ritmo: usa valores base (8/12/16) para márgenes y padding; inputs separados 12–16px.
3. Tipografía móvil: título principal 24sp; inputs/labels 14–16sp; botones 16sp.
4. Touch targets: botones y controles interactivos >= 48dp (mejor 50–56dp).
5. Accesibilidad: no fuerces `textScaleFactor` a 1.0; permite hasta 1.15 como máximo.
6. Semántica: añade `semanticsLabel` y `tooltip` donde tenga sentido (botones, iconos importantes).
7. Formularios: siempre usar `Form` + validators; mostrar mensajes de error debajo de cada campo.
8. Reutilización: los estilos (colores, radios, sombras) provienen de `lib/core/theme/*`.
9. Performance: optimizar assets (SVG/PNG) y evitar sombras pesadas en listas largas.
10. Testing: cada componente nuevo debe tener una historia o test mínimo (puede ser manual al principio).

Usa este documento como checklist antes de crear nuevas pantallas o componentes.
