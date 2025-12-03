import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrack/models/professor.dart';

void main() {
  group('Professor Model Test', () {
    test('fromJson creates correct Professor object', () {
      final json = {
        'id': 'p1',
        'name': 'Dr. Smith',
        'email': 'smith@example.com',
        'course_assignments': [
          {
            'course': {
              'id': 'c1',
              'name': 'Math',
              'code': 'M101',
              'semester': '1',
            },
            'classroom': 'A101',
            'day_of_week': 1,
            'start_time': '10:00',
            'end_time': '11:00',
          }
        ]
      };

      final professor = Professor.fromJson(json);

      expect(professor.id, 'p1');
      expect(professor.name, 'Dr. Smith');
      expect(professor.email, 'smith@example.com');
      expect(professor.assignedCourses.length, 1);
      expect(professor.assignedCourses[0].course.name, 'Math');
      expect(professor.assignedCourses[0].dayName, 'Monday');
    });
  });

  group('CourseAssignment Model Test', () {
    test('dayName returns correct day', () {
      final assignment = CourseAssignment(
        course: Course(id: 'c1', name: 'Math', code: 'M101', semester: '1'),
        classroom: 'A101',
        dayOfWeek: 1,
        startTime: '10:00',
        endTime: '11:00',
      );

      expect(assignment.dayName, 'Monday');
    });
  });
}
