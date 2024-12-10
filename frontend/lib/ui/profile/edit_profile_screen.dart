import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load existing profile data
  }

  // Load profile data from an API or secure storage
  Future<void> _loadProfileData() async {
    // Assuming you have an API to fetch profile data, use the stored token here
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('https://example.com/api/profile'), // Replace with your API endpoint
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _nameController.text = data['name'];
            _emailController.text = data['email'];
          });
        } else {
          Get.snackbar('Error', 'Failed to load profile data');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to load profile: $e');
      }
    } else {
      Get.snackbar('Error', 'No authentication token found');
    }
  }

  // Update profile using API
  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        try {
          final response = await http.put(
            Uri.parse('https://example.com/api/profile'), // Replace with your API endpoint
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'name': _nameController.text,
              'email': _emailController.text,
            }),
          );

          if (response.statusCode == 200) {
            Get.snackbar('Success', 'Profile updated successfully');
          } else {
            final errorData = jsonDecode(response.body);
            Get.snackbar('Error', errorData['message'] ?? 'Failed to update profile');
          }
        } catch (e) {
          Get.snackbar('Error', 'Failed to update profile: $e');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        Get.snackbar('Error', 'No authentication token found');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'Enter your email address',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: const Text('Update Profile'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
