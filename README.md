# test_joblogic

A Flutter application built using Clean Architecture, BLoC state management, and offline-first capabilities.

## Prerequisites

Before you begin, ensure you have met the following requirements:
- **Flutter SDK**: Ensure you have [Flutter](https://docs.flutter.dev/get-started/install) installed (SDK version `^3.11.4` or compatible).
- **IDE**: A suitable IDE such as [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) with the Dart and Flutter plugins installed.
- **Device/Simulator**: An active Android Emulator, iOS Simulator, or a connected physical device.

## Getting Started

Follow these steps to set up and run the project locally.

### 1. Clone the repository (if applicable)

```bash
git clone <repository_url>
cd test_joblogic
```

### 2. Install Dependencies

Fetch all the necessary Flutter and Dart packages:

```bash
flutter pub get
```

### 3. Code Generation (For Mocks, etc.)

Since this project utilizes packages like `build_runner` and `mockito`/`mocktail`, you may need to generate boilerplate code or mocks for testing:

```bash
dart run build_runner build --delete-conflicting-outputs
```

*(You typically only need to run this when modifying or adding new tests that require mocks, or if you introduce code-generation plugins later).*

### 4. Run the Application

Start the app on your connected device or simulator:

```bash
flutter run
```

Alternatively, you can run the app directly from your IDE's run/debug menu.

## Running Tests

To ensure everything is working correctly, you can run the unit and widget tests included in the project:

```bash
flutter test
```

## Architecture Overview

This application follows **Clean Architecture** principles to separate concerns, making it scalable and testable. The architecture is divided into three main layers:

- **Presentation Layer**: Contains the UI elements (Pages, Widgets) and state management using `BLoC`.
- **Domain Layer**: The core of the application involving business logic. It consists of abstract Repository definitions, Entities, and Use Cases. This layer has no dependencies on the outside world (like flutter packages, DB, etc.).
- **Data Layer**: Implements the repositories defined in the domain layer. It handles fetching data from remote APIs (using `Dio`) and caching data locally (using `sqflite`) for seamless offline support.
