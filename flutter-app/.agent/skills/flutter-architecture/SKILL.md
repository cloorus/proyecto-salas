---
name: flutter-architecture
description: Clean Architecture patterns for Flutter. Emphasizes separation of concerns, repository pattern, use cases, and layer-based structure.
triggers:
  - architecture
  - clean architecture
  - repository
  - use case
  - layers
role: architect
scope: design
---

# Flutter Architecture

Guidelines for implementing Clean Architecture in Flutter projects.

## Layers

1. **Domain Layer**: Entities, Use Cases, Repository Interfaces. No external dependencies.
2. **Data Layer**: Repository implementations, Data Sources (API, Local), Mappings.
3. **Presentation Layer**: Widgets, Providers/Notifiers, State management.

## Principles

- **Dependency Rule**: Dependencies only point inwards (Presentation -> Domain <- Data).
- **Repository Pattern**: Abstract data access to allow easy switching between local/remote.
- **UseCase Pattern**: Encapsulate single business logic units.
- **Data Transfer Objects (DTOs)**: Separate network/database models from domain entities.
