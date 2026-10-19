
import 'package:flutter/material.dart';
import 'models/course.dart';
import 'repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  // 1. Tambahkan repository sebagai dependency
  final CourseRepository repository;

  CourseProvider(this.repository);

  // Variabel untuk mengelola status async (loading, data, error)
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  // 2. Implementasikan loadCourses()
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners(); // Kasih tau UI buat muter-muter (loading)

    try {
      // Ambil data lewat repository
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString(); // Kalau gagal, simpan pesan errornya
    } finally {
      isLoading = false;
      notifyListeners(); // Kasih tau UI kalau loadingnya udah kelar
    }
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }
}