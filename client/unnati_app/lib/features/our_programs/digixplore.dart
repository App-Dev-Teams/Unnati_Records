import 'package:flutter/material.dart';

class DigixplorePage extends StatelessWidget {
  const DigixplorePage({super.key});

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
                    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.computer, size: 80, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Digi',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Empowering young minds with the skills of tomorrow',
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
                  _buildSectionTitle('About Digi'),
                  SizedBox(height: 12),
                  _buildDescriptionCard(
                    'Digi is UNNATI Society\'s digital education initiative focused on introducing underprivileged school students to technology and bridging the digital divide through weekly interactive sessions.',
                    Icons.info_outline,
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('Our Purpose'),
                  SizedBox(height: 12),
                  _buildFeaturesList([
                    'Teach computer fundamentals',
                    'Improve digital literacy',
                    'Encourage responsible technology use',
                    'Familiarize with modern digital tools',
                    'Prepare for future academic & professional environments',
                  ]),
                  SizedBox(height: 30),
                  _buildSectionTitle('Who We Serve'),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _buildBeneficiaryCard('Underprivileged\nStudents', Icons.school),
                      SizedBox(width: 12),
                      _buildBeneficiaryCard('Government\nSchools', Icons.domain),
                      SizedBox(width: 12),
                      _buildBeneficiaryCard('Rural\nLearners', Icons.location_on),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('What Students Learn'),
                  SizedBox(height: 12),
                  _buildSkillCard(
                    'Computer Fundamentals',
                    'Learn basics of computers, hardware, and software',
                    Icons.devices,
                    Color(0xFF1E88E5),
                  ),
                  SizedBox(height: 12),
                  _buildSkillCard(
                    'Digital Skills',
                    'Master essential tools and responsible internet usage',
                    Icons.security,
                    Color(0xFF43A047),
                  ),
                  SizedBox(height: 12),
                  _buildSkillCard(
                    'Problem-Solving',
                    'Develop critical thinking through interactive activities',
                    Icons.lightbulb,
                    Color(0xFFFB8C00),
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('How DigiXplore Works'),
                  SizedBox(height: 12),
                  _buildProcessStep('1', 'Weekly Sessions', 'Structured interactive learning sessions', Colors.blue),
                  _buildProcessStep('2', 'Activity-Based', 'Practical, hands-on computer education', Colors.green),
                  _buildProcessStep('3', 'Digital Workshops', 'Awareness and skill development workshops', Colors.orange),
                  SizedBox(height: 30),
                  _buildSectionTitle('Our Impact'),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImpactCard('Hundreds', 'Students Empowered', Colors.blue),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildImpactCard('Digital', 'Divide Bridged', Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImpactCard('Enhanced', 'Problem Solving', Colors.orange),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildImpactCard('Increased', 'Engagement', Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('Future Vision'),
                  SizedBox(height: 12),
                  _buildVisionCard('Expand to more rural and government schools', Icons.public),
                  SizedBox(height: 12),
                  _buildVisionCard('Introduce coding and AI awareness modules', Icons.code),
                  SizedBox(height: 12),
                  _buildVisionCard('Create digitally confident future generations', Icons.star),
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
        color: Color(0xFF1565C0),
      ),
    );
  }

  static Widget _buildDescriptionCard(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E88E5).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF1E88E5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF1E88E5), size: 24),
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
          .map((feature) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF43A047), size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  static Widget _buildBeneficiaryCard(String title, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF1E88E5).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xFF1E88E5), size: 32),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSkillCard(String title, String description, IconData icon, Color color) {
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

  static Widget _buildProcessStep(String number, String title, String description, Color color) {
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

  static Widget _buildVisionCard(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF1E88E5), size: 28),
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