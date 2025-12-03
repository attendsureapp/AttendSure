import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase init
import 'package:SmartTrack/services/supabase_service.dart';

// Controllers
import 'package:SmartTrack/modules/auth/controllers/auth_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/professor_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/attendance_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/passcode_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/lecture_session_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/my_courses_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_auth_controller.dart';
import 'package:SmartTrack/modules/admin/controllers/admin_settings_controller.dart';

// Views
import 'package:SmartTrack/modules/professor/views/professor_main_layout.dart';

// Models
import 'package:SmartTrack/modules/professor/models/professor_model.dart';
import 'package:SmartTrack/modules/student/models/student_model.dart' as student_model;

// Routes
import 'package:SmartTrack/routes/app_routes.dart';

/// ---------------- MOCK CONTROLLERS ---------------- ///

class MockAuthController extends AuthController {
  @override
  void onInit() {}
}

class MockStudentAuthController extends StudentAuthController {
  @override
  void onInit() {}
}

class MockProfessorController extends ProfessorController {
  @override
  void onInit() {
    currentProfessor.value = Professor(
      id: 'prof1',
      name: 'Test Professor',
      email: 'prof@test.com',
      program: 'CS',
      phone: '1234567890',
    );
    assignedCourses.value = [];
    isLoading.value = false;
  }
}

class MockAttendanceController extends AttendanceController {
  @override
  void onInit() {}
}

class MockPasscodeController extends PasscodeController {
  @override
  void onInit() {}
}

class MockAdminSettingsController extends AdminSettingsController {
  @override
  void onInit() {
    // Skip super.onInit() to avoid loading real data
    // Initialize any required observable properties with default values
  }
  
  @override
  Future<void> loadSettings() async {
    // Mock implementation - do nothing
  }
  
  @override
  Future<void> saveSettings() async {
    // Mock implementation - do nothing
  }
}

class MockLectureSessionController extends LectureSessionController {
  @override
  void onInit() {
    // Override to prevent calling super.onInit() if it causes issues
    // Initialize any required properties here
  }
}

class MockMyCoursesController extends MyCoursesController {
  @override
  void onInit() {}
  
  @override
  Future<void> fetchAssignedCourses() async {}
}

class MockStudentController extends StudentController {
  @override
  void onInit() {
    currentStudent.value = student_model.Student(
      id: 'st1',
      name: 'Test Student',
      email: 'student@test.com',
      registrationNumber: 'REG001',
      programId: 'prog1',
      semester: 1,
    );
    isLoading.value = false;
  }
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = null;

    try {
      Supabase.instance;
    } catch (_) {
      await Supabase.initialize(
        url: SupabaseService.supabaseUrl,
        anonKey: SupabaseService.supabaseAnonKey,
      );
    }
  });

  testWidgets("Professor Dashboard Interaction Test", (WidgetTester tester) async {
    /// Register Mock Controllers
    Get.delete<AuthController>(force: true);
    Get.put<AuthController>(MockAuthController());
    
    Get.delete<StudentAuthController>(force: true);
    Get.put<StudentAuthController>(MockStudentAuthController());
    
    Get.delete<ProfessorController>(force: true);
    Get.put<ProfessorController>(MockProfessorController(), permanent: true);
    
    Get.delete<AttendanceController>(tag: "professor", force: true);
    Get.put<AttendanceController>(MockAttendanceController(), tag: "professor");
    
    Get.delete<PasscodeController>(force: true);
    Get.put<PasscodeController>(MockPasscodeController(), permanent: true);
    
    // Register AdminSettingsController BEFORE LectureSessionController
    Get.delete<AdminSettingsController>(force: true);
    Get.put<AdminSettingsController>(MockAdminSettingsController());
    
    Get.delete<LectureSessionController>(force: true);
    Get.put<LectureSessionController>(MockLectureSessionController());
    
    Get.delete<MyCoursesController>(force: true);
    Get.put<MyCoursesController>(MockMyCoursesController());
    
    Get.delete<StudentController>(force: true);
    Get.put<StudentController>(MockStudentController());

    /// Configure screen dimensions for test environment
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      Get.reset();
    });

    /// Launch UI
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppRoutes.professorDashboard,
        getPages: [
          GetPage(
            name: AppRoutes.professorDashboard,
            page: () => const ProfessorMainLayout(),
          ),
          GetPage(
            name: "/professor/start-lecture",
            page: () => const Scaffold(body: Text("No lectures today")),
          ),
        ],
      ),
    );

    await tester.pumpAndSettle();

    /// Validate professor profile visible
    expect(find.text("Test Professor"), findsOneWidget);
    expect(find.text("Start Lecture"), findsOneWidget);

    /// Start lecture navigation
    // await tester.tap(find.text("Start Lecture"));
    // await tester.pumpAndSettle();
    // expect(find.text("No lectures today"), findsOneWidget);

    /// Navigate back
    // await tester.tap(find.descendant(of: find.byType(AppBar), matching: find.byType(IconButton)));
    // await tester.pumpAndSettle();
    
    /// Verify we are back on dashboard
    // expect(find.text("Start Lecture"), findsOneWidget);

    /// ---- BOTTOM NAVIGATION TESTING ----

  });
}