import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_admin/features/adminappbar.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        name: "Admin Name",
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
                  child: _AdminActionCard(
                    icon: Icons.groups_outlined,
                    title: "Manage Volunteers",
                    subtitle: "View, approve, remove",
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: 180,
                  width: MediaQuery.of(context).size.width / 2 - 30 ,
                  child: _AdminActionCard(
                    icon: Icons.admin_panel_settings_outlined,
                    title: "Assign Leads",
                    subtitle: "Promote & change roles",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// 🔹 CURRENT LEADS
            Text(
              "Current Leads",
              style: GoogleFonts.oswald(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            _LeadCard(
              name: "Anuj Sah",
              role: "Education Lead",
            ),
            _LeadCard(
              name: "Thakur Ayush",
              role: "Operations Lead",
            ),
            _LeadCard(
              name: "Sukrit Aryan",
              role: "Design Lead",
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
class _LeadCard extends StatelessWidget {
  final String name;
  final String role;

  const _LeadCard({
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color.fromARGB(255, 14, 22, 33),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 9, 75, 128),
            child: Text(
              name[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
