import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:SmartTrack/views/change_password_dialog.dart';

void main() {

  testWidgets('ChangePasswordDialog renders correctly', (WidgetTester tester) async {
    // Set a large enough size to avoid overflow
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build the widget
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ChangePasswordDialog(
            onChangePassword: (current, newPass) {},
          ),
        ),
      ),
    );

    // Verify that the title is displayed
    expect(find.text('Change Password'), findsNWidgets(2)); // Title and Button

    // Verify text fields
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Current Password'), findsOneWidget);
    expect(find.text('New Password'), findsOneWidget);
    expect(find.text('Confirm New Password'), findsOneWidget);

    // Verify buttons
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('ChangePasswordDialog validates empty fields', (WidgetTester tester) async {
    // Set a large enough size to avoid overflow
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ChangePasswordDialog(
            onChangePassword: (current, newPass) {},
          ),
        ),
      ),
    );

    // Tap the Change Password button without entering anything
    final buttonFinder = find.widgetWithText(ElevatedButton, 'Change Password');
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // Verify validation errors
    expect(find.text('This field is required'), findsNWidgets(3));
  });

  testWidgets('ChangePasswordDialog calls onChangePassword when valid', (WidgetTester tester) async {
    String? currentPassword;
    String? newPassword;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ChangePasswordDialog(
            onChangePassword: (current, newPass) {
              currentPassword = current;
              newPassword = newPass;
            },
          ),
        ),
      ),
    );

    // Enter text into fields
    await tester.enterText(find.byType(TextFormField).at(0), 'oldPass');
    await tester.enterText(find.byType(TextFormField).at(1), 'newPass');
    await tester.enterText(find.byType(TextFormField).at(2), 'newPass');

    // Tap the button
    final buttonFinder = find.widgetWithText(ElevatedButton, 'Change Password');
    await tester.tap(buttonFinder);
    await tester.pump();

    // Verify callback was called
    expect(currentPassword, 'oldPass');
    expect(newPassword, 'newPass');
  });
}
