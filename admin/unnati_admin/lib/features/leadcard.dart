import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class LeadCard extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const LeadCard({
    required this.name,
    required this.role,
    required this.onDelete,
    required this.onEdit,
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
            onPressed: onEdit,
          ),
          IconButton(
            icon:
                const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
