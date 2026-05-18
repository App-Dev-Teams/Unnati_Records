import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/features/adminappbar.dart';
import 'package:unnati_admin/features/leadcard.dart';
import 'package:unnati_admin/services/api_service.dart';

class AssignLeadsPage extends StatefulWidget {
  const AssignLeadsPage({super.key});

  @override
  State<AssignLeadsPage> createState() => _AssignLeadsPageState();
}

class _AssignLeadsPageState extends State<AssignLeadsPage> {
  final TextEditingController searchCtrl = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> roles = [
    "Finance Lead",
    "JS-Program",
    "JS-Public Relations",
    "JS-Technical",
    "DigiXplore Lead",
    "Akshar Lead",
    "Netritva Lead",
    "R&D Lead",
    "Operations Lead",
    "Social Media Lead",
    "Design Lead",
    "Video Editing Lead",
    "Outreach Lead",
    "Membership Lead",
  ];

  final List<String> programs = ["DigiXplore", "Netritva", "Akshar"];
  Map<String, bool> expandedPrograms = {
    'DigiXplore': false,
    'Netritva': false,
    'Akshar': false,
  };
  
  Map<String, List<Volunteer>> volunteersByProgram = {};
  Map<String, List<Volunteer>> searchResultsByProgram = {};
  List<Volunteer> leads = [];

  @override
  void initState() {
    super.initState();
    // Initialize all programs as collapsed
    for (var program in programs) {
      expandedPrograms[program] = false;
    }
    _loadVolunteers();
  }

  Future<void> _loadVolunteers() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final volunteerGrouped = await AdminApiService.fetchVolunteersByProgram();
      
      setState(() {
        volunteersByProgram = {};
        searchResultsByProgram = {};
        
        for (var program in programs) {
          final volunteers = volunteerGrouped[program] ?? [];
          volunteersByProgram[program] = volunteers
              .map((v) => Volunteer(
                name: v['name'] ?? 'Unknown',
                id: v['_id'] ?? '',
                email: v['email'] ?? '',
                program: program,
              ))
              .toList();
          searchResultsByProgram[program] = List.from(volunteersByProgram[program]!);
        }
        
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

  void onSearch(String query) {
    setState(() {
      searchResultsByProgram = {};
      for (var program in programs) {
        searchResultsByProgram[program] = volunteersByProgram[program]!
            .where((v) =>
                v.name.toLowerCase().contains(query.toLowerCase()) &&
                !leads.contains(v))
            .toList();
      }
    });
  }

  void assignRole(Volunteer v, String role) async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assigning role...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Call backend API
      final result = await AdminApiService.assignRoleToVolunteer(v.id, role);

      if (result['success'] == true) {
        // Success - update UI
        setState(() {
          v.role = role;
          leads.add(v);
          searchResultsByProgram[v.program]!.remove(v);
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role assigned: $role'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Error from backend
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${result['message'] ?? 'Failed to assign role'}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void deleteLead(Volunteer v) {
    setState(() {
      leads.remove(v);
      v.role = "";
      if (searchCtrl.text.isEmpty) {
        searchResultsByProgram[v.program]!.add(v);
      }
    });
  }

  void editLead(Volunteer v) {
    setState(() {
      leads.remove(v);
      if (searchCtrl.text.isEmpty) {
        searchResultsByProgram[v.program]!.add(v);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      appBar: AdminAppBar(name: "Admin Name", imageName: "unnatiLogoColourFix.png"),
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
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadVolunteers,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: searchCtrl,
                        onChanged: onSearch,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search volunteers",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 14, 22, 33),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ...programs.map((program) {
                        final volunteers = searchResultsByProgram[program] ?? [];
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
                                    "No volunteers available",
                                    style: GoogleFonts.nunito(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              else
                                ...volunteers.map((v) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: const Color.fromARGB(255, 14, 22, 33),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color.fromARGB(255, 9, 75, 128),
                                          child: Text(
                                            v.name[0],
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                v.name,
                                                style: GoogleFonts.nunito(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                v.email,
                                                style: GoogleFonts.nunito(
                                                  color: Colors.white54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DropdownButton<String>(
                                          dropdownColor:
                                              const Color.fromARGB(255, 14, 22, 33),
                                          hint: const Text(
                                            "Assign Role",
                                            style: TextStyle(color: Colors.white70),
                                          ),
                                          items: roles.map((r) {
                                            return DropdownMenuItem(
                                              value: r,
                                              child: Text(
                                                r,
                                                style:
                                                    const TextStyle(color: Colors.white),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            if (val != null) assignRole(v, val);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            ],
                            const SizedBox(height: 12),
                          ],
                        );
                      }),
                      const SizedBox(height: 20),
                      Text(
                        "Assigned Leads",
                        style: GoogleFonts.oswald(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (leads.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No leads assigned yet",
                            style: GoogleFonts.nunito(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        )
                      else
                        ...leads.map((v) {
                          return LeadCard(
                            name: v.name,
                            role: v.role,
                            onDelete: () => deleteLead(v),
                            onEdit: () => editLead(v),
                          );
                        }),
                    ],
                  ),
                ),
    );
  }
}

class Volunteer {
  final String name;
  final String id;
  final String email;
  final String program;
  String role;

  Volunteer({
    required this.name,
    required this.id,
    required this.email,
    required this.program,
    this.role = "",
  });
}
