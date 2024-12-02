import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mood_tracker_app/screens/suggestion_screen.dart';
import 'package:mood_tracker_app/widgets/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/report_provider.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';
import 'user_screen.dart';
import '../../widgets/bottom_navigation.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedIndex = 1;
  DateTime _selectedMonth = DateTime.now();
  List<DateTime> _moodDates = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchDataForSelectedMonth();
    });
  }

  void _fetchDataForSelectedMonth() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?['user_id'];

    if (userId != null) {
      final reportProvider =
          Provider.of<ReportProvider>(context, listen: false);
      await reportProvider.fetchMonthlyMoodSummary(
          userId, _selectedMonth.month, _selectedMonth.year);
      _moodDates = await reportProvider.fetchMoodDates(
          userId, _selectedMonth.month, _selectedMonth.year);
      setState(() {});
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomeScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => ReportScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SuggestionScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => UserScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    int selectedYear = _selectedMonth.year;
    int selectedMonth = _selectedMonth.month;

    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text('Select Month',
                style: TextStyle(color: Color(0xFFE68C52))),
            content: Row(
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  items: List.generate(10, (index) {
                    final year = DateTime.now().year - index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text('$year'),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setStateDialog(() {
                        selectedYear = value;
                      });
                    }
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: selectedMonth,
                  items: List.generate(12, (index) {
                    final month = index + 1;
                    return DropdownMenuItem(
                      value: month,
                      child: Text(
                        DateFormat.MMMM().format(DateTime(0, month)),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setStateDialog(() {
                        selectedMonth = value;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFFE68C52)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(
                      DateTime(selectedYear, selectedMonth)); // Pilih tanggal
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFFE68C52)),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedMonth = result;
      });
      _fetchDataForSelectedMonth();
    }
  }

  Widget _buildCalendar() {
    final firstDayOfMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // Days in a week
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: lastDayOfMonth.day,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final day = firstDayOfMonth.add(Duration(days: index));
        final isMoodLogged = _moodDates.any((moodDate) =>
            moodDate.year == day.year &&
            moodDate.month == day.month &&
            moodDate.day == day.day);

        return Container(
          decoration: BoxDecoration(
            color: isMoodLogged ? const Color(0xFFE68C52) : Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            '${day.day}',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalBar(Map<String, dynamic> moodSummary) {
    final int totalMoods = moodSummary.values.reduce((a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE68C52)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Mood Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE68C52),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset('assets/images/bad.png', height: 48),
                  Text(
                    'Bad',
                    style: TextStyle(
                      color: Color(0xFFE68C52),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset('assets/images/poor.png', height: 48),
                  Text(
                    'Poor',
                    style: TextStyle(
                      color: Color(0xFFE68C52),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset('assets/images/medium.png', height: 48),
                  Text(
                    'Medium',
                    style: TextStyle(
                      color: Color(0xFFE68C52),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset('assets/images/good.png', height: 48),
                  Text(
                    'Good',
                    style: TextStyle(
                      color: Color(0xFFE68C52),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset('assets/images/excellent.png', height: 48),
                  Text(
                    'Excellent',
                    style: TextStyle(
                      color: Color(0xFFE68C52),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 42,
              width: double.infinity,
              color: Color(0xFFD9D9D9),
              child: Row(
                children: [
                  _buildMoodBarSegment(moodSummary['score_1'] ?? 0, totalMoods,
                      Color(0xFFF64927)),
                  _buildMoodBarSegment(moodSummary['score_2'] ?? 0, totalMoods,
                      Color(0xFFF9C26D)),
                  _buildMoodBarSegment(moodSummary['score_3'] ?? 0, totalMoods,
                      Color(0xFFFFDE4B)),
                  _buildMoodBarSegment(moodSummary['score_4'] ?? 0, totalMoods,
                      Color(0xFFC9E23D)),
                  _buildMoodBarSegment(moodSummary['score_5'] ?? 0, totalMoods,
                      Color(0xFF76D650)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '${moodSummary['score_1'] ?? 0}',
                style: TextStyle(
                  color: Color(0xFFF64927),
                  fontSize: 12,
                ),
              ),
              Text(
                '${moodSummary['score_2'] ?? 0}',
                style: TextStyle(
                  color: Color(0xFFF9C26D),
                  fontSize: 12,
                ),
              ),
              Text(
                '${moodSummary['score_3'] ?? 0}',
                style: TextStyle(
                  color: Color(0xFFFFDE4B),
                  fontSize: 12,
                ),
              ),
              Text(
                '${moodSummary['score_4'] ?? 0}',
                style: TextStyle(
                  color: Color(0xFFC9E23D),
                  fontSize: 12,
                ),
              ),
              Text(
                '${moodSummary['score_5'] ?? 0}',
                style: TextStyle(
                  color: Color(0xFF76D650),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMotivationalMessage(Map<String, dynamic> moodSummary) {
    final moodCounts = [
      moodSummary['score_1'] ?? 0,
      moodSummary['score_2'] ?? 0,
      moodSummary['score_3'] ?? 0,
      moodSummary['score_4'] ?? 0,
      moodSummary['score_5'] ?? 0,
    ];

    final totalMoods = moodCounts.reduce((a, b) => a + b);

    if (totalMoods == 0) {
      return 'No mood data available for this month. Start tracking your mood today!';
    }

    // Urutkan mood berdasarkan jumlah
    final maxMoodCount = moodCounts.reduce((a, b) => a > b ? a : b);
    final dominantMoods = moodCounts
        .asMap()
        .entries
        .where((entry) => entry.value == maxMoodCount)
        .map((entry) => entry.key)
        .toList();

    if (dominantMoods.length > 1) {
      // Seri antara beberapa mood
      final moodLabels = ['Bad', 'Poor', 'Medium', 'Good', 'Excellent'];
      final tiedMoodNames =
          dominantMoods.map((index) => moodLabels[index]).join(' and ');
      return 'Your moods this month are equally balanced between $tiedMoodNames. Maintain the momentum and keep tracking!';
    }

    // Tidak seri: pilih pesan berdasarkan mood dominan
    final messages = {
      0: [
        'Keep going, better days are ahead!',
        'It’s okay to feel down sometimes. You got this!',
        'Every day is a new beginning. Stay strong!',
      ],
      1: [
        'Stay strong, you are doing great!',
        'It’s just a rough patch. Keep pushing!',
        'You are stronger than you think!',
      ],
      2: [
        'Keep up the good work!',
        'You are doing well, keep it up!',
        'Stay positive and keep moving forward!',
      ],
      3: [
        'You are doing amazing!',
        'Great job! Keep the momentum going!',
        'You are on the right track!',
      ],
      4: [
        'Excellent! Keep shining!',
        'You are a star! Keep up the great work!',
        'Fantastic! Keep spreading positivity!',
      ],
    };

    final random = Random();
    final selectedMessages = messages[dominantMoods[0]]!;
    return selectedMessages[random.nextInt(selectedMessages.length)];
  }

  Widget _buildMoodBarSegment(int count, int total, Color color) {
    if (count == 0) {
      return const SizedBox();
    }

    return Expanded(
      flex: count,
      child: Container(
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final moodSummary = reportProvider.moodSummary;

    return Scaffold(
      appBar: CustomAppBar(
        imagePath: 'assets/images/default_profile.png',
        titleText: 'Report',
        useBorder: true,
        imageHeight: 48,
        useImage: false,
        backgroundColor: Colors.white,
        textColor: const Color(0xFFE68C52),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Color(0xFFE68C52)),
                      onPressed: () {
                        setState(() {
                          _selectedMonth = DateTime(
                            _selectedMonth.year,
                            _selectedMonth.month - 1,
                          );
                        });
                        _fetchDataForSelectedMonth();
                      },
                    ),
                    GestureDetector(
                      onTap: () => _showMonthPicker(context),
                      child: Text(
                        DateFormat('MMMM - yyyy').format(_selectedMonth),
                        style: const TextStyle(
                            fontSize: 18, color: Color(0xFFE68C52)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Color(0xFFE68C52)),
                      onPressed: () {
                        setState(() {
                          _selectedMonth = DateTime(
                            _selectedMonth.year,
                            _selectedMonth.month + 1,
                          );
                        });
                        _fetchDataForSelectedMonth();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCalendar(),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              if (reportProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (moodSummary == null)
                const Center(child: Text('No data available for this month'))
              else ...[
                _buildHorizontalBar(moodSummary),
                const SizedBox(
                    height: 16), // Pemberi jarak antara Stats & Motivasi
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFFE68C52)),
                  ),
                  child: Text(
                    _getMotivationalMessage(moodSummary),
                    style: TextStyle(
                      color: Color(0xFFE68C52),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
