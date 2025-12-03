import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:SmartTrack/main.dart';
import 'package:SmartTrack/services/supabase_service.dart';
import 'package:SmartTrack/modules/auth/controllers/auth_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/professor_controller.dart';
import 'package:SmartTrack/modules/professor/models/professor_model.dart';
import 'package:SmartTrack/routes/app_routes.dart';
import 'package:SmartTrack/modules/admin/controllers/admin_settings_controller.dart';

import 'package:SmartTrack/modules/professor/controllers/attendance_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/passcode_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/lecture_session_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/my_courses_controller.dart';

class MockProfessorAuthController extends AuthController {
  @override
  Future<void> login(String username, String password) async {
    // Simulate network delay
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    
    // Mock successful login for Professor
    if (selectedRole.value == 'Professor') {
      Get.offAllNamed(AppRoutes.professorDashboard);
    }
  }
}

class MockAdminSettingsController extends AdminSettingsController {
  @override
  void onInit() {
    // Skip super.onInit
    qrCodeDuration.value = 10;
  }
}

class MockProfessorController extends ProfessorController {
  @override
  void onInit() {
    // Skip super.onInit to avoid loading data and admin settings dependency
    // But we need to initialize some observables
    currentProfessor.value = Professor(
      id: '456',
      name: 'Test Professor',
      email: 'professor@example.com',
      role: 'instructor',
    );
  }
  
  @override
  Future<void> loadProfessorData() async {
    // Do nothing
  }

  @override
  Future<List<Map<String, dynamic>>> getTodayLectures() async {
    return [];
  }
}

class MockAttendanceController extends AttendanceController {
  @override
  void onInit() {
    // Skip super.onInit to avoid loading data
  }
  
  @override
  Future<void> loadProfessorCourses() async {
    // Do nothing
  }
}

class MockPasscodeController extends PasscodeController {
  // No onInit to skip, but good to have just in case
}

class MockLectureSessionController extends LectureSessionController {
  // No onInit to skip
}

class MockMyCoursesController extends MyCoursesController {
  @override
  void onInit() {
    // Skip super.onInit to avoid loading data
  }
  
  @override
  Future<void> fetchAssignedCourses() async {
    // Do nothing
  }
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = null; // Enable real network requests
    
    // Initialize Supabase if not already initialized
    try {
      Supabase.instance;
    } catch (_) {
      await Supabase.initialize(
        url: SupabaseService.supabaseUrl,
        anonKey: SupabaseService.supabaseAnonKey,
      );
    }
  });

  testWidgets('Professor Login flow test', (WidgetTester tester) async {
    // Register MockAuthController
    Get.delete<AuthController>();
    Get.put<AuthController>(MockProfessorAuthController());
    
    // Register MockAdminSettingsController (needed by ProfessorController)
    Get.delete<AdminSettingsController>();
    Get.put<AdminSettingsController>(MockAdminSettingsController());

    // Register MockProfessorController
    Get.delete<ProfessorController>();
    Get.put<ProfessorController>(MockProfessorController());

    // Register MockAttendanceController with tag 'professor'
    Get.delete<AttendanceController>(tag: 'professor');
    Get.put<AttendanceController>(MockAttendanceController(), tag: 'professor');

    // Register MockPasscodeController
    Get.delete<PasscodeController>();
    Get.put<PasscodeController>(MockPasscodeController());

    // Register MockLectureSessionController
    Get.delete<LectureSessionController>();
    Get.put<LectureSessionController>(MockLectureSessionController());

    // Register MockMyCoursesController
    Get.delete<MyCoursesController>();
    Get.put<MyCoursesController>(MockMyCoursesController());

    // Set screen size
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify we are on the login screen
    expect(find.text('Login'), findsAtLeastNWidgets(1));

    // Enter email
    await tester.enterText(find.byType(TextField).at(0), 'professor@example.com');
    await tester.pump();

    // Enter password
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.pump();

    // Select Role
    final dropdownFinder = find.byType(DropdownButton<String>);
    await tester.tap(dropdownFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Tap 'Professor' from the menu
    await tester.tap(find.text('Professor').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Tap Login button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    
    // Wait for navigation
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text('Welcome back,').evaluate().isNotEmpty) break;
    }

    // Debug: Print all text widgets found after login attempt
    final textWidgetsAfterLogin = find.byType(Text).evaluate();
    print('Found ${textWidgetsAfterLogin.length} text widgets after login:');
    for (final widget in textWidgetsAfterLogin) {
      print((widget.widget as Text).data);
    }

    // Verify navigation to Professor Dashboard
    // We look for "Welcome back," which is in the dashboard header
    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Test Professor'), findsOneWidget);
  });
}
