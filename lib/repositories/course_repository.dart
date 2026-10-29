// Lokasi: lib/repositories/course_repository.dart
import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  final CourseApiService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }

  // TAHAP 6: Fungsi untuk meneruskan POST dari service
  Future<Course> createCourse(Course course) {
    return service.createCourse(course);
  }

  // TAHAP 7: Fungsi meneruskan PUT dari service
  Future<void> updateCourse(int id, Course course) {
    return service.updateCourse(id, course);
  }

  // TAHAP 8: Fungsi meneruskan DELETE dari service
  Future<void> deleteCourse(int id) {
    return service.deleteCourse(id);
  }
}