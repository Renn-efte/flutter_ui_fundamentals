
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/student_header.dart';
import 'course_form_page.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // TAHAP 13: 2. Tampilkan status favorite pada DetailPage dengan Consumer/watch
    final isFav = context.watch<CourseProvider>().isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        actions: [
          // TAHAP 7: Tombol Edit (Akan mengarahkan ke form dan mengirim data course)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(courseToEdit: course),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Hapus Course'),
                  content: Text('Apakah Anda yakin ingin menghapus course ${course.code}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext), // Tutup dialog (batal)
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext); // Tutup dialog konfirmasi terlebih dulu
                        
                        try {
                          // Panggil fungsi Provider
                          await context.read<CourseProvider>().removeCourseData(course.id!, course.code);
                          
                          if (!context.mounted) return;
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Course berhasil dihapus'), backgroundColor: Colors.red),
                          );
                          Navigator.pop(context); // Tutup halaman detail, kembali ke list
                          
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                          );
                        }
                      },
                      child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),

          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(course.code);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StudentHeader(),
            const SizedBox(height: 20),
            Text(course.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Kode Mata Kuliah: ${course.code}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Jumlah SKS: ${course.credits}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status: ${course.status}', style: const TextStyle(fontSize: 16)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}