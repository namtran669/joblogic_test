# Architectural Decision Records (ADR)

## ADR 1: Clean Architecture Adoption
**Status**: Adopted
**Context**: The application requires high maintainability, testability, and a clear separation of concerns, especially with hybrid sync and multiple data sources.
**Decision**: We will use Clean Architecture with three main layers: Presentation, Domain, Data.
**Consequences**: Increases folder nesting and initial boilerplate, but guarantees module independence and high testability over time.

## ADR 2: State Management with Bloc/Cubit
**Status**: Adopted
**Context**: We need reactive state propagation across complex modules, particularly with offline/online state and sync counters.
**Decision**: `flutter_bloc` provides an intuitive pattern separating business logic from the UI.
**Consequences**: Requires explicit state definitions but ensures highly predictable and debuggable data flows.

## ADR 3: Data Persistence with SQLite
**Status**: Adopted
**Context**: We need to perform offline-first, full CRUD operations to support To-Sell and Hybrid Sync functionality.
**Decision**: Use `sqflite` for relational robust storage.
**Consequences**: Offers better data integrity and querying capabilities than SharedPreferences, though it requires SQL schema management.

## ADR 4: Implementation of Mock API
**Status**: Adopted
**Context**: The assignment allows creating a mock API to feed To-Call and To-Buy.
**Decision**: Use `dio` with a mock interceptor directly inside the app.
**Consequences**: Eliminates the need for reviewers to run a separate local Node.js server. The app entirely stands on its own while simulating network delays and API error logic accurately.

## ADR 5: Dependency Injection via GetIt
**Status**: Adopted
**Context**: Clean Architecture requires injecting repositories into usecases, and usecases into blocs.
**Decision**: Use Service Locator pattern with `get_it`.
**Consequences**: Provides a straightforward way to manage singletons and factory instances globally.
