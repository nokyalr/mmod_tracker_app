import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data for the chart
    final data = [
      MoodData('Happy', 10),
      MoodData('Sad', 5),
      MoodData('Anxious', 7),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Monthly Report')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Mood Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 12, // Adjust according to your data
                    barGroups: data
                        .asMap()
                        .map(
                          (index, moodData) => MapEntry(
                            index,
                            BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: moodData.count.toDouble(),
                                  color: Colors.orange,
                                  width: 20,
                                ),
                              ],
                              showingTooltipIndicators: [0],
                            ),
                          ),
                        )
                        .values
                        .toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < data.length) {
                              return Text(
                                data[value.toInt()].category,
                                style: TextStyle(fontSize: 12),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data Model for Chart
class MoodData {
  final String category; // Mood category (e.g., Happy, Sad)
  final int count; // Number of occurrences for the mood

  MoodData(this.category, this.count);
}
