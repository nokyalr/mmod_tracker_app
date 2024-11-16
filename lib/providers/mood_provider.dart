import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../services/api_service.dart';

class MoodProvider with ChangeNotifier {
  List<Mood> _moods = [];

  List<Mood> get moods => _moods;

  Future<void> fetchMoods() async {
    _moods = await ApiService().getMoods();
    notifyListeners();
  }
}
