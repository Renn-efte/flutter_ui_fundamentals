import 'package:flutter/material.dart';

// 1. Membuat class yang extends ChangeNotifier
class CourseProvider extends ChangeNotifier {
  
  // 2. Tambahkan collection favorites
  final Set<String> _favorites = {};

  // Getter (opsional) agar widget lain bisa membaca isi Set favorites
  Set<String> get favorites => _favorites;

  // 3. Tambahkan method toggleFavorite()
  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    
    // 4. Pastikan notifyListeners() dipanggil setelah state berubah
    // Ini fungsinya sebagai "toa" untuk ngasih tau UI: "Woi, data berubah nih, update layarnya dong!"
    notifyListeners();
  }
}