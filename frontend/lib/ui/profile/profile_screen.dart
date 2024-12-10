import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_profile_screen.dart';  // Import the EditProfileScreen

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userAvatar;

  const ProfileScreen({
    Key? key,
    this.userName = 'John Doe',
    this.userEmail = 'johndoe@example.com',
    this.userAvatar = 'https://via.placeholder.com/150', // Placeholder avatar URL
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userAvatar),
              child: userAvatar.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null, // Fallback icon when avatar is empty
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text(
                'Update Profile',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                // Navigate to update profile screen
                Get.to(() => const EditProfileScreen());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.blue),
              title: const Text(
                'Change Password',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                // Navigate to change password screen
                // Get.to(() => ChangePasswordScreen()); 
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              onTap: () {
                // Handle logout functionality
                Get.offAllNamed('/login');
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
