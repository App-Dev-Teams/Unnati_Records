import 'package:flutter/material.dart';
import '../our_programs/digixplore.dart';
import '../our_programs/akshar.dart';
import '../our_programs/netritva.dart';

import 'package:unnati_app/l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6200EA), Color(0xFF3700B3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, size: 60, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.unnatisociety,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.socialoutreachinitiative,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('About Unnati'),

                  SizedBox(height: 12),

                  _buildAboutCard(context),

                  SizedBox(height: 30),

                  _buildSectionTitle('Parent Institution'),

                  SizedBox(height: 12),

                  _buildInstitutionCard(context),

                  SizedBox(height: 30),

                  _buildSectionTitle('Our Mission'),

                  SizedBox(height: 12),

                  _buildMissionCard(context),

                  SizedBox(height: 30),

                  _buildSectionTitle('Our Programs'),

                  SizedBox(height: 12),

                  Text(
                    AppLocalizations.of(
                      context,
                    )!.clickonanyprogramcardtoexploreindetail,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 16),

                  _buildProgramCard(
                    context,
                    'DigiXplore',
                    'Digital Education Initiative',
                    'Introducing underprivileged students to technology and bridging the digital divide through interactive sessions.',
                    Icons.computer,
                    Color(0xFF1E88E5),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DigixplorePage()),
                    ),
                  ),

                  SizedBox(height: 16),

                  _buildProgramCard(
                    context,
                    'Akshar',
                    'Foundational Education Initiative',
                    'Providing foundational literacy and numeracy to underprivileged children unable to attend formal schooling.',
                    Icons.auto_stories,
                    Color(0xFFE91E63),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AksharPage()),
                    ),
                  ),

                  SizedBox(height: 16),

                  _buildProgramCard(
                    context,
                    'Netritva',
                    'Career Guidance & Mentorship',
                    'Helping underprivileged students discover their potential through career guidance, mentorship, and leadership development.',
                    Icons.trending_up,
                    Color(0xFFFFA726),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NetritvaPage()),
                    ),
                  ),

                  SizedBox(height: 30),

                  _buildSectionTitle('Contact Us'),

                  SizedBox(height: 12),

                  _buildContactCard(context),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3700B3),
      ),
    );
  }

  static Widget _buildAboutCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF6200EA).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF6200EA), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.whatisunnati,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3700B3),
            ),
          ),

          SizedBox(height: 8),

          Text(
            AppLocalizations.of(
              context,
            )!.unnatisocietyisaninstituteoutreachactivityandsocialoutreachinitiativeassociatedwithiIITbhagalpurfocusedonempoweringunderprivilegedcommunitiesthrougheducationmentorshipliteracyanddigitalinclusion,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInstitutionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Image.asset('assets/images/collegeLogo.png'),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.iIITbhagalpur,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),

                    Text(
                      AppLocalizations.of(
                        context,
                      )!.aninstituteofnationalimportance,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey, size: 18),

              SizedBox(width: 8),

              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.sabourbhagalpurbihar813210india,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildMissionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF3700B3).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3700B3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MissionPoint(
            emoji: '🎓',
            title: AppLocalizations.of(context)!.educationalempowerment,
            description: 'Literacy, digital, and career guidance',
          ),

          SizedBox(height: 12),

          _MissionPoint(
            emoji: '👥',
            title: AppLocalizations.of(context)!.socialempowerment,
            description:
                'Reducing inequality & supporting marginalized communities',
          ),

          SizedBox(height: 12),

          _MissionPoint(
            emoji: '⭐',
            title: AppLocalizations.of(context)!.youthdevelopment,
            description: 'Leadership, skill development & confidence building',
          ),

          SizedBox(height: 12),

          _MissionPoint(
            emoji: '🚀',
            title: AppLocalizations.of(context)!.communityimpact,
            description: 'Bridging educational & digital divides',
          ),
        ],
      ),
    );
  }

  static Widget _buildProgramCard(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),

                SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(Icons.arrow_forward_ios, color: color, size: 20),
              ],
            ),

            SizedBox(height: 12),

            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!.taptoexplore,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.touch_app, size: 14, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildContactCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),

      child: Row(
        children: [
          Icon(Icons.email, color: Colors.grey[700], size: 24),

          SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.email,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),

              Text(
                // 'unnati.ir@iiitbh.ac.in',
                'unnati.ir@iiitbh.ac.in',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MissionPoint extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _MissionPoint({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: TextStyle(fontSize: 20)),

        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
