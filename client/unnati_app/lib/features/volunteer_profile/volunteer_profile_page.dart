import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/self_attendance_page.dart';
import 'package:unnati_app/features/volunteer_profile/Volunteer_profile_listtile.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/main.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class VolunteerProfilePage extends StatefulWidget {
  const VolunteerProfilePage({super.key});

  @override
  State<VolunteerProfilePage> createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  static final List<String> _programOptions = [
    'DigiXplore',
    'Netritva',
    'Akshar',
  ];
  static const List<String> _branchOptions = ['CSE', 'MAE', 'ECE', 'MNC'];
  File? _selectedProfileImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploadingProfilePic = false;
  ImageProvider? _cachedProfileImage;
  String? _cachedProfilePicUrl;

  String _name = "";
  String phone = "xxxxxxxxxxxx";
  String batch = "2025";
  String program = "DigiXplore";
  String branch = "CSE";
  Map<String, dynamic>? _user;
  late final StreamSubscription<Map<String, dynamic>?> _userDataSubscription;

  int _parseBatchYear(String value) {
    final match = RegExp(r'(\d{4})').firstMatch(value);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 2025;
    }

    return int.tryParse(value.trim()) ?? 2025;
  }
  
  
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
    _loadUser();
    _userDataSubscription = ApiService.userDataStream.listen((user) {
      if (!mounted) return;
      setState(() {
        _user = user;
        if (user != null) {
          if (user['name'] != null) {
            _name = user['name'].toString();
          }
          if (user['phoneNo'] != null) {
            phone = user['phoneNo'].toString();
          }
          if (user['batch'] != null) {
            batch = user['batch'] is Map<String, dynamic>
                ? '${user['batch']['startYear']}-${user['batch']['endYear']}'
                : user['batch'].toString();
          }
          if (user['program'] != null) {
            program = user['program'].toString();
          }
          if (user['branch'] != null) {
            branch = user['branch'].toString();
          }
        }
      });
    });
  }

  Future<void> _loadUser() async {
    final user = await ApiService.getUserData();
    if (!mounted) return;
    setState(() {
      _user = user;
      if (user != null) {
        _name = user['name']?.toString() ?? _name;
        phone = user['phoneNo']?.toString() ?? phone;
        batch = user['batch'] is Map<String, dynamic>
            ? '${user['batch']['startYear']}-${user['batch']['endYear']}'
            : (user['batch']?.toString() ?? batch);
        program = user['program']?.toString() ?? program;
        branch = user['branch']?.toString() ?? branch;
      }
    });
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    super.dispose();
  }

  // opens dialog to edit profile details
  void _editProfile({
    required String currentName,
    required String currentPhone,
    required String currentBatch,
    required String currentProgram,
    required String currentBranch,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);
    final batchController = TextEditingController(
      text: _parseBatchYear(currentBatch).toString(),
    );

    String selectedProgram = _programOptions.contains(currentProgram)
        ? currentProgram
        : _programOptions.first;
    String selectedBranch = _branchOptions.contains(currentBranch)
        ? currentBranch
        : _branchOptions.first;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                      labelText: AppLocalizations.of(context)!.username,
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      counterStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 11,
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
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(text)) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: batchController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.batchstartyear,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_month_outlined,
                        color: Color(0xFF147DAD),
                      ),
                      counterStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 11,
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
                      final text = value?.trim() ?? '';
                      final year = int.tryParse(text);
                      if (text.isEmpty) {
                        return 'Batch year is required';
                      }
                      if (year == null || year < 2000 || year > 2100) {
                        return 'Batch year must be between 2000 and 2100';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: selectedProgram,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.program,
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
                    items: _programOptions
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedProgram = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Program is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedBranch,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.branch,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF52616B),
                      ),
                      prefixIcon: Icon(
                        Icons.account_tree_outlined,
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
                    items: _branchOptions
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedBranch = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Branch is required';
                      }
                      return null;
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
                  final newBatchYear = int.parse(batchController.text.trim());

                  final res = await ApiService.updateProfile(
                    name: newName,
                    phoneNo: newPhone,
                    program: selectedProgram,
                    branch: selectedBranch,
                    batchYear: newBatchYear,
                  );

                  if (res['success'] == true) {
                    setState(() {
                      _name = newName;
                      phone = newPhone;
                      batch = '$newBatchYear-${newBatchYear + 4}';
                      program = selectedProgram;
                      branch = selectedBranch;
                    });
                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.profileupdated,
                          ),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res['message'] ?? 'Update failed'),
                        ),
                      );
                    }
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
    final user = _user;
    print("snapshot data in profile page ${user}");
    
    final profilePicUrl = user?['profilePic']?.toString() ?? '';

    if (_cachedProfilePicUrl != profilePicUrl) {
      _cachedProfilePicUrl = profilePicUrl;
      _cachedProfileImage =
          profilePicUrl.isNotEmpty ? NetworkImage(profilePicUrl) : null;
    }

    final ImageProvider? profileImage = _selectedProfileImage != null
        ? FileImage(_selectedProfileImage!)
        : _cachedProfileImage;


    final name = (user != null && user['name'] != null)
        ? user['name'] as String
        : _name;
    final email = (user != null && user['email'] != null)
        ? user['email'] as String
        : 'abc@iiitbh.ac.in';
    final phoneLocal = (user != null && user['phoneNo'] != null)
        ? user['phoneNo'] as String
        : phone;
    final batchLocal = (user != null && user['batch'] != null)
        ? (user['batch'] is Map<String, dynamic>
              ? '${user['batch']['startYear']}-${user['batch']['endYear']}'
              : user['batch'].toString())
        : batch;
    final roleLocal = (user != null && user['role'] != null)
        ? user['role'] as String
        : 'Volunteer';
    final programLocal = (user != null && user['program'] != null)
        ? user['program'] as String
        : program;
    final branchLocal = (user != null && user['branch'] != null)
        ? user['branch'] as String
        : branch;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 221, 221, 221),

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
              currentBatch: batchLocal,
              currentProgram: programLocal,
              currentBranch: branchLocal,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
      
              
        GestureDetector(
          onTap: () {
            if (profileImage != null) {
              _showProfilePicture(profileImage);
            } else {
              _changeProfilePicture();
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
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
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                
        child: ClipOval(
          child: profileImage != null
              ? Image(
                  image: profileImage,
                  fit: BoxFit.cover,
                  width: 126,
                  height: 126,

                  // Show loader while network image is loading
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    final expectedBytes =
                        loadingProgress.expectedTotalBytes;
                    final loadedBytes =
                        loadingProgress.cumulativeBytesLoaded;

                    return Container(
                      width: 126,
                      height: 126,
                      color: const Color(0xFF172B40),
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          value: expectedBytes != null
                              ? loadedBytes / expectedBytes
                              : null,
                          color: const Color(0xFF29B6F6),
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    );
                  },

                  errorBuilder: (_, __, ___) {
                    return const Center(
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.white70,
                      ),
                    );
                  },
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
                color: Color.fromARGB(255, 216, 220, 222),
              ),
            ),
          ),
        ),

      // Positioned(
      //   bottom: 2,
      //   right: 0,
      //   child: Material(
      //     color: const Color(0xFF29B6F6),
      //     elevation: 5,
      //     shape: const CircleBorder(),
      //     child: InkWell(
      //       customBorder: const CircleBorder(),
      //       onTap: _isUploadingProfilePic
      //       ? null
      //       : _changeProfilePicture,
      //       child: SizedBox(
      //         width: 40,
      //         height: 40,
      //         child: Center(
      //           child: _isUploadingProfilePic
      //               ? const SizedBox(
      //                   width: 19,
      //                   height: 19,
      //                   child: CircularProgressIndicator(
      //                     strokeWidth: 2,
      //                     color: Color(0xFF061A22),
      //                   ),
      //                 )
      //               : const Icon(
      //                   Icons.camera_alt_rounded,
      //                   color: Color(0xFF061A22),
      //                   size: 22,
      //                 ),
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

              // VIEW ATTENDANCE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelfAttendancePage(
                        userId: user != null && user['id'] != null
                            ? user['id'].toString()
                            : '',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    //padding: EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.calendar_month,
                              color: Colors.lightBlueAccent,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 14),

                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.viewyourattendance2,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

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
                            AppLocalizations.of(context)!.contactinformation,
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
                          title: programLocal,
                          subtitle: 'Program',
                          icon: Icons.flag,
                          iconColor: Colors.white,
                        ),

                        // VolunteerProfileListtile(
                        //   title: branch,
                        //   subtitle: 'branch',
                        //   icon: Icons.school,
                        //   iconColor: Colors.white,
                        // ),
                        VolunteerProfileListtile(
                          title: batchLocal,
                          subtitle: 'Batch',
                          icon: Icons.calendar_today,
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
  }
}
