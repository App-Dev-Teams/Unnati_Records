import 'package:flutter/material.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/main.dart';

class StudedntProfileScreen extends StatelessWidget {
  const StudedntProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              // Clear all stored data
              await ApiService.clearAllData();

              // Navigate to auth check (which will route to login)
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthCheck()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile'), elevation: 0),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: ApiService.getUserData(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          final name = (user != null && user['name'] != null)
              ? user['name'] as String
              : 'Student';
          final email = (user != null && user['email'] != null)
              ? user['email'] as String
              : '';
          final phone = (user != null && user['phoneNo'] != null)
              ? user['phoneNo'] as String
              : '';
          final studentClass = (user != null && user['studentClass'] != null)
              ? user['studentClass'] as String
              : '';
          final school = (user != null && user['school'] != null)
              ? user['school'] as String
              : '';

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Name'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(name),
                      ),

                      const SizedBox(height: 16),
                      const Text('Email'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(email),
                      ),

                      const SizedBox(height: 16),
                      const Text('Phone'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(phone),
                      ),

                      const SizedBox(height: 16),
                      const Text('Class'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(studentClass),
                      ),

                      const SizedBox(height: 16),
                      const Text('School'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(school),
                      ),

                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleLogout(context),
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
