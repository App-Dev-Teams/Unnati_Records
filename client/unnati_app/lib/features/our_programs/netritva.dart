import 'package:flutter/material.dart';

class NetritvaPage extends StatelessWidget {
  const NetritvaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFFF8A00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.trending_up, size: 80, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Netri',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Career Guidance & Mentorship Program',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
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
                  _buildSectionTitle('About Netri'),
                  SizedBox(height: 12),
                  _buildDescriptionCard(
                    'Netri is UNNATI\'s career guidance and mentorship program designed for underprivileged students focused on career awareness, self-development, and helping them discover their potential.',
                    Icons.info_outline,
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('Our Purpose'),
                  SizedBox(height: 12),
                  _buildFeaturesList([
                    'Help students make informed career choices',
                    'Provide mentorship support',
                    'Develop leadership qualities',
                    'Build self-confidence',
                    'Increase awareness about higher education and careers',
                  ]),
                  SizedBox(height: 30),
                  _buildSectionTitle('Who We Serve'),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _buildBeneficiaryCard(
                        'Underprivileged\nStudents',
                        Icons.person,
                      ),
                      SizedBox(width: 12),
                      _buildBeneficiaryCard('Rural\nLearners', Icons.map),
                      SizedBox(width: 12),
                      _buildBeneficiaryCard(
                        'First-Generation\nLearners',
                        Icons.family_restroom,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('Program Features'),
                  SizedBox(height: 12),
                  _buildFeatureCard(
                    'Career Guidance',
                    'Expert counseling for career path selection',
                    Icons.compass_calibration,
                    Color(0xFFFFA726),
                  ),
                  SizedBox(height: 12),
                  _buildFeatureCard(
                    'Mentorship Sessions',
                    'One-to-one interactions with experienced mentors',
                    Icons.people,
                    Color(0xFFFFB74D),
                  ),
                  SizedBox(height: 12),
                  _buildFeatureCard(
                    'Skill Development',
                    'Workshops focused on practical skill enhancement',
                    Icons.school,
                    Color(0xFFFFC95D),
                  ),
                  SizedBox(height: 12),
                  _buildFeatureCard(
                    'Leadership Training',
                    'Develop leadership qualities and self-belief',
                    Icons.star,
                    Color(0xFFFFD54F),
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('How Netritva Works'),
                  SizedBox(height: 12),
                  _buildProcessStep(
                    '1',
                    'Workshops',
                    'Interactive career and skill workshops',
                    Colors.orange,
                  ),
                  _buildProcessStep(
                    '2',
                    'Counseling',
                    'Personalized career counseling sessions',
                    Colors.deepOrange,
                  ),
                  _buildProcessStep(
                    '3',
                    'Mentorship',
                    'Connect with mentors and industry professionals',
                    Colors.deepOrangeAccent,
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('Our Impact'),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImpactCard(
                          'Career',
                          'Clarity Gained',
                          Color(0xFFFFA726),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildImpactCard(
                          'Exam',
                          'Awareness',
                          Color(0xFFFFB74D),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImpactCard(
                          'Education',
                          'Pathways Clear',
                          Color(0xFFFFC95D),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildImpactCard(
                          'Confusion',
                          'Overcome',
                          Color(0xFFFFD54F),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('Personal Development Impact'),
                  SizedBox(height: 12),
                  _buildImpactListCard('Overcome confusion', Icons.check_box),
                  SizedBox(height: 12),
                  _buildImpactListCard('Build ambition and goals', Icons.flag),
                  SizedBox(height: 12),
                  _buildImpactListCard('Develop confidence', Icons.verified),
                  SizedBox(height: 12),
                  _buildImpactListCard(
                    'Create goal-oriented mindsets',
                    Icons.trending_up,
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('Future Plans'),
                  SizedBox(height: 12),
                  _buildFutureCard(
                    'Create a structured mentorship network',
                    Icons.hub,
                  ),
                  SizedBox(height: 12),
                  _buildFutureCard(
                    'Connect with industry professionals',
                    Icons.business,
                  ),
                  SizedBox(height: 12),
                  _buildFutureCard(
                    'Connect with alumni network',
                    Icons.people_alt,
                  ),
                  SizedBox(height: 12),
                  _buildFutureCard(
                    'Provide scholarship guidance',
                    Icons.card_giftcard,
                  ),
                  SizedBox(height: 12),
                  _buildFutureCard(
                    'Offer internship opportunities',
                    Icons.work,
                  ),
                  SizedBox(height: 30),
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
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFF8A00),
      ),
    );
  }

  static Widget _buildDescriptionCard(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFA726).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFA726), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFFFFA726), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildFeaturesList(List<String> features) {
    return Column(
      children: features
          .map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFFFFA726), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  static Widget _buildBeneficiaryCard(String title, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFFFA726).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xFFFFA726), size: 32),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF8A00),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(width: 16),
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
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildProcessStep(
    String number,
    String title,
    String description,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
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
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildImpactCard(String number, String label, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  static Widget _buildImpactListCard(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFFFA726), size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildFutureCard(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFA726).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFA726).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFFFA726), size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
