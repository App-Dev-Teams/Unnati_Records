import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/l10n/app_localizations.dart';

class DigixplorePage extends StatelessWidget {
  const DigixplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.h,
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
                        height: 84.h,
                        width: 84.h,
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
                          'assets/images/digilogo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        l10n.digixploreDigiXplore,
                        style: GoogleFonts.oswald(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          l10n.digixploreEmpoweringYoungMindsWithTheSkillsOfTomorrow,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
                  _buildSectionTitle(l10n.digixploreAboutDigiXplore),
                  SizedBox(height: 12.h),
                  _buildDescriptionCard(
                    l10n.digixploreDigiXploreIsUNNATISocietySDigitalEducationInitiativeFocusedOnIntroducingUnderprivilegedSchoolStudentsToTechnologyAndBridgingTheDigitalDivideThroughWeeklyInteractiveSessions,
                    Icons.devices_rounded,
                  ),
                  SizedBox(height: 28.h),
                  _buildSectionTitle(l10n.digixploreOurPurpose),
                  SizedBox(height: 12.h),
                  _buildFeaturesList([
                    l10n.digixploreTeachComputerFundamentalsAndPracticalOperation,
                    l10n.digixploreImproveDigitalLiteracyAndInternetAwareness,
                    l10n.digixploreEncourageSafeAndResponsibleTechnologyUse,
                    l10n.digixploreFamiliarizeStudentsWithModernDigitalTools,
                    l10n.digixplorePrepareLearnersForAcademicProfessionalEnvironments,
                  ]),
                  SizedBox(height: 28.h),
                  _buildSectionTitle(l10n.digixploreWhoWeServe),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _buildBeneficiaryCard(
                        l10n.digixploreUnderprivilegedStudents,
                        Icons.school_rounded,
                      ),
                      SizedBox(width: 10.w),
                      _buildBeneficiaryCard(
                        l10n.digixploreGovernmentSchools,
                        Icons.domain_rounded,
                      ),
                      SizedBox(width: 10.w),
                      _buildBeneficiaryCard(
                        l10n.digixploreRuralLearners,
                        Icons.location_on_rounded,
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  _buildSectionTitle(l10n.digixploreWhatStudentsLearn),
                  SizedBox(height: 12.h),
                  _buildSkillCard(
                    l10n.digixploreComputerFundamentals,
                    l10n.digixploreLearnBasicsOfComputersHardwareOperatingSystemsAndTyping,
                    Icons.devices_rounded,
                  ),
                  SizedBox(height: 12.h),
                  _buildSkillCard(
                    l10n.digixploreDigitalSkills,
                    l10n.digixploreMasterEssentialProductivityToolsWebBrowsingAndDigitalSafety,
                    Icons.security_rounded,
                  ),
                  SizedBox(height: 12.h),
                  _buildSkillCard(
                    l10n.digixploreProblemSolving,
                    l10n.digixploreDevelopCriticalThinkingThroughInteractiveChallengesAndActivities,
                    Icons.lightbulb_outline_rounded,
                  ),
                  SizedBox(height: 28.h),
                  _buildSectionTitle(l10n.digixploreHowDigiXploreWorks),
                  SizedBox(height: 12.h),
                  _buildProcessStep(
                    '1',
                    l10n.digixploreWeeklySessions,
                    l10n.digixploreStructuredInteractiveLearningSessionsWithHandsOnPractice,
                  ),
                  SizedBox(height: 10.h),
                  _buildProcessStep(
                    '2',
                    l10n.digixploreActivityBased,
                    l10n.digixplorePracticalEngagingProjectDrivenComputerEducation,
                  ),
                  SizedBox(height: 10.h),
                  _buildProcessStep(
                    '3',
                    l10n.digixploreDigitalWorkshops,
                    l10n.digixploreSpecialAwarenessAndSkillDevelopmentGuestWorkshops,
                  ),
                  SizedBox(height: 28.h),
                  _buildSectionTitle(l10n.digixploreOurImpact),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImpactCard(
                          l10n.digixploreHundreds,
                          l10n.digixploreStudentsEmpowered,
                          Colors.blue,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildImpactCard(
                          l10n.digixploreDigital,
                          l10n.digixploreDivideBridged,
                          Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImpactCard(
                          l10n.digixploreEnhanced,
                          l10n.digixploreProblemSolving,
                          Colors.black,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildImpactCard(
                          l10n.digixploreIncreased,
                          l10n.digixploreStudentEngagement,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  _buildSectionTitle(l10n.digixploreFutureVision),
                  SizedBox(height: 12.h),
                  _buildVisionCard(
                    l10n.digixploreExpandToMoreRuralAndGovernmentPartnerSchools,
                    Icons.public_rounded,
                  ),
                  SizedBox(height: 10.h),
                  _buildVisionCard(
                    l10n.digixploreIntroduceBasicCodingLogicBuildingAndAIAwarenessModules,
                    Icons.code_rounded,
                  ),
                  SizedBox(height: 10.h),
                  _buildVisionCard(
                    l10n.digixploreCreateDigitallyConfidentAndFutureReadyGenerations,
                    Icons.star_border_rounded,
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section title matching lines 74-88 of volunteer_home_page.dart
  static Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(height: 25.h, width: 7.h, color: Colors.black),
        ),
        SizedBox(width: 10.w),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.oswald(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  static Widget _buildDescriptionCard(String text, IconData icon) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: Colors.black87, size: 24),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFeaturesList(List<String> features) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: features.map((feature) {
            final isLast = features.last == feature;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.black87,
                    size: 20,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      feature,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  static Widget _buildBeneficiaryCard(String title, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 48.h,
                width: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.grey.shade100,
                ),
                padding: EdgeInsets.all(6.r),
                child: Icon(icon, color: Colors.black87, size: 26),
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSkillCard(
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 48.h,
              width: 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.grey.shade100,
              ),
              padding: EdgeInsets.all(6.r),
              child: Icon(icon, color: Colors.black87, size: 24),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.oswald(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
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
        ),
      ),
    );
  }

  static Widget _buildProcessStep(
    String number,
    String title,
    String description,
  ) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    description,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Exact matching VolunteerCardUtil from homescreen
  static Widget _buildImpactCard(
    String subtitle,
    String title,
    Color curvedColor,
  ) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top curved border like VolunteerCardUtil
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 7.h,
              decoration: BoxDecoration(
                color: curvedColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 113, 113, 113),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.oswald(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildVisionCard(String text, IconData icon) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: Colors.black87, size: 20),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
