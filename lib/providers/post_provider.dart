import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/constants.dart';

class PostProvider with ChangeNotifier {
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get posts => _posts;
  bool get isLoading => _isLoading;

  // Fungsi untuk mengambil postingan dari backend
  Future<void> fetchPosts() async {
    _isLoading = true; // Mulai loading
    notifyListeners();

    final url = APIConfig.postsUrl; // Ambil URL dari constants.dart

    try {
      // Membatasi waktu request untuk menghindari macet
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Timeout 10 detik

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        _posts = data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } on http.ClientException {
      _posts = []; // Fallback jika terjadi kesalahan koneksi
    } on TimeoutException {
      _posts = []; // Fallback jika waktu habis
    } catch (error) {
      _posts = []; // Fallback jika terjadi kesalahan umum
    } finally {
      _isLoading = false; // Selesai loading
      notifyListeners();
    }
  }

  // Fungsi untuk menghapus semua postingan (digunakan saat logout)
  void clearPosts() {
    _posts = [];
    notifyListeners();
  }
}
