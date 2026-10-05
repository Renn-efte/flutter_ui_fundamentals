import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Derren Wardhana';
const String studentId = '2415051073';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ResponsiveShell(),
    );
  }
}

// ==========================================
// 1. RESPONSIVE SHELL (Adaptive Navigation)
// ==========================================
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CoursesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
                NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                  NavigationRailDestination(icon: Icon(Icons.school), label: Text('Courses')),
                  NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// 2. REUSABLE WIDGET: APP HEADER IDENTITAS
// ==========================================
class StudentHeader extends StatelessWidget {
  const StudentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Text(
        'Mahasiswa: $studentId - $studentName',
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }
}

// ==========================================
// 3. HOME PAGE
// ==========================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StudentHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang di Dashboard Utama',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Aplikasi ini memuat data mata kuliah secara dinamis langsung dari file JSON lokal.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: const [
                          Icon(Icons.folder_open, color: Colors.blue, size: 36),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Silakan buka menu Courses untuk melihat daftar mata kuliah dari JSON.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. COURSES PAGE (Mengambil data dari JSON)
// ==========================================
class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = loadStudentJsonData();
  }

  // Fungsi memuat file JSON dari assets
  Future<Map<String, dynamic>> loadStudentJsonData() async {
    final jsonString = await rootBundle.loadString('assets/data/student_data.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  int _columnsForWidth(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Course (JSON)')),
      body: Column(
        children: [
          const StudentHeader(),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error memuat JSON: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Data tidak ditemukan'));
                }

                final jsonData = snapshot.data!;
                final List<dynamic> courses = jsonData['courses'] as List<dynamic>;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _columnsForWidth(constraints.maxWidth),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.2,
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index] as Map<String, dynamic>;
                        return CourseCard(
                          course: course,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailPage(course: course),
                              ),
                            );
                            if (result == true && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Aksi berhasil pada course: ${course['title']}')),
                              );
                            }
                          },
                        );
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

// ==========================================
// 5. REUSABLE WIDGET: COURSE CARD
// ==========================================
class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                course['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text('${course['code']} • ${course['credits']} SKS'),
              const SizedBox(height: 4),
              Text(
                'Status: ${course['status'] ?? 'planned'}',
                style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. COURSE DETAIL PAGE
// ==========================================
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course['title'] ?? 'Detail')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StudentHeader(),
            const SizedBox(height: 20),
            Text(course['title'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Kode Mata Kuliah: ${course['code']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Jumlah SKS: ${course['credits']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status Pengerjaan: ${course['status']}', style: const TextStyle(fontSize: 16)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Simpan & Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 7. PROFILE PAGE & FEEDBACK FORM
// ==========================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _nimController;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: studentName);
    _nimController = TextEditingController(text: studentId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil & Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/images/profile.jpg.jpeg'),
            ),
            const SizedBox(height: 12),
            Text(studentName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('NIM: $studentId', style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Form Masukan & Evaluasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nimController,
                    decoration: const InputDecoration(labelText: 'NIM', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.isEmpty ? 'NIM wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Komentar (Min. 5 karakter)', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.length < 5 ? 'Komentar minimal 5 karakter' : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Berhasil'),
                              content: const Text('Feedback Anda telah berhasil dikirim!'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text('Kirim Feedback'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}