import 'package:flutter/material.dart';

class VolunteerProfileListtile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const VolunteerProfileListtile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      
      child: Row(
        children: [
          // Icon container
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Text section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: const Color.fromARGB(255, 167, 167, 167),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
