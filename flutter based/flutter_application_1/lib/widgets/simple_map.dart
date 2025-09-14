import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/waste_bin.dart';

class SimpleMap extends StatefulWidget {
  const SimpleMap({super.key});

  @override
  State<SimpleMap> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap> {
  String _selectedFilter = 'all';
  bool _showHeatmap = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final bins = dataService.wasteBins;
        final filteredBins = _filterBins(bins);

        return Scaffold(
          body: Stack(
            children: [
              // Map Background
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green[100]!,
                      Colors.green[50]!,
                      Colors.blue[50]!,
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: MapPainter(
                    bins: filteredBins,
                    showHeatmap: _showHeatmap,
                  ),
                  size: Size.infinite,
                ),
              ),
              
              // Filter Controls
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text('Filter:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 16),
                          _buildFilterChip('all', 'All'),
                          _buildFilterChip('full', 'Full'),
                          _buildFilterChip('overflow', 'Overflow'),
                          _buildFilterChip('normal', 'Normal'),
                          _buildFilterChip('organic', 'Organic'),
                          _buildFilterChip('recyclable', 'Recyclable'),
                          _buildFilterChip('hazardous', 'Hazardous'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Toggle Controls
              Positioned(
                bottom: 16,
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'heatmap',
                      onPressed: () => setState(() => _showHeatmap = !_showHeatmap),
                      backgroundColor: _showHeatmap ? Colors.orange : Colors.grey,
                      child: const Icon(Icons.layers),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'center',
                      onPressed: () => _centerMap(),
                      child: const Icon(Icons.my_location),
                    ),
                  ],
                ),
              ),
              
              // Bin Details Panel
              if (filteredBins.isNotEmpty)
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Bin Statistics',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Total Bins: ${filteredBins.length}'),
                          Text('Full Bins: ${filteredBins.where((b) => b.fillLevel > 0.8).length}'),
                          Text('Overflow: ${filteredBins.where((b) => b.fillLevel > 0.95).length}'),
                          Text('Avg Fill: ${(filteredBins.map((b) => b.fillLevel).reduce((a, b) => a + b) / filteredBins.length * 100).toInt()}%'),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFilter = value);
        },
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        checkmarkColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  List<WasteBin> _filterBins(List<WasteBin> bins) {
    switch (_selectedFilter) {
      case 'all':
        return bins;
      case 'full':
        return bins.where((b) => b.fillLevel > 0.8).toList();
      case 'overflow':
        return bins.where((b) => b.fillLevel > 0.95).toList();
      case 'normal':
        return bins.where((b) => b.fillLevel <= 0.8).toList();
      case 'organic':
        return bins.where((b) => b.type == BinType.organic).toList();
      case 'recyclable':
        return bins.where((b) => b.type == BinType.recyclable).toList();
      case 'hazardous':
        return bins.where((b) => b.type == BinType.hazardous).toList();
      default:
        return bins;
    }
  }

  void _centerMap() {
    // Simulate centering the map
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Map centered on all bins')),
    );
  }
}

class MapPainter extends CustomPainter {
  final List<WasteBin> bins;
  final bool showHeatmap;

  MapPainter({required this.bins, required this.showHeatmap});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Draw grid lines
    paint.color = Colors.grey.withOpacity(0.3);
    paint.strokeWidth = 1;
    
    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      final y = (size.height / 10) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Draw bins
    for (final bin in bins) {
      _drawBin(canvas, size, bin);
    }
    
    // Draw heatmap if enabled
    if (showHeatmap) {
      _drawHeatmap(canvas, size);
    }
  }

  void _drawBin(Canvas canvas, Size size, WasteBin bin) {
    // Convert lat/lng to screen coordinates (simplified)
    final x = (bin.longitude - 77.5) * size.width * 10;
    final y = (12.9 - bin.latitude) * size.height * 10;
    
    if (x < 0 || x > size.width || y < 0 || y > size.height) return;
    
    final paint = Paint();
    final fillColor = _getFillColor(bin.fillLevel);
    
    // Draw bin circle
    paint.color = fillColor;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 8, paint);
    
    // Draw bin border
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawCircle(Offset(x, y), 8, paint);
    
    // Draw fill level indicator
    if (bin.fillLevel > 0.8) {
      paint.color = Colors.red;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  void _drawHeatmap(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (final bin in bins) {
      final x = (bin.longitude - 77.5) * size.width * 10;
      final y = (12.9 - bin.latitude) * size.height * 10;
      
      if (x < 0 || x > size.width || y < 0 || y > size.height) continue;
      
      final radius = bin.fillLevel * 50;
      final color = _getFillColor(bin.fillLevel).withOpacity(0.3);
      
      paint.color = color;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  Color _getFillColor(double fillLevel) {
    if (fillLevel > 0.95) return Colors.red;
    if (fillLevel > 0.8) return Colors.orange;
    if (fillLevel > 0.5) return Colors.yellow;
    return Colors.green;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

