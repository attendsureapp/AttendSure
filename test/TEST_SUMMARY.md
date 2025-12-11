# Detailed Test Coverage Report

This document provides a comprehensive analysis of the existing tests in the `test` directory, detailing the purpose, scenarios covered, and observations for each test file.

## 1. Unit Tests

### Models

#### `test/models/professor_test.dart`
*   **Purpose**: Verifies the data integrity and logic of the `Professor` and `CourseAssignment` models.
*   **Components Tested**: `Professor`, `CourseAssignment`.
*   **Scenarios Covered**:
    *   **`fromJson`**: Ensures a `Professor` object is correctly instantiated from a JSON map, including nested `CourseAssignment` lists.
    *   **`dayName` Getter**: Verifies that the `dayName` getter in `CourseAssignment` correctly converts an integer (e.g., 1) to a string (e.g., 'Monday').
*   **Status**: ✅ Functional.

#### `test/models/attendance_test.dart`
*   **Purpose**: Verifies serialization and deserialization of the `Attendance` model.
*   **Components Tested**: `Attendance`.
*   **Scenarios Covered**:
    *   **`fromJson`**: Ensures correct parsing of JSON data into an `Attendance` object, including `DateTime` parsing.
    *   **`toJson`**: Ensures an `Attendance` object is correctly converted back to a JSON map.
*   **Status**: ✅ Functional.

### Services

#### `test/services/course_import_service_test.dart`
*   **Purpose**: Intended to test `CourseImportService`.
*   **Observations**:
    *   ⚠️ **Placeholder**: The file currently contains only a placeholder test (`expect(true, true)`).
    *   **Comments**: Developer notes indicate difficulty in testing private methods (`_extractProgramCode`, etc.) and suggest that `importDAIICTTimetable` requires integration testing due to Supabase and file I/O dependencies.
*   **Status**: 🚧 Incomplete / Placeholder.

### Controllers

#### `test/controllers/auth_controller_test.dart`
*   **Purpose**: Intended to test `AuthController`.
*   **Observations**:
    *   ⚠️ **Placeholder**: Contains only a placeholder test.
*   **Status**: 🚧 Incomplete / Placeholder.

---

## 2. Widget & Integration Tests

### Authentication & Login Flows

#### `test/ui/login_test.dart`
*   **Purpose**: Tests the generic Login screen logic, validation, and Admin login flow.
*   **Components Tested**: `LoginView` (implied), `AuthController` (Mocked).
*   **Scenarios Covered**:
    *   **Success Flow (Admin)**: Simulates entering valid Admin credentials, selecting the 'Admin' role, and verifying navigation to the Admin Dashboard.
    *   **Validation Errors**:
        *   Empty fields submission -> Expects "Please fill in all fields" error.
        *   Invalid email format -> Expects "Please enter a valid email" error.
    *   **Authentication Failure**: Simulates wrong credentials -> Expects "Invalid credentials" error.
*   **Status**: ✅ Functional.

#### `test/ui/professor_login_test.dart`
*   **Purpose**: Specifically tests the login flow for a Professor.
*   **Components Tested**: Login Screen, `AuthController` (Mocked), `ProfessorController` (Mocked).
*   **Scenarios Covered**:
    *   **Success Flow**: Simulates entering Professor credentials, selecting 'Professor' role, and verifying navigation to the Professor Dashboard ("Welcome back," text).
*   **Status**: ✅ Functional.

#### `test/ui/student_login_test.dart`
*   **Purpose**: **MISNAMED**. The filename suggests a student login test, but the content actually tests the **Professor Dashboard**.
*   **Observations**:
    *   ⚠️ **Duplicate/Misnamed**: The code inside is almost identical to `test/ui/professor_dashboard_test.dart`. It sets up `MockProfessorController` and tests the Professor Dashboard interaction.
*   **Status**: ❓ Needs Review (Renaming or Deletion).

### Dashboards

#### `test/ui/professor_dashboard_test.dart`
*   **Purpose**: Comprehensive interaction test for the Professor Dashboard.
*   **Components Tested**: `ProfessorMainLayout`, Navigation (Bottom/Rail).
*   **Scenarios Covered**:
    *   **Profile Rendering**: Verifies the professor's name is displayed.
    *   **Action Buttons**: Checks for "Start Lecture" button and its navigation (mocked to "No lectures today").
    *   **Navigation**:
        *   Detects whether `BottomNavigationBar` or `NavigationBar` is used.
        *   Tests navigation to "Courses" tab -> Verifies "My Courses" view.
        *   Tests navigation to "Attendance" tab -> Verifies "Attendance" view.
*   **Status**: ✅ Functional.

#### `test/ui/student_dashboard_test.dart`
*   **Purpose**: Interaction test for the Student Dashboard.
*   **Components Tested**: `StudentMainLayout`, `StudentController` (Mocked).
*   **Scenarios Covered**:
    *   **Rendering**: Verifies student name and main menu options ("Scan QR", "View Passcode").
    *   **Scan QR**: Tests navigation to the QR scanning view.
    *   **View Passcode**: Tests opening the passcode dialog and selecting a course.
    *   **Attendance Tab**: Tests navigation to the "Attendance" tab via the bottom bar.
*   **Status**: ✅ Functional.

### Dialogs & Components

#### `test/views/change_password_dialog_test.dart`
*   **Purpose**: Tests the `ChangePasswordDialog` widget in isolation.
*   **Components Tested**: `ChangePasswordDialog`.
*   **Scenarios Covered**:
    *   **UI Layout**: Verifies existence of 3 text fields (Current, New, Confirm) and buttons.
    *   **Form Validation**: Ensures "This field is required" appears if fields are empty.
    *   **Callback Execution**: Verifies that valid input triggers the `onChangePassword` callback with the correct data.
*   **Status**: ✅ Functional.

#### `test/widget_test.dart`
*   **Purpose**: Default Flutter smoke test.
*   **Scenarios Covered**:
    *   **App Launch**: Verifies that `MyApp` builds and contains a `MaterialApp`.
*   **Status**: ✅ Functional.

---

## 3. Findings & Recommendations

1.  **Misnamed File**: `test/ui/student_login_test.dart` contains tests for the Professor Dashboard, not Student Login. It should be renamed to `professor_dashboard_test_2.dart` or merged/deleted if it's a duplicate.
2.  **Missing Coverage**:
    *   **`CourseImportService`**: Critical logic for importing timetables is currently untested.
    *   **`AuthController`**: Unit tests are missing; logic is only tested implicitly via UI tests with mocks.
3.  **Mocking Strategy**: The project uses a manual mocking strategy (creating `Mock...` classes extending the real ones) rather than using a mocking library like `mockito` for controllers in some places, though `mockito` is imported in some files. This is a valid approach for GetX controllers.
