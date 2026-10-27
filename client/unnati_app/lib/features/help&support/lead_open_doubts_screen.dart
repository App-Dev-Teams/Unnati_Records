import 'package:flutter/material.dart';
import 'package:unnati_app/features/help&support/doubt_list_screen.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class LeadOpenDoubtsScreen extends StatelessWidget {
  const LeadOpenDoubtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubtListScreen(
      showOpenDoubts: true,
      title: AppLocalizations.of(context)!.opendoubts,
    );
  }
}
