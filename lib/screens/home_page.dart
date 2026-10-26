
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // TAHAP 2: Import untuk jsonDecode
import 'package:http/http.dart' as http; // TAHAP 2: Import package http

import '../providers/course_provider.dart';
import '../main.dart'; // Untuk mengambil variabel studentId dan studentName

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // TAHAP 2: 1. Buat konstanta apiUrl sesuai endpoint
  static const String apiUrl = 'https://course-api-pearl.vercel.app/coursez';

  // TAHAP 2: 2. Function asynchronous sementara untuk test GET API
  Future<void> testFetchCourses() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        // TAHAP 2: 3. Tampilkan jumlah item pada debugPrint
        debugPrint('✅ Sukses GET API! Jumlah course ditarik: ${data.length}');
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final totalCourses = provider.courses.length;
    final totalFavorites = provider.favorites.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: provider.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
            
            // Row Summary (Courses dan Favorites)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade100)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Courses', style: TextStyle(color: Colors.blueGrey, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text('$totalCourses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade100)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Favorites', style: TextStyle(color: Colors.blueGrey, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text('$totalFavorites', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // TAHAP 2: Tombol sementara untuk memicu HTTP GET
            ElevatedButton.icon(
              onPressed: testFetchCourses,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Test GET API (Lihat Debug Console)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12)
              ),
            ),
            const SizedBox(height: 24),
            
            // List Item Course (Masih pakai data lokal sementara)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.courses.length,
              itemBuilder: (context, index) {
                final course = provider.courses[index];
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
                          course.title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800),
                        ),
                        const SizedBox(height: 8),
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