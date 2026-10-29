// Lokasi: lib/screens/course_form_page.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/student_header.dart';

class CourseFormPage extends StatefulWidget {
  // TAHAP 7: Parameter opsional, jika diisi berarti mode Edit
  final Course? courseToEdit;

  const CourseFormPage({super.key, this.courseToEdit});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();
  String _status = 'planned';
  bool _isSaving = false; 

  @override
  void initState() {
    super.initState();
    // TAHAP 7: Jika mode edit, isi form dengan data lama
    if (widget.courseToEdit != null) {
      _codeController.text = widget.courseToEdit!.code;
      _titleController.text = widget.courseToEdit!.title;
      _creditsController.text = widget.courseToEdit!.credits.toString();
      _status = widget.courseToEdit!.status;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final submittedCourse = Course(
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );

    try {
      if (widget.courseToEdit != null) {
        // Mode EDIT: Panggil editCourse dan kirimkan ID
        await context.read<CourseProvider>().editCourse(widget.courseToEdit!.id!, submittedCourse);
      } else {
        // Mode TAMBAH BARU
        await context.read<CourseProvider>().addCourse(submittedCourse);
      }
      
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.courseToEdit != null ? 'Course berhasil diperbarui!' : 'Course berhasil ditambahkan!'), 
          backgroundColor: Colors.green
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (context.mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.courseToEdit != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Course' : 'Tambah Course')),
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
                    readOnly: isEditMode, // TAHAP 7: Code tidak boleh diubah saat edit
                    decoration: InputDecoration(
                      labelText: 'Kode Mata Kuliah', 
                      border: const OutlineInputBorder(),
                      fillColor: isEditMode ? Colors.grey.shade200 : null,
                      filled: isEditMode,
                    ),
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
                    onPressed: _isSaving ? null : _submitForm,
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