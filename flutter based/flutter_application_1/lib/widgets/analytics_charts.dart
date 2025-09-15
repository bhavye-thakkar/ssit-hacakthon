import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/mock_data_service.dart';
import '../models/waste_bin.dart';

class AnalyticsCharts extends StatefulWidget {
  const AnalyticsCharts({super.key});

  @override
  State<AnalyticsCharts> createState() => _AnalyticsChartsState();
}

class _AnalyticsChartsState extends State<AnalyticsCharts>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = '7d';
  late AnimationController _barAnimationController;
  late Animation<double> _barAnimation;
  late AnimationController _lineAnimationController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Bar chart animation
    _barAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _barAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _barAnimationController, curve: Curves.easeOut),
    );

    // Line chart animation
    _lineAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _lineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _lineAnimationController, curve: Curves.easeInOut),
    );

    // Start animations when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }

  void _onTabChanged() {
    // Restart animations when switching to overview or trends tab
    if (_tabController.index == 0 || _tabController.index == 1) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _barAnimationController.reset();
    _lineAnimationController.reset();
    _barAnimationController.forward();
    _lineAnimationController.forward();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _barAnimationController.dispose();
    _lineAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final bins = dataService.wasteBins;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Analytics & Insights'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) => setState(() => _selectedTimeRange = value),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: '1d', child: Text('Last 24 Hours')),
                  const PopupMenuItem(value: '7d', child: Text('Last 7 Days')),
                  const PopupMenuItem(value: '30d', child: Text('Last 30 Days')),
                  const PopupMenuItem(value: '90d', child: Text('Last 90 Days')),
                ],
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.pie_chart), text: 'Overview'),
                Tab(icon: Icon(Icons.trending_up), text: 'Trends'),
                Tab(icon: Icon(Icons.location_on), text: 'Zones'),
                Tab(icon: Icon(Icons.category), text: 'Types'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(bins, dataService),
              _buildTrendsTab(bins, dataService),
              _buildZonesTab(bins, dataService),
              _buildTypesTab(bins, dataService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(List<WasteBin> bins, MockDataService dataService) {
    final totalBins = bins.length;
    final fullBins = bins.where((b) => b.fillLevel > 0.8).length;
    final overflowBins = bins.where((b) => b.fillLevel > 0.95).length;
    final averageFillLevel = bins.isEmpty
        ? 0.0
        : bins.map((b) => b.fillLevel).reduce((a, b) => a + b) / bins.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics
          _buildMetricsGrid(totalBins, fullBins, overflowBins, averageFillLevel),
          const SizedBox(height: 24),

          // Fill Level Distribution
          _buildFillLevelChart(bins),
          const SizedBox(height: 24),

          // Status Distribution
          _buildStatusChart(bins),
          const SizedBox(height: 24),

          // Efficiency Metrics
          _buildEfficiencyMetrics(bins, dataService),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(int totalBins, int fullBins, int overflowBins, double averageFillLevel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Metrics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildMetricCard('Total Bins', totalBins.toString(), Icons.delete_outline, Colors.blue),
            _buildMetricCard('Full Bins', fullBins.toString(), Icons.warning, Colors.orange),
            _buildMetricCard('Overflow Bins', overflowBins.toString(), Icons.error, Colors.red),
            _buildMetricCard('Avg Fill Level', '${(averageFillLevel * 100).toInt()}%', Icons.pie_chart, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFillLevelChart(List<WasteBin> bins) {
    final ranges = [
      {'min': 0.0, 'max': 0.2, 'label': '0-20%', 'count': 0},
      {'min': 0.2, 'max': 0.4, 'label': '20-40%', 'count': 0},
      {'min': 0.4, 'max': 0.6, 'label': '40-60%', 'count': 0},
      {'min': 0.6, 'max': 0.8, 'label': '60-80%', 'count': 0},
      {'min': 0.8, 'max': 1.0, 'label': '80-100%', 'count': 0},
    ];

    for (final bin in bins) {
      for (final range in ranges) {
        if (bin.fillLevel >= (range['min'] as num).toDouble() &&
            (bin.fillLevel < (range['max'] as num).toDouble() ||
                (range['max'] == 1.0 && bin.fillLevel == 1.0))) {
          range['count'] = (range['count'] as int) + 1;
        }
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fill Level Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: ranges.map((range) {
                    final count = range['count'] as int;
                    final percentage = bins.isEmpty ? 0.0 : (count / bins.length) * 100;

                    return PieChartSectionData(
                      color: _getFillLevelColor((range['min'] as num).toDouble()),
                      value: count.toDouble(),
                      title: '${percentage.toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: ranges.map((range) {
                final count = range['count'] as int;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: _getFillLevelColor((range['min'] as num).toDouble()),
                    ),
                    const SizedBox(width: 4),
                    Text('${range['label']}: $count'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChart(List<WasteBin> bins) {
    final statusCounts = <BinStatus, int>{};
    for (final status in BinStatus.values) {
      statusCounts[status] = bins.where((b) => b.status == status).length;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bin Status Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _barAnimation,
                builder: (context, child) {
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: statusCounts.values.isEmpty ? 1 : statusCounts.values.reduce((a, b) => a > b ? a : b).toDouble(),
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final status = BinStatus.values[value.toInt()];
                              return Text(
                                status.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: statusCounts.entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key.index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble() * _barAnimation.value,
                              color: _getStatusColor(entry.key),
                              width: 20,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEfficiencyMetrics(List<WasteBin> bins, MockDataService dataService) {
    final historicalData = dataService.historicalData;
    final recentData = historicalData.take(7).toList();

    final avgEfficiency = recentData.isEmpty
        ? 0.0
        : recentData.map((d) => d.efficiency).reduce((a, b) => a + b) / recentData.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Efficiency Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildEfficiencyCard(
                    'Collection Efficiency',
                    '${avgEfficiency.toStringAsFixed(1)}%',
                    Icons.speed,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEfficiencyCard(
                    'Route Optimization',
                    '15%',
                    Icons.route,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildEfficiencyCard(
                    'Fuel Efficiency',
                    '8.5 km/L',
                    Icons.local_gas_station,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEfficiencyCard(
                    'Time Savings',
                    '2.3 hrs',
                    Icons.access_time,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEfficiencyCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab(List<WasteBin> bins, MockDataService dataService) {
    final historicalData = dataService.historicalData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historical Trends',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Waste Collection Trend
          _buildTrendChart(
            'Waste Collection Trend',
            historicalData.map((d) => d.totalWasteCollected).toList(),
            historicalData.map((d) => DateFormat('MMM d').format(d.date)).toList(),
            'kg',
            Colors.green,
          ),

          const SizedBox(height: 24),

          // Efficiency Trend
          _buildTrendChart(
            'Efficiency Trend',
            historicalData.map((d) => d.efficiency).toList(),
            historicalData.map((d) => DateFormat('MMM d').format(d.date)).toList(),
            '%',
            Colors.blue,
          ),

          const SizedBox(height: 24),

          // Alerts Trend
          _buildTrendChart(
            'Alerts Generated',
            historicalData.map((d) => d.alertsGenerated.toDouble()).toList(),
            historicalData.map((d) => DateFormat('MMM d').format(d.date)).toList(),
            'count',
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(String title, List<double> values, List<String> labels, String unit, Color color) {
    if (values.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text('No data available for $title'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _lineAnimation,
                builder: (context, child) {
                  // Calculate how many points to show based on animation progress
                  final totalPoints = values.length;
                  final pointsToShow = (_lineAnimation.value * totalPoints).ceil();
                  final visibleValues = values.take(pointsToShow).toList();
                  final visibleLabels = labels.take(pointsToShow).toList();

                  return LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < visibleLabels.length) {
                                return Text(
                                  visibleLabels[index],
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}$unit',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: visibleValues.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value);
                          }).toList(),
                          isCurved: true,
                          color: color,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: pointsToShow > 0 && pointsToShow <= visibleValues.length,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: color,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: color.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZonesTab(List<WasteBin> bins, MockDataService dataService) {
    final zoneStats = <String, Map<String, dynamic>>{};

    for (final bin in bins) {
      if (!zoneStats.containsKey(bin.zone)) {
        zoneStats[bin.zone] = {
          'total': 0,
          'full': 0,
          'overflow': 0,
          'avgFillLevel': 0.0,
        };
      }

      final stats = zoneStats[bin.zone]!;
      stats['total'] = (stats['total'] as int) + 1;
      if (bin.fillLevel > 0.8) stats['full'] = (stats['full'] as int) + 1;
      if (bin.fillLevel > 0.95) stats['overflow'] = (stats['overflow'] as int) + 1;
      stats['avgFillLevel'] = (stats['avgFillLevel'] as double) + bin.fillLevel;
    }

    // Calculate averages
    for (final stats in zoneStats.values) {
      stats['avgFillLevel'] = (stats['avgFillLevel'] as double) / (stats['total'] as int);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Zone-wise Analytics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...zoneStats.entries.map((entry) => _buildZoneCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildZoneCard(String zone, Map<String, dynamic> stats) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              zone,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildZoneMetric('Total Bins', stats['total'].toString(), Icons.delete_outline),
                ),
                Expanded(
                  child: _buildZoneMetric('Full Bins', stats['full'].toString(), Icons.warning),
                ),
                Expanded(
                  child: _buildZoneMetric('Overflow', stats['overflow'].toString(), Icons.error),
                ),
                Expanded(
                  child: _buildZoneMetric('Avg Fill', '${((stats['avgFillLevel'] as double) * 100).toInt()}%', Icons.pie_chart),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTypesTab(List<WasteBin> bins, MockDataService dataService) {
    final typeStats = <BinType, Map<String, dynamic>>{};

    for (final type in BinType.values) {
      final typeBins = bins.where((b) => b.type == type).toList();
      typeStats[type] = {
        'count': typeBins.length,
        'avgFillLevel': typeBins.isEmpty
            ? 0.0
            : typeBins.map((b) => b.fillLevel).reduce((a, b) => a + b) / typeBins.length,
        'fullCount': typeBins.where((b) => b.fillLevel > 0.8).length,
      };
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waste Type Analytics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...typeStats.entries.map((entry) => _buildTypeCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildTypeCard(BinType type, Map<String, dynamic> stats) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getBinTypeIcon(type), size: 24),
                const SizedBox(width: 12),
                Text(
                  type.name.toUpperCase(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTypeMetric('Total', stats['count'].toString()),
                ),
                Expanded(
                  child: _buildTypeMetric('Avg Fill', '${((stats['avgFillLevel'] as double) * 100).toInt()}%'),
                ),
                Expanded(
                  child: _buildTypeMetric('Full', stats['fullCount'].toString()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Color _getFillLevelColor(double fillLevel) {
    if (fillLevel < 0.2) return Colors.green;
    if (fillLevel < 0.4) return Colors.lightGreen;
    if (fillLevel < 0.6) return Colors.yellow;
    if (fillLevel < 0.8) return Colors.orange;
    return Colors.red;
  }

  Color _getStatusColor(BinStatus status) {
    switch (status) {
      case BinStatus.normal:
        return Colors.green;
      case BinStatus.full:
        return Colors.orange;
      case BinStatus.overflowing:
        return Colors.red;
      case BinStatus.maintenance:
        return Colors.blue;
      case BinStatus.offline:
        return Colors.grey;
    }
  }

  IconData _getBinTypeIcon(BinType type) {
    switch (type) {
      case BinType.organic:
        return Icons.eco;
      case BinType.recyclable:
        return Icons.recycling;
      case BinType.hazardous:
        return Icons.warning;
      case BinType.electronic:
        return Icons.devices;
      case BinType.mixed:
        return Icons.delete;
    }
  }
}