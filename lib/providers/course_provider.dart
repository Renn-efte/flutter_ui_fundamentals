
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

  // TAHAP 13: Fungsi mengecek status favorite (agar lebih rapi dipanggil di UI)
  bool isFavorite(String code) => _favorites.contains(code);

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }

  // TAHAP 13: Tambahkan getter khusus untuk memfilter course yang difavoritkan
  List<Course> get favoriteCourses {
    return courses.where((c) => _favorites.contains(c.code)).toList();
  }
}