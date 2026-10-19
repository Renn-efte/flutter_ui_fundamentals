
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/student_header.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  int _columnsForWidth(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Dengarkan data dari provider (Watch)
    final provider = context.watch<CourseProvider>();
    
    // 2. Ambil hanya course yang disukai
    final favCourses = provider.favoriteCourses;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Courses')),
      body: Column(
        children: [
          const StudentHeader(),
          Expanded(
            child: favCourses.isEmpty
                ? const Center(child: Text('Belum ada course favorit.'))
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
                        itemCount: favCourses.length,
                        itemBuilder: (context, index) {
                          final course = favCourses[index];
                          return CourseCard(
                            course: course,
                            isFavorite: true, // Karena ini list favorite, pasti true
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