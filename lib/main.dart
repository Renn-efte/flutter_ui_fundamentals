import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString('assets/data/student_data.json');
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  // --- REUSABLE WIDGET 1: Kartu Ringkasan (Summary Card) ---
  Widget buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  // --- REUSABLE WIDGET 2: Item Daftar Materi (Course Item) ---
  Widget buildCourseItem(Map<String, dynamic> course) {
    final status = course['status'] as String;
    
    // Logika kondisional untuk warna, teks, dan ikon status
    Color statusColor = status == 'done' ? Colors.green : (status == 'active' ? Colors.orange : Colors.grey);
    IconData statusIcon = status == 'done' ? Icons.check_circle : (status == 'active' ? Icons.play_circle_fill : Icons.schedule);
    String statusText = status == 'done' ? 'Selesai' : (status == 'active' ? 'Berjalan' : 'Rencana');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor, size: 32),
        title: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        // Menampilkan kode dan credits (SKS) dari JSON
        subtitle: Text('${course['code']} • ${course['credits']} SKS'),
        trailing: Text(
          statusText,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Warna latar belakang agar Card terlihat menonjol
      appBar: AppBar(
        title: const Text('Learning Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          // Menghitung total SKS dari daftar courses
          int totalSks = 0;
          for (var course in courses) {
            totalSks += (course['credits'] as int);
          }

          return Column(
            children: [
              // 1. BAGIAN PROFIL & IDENTITAS
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/profile.jpg.jpeg'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student['name'],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'NIM: ${student['nim']}',
                            style: TextStyle(fontSize: 14, color: Colors.blue.shade100),
                          ),
                          const SizedBox(height: 8),
                          // Menampilkan field tambahan (Program Studi)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              student['program'],
                              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. BAGIAN KARTU RINGKASAN (Memanggil Reusable Widget 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    buildSummaryCard('Total Topik', '${courses.length}', Icons.my_library_books, Colors.blue),
                    buildSummaryCard('Total SKS', '$totalSks', Icons.school, Colors.orange),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Daftar Materi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),

              // 3. BAGIAN DAFTAR LIST DINAMIS (Memanggil Reusable Widget 2)
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return buildCourseItem(courses[index] as Map<String, dynamic>);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}