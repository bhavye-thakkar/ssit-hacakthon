
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/mock_data_service.dart';
import '../models/waste_bin.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Consumer<MockDataService>(
        builder: (context, mockDataService, child) {
          final bins = mockDataService.wasteBins;
          final normalBins = bins.where((b) => b.status == BinStatus.normal).length;
          final fullBins = bins.where((b) => b.status == BinStatus.full).length;
          final overflowingBins = bins.where((b) => b.status == BinStatus.overflowing).length;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text('Bins Status Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 16),

              // Bins Status Chart with enhanced graphics
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated background rings
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                    ).animate()
                        .fadeIn(duration: 1000.ms, delay: 300.ms)
                        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withOpacity(0.15),
                          width: 1.5,
                        ),
                      ),
                    ).animate()
                        .fadeIn(duration: 1000.ms, delay: 500.ms)
                        .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1)),

                    PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: normalBins.toDouble(),
                            title: 'Normal\n$normalBins',
                            color: Colors.green,
                            radius: 60,
                            badgeWidget: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 18,
                              ),
                            ).animate()
                                .fadeIn(duration: 400.ms, delay: 1000.ms)
                                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
                            badgePositionPercentageOffset: 1.3,
                          ),
                          PieChartSectionData(
                            value: fullBins.toDouble(),
                            title: 'Full\n$fullBins',
                            color: Colors.orange,
                            radius: 60,
                            badgeWidget: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.warning,
                                color: Colors.orange,
                                size: 18,
                              ),
                            ).animate()
                                .fadeIn(duration: 400.ms, delay: 1200.ms)
                                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
                            badgePositionPercentageOffset: 1.3,
                          ),
                          PieChartSectionData(
                            value: overflowingBins.toDouble(),
                            title: 'Overflow\n$overflowingBins',
                            color: Colors.red,
                            radius: 60,
                            badgeWidget: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 18,
                              ),
                            ).animate()
                                .fadeIn(duration: 400.ms, delay: 1400.ms)
                                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
                            badgePositionPercentageOffset: 1.3,
                          ),
                        ],
                        sectionsSpace: 4,
                        centerSpaceRadius: 50,
                        startDegreeOffset: 180,
                      ),
                    ).animate()
                        .fadeIn(duration: 800.ms, delay: 700.ms)
                        .rotate(duration: 1500.ms, begin: -0.2, end: 0),
                    // Center loading indicator with animated elements
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2,
                            color: const Color(0xFF4CAF50),
                            size: 26,
                          ).animate()
                              .rotate(duration: 2000.ms)
                              .then()
                              .rotate(duration: 2000.ms, begin: 0, end: 0.5),
                          const SizedBox(height: 2),
                          Text(
                            '${bins.length}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ).animate()
                              .fadeIn(duration: 400.ms, delay: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                          Text(
                            'Total Bins',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ).animate()
                              .fadeIn(duration: 400.ms, delay: 800.ms),
                        ],
                      ),
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 800.ms)
                        .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1))
                        .then()
                        .shimmer(duration: 2000.ms, color: const Color(0xFF4CAF50).withOpacity(0.1)),
                  ],
                ),
              ).animate()
                  .fadeIn(duration: 800.ms, delay: 200.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

              const SizedBox(height: 32),
              const Text('Bins by Zone', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 400.ms)
                  .slideX(begin: 0.2, end: 0),
              const SizedBox(height: 16),

              // Bins by Zone Chart
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 15,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            'Zone ${groupIndex + 1}\n${rod.toY.toInt()} bins',
                            const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    titlesData: const FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 3,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: bins.where((b) => b.zone == 'Zone 1').length.toDouble(),
                            color: Colors.blue,
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: bins.where((b) => b.zone == 'Zone 2').length.toDouble(),
                            color: Colors.blue,
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: bins.where((b) => b.zone == 'Zone 3').length.toDouble(),
                            color: Colors.blue,
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            toY: bins.where((b) => b.zone == 'Zone 4').length.toDouble(),
                            color: Colors.blue,
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            toY: bins.where((b) => b.zone == 'Zone 5').length.toDouble(),
                            color: Colors.blue,
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate()
                  .fadeIn(duration: 800.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 32),
              const Text('Waste Collection Trends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 800.ms)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 16),

              // Waste Collection Trends
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 500,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: mockDataService.historicalData.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.totalWasteCollected);
                        }).toList(),
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: Colors.green,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.green.withOpacity(0.1),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withOpacity(0.3),
                              Colors.green.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.green,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y.toStringAsFixed(0)} kg',
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ).animate()
                  .fadeIn(duration: 800.ms, delay: 1000.ms)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),

              const SizedBox(height: 32),
              const Text('Bins Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 1200.ms)
                  .slideX(begin: 0.2, end: 0),
              const SizedBox(height: 16),

              // Bins Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard('Total Bins', bins.length.toString(), Colors.blue, Icons.inventory_2)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1300.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard('Active Bins', bins.where((b) => b.status != BinStatus.offline).length.toString(), Colors.green, Icons.check_circle)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1400.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard('Full Bins', fullBins.toString(), Colors.orange, Icons.warning)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1500.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard('Overflow', overflowingBins.toString(), Colors.red, Icons.error)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1600.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
