// Lokasi file: lib/repositories/course_repository.dart

import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;

  // Menerima CourseService melalui constructor
  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    // Repository memanggil fungsi dari service
    return service.loadCourses();
  }
}