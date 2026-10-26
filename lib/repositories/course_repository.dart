// Lokasi: lib/repositories/course_repository.dart
import '../models/course.dart';
import '../services/course_api_service.dart'; // Import service baru

class CourseRepository {
  final CourseApiService service; // Gunakan CourseApiService

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses(); // Panggil method dari API service
  }
}