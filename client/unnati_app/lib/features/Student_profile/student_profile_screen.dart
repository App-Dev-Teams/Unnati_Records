import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unnati_app/features/volunteer_profile/Volunteer_profile_listtile.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/main.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class StudedntProfileScreen extends StatefulWidget {
  const StudedntProfileScreen({super.key});

  @override
  State<StudedntProfileScreen> createState() => _StudedntProfileScreenState();
}

class _StudedntProfileScreenState extends State<StudedntProfileScreen> {
  String _name = "Student";
  String phone = "xxxxxxxxxxxx";
  String studentClass = "10";
  String school = "School Name";
  List<String> schools = [];
  List<int> selectClass = [5, 6, 7, 8, 9, 10, 11, 12];

  Map<String, dynamic>? _user;

  File? _selectedProfileImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploadingProfilePic = false;
  ImageProvider? _cachedProfileImage;
  String? _cachedProfilePicUrl;

  Future<void> _changeProfilePicture() async {
    if (_isUploadingProfilePic) return;

    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile == null || !mounted) return;

    final imageFile = File(pickedFile.path);

    // Show selected photo immediately as a local preview.
    setState(() {
      _selectedProfileImage = imageFile;
      _isUploadingProfilePic = true;
    });

    try {
      // Step 1: Upload compressed image to ImageKit.
      final imageUrl =
          await ApiService.uploadProfilePicture(imageFile);

      if (!mounted) return;

      // Step 2: Save the new image URL in the backend.
      final res =
          await ApiService.updateProfilePicture(imageUrl);

      if (!mounted) return;

      if (res['success'] == true) {
        setState(() {
          _user = {
            ...?_user,
            'profilePic': imageUrl,
          };

          // Update cached image to the new URL.
          _cachedProfilePicUrl = imageUrl;
          _cachedProfileImage = NetworkImage(imageUrl);

          _selectedProfileImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully'),
          ),
        );
      } else {
        setState(() {
          _selectedProfileImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res['message'] ?? 'Profile picture update failed',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _selectedProfileImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingProfilePic = false;
        });
      }
    }
  }

    
  void _showProfilePicture(ImageProvider imageProvider) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (dialogContext) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Profile photo',
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                IconButton(
                  tooltip: 'Edit profile photo',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _changeProfilePicture();
                  },
                ),
              ],
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white,
                      size: 60,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    _fetchSchools();
  }

  void _fetchSchools() async {
    final fetchedSchools = await ApiService.getSchools();
    if (!mounted) return;
    setState(() {
      schools = fetchedSchools;
    });
  }

  // opens dialog to edit profile details
  void _editProfile({
    required String currentName,
    required String currentPhone,
    required String currentClass,
    required String currentSchool,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);
    int? selectedClass = int.tryParse(currentClass);

    // Ensure selectedSchool is in the schools list, otherwise set to first available or current value.
    String? selectedSchool = schools.contains(currentSchool)
        ? currentSchool
        : (schools.isNotEmpty ? schools.first : null);

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFFF5F5F5),
          surfaceTintColor: Colors.transparent,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 8),
          actionsPadding: EdgeInsets.fromLTRB(24, 8, 24, 20),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.editprofile,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF061A22),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.updateyourpersonalinformation,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 14),
              Divider(
                color: Color(0xFF29B6F6),
                thickness: 3,
                height: 3,
                endIndent: 180,
              ),
            ],
          ),

          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.name,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFF147DAD),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xFFE0E6E9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF29B6F6),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.phone,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: Color(0xFF147DAD),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xFFE0E6E9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF29B6F6),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  DropdownButtonFormField<int>(
                    initialValue: selectedClass,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.classLabel,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: Icon(
                        Icons.school_outlined,
                        color: Color(0xFF147DAD),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xFFE0E6E9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF29B6F6),
                          width: 2,
                        ),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    items: selectClass.map((cls) {
                      return DropdownMenuItem<int>(
                        value: cls,
                        child: Text(cls.toString()),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Class is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setDialogState(() {
                        selectedClass = value;
                      });
                    },
                  ),

                  SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: selectedSchool,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.school,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: Icon(
                        Icons.apartment_rounded,
                        color: Color(0xFF147DAD),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xFFE0E6E9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF29B6F6),
                          width: 2,
                        ),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    items: schools.map((s) {
                      return DropdownMenuItem<String>(
                        value: s,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                s,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'School is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setDialogState(() {
                        selectedSchool = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          actions: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF29B6F6),
                  foregroundColor: Color(0xFF061A22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                onPressed: () async {
                  if (!(formKey.currentState?.validate() ?? false)) {
                    return;
                  }

                  final newName = nameController.text.trim();
                  final newPhone = phoneController.text.trim();
                  final newClass = selectedClass?.toString() ?? currentClass;
                  final newSchool = selectedSchool ?? currentSchool;

                  final res = await ApiService.updateProfile(
                    name: newName,
                    phoneNo: newPhone,
                    studentClass: newClass,
                    school: newSchool,
                  );

                  if (!mounted) return;

                  if (res['success'] == true) {
                    final updated = res['data'] as Map<String, dynamic>?;

                    final updatedName = updated?['name']?.toString() ?? newName;
                    final updatedPhone =
                        updated?['phoneNo']?.toString() ?? newPhone;
                    final updatedClass =
                        updated?['studentClass']?.toString() ?? newClass;
                    final updatedSchool =
                        updated?['school']?.toString() ?? newSchool;

                    setState(() {
                      _name = updatedName;
                      phone = updatedPhone;
                      studentClass = updatedClass;
                      school = updatedSchool;
                    });

                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.profileupdated,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res['message'] ?? 'Update failed'),
                      ),
                    );
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.savechanges,
                  style: TextStyle(
                    color: Color(0xFF061A22),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color(0xFFF5F5F5),
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 20),
        actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 20),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.logout_rounded, color: Color(0xFF147DAD), size: 27),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.confirmlogout,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF061A22),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Divider(
              color: Color(0xFF29B6F6),
              thickness: 3,
              height: 3,
              endIndent: 180,
            ),
          ],
        ),

        content: Text(
          AppLocalizations.of(context)!.areyousureyouwanttologout,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Color(0xFF52616B),
            fontWeight: FontWeight.w500,
          ),
        ),

        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF061A22),
                    side: BorderSide(color: Color(0xFFD5DEE3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF29B6F6),
                    foregroundColor: Color(0xFF061A22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);

                    // Clear all stored data
                    await ApiService.clearAllData();

                    // Navigate to auth check (which will route to login)
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => AuthCheck()),
                        (route) => false,
                      );
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.logout,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ApiService.getUserData(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        _user = user;

        final profilePicUrl =
            user?['profilePic']?.toString() ?? '';

        if (_cachedProfilePicUrl != profilePicUrl) {
          _cachedProfilePicUrl = profilePicUrl;
          _cachedProfileImage = profilePicUrl.isNotEmpty
              ? NetworkImage(profilePicUrl)
              : null;
        }

        final ImageProvider? profileImage =
            _selectedProfileImage != null
                ? FileImage(_selectedProfileImage!)
                : _cachedProfileImage;

        final name = (user != null && user['name'] != null)
            ? user['name'] as String
            : _name;
        final email = (user != null && user['email'] != null)
            ? user['email'] as String
            : 'abc@example.com';
        final phoneLocal = (user != null && user['phoneNo'] != null)
            ? user['phoneNo'] as String
            : phone;
        final classLocal = (user != null && user['studentClass'] != null)
            ? user['studentClass'] as String
            : studentClass;
        final schoolLocal = (user != null && user['school'] != null)
            ? user['school'] as String
            : school;
        final roleLocal = (user != null && user['role'] != null)
            ? user['role'] as String
            : 'Student';

        return Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(
            elevation: 2,
            backgroundColor: Color.fromARGB(255, 9, 12, 19),
            foregroundColor: Colors.white,
            title: Text(
              AppLocalizations.of(context)!.profile,
              style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: true,

            // edit button
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editProfile(
                  currentName: name,
                  currentPhone: phoneLocal,
                  currentClass: classLocal,
                  currentSchool: schoolLocal,
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20),

                  // avatar
                  


                  GestureDetector(
                    onTap: _isUploadingProfilePic
                        ? null
                        : () {
                            if (profileImage != null) {
                              _showProfilePicture(profileImage);
                            } else {
                              _changeProfilePicture();
                            }
                          },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 126,
                          height: 126,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF172B40),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 130, 130, 174).withOpacity(0.30),
                                blurRadius: 24,
                                spreadRadius: 3,
                                offset: const Offset(0, 6),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 12,
                                spreadRadius: 0.6,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: profileImage != null
                                ? Image(
                                    image: profileImage,
                                    width: 126,
                                    height: 126,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(
                                      Icons.person,
                                      size: 70,
                                      color: Colors.white70,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.white70,
                                  ),
                          ),
                        ),

                        if (_isUploadingProfilePic)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.45),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Color.fromARGB(255, 233, 238, 241),
                                ),
                              ),
                            ),
                          ),

                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Material(
                        //     color: const Color(0xFF29B6F6),
                        //     shape: const CircleBorder(),
                        //     elevation: 4,
                        //     child: InkWell(
                        //       customBorder: const CircleBorder(),
                        //       onTap: _isUploadingProfilePic
                        //           ? null
                        //           : _changeProfilePicture,
                        //       child: const SizedBox(
                        //         width: 38,
                        //         height: 38,
                        //         child: Icon(
                        //           Icons.camera_alt_rounded,
                        //           color: Color(0xFF061A22),
                        //           size: 21,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                    

                  const SizedBox(height: 10),

                  // name
                  Text(
                    name,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 10),

                  // CONTACT INFORMATION CONTAINER
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.contactinformation,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),

                            VolunteerProfileListtile(
                              title: email,
                              subtitle: 'Email',
                              icon: Icons.email,
                              iconColor: Colors.green,
                            ),

                            VolunteerProfileListtile(
                              title: phoneLocal,
                              subtitle: 'Phone',
                              icon: Icons.phone,
                              iconColor: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // QUIZ STATS & PERFORMANCE CONTAINER
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: ApiService.getMyQuizAttempts(),
                          builder: (context, quizSnapshot) {
                            final quizData = quizSnapshot.data;
                            final totalAttempts = quizData?['totalAttempts'] ?? 0;
                            final avgPercentage = quizData?['averagePercentage'] ?? 0;
                            final highestScore = quizData?['highestScore'] ?? 0;
                            final highestTotal = quizData?['highestTotal'] ?? 0;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.military_tech_rounded, color: Colors.amber, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            "Quiz Stats & Performance",
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (totalAttempts > 0)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.25),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.greenAccent, width: 0.8),
                                          ),
                                          child: Text(
                                            "$totalAttempts Quizzes",
                                            style: GoogleFonts.roboto(
                                              color: Colors.greenAccent,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                if (quizSnapshot.connectionState == ConnectionState.waiting)
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
                                      ),
                                    ),
                                  )
                                else if (totalAttempts == 0)
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                                    child: Text(
                                      "No quizzes attempted yet. Head over to Quizzes & Tests to take your first quiz!",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  )
                                else ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "$totalAttempts",
                                                style: GoogleFonts.oswald(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.lightBlueAccent,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Attempted",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "$avgPercentage%",
                                                style: GoogleFonts.oswald(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amberAccent,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Avg Score",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                highestTotal > 0
                                                    ? "$highestScore/$highestTotal"
                                                    : "$highestScore",
                                                style: GoogleFonts.oswald(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.greenAccent,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Best Score",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // MORE DETAILS CONTAINER
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.moredetails,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),

                            VolunteerProfileListtile(
                              title: roleLocal,
                              subtitle: 'Role',
                              icon: Icons.assignment_ind,
                              iconColor: Colors.white,
                            ),

                            VolunteerProfileListtile(
                              title: classLocal,
                              subtitle: 'Class',
                              icon: Icons.school,
                              iconColor: Colors.white,
                            ),

                            VolunteerProfileListtile(
                              title: schoolLocal,
                              subtitle: 'School',
                              icon: Icons.location_city,
                              iconColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // LOGOUT BUTTON
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleLogout,
                        icon: Icon(Icons.logout),
                        label: Text(AppLocalizations.of(context)!.logout),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
