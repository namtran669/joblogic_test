# Folder Structure Justification

We are applying a **Feature-First + Clean Architecture** structural approach. 

## Structure Overview

```text
lib/
├── core/
│   ├── database/
│   ├── di/
│   ├── error/
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/
│   ├── build_app/ (App entry configurations)
│   ├── buy/
│   ├── call/
│   ├── home/
│   ├── sell/
│   └── sync/
└── main.dart
```

## Why Feature-First?
By grouping files by `feature` (e.g., `call`, `buy`, `sell`) rather than by `type` (e.g., `blocs/`, `repositories/`), the project inherently scores high on modularity. If we need to remove the "buy" module in the future, we simply delete `lib/features/buy/` without hunting down its associated bloc in a global `lib/blocs/` directory.

## Layer Separation (Inside Each Feature)
Within each feature layout, we maintain Clean Architecture separation:

- **domain/**: Contains business rules and pure logic. No Flutter external package dependencies exist here. 
  - `entities/`: Base Dart classes representing domain objects.
  - `repositories/`: Abstract classes establishing the contract.
  - `usecases/`: Interactors orchestrating business logic (e.g., `GetCallsUseCase`).

- **data/**: Implements the abstract contracts from Domain.
  - `models/`: Subclasses of entities containing `fromJson`/`toJson` mechanisms.
  - `repositories/`: Concrete implementations of domain repositories, merging local and remote data.
  - `datasources/`: Raw data retrieval (e.g., `Dio` calls or `SQLite` queries).

- **presentation/**: Contains everything UI-related.
  - `pages/`: UI screens.
  - `widgets/`: Reusable components for that specific module.
  - `bloc/`: State management holding the logic between Domain and Presentation.
