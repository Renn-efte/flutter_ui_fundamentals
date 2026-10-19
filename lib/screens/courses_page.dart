import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/student_header.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

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
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(
                        child: Text(
                          'Terjadi Kesalahan:\n${provider.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : provider.courses.isEmpty
                        ? const Center(child: Text('Tidak ada data course.'))
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