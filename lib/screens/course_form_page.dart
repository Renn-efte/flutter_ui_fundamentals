// Lokasi: lib/screens/course_form_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/student_header.dart';

class CourseFormPage extends StatefulWidget {
  const CourseFormPage({super.key});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();
  String _status = 'planned'; // Default value

  bool _isSaving = false; // Flag untuk indikator loading dan disable tombol submit

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true; // Nonaktifkan tombol dan tampilkan loading
    });

    final newCourse = Course(
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );

    try {
      // Panggil Provider (yang akan memanggil Repository -> Service)
      await context.read<CourseProvider>().addCourse(newCourse);
      
      if (!context.mounted) return; // Mencegah pemanggilan context jika widget sudah dibuang
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil ditambahkan!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (context.mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const StudentHeader(),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(labelText: 'Kode Mata Kuliah', border: OutlineInputBorder()),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Kode tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Nama Mata Kuliah', border: OutlineInputBorder()),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _creditsController,
                    decoration: const InputDecoration(labelText: 'Jumlah SKS', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'SKS tidak boleh kosong';
                      if (int.tryParse(value.trim()) == null) return 'SKS harus berupa angka';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'planned', child: Text('Planned')),
                      DropdownMenuItem(value: 'active', child: Text('Active')),
                      DropdownMenuItem(value: 'done', child: Text('Done')),
                    ],
                    onChanged: (value) => setState(() => _status = value!),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _submitForm, // Nonaktifkan jika isSaving true
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSaving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Simpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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