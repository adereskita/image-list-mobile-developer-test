# Project Test

## 📦 Setup & Installation
1.  Clone the repository.
2.  Open `SequisImage/SequisImage.xcodeproj` in Xcode 15 or later.
3.  Let Swift Package Manager resolve dependencies.
4.  Build and run on an iOS Simulator or Device.
## 🧪 Testing
Unit tests are located in the `SequisImageTests` target, focusing on ViewModels and Data layers to ensure business logic reliability.

Overview of the Project:

![Simulator Screen Recording - iPhone 16 Pro - 2026-03-10 at 19 56 22](https://github.com/user-attachments/assets/95d490d2-6320-40d8-8183-f062ab9e281d)

Unit Testing Result:

<img width="438" height="423" alt="Screenshot 2026-03-10 at 19 55 48" src="https://github.com/user-attachments/assets/17eb9f84-0296-48cd-9756-f9956d28c6cd" />

## 🛠 Technology Stack
- **UI Framework**: SwiftUI
- **Networking**: Moya (Network Abstraction Layer)
- **Local Persistence**: Core Data
- **Architecture**:
  - **Clean Architecture**: Separation of concerns across Data, Domain, and Presentation layers.
  - **MVVM-C**: Model-View-ViewModel with a Coordinator pattern for navigation.
- **Dependency Management**: Swift Package Manager (SPM).

## 🏗 Project Architecture
The project follows a modular Clean Architecture approach:
- **Presentation Layer**: Handles UI and user interaction.
  - `Views`: Reusable SwiftUI components.
  - `ViewModels`: Business logic for views.
  - `Coordinators`: Navigation flow management.
- **Domain Layer**: Contains the core business logic.
  - `Entities`: Pure data models (e.g., `ImageItem`, `CommentItem`).
  - `UseCases`: Application-specific business rules.
  - `Repositories`: Protocols defining data operations.
- **Data Layer**: Responsible for data retrieval and persistence.
  - `Network`: API definitions using Moya.
  - `CoreData`: Local database management.
  - `Repositories`: Concrete implementations that orchestrate network and local data.
 
## ⚙️ CI/CD
The project includes a GitHub Actions workflow (`.github/workflows/swift.yml`) that automates:
- Dependency resolution.
- Building the project on every push and pull request to `main` and `develop` branches.
