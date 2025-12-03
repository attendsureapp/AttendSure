import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:SmartTrack/main.dart';
import 'package:SmartTrack/services/supabase_service.dart';
import 'package:SmartTrack/modules/auth/controllers/auth_controller.dart';
import 'package:SmartTrack/routes/app_routes.dart';

class MockAuthController extends AuthController {
  @override
  Future<void> login(String username, String password) async {
    // Simulate network delay
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500)); // Shorter delay for tests
    isLoading.value = false;

    // Validation logic mimicking real controller
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedRole.value != 'Student' && !GetUtils.isEmail(username)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Mock successful login for Admin
    if (selectedRole.value == 'Admin' && username == 'heet369@gmail.com' && password == 'Hari@369') {
      Get.offAllNamed(AppRoutes.adminDashboard);
    } else {
      // Mock failure
      Get.snackbar(
        'Error',
        'Invalid credentials',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = null; // Enable real network requests
    
    // Initialize Supabase
    try {
      Supabase.instance;
    } catch (_) {
      await Supabase.initialize(
        url: SupabaseService.supabaseUrl,
        anonKey: SupabaseService.supabaseAnonKey,
      );
    }
  });

  testWidgets('Login flow test (Success)', (WidgetTester tester) async {
    // Register MockAuthController
    Get.delete<AuthController>();
    Get.put<AuthController>(MockAuthController());

    // Set screen size
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      Get.closeAllSnackbars();
      Get.deleteAll();
    });

    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify we are on the login screen
    expect(find.text('Login'), findsAtLeastNWidgets(1));

    // Enter valid email
    await tester.enterText(find.byType(TextField).at(0), 'heet369@gmail.com');
    await tester.pump();

    // Enter valid password
    await tester.enterText(find.byType(TextField).at(1), 'Hari@369');
    await tester.pump();

    // Select Role
    final dropdownFinder = find.byType(DropdownButton<String>);
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    // Tap 'Admin' from the menu
    await tester.tap(find.text('Admin').last);
    await tester.pumpAndSettle();

    // Tap Login button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    
    // Wait for navigation
    await tester.pumpAndSettle();

    // Verify navigation to Admin Dashboard
    expect(find.text('Admin Dashboard'), findsOneWidget);
  });

  testWidgets('Login failure and validation test', (WidgetTester tester) async {
    // Register MockAuthController
    Get.delete<AuthController>();
    Get.put<AuthController>(MockAuthController());

    // Set screen size
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      Get.closeAllSnackbars();
      Get.deleteAll();
    });

    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // --- Test Empty Fields ---
    // Tap Login button without entering anything
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(seconds: 1)); // Wait for snackbar

    // Verify error message
    expect(find.text('Please fill in all fields'), findsOneWidget);
    
    // Wait for snackbar to disappear
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // --- Test Invalid Email Format (for Admin) ---
    // Select Admin Role first (default is Student which might not check email regex in some implementations, but let's stick to Admin for consistency)
    final dropdownFinder = find.byType(DropdownButton<String>);
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Admin').last);
    await tester.pumpAndSettle();

    // Enter invalid email
    await tester.enterText(find.byType(TextField).at(0), 'invalid-email');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.pump();

    // Tap Login
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify invalid email message
    expect(find.text('Please enter a valid email'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // --- Test Invalid Credentials ---
    // Enter valid format but wrong credentials
    await tester.enterText(find.byType(TextField).at(0), 'wrong@email.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrongpass');
    await tester.pump();

    // Tap Login
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // Wait for network delay + snackbar

    // Verify invalid credentials message
    expect(find.text('Invalid credentials'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
