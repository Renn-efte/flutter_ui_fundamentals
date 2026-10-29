// Lokasi: lib/repositories/course_repository.dart
import '../models/course.dart';
import '../services/course_data_source.dart'; // Ubah import ke DataSource

class CourseRepository {
  // TAHAP 9: Dependency diganti menjadi abstraksi CourseDataSource
  final CourseDataSource dataSource;

  CourseRepository(this.dataSource);

  Future<List<Course>> getCourses() => dataSource.getCourses();

  Future<Course> createCourse(Course course) => dataSource.createCourse(course);

  Future<void> updateCourse(int id, Course course) => dataSource.updateCourse(id, course);

  Future<void> deleteCourse(int id) => dataSource.deleteCourse(id);
}