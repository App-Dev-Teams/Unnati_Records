import 'package:flutter/material.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    super.key,
    required this.currentLocale,
    required this.onLanguageChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isHindi = currentLocale.languageCode == 'hi';

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _languageButton(
            label: 'ENG',
            selected: !isHindi,
            onTap: () => onLanguageChanged(const Locale('en')),
          ),
          _languageButton(
            label: 'HI',
            selected: isHindi,
            onTap: () => onLanguageChanged(const Locale('hi')),
          ),
        ],
      ),
    );
  }

  Widget _languageButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
