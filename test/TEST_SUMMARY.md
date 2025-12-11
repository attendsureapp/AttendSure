# Test Coverage Report

This document provides a comprehensive analysis of the existing tests in the `test` directory. It outlines the purpose of each test file and the scenarios covered.

---

## 1. Unit Tests

### Models

#### `test/models/professor_test.dart`

Purpose:
Ensures that the `Professor` and `CourseAssignment` models work correctly and maintain data integrity.

Components Tested:
Professor, CourseAssignment.

Scenarios Covered:

1. fromJson: Validates that a `Professor` object is correctly created from a JSON map, including nested `CourseAssignment` entries.
2. dayName Getter: Ensures that the integer representation of a day is correctly translated to its weekday name.

#### `test/models/attendance_test.dart`

Purpose:
Validates the serialization and deserialization of the `Attendance` model.

Components Tested:
Attendance.

Scenarios Covered:

1. fromJson: Ensures JSON data is correctly mapped to an `Attendance` object, including proper `DateTime` parsing.
2. toJson: Confirms that an `Attendance` object is correctly converted back to a JSON map.

---

### Services

#### `test/services/course_import_service_test.dart`

Purpose:
Intended to test the `CourseImportService`.

Observations:
The file currently includes only a placeholder test.
Private helper methods such as `_extractProgramCode` cannot be tested directly.
The main method `importDAIICTTimetable` requires integration testing due to Supabase and file import dependencies.

---

### Controllers

#### `test/controllers/auth_controller_test.dart`

Purpose:
Intended to test the `AuthController`.

Observations:
Contains only a placeholder test without meaningful coverage.

---

## 2. Widget and Integration Tests

### Authentication and Login Flows

#### `test/ui/login_test.dart`

Purpose:
Tests the login screen logic, validation, and the Admin login workflow.

Components Tested:
LoginView, AuthController (mocked).

Scenarios Covered:

1. Successful Admin login and navigation to the Admin Dashboard.
2. Validation for empty fields and invalid email formats.
3. Handling of incorrect credentials and displaying the appropriate error messages.

#### `test/ui/professor_login_test.dart`

Purpose:
Tests the login flow for professors.

Components Tested:
Login screen, AuthController (mocked), ProfessorController (mocked).

Scenarios Covered:

1. Successful Professor login and navigation to the Professor Dashboard.

#### `test/ui/student_login_test.dart`

Purpose:
The file name suggests student login testing, but the content actually tests the Professor Dashboard.

Observations:
The test content closely matches that of `professor_dashboard_test.dart`.
The file is misnamed and may be redundant.

---

### Dashboards

#### `test/ui/professor_dashboard_test.dart`

Purpose:
Tests the Professor Dashboard interface and navigation flow.

Components Tested:
ProfessorMainLayout and related navigation components.

Scenarios Covered:

1. Rendering of the professor’s name and profile information.
2. Display of actions such as the Start Lecture button.
3. Navigation using bottom navigation or navigation rail.
4. Switching between Home, Courses, and Attendance sections.

#### `test/ui/student_dashboard_test.dart`

Purpose:
Tests the Student Dashboard interface, interactions, and navigation.

Components Tested:
StudentMainLayout, StudentController (mocked).

Scenarios Covered:

1. Rendering of the student name and key actions such as Scan QR and View Passcode.
2. Navigation to the QR scanning page.
3. Opening the passcode dialog and selecting a course.
4. Switching to the Attendance section from the bottom navigation bar.

---

### Dialogs and Widgets

#### `test/views/change_password_dialog_test.dart`

Purpose:
Tests the `ChangePasswordDialog` widget.

Components Tested:
ChangePasswordDialog.

Scenarios Covered:

1. Verification of UI elements and input fields.
2. Validation of empty fields.
3. Execution of the callback with the correct input values.

#### `test/widget_test.dart`

Purpose:
Basic Flutter smoke test to verify that the main application launches correctly.

Scenarios Covered:

1. Ensures `MyApp` builds and contains a `MaterialApp`.

---
