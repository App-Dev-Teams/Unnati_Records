import 'package:flutter/material.dart';
import '../our_programs/digixplore.dart';
import '../our_programs/akshar.dart';
import '../our_programs/netritva.dart';

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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6200EA), Color(0xFF3700B3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, size: 60, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'UNNATI Society',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Social Outreach Initiative',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('About UNNATI'),

                  const SizedBox(height: 12),

                  _buildAboutCard(),

                  const SizedBox(height: 30),

                  _buildSectionTitle('Parent Institution'),

                  const SizedBox(height: 12),

                  _buildInstitutionCard(),

                  const SizedBox(height: 30),

                  _buildSectionTitle('Our Mission'),

                  const SizedBox(height: 12),

                  _buildMissionCard(),

                  const SizedBox(height: 30),

                  _buildSectionTitle('Our Programs'),

                  const SizedBox(height: 12),

                  Text(
                    'Click on any program card to explore in detail',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildProgramCard(
                    context,
                    'DigiXplore',
                    'Digital Education Initiative',
                    'Introducing underprivileged students to technology and bridging the digital divide through interactive sessions.',
                    Icons.computer,
                    const Color(0xFF1E88E5),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DigixplorePage(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildProgramCard(
                    context,
                    'Akshar',
                    'Foundational Education Initiative',
                    'Providing foundational literacy and numeracy to underprivileged children unable to attend formal schooling.',
                    Icons.auto_stories,
                    const Color(0xFFE91E63),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AksharPage(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildProgramCard(
                    context,
                    'Netritva',
                    'Career Guidance & Mentorship',
                    'Helping underprivileged students discover their potential through career guidance, mentorship, and leadership development.',
                    Icons.trending_up,
                    const Color(0xFFFFA726),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NetritvaPage(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildSectionTitle('Contact Us'),

                  const SizedBox(height: 12),

                  _buildContactCard(),

                  const SizedBox(height: 20),
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
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3700B3),
      ),
    );
  }

  static Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6200EA).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6200EA), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is UNNATI?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3700B3),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'UNNATI Society is an Institute Outreach Activity and social outreach initiative associated with IIIT Bhagalpur, focused on empowering underprivileged communities through education, mentorship, literacy, and digital inclusion.',
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

  static Widget _buildInstitutionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Colors.blue, size: 28),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IIIT Bhagalpur',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),

                    Text(
                      'An Institute of National Importance',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 18),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  'Sabour, Bhagalpur, Bihar 813210, India',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildMissionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3700B3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3700B3), width: 1),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MissionPoint(
            emoji: '🎓',
            title: 'Educational Empowerment',
            description: 'Literacy, digital, and career guidance',
          ),

          SizedBox(height: 12),

          _MissionPoint(
            emoji: '👥',
            title: 'Social Empowerment',
            description:
                'Reducing inequality & supporting marginalized communities',
          ),

          SizedBox(height: 12),

          _MissionPoint(
            emoji: '⭐',
            title: 'Youth Development',
            description: 'Leadership, skill development & confidence building',
          ),

          SizedBox(height: 12),

          _MissionPoint(
            emoji: '🚀',
            title: 'Community Impact',
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),

                const SizedBox(width: 16),

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

                      const SizedBox(height: 4),

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

            const SizedBox(height: 12),

            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Tap to explore',
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.touch_app, size: 14, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),

      child: Row(
        children: [
          Icon(Icons.email, color: Colors.grey[700], size: 24),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),

              Text(
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
        Text(emoji, style: const TextStyle(fontSize: 20)),

        const SizedBox(width: 12),

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
