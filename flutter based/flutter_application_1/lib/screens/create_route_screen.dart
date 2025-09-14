
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  static const LatLng _kMapCenter = LatLng(6.9271, 79.8612); // Colombo, Sri Lanka
  static const CameraPosition _kInitialPosition = CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text(
          'Create Waste Collecti...',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.nightlight_round, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Step Indicator
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStep(number: '1', label: 'Map', isActive: true),
                _buildStep(number: '2', label: 'Details'),
                _buildStep(number: '3', label: 'Schedule'),
                _buildStep(number: '4', label: 'Driver'),
              ],
            ),
          ),
          // Map Section
          Expanded(
            child: Stack(
              children: [
                const GoogleMap(
                  initialCameraPosition: _kInitialPosition,
                ),
                // Map Legend
                Positioned(
                  top: 10,
                  left: 10,
                  child: Card(
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(Colors.green, 'Start Point'),
                          const SizedBox(height: 4),
                          _buildLegendItem(Colors.red, 'End Point'),
                          const SizedBox(height: 4),
                          _buildLegendItem(Colors.yellow, 'Resident'),
                        ],
                      ),
                    ),
                  ),
                ),
                // FABs
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      _buildFab(icon: Icons.my_location),
                      const SizedBox(height: 8),
                      _buildFab(icon: Icons.add),
                      const SizedBox(height: 8),
                      _buildFab(icon: Icons.remove),
                       const SizedBox(height: 8),
                      _buildFab(icon: Icons.refresh),
                    ],
                  ),
                ),
                // Resident Locations Toggle
                Positioned(
                  bottom: 80,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tap on a resident marker (yellow) to add it to your route'),
                          Switch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: const Color(0xFF4CAF50),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('← Previous'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Next →'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStep({required String number, required String label, bool isActive = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: isActive ? const Color(0xFF4CAF50) : Colors.grey.shade300,
          child: Text(
            number,
            style: TextStyle(color: isActive ? Colors.white : Colors.grey),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? Colors.black : Colors.grey)),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Icon(Icons.location_pin, color: color, size: 20),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

    Widget _buildFab({required IconData icon}) {
    return FloatingActionButton(
      mini: true,
      onPressed: () {},
      backgroundColor: Colors.white,
      child: Icon(icon, color: const Color(0xFF4CAF50)),
    );
  }
}
