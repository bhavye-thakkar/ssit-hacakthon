import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/waste_bin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  bool _showBins = true;
  bool _showRoutes = false;
  WasteBin? _selectedBin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Management Map'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: Icon(_showBins ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showBins = !_showBins;
              });
            },
            tooltip: 'Toggle Bins',
          ),
          IconButton(
            icon: Icon(_showRoutes ? Icons.route : Icons.route_outlined),
            onPressed: () {
              setState(() {
                _showRoutes = !_showRoutes;
              });
            },
            tooltip: 'Toggle Routes',
          ),
        ],
      ),
      body: Consumer<MockDataService>(
        builder: (context, mockDataService, child) {
          final bins = mockDataService.wasteBins;

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(12.9716, 77.5946), // Bangalore center
                  zoom: 12.0,
                  maxZoom: 18.0,
                  minZoom: 10.0,
                  onTap: (tapPosition, point) {
                    setState(() {
                      _selectedBin = null;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.flutter_application_1',
                  ),
                  if (_showBins)
                    MarkerLayer(
                      markers: bins.map((bin) => Marker(
                        point: LatLng(bin.latitude, bin.longitude),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedBin = bin;
                            });
                            _animateToLocation(bin.latitude, bin.longitude);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getBinColor(bin),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getBinIcon(bin),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  if (_showRoutes && mockDataService.routes.isNotEmpty)
                    PolylineLayer(
                      polylines: mockDataService.routes.map((route) => Polyline(
                        points: route.waypoints.map((waypoint) {
                          final bin = bins.firstWhere(
                            (bin) => bin.id == waypoint.binId,
                            orElse: () => bins.first,
                          );
                          return LatLng(bin.latitude, bin.longitude);
                        }).toList(),
                        color: Colors.blue,
                        strokeWidth: 3.0,
                      )).toList(),
                    ),
                ],
              ),

              // Map Legend
              Positioned(
                top: 10,
                left: 10,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Legend',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildLegendItem(Colors.green, 'Normal'),
                        _buildLegendItem(Colors.orange, 'Full'),
                        _buildLegendItem(Colors.red, 'Overflow'),
                        _buildLegendItem(Colors.grey, 'Maintenance'),
                      ],
                    ),
                  ),
                ),
              ),

              // Bin Details Panel
              if (_selectedBin != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getBinColor(_selectedBin!),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedBin!.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _selectedBin = null;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Location: ${_selectedBin!.address}'),
                          const SizedBox(height: 4),
                          Text('Fill Level: ${(_selectedBin!.fillLevel * 100).toInt()}%'),
                          const SizedBox(height: 4),
                          Text('Last Collected: ${_formatDate(_selectedBin!.lastCollected)}'),
                          const SizedBox(height: 4),
                          Text('Status: ${_selectedBin!.status.toString().split('.').last}'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigate to collection
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Collection scheduled')),
                                    );
                                  },
                                  icon: const Icon(Icons.local_shipping),
                                  label: const Text('Schedule Collection'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Floating Action Buttons
              Positioned(
                bottom: 100,
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'zoom_in',
                      mini: true,
                      onPressed: () {
                        final currentZoom = _mapController.zoom;
                        _mapController.move(_mapController.center, currentZoom + 1);
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'zoom_out',
                      mini: true,
                      onPressed: () {
                        final currentZoom = _mapController.zoom;
                        _mapController.move(_mapController.center, currentZoom - 1);
                      },
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'my_location',
                      mini: true,
                      onPressed: () {
                        _animateToLocation(12.9716, 77.5946);
                      },
                      child: const Icon(Icons.my_location),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _animateToLocation(double latitude, double longitude) {
    _mapController.move(LatLng(latitude, longitude), 15.0);
  }

  Color _getBinColor(WasteBin bin) {
    if (bin.status == BinStatus.overflowing) return Colors.red;
    if (bin.status == BinStatus.full) return Colors.orange;
    if (bin.status == BinStatus.maintenance) return Colors.grey;
    return Colors.green;
  }

  IconData _getBinIcon(WasteBin bin) {
    switch (bin.type) {
      case BinType.organic:
        return Icons.eco;
      case BinType.recyclable:
        return Icons.recycling;
      case BinType.hazardous:
        return Icons.warning;
      case BinType.mixed:
        return Icons.delete;
      case BinType.electronic:
        return Icons.devices;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}