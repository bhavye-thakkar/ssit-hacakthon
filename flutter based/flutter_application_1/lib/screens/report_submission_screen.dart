import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/mock_data_service.dart';
import '../models/citizen_report.dart';

class ReportSubmissionScreen extends StatefulWidget {
  final ReportType reportType;

  const ReportSubmissionScreen({
    super.key,
    required this.reportType,
  });

  @override
  State<ReportSubmissionScreen> createState() => _ReportSubmissionScreenState();
}

class _ReportSubmissionScreenState extends State<ReportSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  LatLng _selectedLocation = LatLng(12.9716, 77.5946); // Bangalore center
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Set initial coordinates
    _latitudeController.text = _selectedLocation.latitude.toStringAsFixed(6);
    _longitudeController.text = _selectedLocation.longitude.toStringAsFixed(6);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getReportTitle()),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Use Current Location',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Map Section
            Container(
              height: 250,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _selectedLocation,
                        zoom: 15.0,
                        onTap: (tapPosition, point) {
                          setState(() {
                            _selectedLocation = point;
                            _latitudeController.text = point.latitude.toStringAsFixed(6);
                            _longitudeController.text = point.longitude.toStringAsFixed(6);
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.flutter_application_1',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _selectedLocation,
                              width: 40,
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _getReportColor(),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getReportIcon(),
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tap to select location',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.1, end: 0),

            // Form Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ).animate()
                        .fadeIn(duration: 500.ms, delay: 300.ms)
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 16),

                    // Coordinates Input
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _latitudeController,
                            decoration: const InputDecoration(
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter latitude';
                              }
                              final lat = double.tryParse(value);
                              if (lat == null || lat < -90 || lat > 90) {
                                return 'Invalid latitude';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final lat = double.tryParse(value);
                              if (lat != null && lat >= -90 && lat <= 90) {
                                setState(() {
                                  _selectedLocation = LatLng(lat, _selectedLocation.longitude);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _longitudeController,
                            decoration: const InputDecoration(
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter longitude';
                              }
                              final lng = double.tryParse(value);
                              if (lng == null || lng < -180 || lng > 180) {
                                return 'Invalid longitude';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final lng = double.tryParse(value);
                              if (lng != null && lng >= -180 && lng <= 180) {
                                setState(() {
                                  _selectedLocation = LatLng(_selectedLocation.latitude, lng);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 24),

                    const Text(
                      'Your Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ).animate()
                        .fadeIn(duration: 500.ms, delay: 500.ms)
                        .slideX(begin: 0.2, end: 0),

                    const SizedBox(height: 16),

                    // Personal Information
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 600.ms)
                        .slideX(begin: -0.1, end: 0),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 700.ms)
                        .slideX(begin: 0.1, end: 0),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 800.ms)
                        .slideX(begin: -0.1, end: 0),

                    const SizedBox(height: 24),

                    const Text(
                      'Additional Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ).animate()
                        .fadeIn(duration: 500.ms, delay: 900.ms)
                        .slideX(begin: 0.2, end: 0),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.description),
                        hintText: 'Provide additional details about the issue...',
                      ),
                      maxLines: 3,
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 1000.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _submitReport,
                        icon: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(_isSubmitting ? 'Submitting...' : 'Submit Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 1100.ms)
                        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getReportTitle() {
    switch (widget.reportType) {
      case ReportType.binOverflow:
        return 'Report Overflowing Bin';
      case ReportType.binMissing:
        return 'Report Missing Bin';
      default:
        return 'Report Issue';
    }
  }

  Color _getReportColor() {
    switch (widget.reportType) {
      case ReportType.binOverflow:
        return Colors.red;
      case ReportType.binMissing:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getReportIcon() {
    switch (widget.reportType) {
      case ReportType.binOverflow:
        return Icons.warning;
      case ReportType.binMissing:
        return Icons.location_off;
      default:
        return Icons.report_problem;
    }
  }

  void _getCurrentLocation() {
    // In a real app, this would get the device's current location
    // For now, we'll just center on Bangalore
    setState(() {
      _selectedLocation = LatLng(12.9716, 77.5946);
      _latitudeController.text = _selectedLocation.latitude.toStringAsFixed(6);
      _longitudeController.text = _selectedLocation.longitude.toStringAsFixed(6);
    });
    _mapController.move(_selectedLocation, 15.0);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location updated to Bangalore center')),
    );
  }

  void _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final mockDataService = Provider.of<MockDataService>(context, listen: false);

      final report = CitizenReport(
        id: 'report_${DateTime.now().millisecondsSinceEpoch}',
        citizenId: 'citizen_${DateTime.now().millisecondsSinceEpoch}',
        citizenName: _nameController.text,
        citizenEmail: _emailController.text,
        citizenPhone: _phoneController.text,
        type: widget.reportType,
        title: _getReportTitle(),
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : 'Reported via mobile app',
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        address: 'Location selected on map',
        imageUrls: [],
        status: ReportStatus.submitted,
        priority: ReportPriority.medium,
        createdAt: DateTime.now(),
        updates: [],
        rating: 0.0,
      );

      mockDataService.addCitizenReport(report);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_getReportTitle()} submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}