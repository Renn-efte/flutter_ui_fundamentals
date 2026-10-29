//Derren Wardhana - 2415051073
// ignore_for_file: unused_local_variable, unused_import
//"Tambahkan error handling dan security hardening dasar"

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/course_api_service.dart'; 
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/home_page.dart';
import 'screens/courses_page.dart';
import 'screens/favorites_page.dart';
import 'screens/profile_page.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';

const String studentName = 'Derren Wardhana'; // Pastikan nama Bli benar
const String studentId = '2415051073'; // Pastikan NIM Bli benar

void main() async {
  // Tambahkan baris ini untuk memastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // TAHAP 10: Inisialisasi Supabase 
  await Supabase.initialize(
    url: 'https://dquvawyjxltbekddfzaw.supabase.co',
    publishableKey: 'sb_publishable_j02DccIFVjzGYjsKr4U80g_OZPsZD8h',
  );

  const String apiBaseUrl = 'https://course-api-pearl.vercel.app';
  
  // TAHAP 9: Kita mendefinisikan sumber datanya menggunakan tipe CourseDataSource
  // final CourseDataSource dataSource = CourseApiService(apiBaseUrl); 
  final CourseDataSource dataSource = CourseSupabaseService();
  final courseRepository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(courseRepository)..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
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

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  // TAHAP 13: Tambahkan FavoritesPage ke dalam list menu
  final List<Widget> _pages = const [
    HomePage(),
    CoursesPage(),
    FavoritesPage(),
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
                NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'Favorites'), // Menu baru
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
                  NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')), // Menu baru
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