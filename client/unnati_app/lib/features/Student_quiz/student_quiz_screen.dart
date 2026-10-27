import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/features/Student_quiz/attempt_quiz.dart';
import 'package:unnati_app/services/api_service.dart';

class StudentQuizScreen extends StatefulWidget {
  const StudentQuizScreen({super.key});

  @override
  State<StudentQuizScreen> createState() => _StudentQuizScreenState();
}

class _StudentQuizScreenState extends State<StudentQuizScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _quizzes = [];
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _myQuizStats;
  // Maps quizId -> attempt details { score, total, submittedAt }
  final Map<String, Map<String, dynamic>> _attemptMap = {};

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await ApiService.getUserData();
      final quizzes = await ApiService.getQuizzes();

      // Fetch attempts from backend stats endpoint
      Map<String, dynamic>? stats;
      try {
        stats = await ApiService.getMyQuizAttempts();
      } catch (e) {
        print('Error fetching my quiz attempts: $e');
      }

      final Map<String, Map<String, dynamic>> attempts = {};

      // Populate from backend attempts
      if (stats != null && stats['attempts'] is List) {
        for (final att in stats['attempts']) {
          final qId = att['quizId']?.toString() ?? '';
          if (qId.isNotEmpty) {
            attempts[qId] = {
              'score': att['score'] ?? 0,
              'total': att['totalQuestions'] ?? 0,
              'submittedAt': att['submittedAt'] ?? '',
            };
          }
        }
      }

      // Merge with local attempts as fallback
      for (final q in quizzes) {
        final id = q['id']?.toString() ?? '';
        if (id.isNotEmpty && !attempts.containsKey(id)) {
          final attempt = await ApiService.getLocalQuizAttempt(id);
          if (attempt != null) {
            attempts[id] = attempt;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _userData = user;
        _quizzes = quizzes;
        _myQuizStats = stats;
        _attemptMap.clear();
        _attemptMap.addAll(attempts);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _openQuiz(Map<String, dynamic> quiz) async {
    final quizId = quiz['id']?.toString() ?? '';
    final quizTitle = quiz['title']?.toString() ?? 'Quiz';

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttemptQuizScreen(
          quizId: quizId,
          quizTitle: quizTitle,
        ),
      ),
    );

    // Refresh if quiz was submitted or state changed
    if (result == true) {
      _loadAllData();
    }
  }

  String _formatClassDisplay(String rawClass) {
    final trimmed = rawClass.trim();
    if (trimmed.isEmpty) return '';
    final lower = trimmed.toLowerCase();
    if (lower.startsWith('class') || lower.contains('all')) {
      return trimmed;
    }
    return 'Class $trimmed';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isTablet = screenWidth >= 600;
    final horizontalPadding = isTablet ? 28.w : 16.w;

    final studentClass = _userData?['studentClass']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 240, 244),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color.fromARGB(255, 9, 12, 19),
        title: Text(
          'Quizzes & Tests',
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 22.sp : 19.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: isTablet ? 26.r : 22.r,
            ),
            tooltip: "Refresh Quizzes",
            onPressed: _loadAllData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllData,
        color: const Color(0xFF111212),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  14.h,
                  horizontalPadding,
                  8.h,
                ),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isTablet ? 20.r : 16.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (studentClass.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  margin: EdgeInsets.only(bottom: 6.h),
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: Colors.lightBlueAccent,
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    _formatClassDisplay(studentClass),
                                    style: GoogleFonts.roboto(
                                      color: Colors.lightBlueAccent,
                                      fontSize: isTablet ? 13.sp : 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              Text(
                                "TEST YOUR KNOWLEDGE",
                                style: GoogleFonts.oswald(
                                  fontSize: isTablet ? 24.sp : 19.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "Participate in curated quizzes to evaluate and strengthen your subject concepts.",
                                style: GoogleFonts.roboto(
                                  fontSize: isTablet ? 13.sp : 11.sp,
                                  color: Colors.grey.shade300,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          flex: 2,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: (screenHeight * 0.14).clamp(80.0, 140.0),
                            ),
                            child: Lottie.asset(
                              "assets/lottie/Quiz.json",
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.quiz_outlined,
                                  size: isTablet ? 64.r : 48.r,
                                  color: Colors.white70,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // QUIZ STATS SECTION
              _buildQuizStatsSection(horizontalPadding, isTablet),

              // Title Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding + 2.w,
                  vertical: 10.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "AVAILABLE QUIZZES",
                      style: GoogleFonts.oswald(
                        fontSize: isTablet ? 20.sp : 17.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (!_isLoading && _quizzes.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          "${_quizzes.length} Total",
                          style: GoogleFonts.roboto(
                            fontSize: isTablet ? 13.sp : 11.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Content Area
              _buildContent(horizontalPadding, screenHeight),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizStatsSection(double horizontalPadding, bool isTablet) {
    if (_isLoading) return const SizedBox.shrink();

    final totalAttempts = _myQuizStats?['totalAttempts'] ?? _attemptMap.length;
    final averagePercentage = _myQuizStats?['averagePercentage'] ?? 0;
    final highestScore = _myQuizStats?['highestScore'] ?? 0;
    final highestTotal = _myQuizStats?['highestTotal'] ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 6.h,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.query_stats_rounded,
                      size: 18.r,
                      color: const Color(0xFF111212),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "MY QUIZ STATS",
                      style: GoogleFonts.oswald(
                        fontSize: isTablet ? 16.sp : 15.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111212),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    "$totalAttempts Completed",
                    style: GoogleFonts.roboto(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    label: "Quizzes Given",
                    value: "$totalAttempts",
                    icon: Icons.checklist_rounded,
                    color: Colors.blue.shade700,
                    bgColor: Colors.blue.shade50,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildMetricTile(
                    label: "Avg Score",
                    value: "$averagePercentage%",
                    icon: Icons.trending_up_rounded,
                    color: Colors.orange.shade800,
                    bgColor: Colors.orange.shade50,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildMetricTile(
                    label: "Best Score",
                    value: highestTotal > 0
                        ? "$highestScore/$highestTotal"
                        : "$highestScore",
                    icon: Icons.emoji_events_outlined,
                    color: Colors.green.shade700,
                    bgColor: Colors.green.shade50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18.r, color: color),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.oswald(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 10.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(double horizontalPadding, double screenHeight) {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.15),
          child: const CircularProgressIndicator(color: Color(0xFF111212)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, size: 48.r, color: Colors.grey),
              SizedBox(height: 12.h),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.black87),
              ),
              SizedBox(height: 14.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111212),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                ),
                onPressed: _loadAllData,
                child: Text(
                  "Try Again",
                  style: GoogleFonts.oswald(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_quizzes.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: (screenHeight * 0.08).clamp(24.0, 60.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (screenHeight * 0.2).clamp(120.0, 180.0),
                width: (screenHeight * 0.2).clamp(120.0, 180.0),
                child: Lottie.asset(
                  "assets/lottie/empty.json",
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.inventory_2_outlined,
                    size: 70.r,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'No Quizzes Available',
                style: GoogleFonts.oswald(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'New quizzes uploaded for your class will appear right here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      itemCount: _quizzes.length,
      itemBuilder: (context, index) {
        final quiz = _quizzes[index];
        final quizId = quiz['id']?.toString() ?? '';
        final title = quiz['title']?.toString() ?? 'Quiz';
        final targetClass = quiz['targetClass']?.toString() ?? '';
        final questionCount = quiz['questionCount']?.toString() ?? '0';

        final attempt = _attemptMap[quizId];
        final hasAttempted = attempt != null;

        return Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: InkWell(
            onTap: () => _openQuiz(quiz),
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border(
                  left: BorderSide(
                    color: hasAttempted
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF2B3D54),
                    width: 5.w,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 4.h,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                _formatClassDisplay(targetClass),
                                style: GoogleFonts.roboto(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.help_outline_rounded,
                                    size: 12.sp,
                                    color: Colors.grey.shade700,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "$questionCount Questions",
                                    style: GoogleFonts.roboto(
                                      fontSize: 11.sp,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          title,
                          style: GoogleFonts.oswald(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111212),
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        if (hasAttempted)
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 14.sp,
                                color: Colors.green.shade700,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Completed: ${attempt['score']}/${attempt['total']}",
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            "Not attempted yet",
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    height: 38.w,
                    width: 38.w,
                    decoration: BoxDecoration(
                      color: hasAttempted
                          ? Colors.green.shade50
                          : const Color(0xFF111212),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      hasAttempted
                          ? Icons.refresh_rounded
                          : Icons.play_arrow_rounded,
                      color: hasAttempted
                          ? Colors.green.shade800
                          : Colors.white,
                      size: 20.r,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
