import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:SmartTrack/services/supabase_service.dart';

// Controllers
import 'package:SmartTrack/modules/auth/controllers/auth_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_attendance_history_controller.dart';

// Views
import 'package:SmartTrack/modules/student/views/student_main_layout.dart';

// Models
import 'package:SmartTrack/modules/student/models/student_model.dart';
import 'package:SmartTrack/modules/admin/models/course_model.dart';
import 'package:SmartTrack/routes/app_routes.dart';

/// ---------------- MOCK CONTROLLERS ---------------- ///

class MockAuthController extends AuthController {
  @override
  void onInit() {}
}

class MockStudentController extends StudentController {
  @override
  void onInit() {
    currentStudent.value = Student(
      id: '123',
      name: 'Test Student',
      email: 'student@test.com',
      registrationNumber: 'REG123',
      programId: 'prog1',
      programName: 'Test Program',
      semester: 1,
    );

    isLoading.value = false;
    hasError.value = false;
    errorMessage.value = '';
    enrolledCourses.value = [];
    todayLectures.value = [];
    courseAttendance.value = {'Math': 0.8, 'Physics': 0.9};
  }

  @override
  Future<void> loadStudentData() async {}

  @override
  Future<List<Course>> loadStudentCourses() async {
    return [
      Course(
        id: 'c1',
        code: 'MATH101',
        name: 'Mathematics',
        semester: 1,
        credits: 3,
        programId: 'prog1',
      )
    ];
  }
}

class MockStudentAttendanceHistoryController
    extends StudentAttendanceHistoryController {
  @override
  void onInit() {}

  @override
  Future<void> loadAttendanceData() async {}
}

/// -------------------- TEST -------------------- ///

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

  testWidgets("Student Dashboard Interaction Test", (WidgetTester tester) async {
    /// Register controllers
    Get.put<AuthController>(MockAuthController());
    Get.put<StudentController>(MockStudentController());
    Get.put<StudentAttendanceHistoryController>(
        MockStudentAttendanceHistoryController());

    /// Configure UI device size
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      Get.reset();
    });

    /// Pump UI
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppRoutes.studentDashboard,
        getPages: [
          GetPage(
            name: AppRoutes.studentDashboard,
            page: () => const StudentMainLayout(),
          ),
          GetPage(
            name: AppRoutes.scanQr,
            page: () => const Scaffold(body: Text("Scan QR View")),
          ),
        ],
      ),
    );

    await tester.pumpAndSettle();

    /// Dashboard rendering validation
    expect(find.text("Test Student"), findsOneWidget);
    expect(find.text("Scan QR"), findsOneWidget);
    expect(find.text("View Passcode"), findsOneWidget);

    /// Scan QR Navigation
    await tester.tap(find.text("Scan QR"));
    await tester.pumpAndSettle();
    expect(find.text("Scan QR View"), findsOneWidget);

    /// Back to dashboard
    Get.back();
    await tester.pumpAndSettle();

    /// View Passcode Dialog test
    await tester.tap(find.text("View Passcode"));
    await tester.pumpAndSettle();
    expect(find.text("Select Course"), findsOneWidget);
    expect(find.text("Mathematics"), findsOneWidget);

    /// Close dialog
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    /// Navigate to Attendance tab using BottomNavigationBar
    await tester.tap(find.text("Attendance"));
    await tester.pumpAndSettle();

    /// Expect Attendance page
    expect(find.text("My Attendance"), findsOneWidget);
  });
}
