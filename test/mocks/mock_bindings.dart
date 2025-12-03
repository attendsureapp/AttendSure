import 'package:get/get.dart';

// Controllers
import 'package:SmartTrack/modules/auth/controllers/auth_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_auth_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_controller.dart';
import 'package:SmartTrack/modules/student/controllers/student_attendance_history_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/professor_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/attendance_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/passcode_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/lecture_session_controller.dart';
import 'package:SmartTrack/modules/professor/controllers/my_courses_controller.dart';

// Models
import 'package:SmartTrack/modules/student/models/student_model.dart';

class TestAppBindings extends Bindings {
  @override
  void dependencies() {

    // ------ AUTH ------
    Get.put<AuthController>(MockAuthController(), permanent: true);
    Get.put<StudentAuthController>(MockStudentAuthController(), permanent: true);

    // ------ STUDENT ------
    Get.put<StudentController>(MockStudentController(), permanent: true);
    Get.put<StudentAttendanceHistoryController>(MockStudentAttendanceHistoryController(), permanent: true);

    // ------ PROFESSOR ------
    Get.put<ProfessorController>(MockProfessorController(), permanent: true);
    Get.put<AttendanceController>(MockAttendanceController(), tag: "professor", permanent: true);
    Get.put<PasscodeController>(MockPasscodeController(), permanent: true);
    Get.put<LectureSessionController>(MockLectureSessionController(), permanent: true);
    Get.put<MyCoursesController>(MockMyCoursesController(), permanent: true);
  }
}
