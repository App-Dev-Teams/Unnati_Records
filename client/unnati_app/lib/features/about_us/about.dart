import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/l10n/app_localizations.dart';
import 'package:unnati_app/theme/colors.dart';

import '../our_programs/akshar.dart';
import '../our_programs/digixplore.dart';
import '../our_programs/netritva.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260.h,
            pinned: true,
            elevation: 2,
            backgroundColor: const Color.fromARGB(255, 9, 12, 19),
            leading: Padding(
              padding: EdgeInsets.all(8.r),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.35),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      // Logo Badge
                      Container(
                        height: 76.h,
                        width: 76.h,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/unnatiLogoColourFix.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.unnatisociety,
                        style: GoogleFonts.oswald(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          l10n.socialoutreachinitiative,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l10n.aboutUnnatiTitle),
                  SizedBox(height: 12.h),
                  _buildAboutCard(context),
                  SizedBox(height: 28.h),

                  _buildSectionTitle(l10n.parentInstitutionTitle),
                  SizedBox(height: 12.h),
                  _buildInstitutionCard(context),
                  SizedBox(height: 28.h),

                  _buildSectionTitle(l10n.ourMissionTitle),
                  SizedBox(height: 12.h),
                  _buildMissionCard(context),
                  SizedBox(height: 28.h),

                  _buildSectionTitle(l10n.oURpROGRAMS),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.clickonanyprogramcardtoexploreindetail,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 14.h),

                  _buildProgramCard(
                    context,
                    imageLogo: 'digilogo.png',
                    title: l10n.digixploreDigiXplore,
                    subtitle: l10n.programDigixploreSubtitle,
                    description: l10n.programDigixploreDescription,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DigixplorePage(),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  _buildProgramCard(
                    context,
                    imageLogo: 'aklogo.png',
                    title: l10n.akshar,
                    subtitle: l10n.programAksharSubtitle,
                    description: l10n.programAksharDescription,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AksharPage(),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  _buildProgramCard(
                    context,
                    imageLogo: 'netrilogo.png',
                    title: l10n.netritva,
                    subtitle: l10n.programNetritvaSubtitle,
                    description: l10n.programNetritvaDescription,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NetritvaPage(),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),

                  _buildSectionTitle(l10n.contactUsTitle),
                  SizedBox(height: 12.h),
                  _buildContactCard(context),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Container(
            height: 22.h,
            width: 6.w,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.oswald(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  static Widget _buildAboutCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: C.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: C.blue,
                    size: 22,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    l10n.whatisunnati,
                    style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.unnatisocietyisaninstituteoutreachactivityandsocialoutreachinitiativeassociatedwithiIITbhagalpurfocusedonempoweringunderprivilegedcommunitiesthrougheducationmentorshipliteracyanddigitalinclusion,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildInstitutionCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 48.h,
                  width: 48.h,
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Image.asset(
                    'assets/images/collegeLogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.iIITbhagalpur,
                        style: GoogleFonts.oswald(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        l10n.aninstituteofnationalimportance,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(color: Colors.grey.shade200, height: 1),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: C.blue,
                  size: 20,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    l10n.sabourbhagalpurbihar813210india,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMissionCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MissionPoint(
              icon: Icons.school_rounded,
              iconColor: const Color(0xFF1976D2),
              bgColor: const Color(0xFFE3F2FD),
              title: l10n.educationalempowerment,
              description: l10n.educationalEmpowermentDesc,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Divider(color: Colors.grey.shade200, height: 1),
            ),
            _MissionPoint(
              icon: Icons.people_alt_rounded,
              iconColor: const Color(0xFF388E3C),
              bgColor: const Color(0xFFE8F5E9),
              title: l10n.socialempowerment,
              description: l10n.socialEmpowermentDesc,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Divider(color: Colors.grey.shade200, height: 1),
            ),
            _MissionPoint(
              icon: Icons.stars_rounded,
              iconColor: const Color(0xFFF57C00),
              bgColor: const Color(0xFFFFF3E0),
              title: l10n.youthdevelopment,
              description: l10n.youthDevelopmentDesc,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Divider(color: Colors.grey.shade200, height: 1),
            ),
            _MissionPoint(
              icon: Icons.rocket_launch_rounded,
              iconColor: const Color(0xFF7B1FA2),
              bgColor: const Color(0xFFF3E5F5),
              title: l10n.communityimpact,
              description: l10n.communityImpactDesc,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildProgramCard(
    BuildContext context, {
    required String imageLogo,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 58.h,
                    width: 58.h,
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Image.asset(
                      'assets/images/$imageLogo',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.oswald(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          subtitle,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: C.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black38,
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                description,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    l10n.taptoexplore,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: C.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  const Icon(
                    Icons.touch_app_rounded,
                    size: 16,
                    color: C.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildContactCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: C.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Icon(
                Icons.email_outlined,
                color: C.blue,
                size: 24,
              ),
            ),
            SizedBox(width: 14.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.email,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'unnati.ir@iiitbh.ac.in',
                  style: GoogleFonts.oswald(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionPoint extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String description;

  const _MissionPoint({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.oswald(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                description,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
