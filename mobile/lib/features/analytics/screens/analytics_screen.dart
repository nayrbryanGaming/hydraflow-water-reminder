import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Weekly Overview', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 3000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(color: AppColors.textSecondary, fontSize: 12);
                          String text;
                          switch (value.toInt()) {
                            case 0: text = 'Mon'; break;
                            case 1: text = 'Tue'; break;
                            case 2: text = 'Wed'; break;
                            case 3: text = 'Thu'; break;
                            case 4: text = 'Fri'; break;
                            case 5: text = 'Sat'; break;
                            case 6: text = 'Sun'; break;
                            default: text = ''; break;
                          }
                          return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _buildBar(0, 1500),
                    _buildBar(1, 2000),
                    _buildBar(2, 2200),
                    _buildBar(3, 1800),
                    _buildBar(4, 2500),
                    _buildBar(5, 1200),
                    _buildBar(6, 2000),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildStatCard('Current Streak', '🔥 5 Days'),
            const SizedBox(height: 16),
            _buildStatCard('Average Intake', '💧 1,850 ml/day'),
            const SizedBox(height: 16),
            _buildStatCard('Performance', '📈 85% Goal Completion'),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primaryBlue,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
             Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
