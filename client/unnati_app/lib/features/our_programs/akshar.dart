import 'package:flutter/material.dart';

class AksharPage extends StatelessWidget {
  const AksharPage({super.key});

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
                    colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_stories, size: 80, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Aksh',
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
                  _buildSectionTitle('About Aksh'),
                  SizedBox(height: 12),
                  _buildDescriptionCard(
                    'Aksh is UNNATI Society\'s foundational education initiative focused on underprivileged children designed for those unable to afford formal schooling and built around community-based learning.',
                    Icons.info_outline,
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('Our Purpose'),
                  SizedBox(height: 12),
                  _buildFeaturesList([
                    'Provide access to education',
                    'Deliver foundational literacy skills',
                    'Teach numeracy and basic mathematics',
                    'Improve English communication',
                    'Support children excluded from formal education',
                  ]),
                  SizedBox(height: 30),
                  _buildSectionTitle('Who We Serve'),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _buildBeneficiaryCard('Underprivileged\nChildren', Icons.child_care),
                      SizedBox(width: 12),
                      _buildBeneficiaryCard('Out-of-School\nChildren', Icons.school_outlined),
                      SizedBox(width: 12),
                      _buildBeneficiaryCard('Rural &\nDisadvantaged', Icons.public),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('What Students Learn'),
                  SizedBox(height: 12),
                  _buildSkillCard(
                    'Reading & Writing',
                    'Build strong literacy foundations',
                    Icons.menu_book,
                    Color(0xFFE91E63),
                  ),
                  SizedBox(height: 12),
                  _buildSkillCard(
                    'Numeracy Skills',
                    'Master basic mathematics and counting',
                    Icons.calculate,
                    Color(0xFFF06292),
                  ),
                  SizedBox(height: 12),
                  _buildSkillCard(
                    'English Communication',
                    'Develop verbal and written communication',
                    Icons.chat_bubble,
                    Color(0xFFEC407A),
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('How Akshar Works'),
                  SizedBox(height: 12),
                  _buildProcessStep('1', 'Community Centers', 'Learning in accessible community environments', Colors.pink),
                  _buildProcessStep('2', 'Supportive Teaching', 'Personalized attention and supportive pedagogy', const Color.fromARGB(255, 157, 0, 52)),
                  _buildProcessStep('3', 'Foundational Focus', 'Building strong literacy and numeracy bases', Colors.pinkAccent),
                  SizedBox(height: 30),
                  _buildSectionTitle('Our Impact'),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImpactCard('Education', 'Access Provided', Color(0xFFE91E63)),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildImpactCard('Children', 'Learning to Read', Color(0xFFF06292)),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImpactCard('Confidence', 'Improved', Color(0xFFEC407A)),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildImpactCard('Inequality', 'Reduced', Color(0xFFC2185B)),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildSectionTitle('Emotional & Social Impact'),
                  SizedBox(height: 12),
                  _buildVisionCard('Ignited a love for learning', Icons.favorite),
                  SizedBox(height: 12),
                  _buildVisionCard('Created hope among families', Icons.home),
                  SizedBox(height: 12),
                  _buildVisionCard('Encouraged educational participation', Icons.people),
                  SizedBox(height: 30),
                  _buildSectionTitle('Future Vision'),
                  SizedBox(height: 12),
                  _buildFutureCard('Expand to more rural areas', Icons.public),
                  SizedBox(height: 12),
                  _buildFutureCard('Introduce bridge courses', Icons.trending_up),
                  SizedBox(height: 12),
                  _buildFutureCard('Mainstream students into formal schools', Icons.school),
                  SizedBox(height: 12),
                  _buildFutureCard('Add digital education modules', Icons.laptop),
                  SizedBox(height: 12),
                  _buildFutureCard('Add life-skills education', Icons.lightbulb),
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
        color: Color(0xFFC2185B),
      ),
    );
  }

  static Widget _buildDescriptionCard(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE91E63), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFFE91E63), size: 24),
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
                    Icon(Icons.check_circle, color: Color(0xFFE91E63), size: 20),
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
          color: Color(0xFFE91E63).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xFFE91E63), size: 32),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC2185B),
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
          Icon(icon, color: Color(0xFFE91E63), size: 28),
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
        color: Color(0xFFE91E63).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFE91E63), size: 28),
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