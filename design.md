---

# Project Design Commentary

This document outlines the architectural decisions, design principles, and major refactoring efforts undertaken to enhance the overall structure, maintainability, and scalability of the AttendSure application.

---

## 1. Architectural Improvements

### Modular Architecture (Feature-Based Structure)

The application is organized using a **feature-based modular architecture**. Instead of grouping files by type (such as controllers, views, or models), the project is structured by domain-specific modules. For example, all authentication-related components reside inside `lib/modules/auth/`, including:

• Controllers
• Views
• Models
• Bindings

This structure ensures that each module is self-contained and easier to understand.

**Previous Approach:**
Files belonging to the same feature were scattered across multiple directories, making navigation and maintenance difficult.

**Current Approach:**
Feature-specific modules contain all related logic, reducing coupling between different parts of the system.

**Resulting Benefits:**
• Improved maintainability
• Easier scalability
• Clear separation between unrelated features
• Simplified onboarding for new developers

---

### Service Layer Pattern

A dedicated **Service Layer** has been introduced to manage all external interactions such as database operations, authentication, and API calls. Examples include `SupabaseService` and `AuthService`.

**Design Characteristics:**
• Controllers and UI components do not directly perform HTTP or database calls.
• All external communication is centralized in service classes.

**Key Outcomes:**
• Decoupling between business logic and data access
• Easy replacement of backend technologies without affecting UI or controllers
• Consistent error handling across the application
• A unified retry mechanism (`withRetry`) for more robust network operations

---

### Middleware for Route Protection

Middleware components, such as `AuthMiddleware`, now enforce access control and user role validation during navigation.

**Functionality:**
• Intercepts routing actions to ensure the user is authenticated
• Restricts access based on user roles (Admin, Professor, Student)

**Advantages:**
• Enhanced security
• Centralized access management
• Reduced duplication of authentication logic across screens

---

## 2. Design Principles (SOLID)

### Single Responsibility Principle (SRP)

Each component in the system has a clearly defined responsibility:

• **Views:** Manage only the visual layout and user input
• **Controllers:** Handle UI state and business logic
• **Services:** Manage data operations and external communication

**Example:**
`AuthService` handles authentication logic, while `AuthController` focuses solely on updating UI state and managing user interactions.

---

### Open/Closed Principle (OCP)

The system supports adding new modules and features without modifying existing ones.

**Examples:**
• A new “Parent” module can be added without modifying the Student or Professor modules.
• New routes can be introduced through the centralized `AppRoutes` configuration without altering existing navigation code.

---

### Dependency Inversion Principle (DIP)

High-level modules depend on abstractions rather than concrete implementations, using GetX’s dependency injection mechanism.

**Implementation:**
• Services are injected into controllers using `Get.put` and `Get.find`
• Makes testing simpler by allowing service mocks to be injected in place of real services

---

## 3. Key Refactoring Highlights

### Centralized Supabase Client and Error Handling

**Initial Issue:**
Supabase calls were scattered across multiple widgets and controllers, resulting in inconsistent error handling and duplicated logic.

**Refactoring:**
• All database interactions moved to `SupabaseService`
• Unified `withRetry` wrapper implemented for all operations
• Centralized exception logging added for debugging

**Outcome:**
Cleaner, more reliable code with unified data access patterns.

---

### Authentication Logic Extraction

**Initial Issue:**
`AuthController` mixed UI logic with direct database queries, creating tightly coupled and hard-to-test code.

**Refactoring:**
• All authentication operations moved to `AuthService`
• `AuthController` now strictly manages UI state (loading, validation, navigation)

**Outcome:**
More modular and testable architecture.

---

### Reusable Widgets and Dialogs

Common UI components such as the `ChangePasswordDialog` were extracted into reusable widgets.

**Benefits:**
• Consistent UI patterns
• Reduced code duplication
• Simplified updates to shared components

---

### Centralized Routing Structure

Route definitions were consolidated into a single `AppRoutes` file, and named routes were adopted across the project.

**Advantages:**
• Eliminates scattered hardcoded route strings
• Simplifies route modification and maintenance
• Enables better navigation structure and readability

---
