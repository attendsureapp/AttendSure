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
