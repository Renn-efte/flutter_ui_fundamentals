// Lokasi file: lib/services/course_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/course.dart'; // Import model yang dibuat di Tahap 8

class CourseService {
  Future<List<Course>> loadCourses() async {
    // 1. Ambil data mentah dari file JSON lokal
    final jsonString = await rootBundle.loadString('assets/data/student_data.json');
    
    // 2. Decode JSON menjadi bentuk Map
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;

    // 3. Ubah setiap item Map menjadi object Course menggunakan dari Course.fromJson()
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}