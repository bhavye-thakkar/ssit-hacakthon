import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/mock_data_service.dart';
import '../models/citizen_report.dart';

class SpecialRequestsScreen extends StatefulWidget {
  const SpecialRequestsScreen({super.key});

  @override
  State<SpecialRequestsScreen> createState() => _SpecialRequestsScreenState();
}

class _SpecialRequestsScreenState extends State<SpecialRequestsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _requestDetailsController = TextEditingController();
  final _locationController = TextEditingController();

  String _requestType = 'New Bin Installation';
  bool _isSubmitting = false;

  final List<String> _requestTypes = [
    'New Bin Installation',
    'Bin Relocation',
    'Additional Bin Capacity',
    'Bin Maintenance',
    'Special Collection',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _requestDetailsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Requests'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade100, Colors.purple.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.star,
                      size: 48,
                      color: Colors.purple.shade700,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Request Special Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Submit requests for new bins or special services',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: 24),

              // Request Type
              const Text(
                'Request Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ).animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideX(begin: -0.2, end: 0),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: _requestType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _requestTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _requestType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a request type';
                  }
                  return null;
                },
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: 24),

              // Personal Information
              const Text(
                'Your Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ).animate()
                  .fadeIn(duration: 500.ms, delay: 400.ms)
                  .slideX(begin: 0.2, end: 0),

              const SizedBox(height: 16),

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
                  .fadeIn(duration: 600.ms, delay: 500.ms)
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
                  .fadeIn(duration: 600.ms, delay: 600.ms)
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
                  .fadeIn(duration: 600.ms, delay: 700.ms)
                  .slideX(begin: -0.1, end: 0),

              const SizedBox(height: 24),

              // Location Information
              const Text(
                'Location Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ).animate()
                  .fadeIn(duration: 500.ms, delay: 800.ms)
                  .slideX(begin: 0.2, end: 0),

              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'Street address, landmark, or area description',
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location details';
                  }
                  return null;
                },
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 900.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: 24),

              // Request Details
              const Text(
                'Request Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ).animate()
                  .fadeIn(duration: 500.ms, delay: 1000.ms)
                  .slideX(begin: -0.2, end: 0),

              const SizedBox(height: 16),

              TextFormField(
                controller: _requestDetailsController,
                decoration: const InputDecoration(
                  labelText: 'Additional Details',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  hintText: 'Please provide more details about your request...',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide details about your request';
                  }
                  return null;
                },
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 1100.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitRequest,
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
                  label: Text(_isSubmitting ? 'Submitting...' : 'Submit Request'),
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
                  .fadeIn(duration: 600.ms, delay: 1200.ms)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final mockDataService = Provider.of<MockDataService>(context, listen: false);

      // Create a special request as a citizen report
      final request = CitizenReport(
        id: 'special_request_${DateTime.now().millisecondsSinceEpoch}',
        citizenId: 'citizen_${DateTime.now().millisecondsSinceEpoch}',
        citizenName: _nameController.text,
        citizenEmail: _emailController.text,
        citizenPhone: _phoneController.text,
        type: ReportType.suggestion, // Using suggestion type for special requests
        title: 'Special Request: $_requestType',
        description: '''
Request Type: $_requestType
Location: ${_locationController.text}
Details: ${_requestDetailsController.text}
        ''',
        latitude: 12.9716, // Default Bangalore coordinates
        longitude: 77.5946,
        address: _locationController.text,
        imageUrls: [],
        status: ReportStatus.submitted,
        priority: ReportPriority.medium,
        createdAt: DateTime.now(),
        updates: [],
        rating: 0.0,
      );

      mockDataService.addCitizenReport(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Special request for "$_requestType" submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _requestDetailsController.clear();
        _locationController.clear();

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit request: $e'),
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