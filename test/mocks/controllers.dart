import 'package:SmartTrack/controllers/attendance_controller.dart';
import 'package:SmartTrack/controllers/auth_controller.dart';
import 'package:SmartTrack/controllers/professor_controller.dart';
import 'package:SmartTrack/models/professor.dart';
import 'package:SmartTrack/modules/professor/controllers/lecture_session_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/my_courses_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/passcode_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_attendance_history_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_auth_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_controller.dart';

class MockAuthController extends AuthController {}

class MockStudentAuthController extends StudentAuthController {}

class MockProfessorController extends ProfessorController {
  @override
  void onInit() {
    currentProfessor.value = Professor(
      id: 'prof1',
      name: 'Test Professor',
      email: 'prof@test.com',
      program: 'CS',
      phone: '1234567890',
      // assignedCourses: [],
    );
    isLoading.value = false;
  }
}

class MockAttendanceController extends AttendanceController {}

class MockPasscodeController extends PasscodeController {}

class MockLectureSessionController extends LectureSessionController {}

class MockMyCoursesController extends MyCoursesController {}

class MockStudentController extends StudentController {
  @override
  void onInit() {
    currentStudent.value = Student(
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

class MockStudentAttendanceHistoryController extends StudentAttendanceHistoryController {}
