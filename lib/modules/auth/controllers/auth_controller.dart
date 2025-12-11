import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthController extends GetxController {
  final _authService = Get.find<AuthService>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString selectedRole = 'Student'.obs;

  @override
  void onInit() {
    super.onInit();
    // Clear fields and reset state when controller is initialized
    emailController.clear();
    passwordController.clear();
    selectedRole.value = 'Student';
    isPasswordVisible.value = false;
  }

  void setRole(String role) {
    selectedRole.value = role;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validateInputs() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedRole.value != 'Student' && !GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> login(String username, String password) async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;
      
      final response = await _authService.signIn(
        username: username,
        password: password,
        userType: selectedRole.value,
      );

      if (response != null) {
        debugPrint('${selectedRole.value} login successful with data: $response');
        _handleNavigation(selectedRole.value);
      } else {
        Get.snackbar(
          'Error',
          'Invalid credentials',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      Get.snackbar(
        'Error',
        'Failed to login: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // Sign out from Supabase
      await _supabase.auth.signOut();
      
      // Reset controller state
      isLoading.value = false;
      selectedRole.value = 'Student';
      isPasswordVisible.value = false;
      
      // Clear text fields
      emailController.clear();
      passwordController.clear();
      
      // Navigate to login screen
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      debugPrint('Error during logout: $e');
      Get.snackbar(
        'Error',
        'Failed to logout properly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _handleNavigation(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        Get.offAllNamed(AppRoutes.studentDashboard);
        break;
      case 'professor':
        Get.offAllNamed(AppRoutes.professorDashboard);
        break;
      case 'admin':
        Get.offAllNamed(AppRoutes.adminDashboard);
        break;
      default:
        Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
} 