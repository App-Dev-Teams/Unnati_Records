import 'package:flutter/material.dart';
import 'package:unnati_app/features/help&support/doubt_list_screen.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class LeadClosedDoubtsScreen extends StatelessWidget {
  const LeadClosedDoubtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubtListScreen(
      showClosedDoubts: true,
      title: AppLocalizations.of(context)!.closeddoubts,
    );
  }
}
