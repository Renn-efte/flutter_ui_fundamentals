// Lokasi: lib/providers/course_provider.dart
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;
  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // TAHAP 6: Menambah course dan me-refresh daftar secara otomatis
  Future<void> addCourse(Course course) async {
    await repository.createCourse(course);
    await loadCourses(); // Refresh isi list dengan data terbaru
  }

  // TAHAP 7: Memperbarui course dan me-refresh daftar secara otomatis
  Future<void> editCourse(int id, Course course) async {
    await repository.updateCourse(id, course);
    await loadCourses(); 
  }

  // TAHAP 8: Menghapus course dari database dan membersihkan data favorites yatim
  Future<void> removeCourseData(int id, String code) async {
    await repository.deleteCourse(id);
    
    // Hapus dari favorites agar tidak ada data yatim
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    }
    
    await loadCourses(); // Refresh daftar data
  }

  bool isFavorite(String code) => _favorites.contains(code);

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }

  List<Course> get favoriteCourses {
    return courses.where((c) => _favorites.contains(c.code)).toList();
  }
}