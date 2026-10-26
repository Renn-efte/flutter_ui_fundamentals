// Lokasi: lib/screens/home_page.dart
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../providers/course_provider.dart';
import '../models/course.dart'; // Import model Course
import '../main.dart'; // Untuk mengambil variabel studentId dan studentName

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String apiUrl = 'https://course-api-pearl.vercel.app/courses';
  
  // State lokal sementara untuk membuktikan Tahap 3
  List<Course> _apiCourses = [];
  bool _isLoadingApi = false;

  Future<void> fetchCoursesFromApi() async {
    setState(() {
      _isLoadingApi = true;
    });
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          // Konversi response JSON list menjadi List<Course>
          _apiCourses = data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
        });
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        _isLoadingApi = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final totalFavorites = provider.favorites.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Box Identitas Mahasiswa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$studentId • $studentName',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue.shade900),
              ),
            ),
            const SizedBox(height: 16),
            
            // Tombol Fetch API
            ElevatedButton.icon(
              onPressed: fetchCoursesFromApi,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Tarik Data API & Convert ke Model'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12)
              ),
            ),
            const SizedBox(height: 24),
            
            // Render UI List Course dari API
            _isLoadingApi 
              ? const Center(child: CircularProgressIndicator()) 
              : _apiCourses.isEmpty 
                ? const Text('Klik tombol di atas untuk memuat data dari REST API.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _apiCourses.length,
                    itemBuilder: (context, index) {
                      final course = _apiCourses[index]; // Ini sudah bentuk Object Course
                      final isDone = course.status.toLowerCase() == 'done';
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.blue.shade100)
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${course.code} - ${course.title}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${course.credits} SKS | ID: ${course.id}'),
                                  Text(
                                    course.status,
                                    style: TextStyle(
                                      fontSize: 14, 
                                      fontWeight: FontWeight.bold,
                                      color: isDone ? Colors.teal : Colors.blue.shade700
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}