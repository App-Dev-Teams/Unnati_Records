import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/features/adminappbar.dart';
import 'package:unnati_admin/features/leadcard.dart';

class AssignLeadsPage extends StatefulWidget {
  const AssignLeadsPage({super.key});

  @override
  State<AssignLeadsPage> createState() => _AssignLeadsPageState();
}

class _AssignLeadsPageState extends State<AssignLeadsPage> {
  final TextEditingController searchCtrl = TextEditingController();

  final List<String> roles = [
    "Finance Lead",
    "Operations Lead",
    "Volunteer",
    "School Lead",
  ];

  final List<Volunteer> allVolunteers = [
    Volunteer(name: "Anuj Sah"),
    Volunteer(name: "Thakur Ayush"),
    Volunteer(name: "Sukrit Aryan"),
    Volunteer(name: "Utkarsh"),
    Volunteer(name: "Priyanshu"),
    Volunteer(name: "Shreyas"),
  ];//isko replace krna hai mongodb se ane wali list se

  List<Volunteer> searchResults = [];
  List<Volunteer> leads = [];

  @override
  void initState() {
    super.initState();
    searchResults = List.from(allVolunteers);
  }

  void onSearch(String query) {
    setState(() {
      searchResults = allVolunteers
          .where((v) =>
              v.name.toLowerCase().contains(query.toLowerCase()) &&
              !leads.contains(v))
          .toList();
    });
  }

  void assignRole(Volunteer v, String role) {
    setState(() {
      v.role = role;
      leads.add(v);
      searchResults.remove(v);
    });
  }

  void deleteLead(Volunteer v) {
    setState(() {
      leads.remove(v);
      v.role = "";
      searchResults.add(v);
    });
  }

  void editLead(Volunteer v) {
    setState(() {
      leads.remove(v);
      searchResults.add(v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 12, 19),
      appBar: AdminAppBar(name: "Admin Name", imageName: "unnatiLogoColourFix.png"),
      body: SingleChildScrollView(
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

            const SizedBox(height: 20),

            ...searchResults.map((v) {
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
                      child: Text(
                        v.name,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
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

            const SizedBox(height: 30),

            Text(
              "Assigned Leads",
              style: GoogleFonts.oswald(
                fontSize: 22,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 14),

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
  String role;

  Volunteer({required this.name, this.role = ""});
}
