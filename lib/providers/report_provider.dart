import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/constants.dart';

class ReportProvider with ChangeNotifier {
  Map<String, dynamic>? _moodSummary;
  bool _isLoading = false;

  Map<String, dynamic>? get moodSummary => _moodSummary;
  bool get isLoading => _isLoading;

  Future<void> fetchMonthlyMoodSummary(int userId, int month, int year) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(
          '${APIConfig.fetchReportSummary}=$userId&month=$month&year=$year'));

      if (response.statusCode == 200) {
        _moodSummary = json.decode(response.body);
      } else {
        _moodSummary = null;
      }
    } catch (error) {
      _moodSummary = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<DateTime>> fetchMoodDates(int userId, int month, int year) async {
    try {
      final response = await http.get(Uri.parse(
          '${APIConfig.fetchReportDates}=$userId&month=$month&year=$year'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((date) => DateTime.parse(date)).toList();
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}
