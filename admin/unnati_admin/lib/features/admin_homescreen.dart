import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/features/adminappbar.dart';
import 'package:unnati_admin/features/assign_leads.dart';
import 'package:unnati_admin/features/file_upload_admin.dart';
import 'package:unnati_admin/features/leadcard.dart';
import 'package:unnati_admin/services/api_service.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String adminName = "Admin";
  Map<String, List<Map<String, dynamic>>> leadsByProgram = {};
  Map<String, bool> expandedPrograms = {
    'DigiXplore': false,
    'Netritva': false,
    'Akshar': false,
  };
  final List<String> programs = ["DigiXplore", "Netritva", "Akshar"];
  bool _isLoadingLeads = false;

  @override
  void initState() {
    super.initState();
    // Add slight delay to ensure SharedPreferences data is written
    Future.delayed(const Duration(milliseconds: 100), () {
      _loadAdminName();
      _loadCurrentLeads();
    });
  }

  Future<void> _loadAdminName() async {
    final storedName = await AdminApiService.getAdminName();
    if (!mounted) return;
    setState(() {
      adminName = (storedName != null && storedName.isNotEmpty) ? storedName : "Admin";
    });
  }

  Future<void> _loadCurrentLeads() async {
    try {
      setState(() {
        _isLoadingLeads = true;
      });
      final volunteersGrouped = await AdminApiService.fetchVolunteersByProgram();
      
      Map<String, List<Map<String, dynamic>>> grouped = {};
      for (var program in programs) {
        final volunteers = volunteersGrouped[program] ?? [];
        grouped[program] = volunteers
            .where((v) => (v['role'] ?? '').toString().contains('Lead'))
            .map((v) {
              return {
                'name': v['name'] ?? 'Unknown',
                'role': v['role'] ?? 'Volunteer',
                'id': v['_id'] ?? '',
                'program': program,
              };
            })
            .toList();
      }

      if (mounted) {
        setState(() {
          leadsByProgram = grouped;
          _isLoadingLeads = false;
        });
      }
    } catch (e) {
      print('Error loading current leads: $e');
      if (mounted) {
        setState(() {
          _isLoadingLeads = false;
        });
      }
    }
  }

  void _deleteLead(Map<String, dynamic> lead) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 14, 22, 33),
          title: Text(
            'Delete Lead?',
            style: GoogleFonts.nunito(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to remove ${lead['name']} from leads?',
            style: GoogleFonts.nunito(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.nunito(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final program = lead['program'];
                  if (leadsByProgram.containsKey(program)) {
                    leadsByProgram[program]!.removeWhere((l) => l['id'] == lead['id']);
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${lead['name']} removed from leads'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                'Delete',
                style: GoogleFonts.nunito(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editLead(Map<String, dynamic> lead) {
    final roles = [
      "Finance Lead",
      "Operations Lead",
      "Volunteer",
      "School Lead",
      "Education Lead",
      "Design Lead",
    ];

    String selectedRole = lead['role'] ?? 'Volunteer';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 14, 22, 33),
              title: Text(
                'Edit Lead Role',
                style: GoogleFonts.nunito(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lead['name'],
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    dropdownColor: const Color.fromARGB(255, 14, 22, 33),
                    isExpanded: true,
                    value: selectedRole,
                    items: roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(
                          role,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedRole = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.nunito(color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      final program = lead['program'];
                      if (leadsByProgram.containsKey(program)) {
                        final index = leadsByProgram[program]!.indexWhere((l) => l['id'] == lead['id']);
                        if (index != -1) {
                          leadsByProgram[program]![index]['role'] = selectedRole;
                        }
                      }
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${lead['name']} updated to $selectedRole'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.nunito(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        name: adminName,
        imageName: "unnatiLogoColourFix.png",
      ),
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Dashboard",
              style: GoogleFonts.oswald(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Manage volunteers and leads",
              style: GoogleFonts.nunito(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 28),

          
            Row(
              children: [
                SizedBox(
                  height: 180,
                  width: MediaQuery.of(context).size.width / 2 - 30 ,
                  child: InkWell(
                    onTap: (){
                      Navigator.push( context, MaterialPageRoute(builder: (context) => const AdminFileUploadPage(),) );
                    },
                    child: _AdminActionCard(
                      icon: Icons.file_copy,
                      title: "Upload Files",
                      subtitle: "Provide students the study materials.",
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: 180,
                  width: MediaQuery.of(context).size.width / 2 - 30 ,
                  child: InkWell(
                    onTap: (){
                      Navigator.push( context, MaterialPageRoute(builder: (context) =>  AssignLeadsPage(),) );
                    },
                    child: _AdminActionCard(
                      icon: Icons.admin_panel_settings_outlined,
                      title: "Assign Leads",
                      subtitle: "Promote & change roles",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Text(
              "Current Leads",
              style: GoogleFonts.oswald(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            _isLoadingLeads
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: programs.map((program) {
                      final leads = leadsByProgram[program] ?? [];
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
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                        isExpanded ? Icons.expand_less : Icons.expand_more,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 12),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${leads.length}',
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
                          if (isExpanded && leads.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            ...leads.map((lead) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: LeadCard(
                                  name: lead['name'],
                                  role: lead['role'],
                                  onEdit: () => _editLead(lead),
                                  onDelete: () => _deleteLead(lead),
                                ),
                              );
                            }),
                          ],
                          if (isExpanded && leads.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'No leads assigned in $program',
                                style: GoogleFonts.nunito(
                                  color: Colors.white54,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
class _AdminActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AdminActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF111212),
            Color(0xFF1E2A3A),
            Color(0xFF2B3D54),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.lightBlueAccent, size: 30),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
// // class _LeadCard extends StatelessWidget {
//   final String name;
//   final String role;

//   const _LeadCard({
//     required this.name,
//     required this.role,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         color: const Color.fromARGB(255, 14, 22, 33),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: const Color.fromARGB(255, 9, 75, 128),
//             child: Text(
//               name[0],
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),

//           const SizedBox(width: 14),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: GoogleFonts.nunito(
//                     fontSize: 15,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   role,
//                   style: GoogleFonts.nunito(
//                     fontSize: 13,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           IconButton(
//             icon: const Icon(Icons.edit, color: Colors.white70),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }
