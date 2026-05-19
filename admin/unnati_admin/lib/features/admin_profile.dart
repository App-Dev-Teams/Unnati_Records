import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/services/api_service.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  Map<String, dynamic>? adminData;
  bool _isLoading = true;
  bool _isEditing = false;

  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController startYearCtrl;
  late TextEditingController endYearCtrl;
  late TextEditingController rollNoCtrl;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    try {
      final data = await AdminApiService.getAdminData();
      if (mounted) {
        setState(() {
          adminData = data ?? {};
          _initializeControllers();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error loading admin data: $e');
    }
  }

  void _initializeControllers() {
    nameCtrl = TextEditingController(text: adminData?['name'] ?? '');
    emailCtrl = TextEditingController(text: adminData?['email'] ?? '');
    startYearCtrl =
        TextEditingController(text: adminData?['batch']?['startYear']?.toString() ?? '');
    endYearCtrl =
        TextEditingController(text: adminData?['batch']?['endYear']?.toString() ?? '');
    rollNoCtrl = TextEditingController(text: adminData?['rollNo']?.toString() ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    startYearCtrl.dispose();
    endYearCtrl.dispose();
    rollNoCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    // Prepare data for API
    final updatedData = {
      'name': nameCtrl.text,
      'phoneNo': adminData?['phoneNo'] ?? '',
      'program': adminData?['program'] ?? '',
    };

    try {
      // Call API to update profile
      final result = await AdminApiService.updateProfile(updatedData);

      if (result['success'] == true) {
        // Update local data
        setState(() {
          adminData?['name'] = nameCtrl.text;
          _isEditing = false;
        });

        // Save updated admin name
        await AdminApiService.saveAdminName(nameCtrl.text);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to update profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 12, 19),
        elevation: 0,
        title: Text(
          'Admin Profile',
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.lightBlueAccent),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      _initializeControllers();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: _saveChanges,
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                          child: Text(
                            (adminData?['name'] ?? 'A')[0].toUpperCase(),
                            style: GoogleFonts.oswald(
                              fontSize: 48.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          adminData?['name'] ?? 'Admin',
                          style: GoogleFonts.oswald(
                            fontSize: 24.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Administrator',
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Profile Information Sections
                  _buildSection(
                    title: 'Basic Information',
                    children: [
                      _buildProfileField(
                        label: 'Full Name',
                        value: adminData?['name'] ?? 'N/A',
                        controller: _isEditing ? nameCtrl : null,
                        isEditing: _isEditing,
                      ),
                      SizedBox(height: 16.h),
                      _buildProfileField(
                        label: 'Email',
                        value: adminData?['email'] ?? 'N/A',
                        controller: _isEditing ? emailCtrl : null,
                        isEditing: _isEditing,
                        readOnly: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Batch Information
                  _buildSection(
                    title: 'Batch Information',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildProfileField(
                              label: 'Start Year',
                              value: adminData?['batch']?['startYear']?.toString() ?? 'N/A',
                              controller: _isEditing ? startYearCtrl : null,
                              isEditing: _isEditing,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildProfileField(
                              label: 'End Year',
                              value: adminData?['batch']?['endYear']?.toString() ?? 'N/A',
                              controller: _isEditing ? endYearCtrl : null,
                              isEditing: _isEditing,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildProfileField(
                        label: 'Roll Number',
                        value: adminData?['rollNo']?.toString() ?? 'N/A',
                        controller: _isEditing ? rollNoCtrl : null,
                        isEditing: _isEditing,
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Additional Info
                  if (!_isEditing)
                    _buildSection(
                      title: 'Additional Information',
                      children: [
                        _buildInfoRow('Role', 'Administrator'),
                        SizedBox(height: 12.h),
                        _buildInfoRow('Status', 'Active'),
                        SizedBox(height: 12.h),
                        _buildInfoRow(
                          'Member Since',
                          adminData?['batch']?['startYear']?.toString() ?? 'N/A',
                        ),
                      ],
                    ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.oswald(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: const Color.fromARGB(255, 14, 22, 33),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    TextEditingController? controller,
    bool isEditing = false,
    bool readOnly = false,
  }) {
    if (isEditing && controller != null) {
      return TextField(
        controller: controller,
        readOnly: readOnly,
        style: GoogleFonts.nunito(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.nunito(color: Colors.white70),
          filled: true,
          fillColor: const Color.fromARGB(255, 9, 12, 19),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.white10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 9, 75, 128),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12.sp,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 14.sp,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
