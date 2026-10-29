// Lokasi: lib/services/course_supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    // Menarik data dari tabel 'courses' dan mengurutkannya berdasarkan id
    final data = await supabase
        .from('courses')
        .select()
        .order('id');

    // Konversi hasil JSON dari Supabase menjadi List<Course>
    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Sisa method diisi UnimplementedError sementara agar tidak error saat di-compile
  // TAHAP 13: Fungsi POST/INSERT ke Supabase
  @override
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select() // Mengembalikan data yang baru di-insert
        .single(); // Pastikan hanya 1 baris yang dikembalikan

    return Course.fromJson(row);
  }

  // TAHAP 14: Fungsi PUT/UPDATE ke Supabase
  @override
  Future<void> updateCourse(int id, Course course) async {
    await supabase
        .from('courses')
        .update(course.toJson())
        .eq('id', id); // PENTING: Memastikan hanya data dengan id ini yang diubah
  }

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}