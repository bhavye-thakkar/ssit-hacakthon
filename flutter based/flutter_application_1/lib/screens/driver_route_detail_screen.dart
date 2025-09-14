
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverRouteDetailScreen extends StatefulWidget {
  const DriverRouteDetailScreen({super.key});

  @override
  State<DriverRouteDetailScreen> createState() => _DriverRouteDetailScreenState();
}

class _DriverRouteDetailScreenState extends State<DriverRouteDetailScreen> {
  static const LatLng _kMapCenter = LatLng(6.9271, 79.8612); // Colombo, Sri Lanka
  static const CameraPosition _kInitialPosition = CameraPosition(target: _kMapCenter, zoom: 14.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text(
          'Selected Route',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.layers, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: _kInitialPosition,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Card(
              color: const Color(0xFFE1D5E7), // Light lavender
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Route 00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Text('School Junction to alubogahawatta'),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text('Category: '),
                        Text('MIXED', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Distance: 0.04 km away'),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text('Driver: Driver1'),
                        SizedBox(width: 8),
                        Icon(Icons.phone, size: 16),
                        Text('+9471234567'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Est. Arrival: 8:00 AM'),
                    const SizedBox(height: 8),
                    const Text('Route Progress: 0%'),
                    const LinearProgressIndicator(
                      value: 0.0,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                          child: const Text('HIDE ROUTE'),
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.my_location_sharp)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
