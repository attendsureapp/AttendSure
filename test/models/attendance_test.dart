import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrack/models/attendance.dart';

void main() {
  group('Attendance Model Test', () {
    test('fromJson creates correct Attendance object', () {
      final json = {
        'id': '1',
        'course_id': 'c1',
        'student_id': 's1',
        'date': '2023-10-27T10:00:00.000',
        'is_present': true,
      };

      final attendance = Attendance.fromJson(json);

      expect(attendance.id, '1');
      expect(attendance.courseId, 'c1');
      expect(attendance.studentId, 's1');
      expect(attendance.date, DateTime.parse('2023-10-27T10:00:00.000'));
      expect(attendance.isPresent, true);
    });

    test('toJson creates correct Map', () {
      final attendance = Attendance(
        id: '1',
        courseId: 'c1',
        studentId: 's1',
        date: DateTime.parse('2023-10-27T10:00:00.000'),
        isPresent: true,
      );

      final json = attendance.toJson();

      expect(json['course_id'], 'c1');
      expect(json['student_id'], 's1');
      expect(json['date'], '2023-10-27T10:00:00.000');
      expect(json['is_present'], true);
    });
  });
}
