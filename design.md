# Project Design Commentary

This document outlines the architectural decisions, design principles, and key refactoring steps undertaken to improve the **AttendSure** application.

## 1. Architectural Improvements

### Modular Architecture (Package by Feature)
We have structured the application using a **Modular Architecture**. Instead of grouping files by type (e.g., all controllers in one folder, all views in another), we group them by **feature** (e.g., `auth`, `professor`, `student`, `admin`).

*   **Before**: A monolithic structure where finding all files related to "Authentication" required jumping between `controllers/`, `views/`, and `models/`.
*   **After**: `lib/modules/auth/` contains everything related to authentication:
    *   `controllers/`: State management logic.
    *   `views/`: UI screens.
    *   `models/`: Data structures.
    *   `bindings/`: Dependency injection setup.

**Benefit**: This improves scalability and maintainability. Developers can work on the "Student" module without accidentally impacting the "Admin" module.

### Service Layer Pattern
We implemented a dedicated **Service Layer** (e.g., `SupabaseService`, `AuthService`) to handle all external data interactions.

*   **Design**: The UI and Controllers do not make direct HTTP or database calls. Instead, they call methods like `SupabaseService.getPrograms()`.
*   **Benefit**:
    *   **Decoupling**: The UI is agnostic of the backend implementation. If we switch from Supabase to Firebase, we only update the Service Layer.
    *   **Resilience**: We implemented a centralized `withRetry` mechanism in `SupabaseService` to automatically retry failed network requests, improving app stability.

### Middleware for Route Protection
We introduced **Middleware** (e.g., `AuthMiddleware`) to handle route protection and navigation guards.

*   **Design**: Middleware intercepts navigation events to check if a user is authenticated or has the correct role before allowing access to a route.
*   **Benefit**:
    *   **Security**: Prevents unauthorized access to sensitive pages (e.g., Admin Dashboard).
    *   **Centralized Logic**: Authentication checks are defined in one place rather than being repeated in every controller or view.

## 2. Design Principles Applied (SOLID)

### Single Responsibility Principle (SRP)
We strictly separated the application into three layers, ensuring each class has a single reason to change:
*   **UI (Views)**: Responsible *only* for rendering the interface and capturing user input.
*   **State Management (Controllers)**: Responsible for business logic and managing the state of the UI (using GetX).
*   **Data Access (Services)**: Responsible for communicating with the backend.
    *   *Example*: `AuthService` handles the raw API calls for login/signup, while `AuthController` handles the form validation and UI state (loading spinners).

### Open/Closed Principle (OCP)
The application is designed to be open for extension but closed for modification.
*   **Modules**: New features (e.g., a "Parent" portal) can be added as new modules (`lib/modules/parent/`) without modifying the existing `student` or `professor` modules.
*   **Routing**: The `AppRoutes` system allows adding new routes without changing the core navigation logic.

### Dependency Inversion Principle (DIP)
We use Dependency Injection to decouple high-level modules from low-level modules.
*   **Implementation**: We use GetX's Dependency Injection system (`Get.put`, `Get.find`).
*   **Example**: Controllers do not instantiate Services directly. Instead, Services are injected. This makes it easy to swap out a real `AuthService` for a `MockAuthService` during testing, as seen in our test files.

## 3. Key Refactoring

### Centralized Supabase Client & Error Handling
*   **Problem**: Database calls were scattered across widgets, with inconsistent error handling and no retry logic.
*   **Refactoring**: Moved all Supabase interactions to `SupabaseService`.
*   **Improvement**: Added a `withRetry` wrapper around all calls to handle network flakes gracefully. Added centralized error logging.

### Refactoring Auth Logic to Service Layer
*   **Problem**: `AuthController` contained mixed responsibilities—handling UI state *and* direct database queries.
*   **Refactoring**: Extracted authentication logic (Admin, Student, Professor login) into `AuthService`.
*   **Improvement**: `AuthController` became lighter and focused solely on user interaction, while `AuthService` became a reusable component for auth logic.

### Reusable Widgets & Dialogs
*   **Refactoring**: Extracted common UI elements (like `ChangePasswordDialog`) into reusable widgets.
*   **Improvement**: Reduces code duplication and ensures UI consistency across the app.

### Centralized Routing
*   **Refactoring**: Moved all route definitions to `AppRoutes` and used named routes for navigation.
*   **Improvement**: Makes navigation logic easier to manage and refactor. Hardcoded strings are replaced with constants, reducing typos.
