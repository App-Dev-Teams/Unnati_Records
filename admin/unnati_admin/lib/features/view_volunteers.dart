import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/features/adminappbar.dart';
import 'package:unnati_admin/services/api_service.dart';

class ViewVolunteersPage extends StatefulWidget {
  const ViewVolunteersPage({super.key});

  @override
  State<ViewVolunteersPage> createState() => _ViewVolunteersPageState();
}

class _ViewVolunteersPageState extends State<ViewVolunteersPage> {
  bool _isLoading = true;
  String? _errorMessage;
  String adminName = "Admin";
  
  final List<String> programs = ["DigiXplore", "Netritva", "Akshar"];
  Map<String, bool> expandedPrograms = {
    'DigiXplore': false,
    'Netritva': false,
    'Akshar': false,
  };
  Map<String, List<Map<String, dynamic>>> volunteersByProgram = {};
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAdminName();
    _loadAllVolunteers();
  }

  Future<void> _loadAdminName() async {
    final storedName = await AdminApiService.getAdminName();
    if (!mounted) return;
    setState(() {
      adminName = (storedName != null && storedName.isNotEmpty) ? storedName : "Admin";
    });
  }

  Future<void> _loadAllVolunteers() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final volunteersGrouped = await AdminApiService.fetchVolunteersByProgram();

      setState(() {
        volunteersByProgram = volunteersGrouped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load volunteers: $e';
      });
      print('Error loading volunteers: $e');
    }
  }

  List<Map<String, dynamic>> _getFilteredVolunteers(String program) {
    final volunteers = volunteersByProgram[program] ?? [];
    if (searchQuery.isEmpty) {
      return volunteers;
    }
    return volunteers
        .where((v) =>
            (v['name'] ?? '').toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
            (v['email'] ?? '').toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void _showVolunteerDetails(Map<String, dynamic> volunteer, String program) {
    // Extract roll number from email (format: xxx.XXXXXX@iiitbh.ac.in)
    String email = volunteer['email'] ?? '';
    String rollNo = 'N/A';
    String batch = 'N/A';
    
    if (email.contains('.') && email.contains('@')) {
      final parts = email.split('.');
      if (parts.length > 1) {
        final emailParts = parts[1].split('@');
        if (emailParts.isNotEmpty) {
          rollNo = emailParts[0];
          // Extract first two digits and create batch (20XX)
          if (rollNo.length >= 2) {
            batch = '20${rollNo.substring(0, 2)}';
          }
        }
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 14, 22, 33),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                        child: Text(
                          (volunteer['name'] ?? 'V')[0].toUpperCase(),
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              volunteer['name'] ?? 'Unknown',
                              style: GoogleFonts.oswald(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                program,
                                style: GoogleFonts.nunito(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _detailRow('Email', email),
                  SizedBox(height: 16.h),
                  _detailRow('Roll Number', rollNo),
                  SizedBox(height: 16.h),
                  _detailRow('Batch', batch),
                  SizedBox(height: 16.h),
                  _detailRow('Role', volunteer['role'] ?? 'Volunteer'),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 9, 12, 19),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(
            value,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 9, 12, 19),
          elevation: 4,
          shadowColor: Colors.black54,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 8.0.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                  backgroundImage: const AssetImage("assets/images/unnatiLogoColourFix.png"),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        adminName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Administrator",
                        style: GoogleFonts.nunito(
                          color: Colors.lightBlueAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          titleSpacing: 0,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadAllVolunteers,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        style: TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search volunteers by name or email",
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 17),
                          prefixIcon: Icon(Icons.search, color: Colors.white54, size: 20),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 14, 22, 33),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ...programs.map((program) {
                        final volunteers = _getFilteredVolunteers(program);
                        final isExpanded = expandedPrograms[program] ?? false;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  expandedPrograms[program] = !isExpanded;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 9, 75, 128),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          isExpanded
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          program,
                                          style: GoogleFonts.oswald(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${volunteers.length}',
                                        style: GoogleFonts.nunito(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded) ...[
                              const SizedBox(height: 12),
                              if (volunteers.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "No volunteers found",
                                    style: GoogleFonts.nunito(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              else
                                ...volunteers.map((v) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _showVolunteerDetails(v, program),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 12),
                                      padding: EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color:
                                            const Color.fromARGB(255, 14, 22, 33),
                                        border: Border.all(color: Colors.white10),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                const Color.fromARGB(255, 9, 75, 128),
                                            child: Text(
                                              (v['name'] ?? 'V')[0].toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  v['name'] ?? 'Unknown',
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  v['email'] ?? 'N/A',
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white54,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (v['role'] != null &&
                                              v['role'].toString().isNotEmpty)
                                            Container(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .orangeAccent
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                v['role'] ?? '',
                                                style: GoogleFonts.nunito(
                                                  color: Colors.orangeAccent,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            ],
                            const SizedBox(height: 12),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
    );
  }
}