import 'package:flutter/material.dart';
import '../main.dart'; // Ngambil variabel studentId dan studentName dari main.dart

class StudentHeader extends StatelessWidget {
  const StudentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: const Text(
        'Mahasiswa: $studentId\n$studentName',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }
}