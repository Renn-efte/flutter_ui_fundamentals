// Lokasi: lib/screens/courses_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/student_header.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart'; // Import ErrorView yang baru dibuat
import 'course_detail_page.dart';
import 'course_form_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  int _columnsForWidth(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final int favoriteCount = provider.favorites.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      // TAMBAHAN TAHAP 6: Tombol mengambang untuk navigasi ke form tambah
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CourseFormPage()),
          );
        },
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const StudentHeader(),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.amber.shade100,
            child: Text(
              'Total Favorites: $favoriteCount',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          
          Expanded(
            // TAHAP 5: Penanganan State yang eksplisit
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator()) // 1. Loading State
                
                : provider.error != null
                    ? ErrorView( // 2. Error State menggunakan custom widget
                        message: 'Terjadi Kesalahan:\n${provider.error}',
                        onRetry: provider.loadCourses, // Memanggil ulang fetch API
                      )
                    
                    : provider.courses.isEmpty
                        ? const Center(child: Text('Data course belum tersedia')) // 3. Empty State
                        
                        // 4. Success State
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              return GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _columnsForWidth(constraints.maxWidth),
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 2.2,
                                ),
                                itemCount: provider.courses.length,
                                itemBuilder: (context, index) {
                                  final course = provider.courses[index];
                                  final isFav = provider.favorites.contains(course.code);

                                  return CourseCard(
                                    course: course,
                                    isFavorite: isFav,
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CourseDetailPage(course: course),
                                        ),
                                      );
                                    },
                                    onFavoriteChanged: () {
                                      context.read<CourseProvider>().toggleFavorite(course.code);
                                    },
                                  );
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}