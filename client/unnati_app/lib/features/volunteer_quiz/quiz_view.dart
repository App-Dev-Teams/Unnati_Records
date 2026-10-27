import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/features/volunteer_quiz/quiz_upload.dart';
import 'package:unnati_app/services/api_service.dart';

class QuizViewPage extends StatefulWidget {
  const QuizViewPage({super.key});

  @override
  State<QuizViewPage> createState() => _QuizViewPageState();
}

class _QuizViewPageState extends State<QuizViewPage> {
  bool _isLoading = true;
  bool _hasManagePermission = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _quizzes = [];
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12',
    'All Classes',
  ];

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoadQuizzes();
  }

  Future<void> _checkPermissionAndLoadQuizzes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final allowed = await ApiService.hasPermission("MANAGE_QUIZZES");
      final list = await ApiService.getQuizzes();

      if (!mounted) return;
      setState(() {
        _hasManagePermission = allowed;
        _quizzes = list;
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

  List<Map<String, dynamic>> get _filteredQuizzes {
    if (_selectedFilter == 'All') return _quizzes;

    final targetDigits = _selectedFilter.replaceAll(RegExp(r'\D'), '').trim();

    return _quizzes.where((q) {
      final qClass = q['targetClass']?.toString().trim() ?? '';
      final qDigits = qClass.replaceAll(RegExp(r'\D'), '').trim();

      if (_selectedFilter == 'All Classes') {
        return qClass.toLowerCase().contains('all');
      }

      return qClass.toLowerCase() == _selectedFilter.toLowerCase() ||
          (targetDigits.isNotEmpty && qDigits == targetDigits) ||
          qClass.toLowerCase() == 'all classes';
    }).toList();
  }

  void _openUploadPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const QuizUploadPage(),
      ),
    );

    if (result == true) {
      _checkPermissionAndLoadQuizzes();
    }
  }

  void _previewQuiz(Map<String, dynamic> quiz) {
    final quizId = quiz['id']?.toString() ?? '';
    final title = quiz['title']?.toString() ?? 'Quiz Details';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _QuizPreviewSheet(quizId: quizId, title: title),
    );
  }

  void _showQuizSubmissions(Map<String, dynamic> quiz) {
    final quizId = quiz['id']?.toString() ?? '';
    final title = quiz['title']?.toString() ?? 'Quiz Submissions';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _QuizSubmissionsSheet(quizId: quizId, title: title),
    );
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
    final isTablet = screenWidth >= 600;
    final horizontalPadding = isTablet ? 28.w : 16.w;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 240, 244),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color.fromARGB(255, 9, 12, 19),
        foregroundColor: Colors.white,
        title: Text(
          'Quiz Management',
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
            onPressed: _checkPermissionAndLoadQuizzes,
          ),
        ],
      ),
      floatingActionButton: _hasManagePermission
          ? FloatingActionButton.extended(
              elevation: 4,
              backgroundColor: const Color(0xFF111212),
              foregroundColor: Colors.white,
              onPressed: _openUploadPage,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                "Upload Quiz",
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 15.sp : 14.sp,
                ),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _checkPermissionAndLoadQuizzes,
        color: const Color(0xFF111212),
        child: Column(
          children: [
            // Filter Pills Bar
            Container(
              height: isTablet ? 56.h : 50.h,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              color: Colors.white,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF111212)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF111212)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: GoogleFonts.roboto(
                            fontSize: isTablet ? 13.sp : 12.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main List Area
            Expanded(
              child: _buildBody(horizontalPadding, mediaQuery.size.height),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(double horizontalPadding, double screenHeight) {
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
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, size: 48.r, color: Colors.grey),
              SizedBox(height: 12.h),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 14.sp),
              ),
              SizedBox(height: 14.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111212),
                ),
                onPressed: _checkPermissionAndLoadQuizzes,
                child: Text(
                  "Retry",
                  style: GoogleFonts.oswald(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayed = _filteredQuizzes;

    if (displayed.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: (screenHeight * 0.08).clamp(20.0, 50.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (screenHeight * 0.18).clamp(110.0, 160.0),
                width: (screenHeight * 0.18).clamp(110.0, 160.0),
                child: Lottie.asset(
                  "assets/lottie/empty.json",
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.quiz_outlined,
                    size: 70.r,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "No Quizzes Found",
                style: GoogleFonts.oswald(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                _selectedFilter == 'All'
                    ? "No quizzes have been created yet. Tap '+ Upload Quiz' to create your first quiz."
                    : "No quizzes found for $_selectedFilter.",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              if (_hasManagePermission) ...[
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111212),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  ),
                  onPressed: _openUploadPage,
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: Text(
                    "Create Quiz Now",
                    style: GoogleFonts.oswald(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(horizontalPadding),
      itemCount: displayed.length,
      itemBuilder: (context, index) {
        final quiz = displayed[index];
        final title = quiz['title']?.toString() ?? 'Quiz';
        final targetClass = quiz['targetClass']?.toString() ?? '';
        final questionCount = quiz['questionCount']?.toString() ?? '0';
        final status = quiz['status']?.toString() ?? 'published';

        return Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border(
                left: BorderSide(
                  color: const Color(0xFF2B3D54),
                  width: 5.w,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
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
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
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
                                Icons.format_list_numbered_rounded,
                                size: 12.sp,
                                color: Colors.grey.shade700,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "$questionCount Questions",
                                style: GoogleFonts.roboto(
                                  fontSize: 11.sp,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: status == 'published'
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: status == 'published'
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  title,
                  style: GoogleFonts.oswald(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111212),
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 14.h),
                const Divider(height: 1),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    // Preview Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _previewQuiz(quiz),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2B3D54),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                        icon: Icon(Icons.visibility_outlined, size: 16.r),
                        label: Text(
                          "Preview",
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Submissions Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showQuizSubmissions(quiz),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF111212),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          elevation: 1,
                        ),
                        icon: Icon(Icons.people_alt_outlined, size: 16.r),
                        label: Text(
                          "Submissions",
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ================= QUIZ PREVIEW SHEET =================
class _QuizPreviewSheet extends StatelessWidget {
  final String quizId;
  final String title;

  const _QuizPreviewSheet({
    required this.quizId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final sheetHeight = (mediaQuery.size.height * 0.78).clamp(320.0, 750.0);
    final isTablet = mediaQuery.size.width >= 600;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Drag handle
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 28.w : 18.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.oswald(
                        fontSize: isTablet ? 22.sp : 19.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111212),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Questions content
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: ApiService.getQuizById(quizId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF111212),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Text(
                          "Failed to load preview: ${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  final questions =
                      (snapshot.data?['questions'] as List?) ?? [];

                  if (questions.isEmpty) {
                    return Center(
                      child: Text(
                        "No questions found",
                        style: GoogleFonts.oswald(fontSize: 16.sp),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(isTablet ? 24.r : 16.r),
                    itemCount: questions.length,
                    itemBuilder: (context, qIndex) {
                      final q = questions[qIndex];
                      final qText = q['questionText']?.toString() ?? '';
                      final options = (q['options'] as List?) ?? [];

                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(14.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF111212),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      "Q${qIndex + 1}",
                                      style: GoogleFonts.oswald(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      qText,
                                      style: GoogleFonts.oswald(
                                        fontSize: isTablet ? 17.sp : 15.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              ...List.generate(options.length, (optIdx) {
                                final opt = options[optIdx];
                                final optText = opt['text']?.toString() ?? '';
                                final labels = ['A', 'B', 'C', 'D', 'E', 'F'];
                                final label = optIdx < labels.length
                                    ? labels[optIdx]
                                    : '${optIdx + 1}';

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 4.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$label. ",
                                        style: GoogleFonts.oswald(
                                          fontWeight: FontWeight.bold,
                                          fontSize: isTablet ? 14.sp : 13.sp,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          optText,
                                          style: GoogleFonts.roboto(
                                            fontSize: isTablet ? 14.sp : 13.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= QUIZ SUBMISSIONS SHEET =================
class _QuizSubmissionsSheet extends StatefulWidget {
  final String quizId;
  final String title;

  const _QuizSubmissionsSheet({
    required this.quizId,
    required this.title,
  });

  @override
  State<_QuizSubmissionsSheet> createState() => _QuizSubmissionsSheetState();
}

class _QuizSubmissionsSheetState extends State<_QuizSubmissionsSheet> {
  late Future<Map<String, dynamic>> _submissionsFuture;

  @override
  void initState() {
    super.initState();
    _submissionsFuture = ApiService.getQuizSubmissions(widget.quizId);
  }

  void _openStudentProfile(String studentId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _StudentProfileWithStatsSheet(studentId: studentId),
    );
  }

  Color _getScoreColor(int percentage) {
    if (percentage >= 70) return Colors.green.shade700;
    if (percentage >= 40) return Colors.orange.shade800;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final sheetHeight = (mediaQuery.size.height * 0.85).clamp(380.0, 800.0);
    final isTablet = mediaQuery.size.width >= 600;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 246, 248),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Drag handle
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),

            // Sheet Title & Close
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 28.w : 18.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quiz Submissions",
                          style: GoogleFonts.oswald(
                            fontSize: isTablet ? 22.sp : 19.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111212),
                          ),
                        ),
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),

            // List of submissions
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _submissionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF111212)),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Text(
                          "Failed to load submissions: ${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data ?? {};
                  final submissions =
                      (data['submissions'] as List?) ?? [];

                  if (submissions.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.assignment_late_outlined,
                              size: 54.r,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "No Submissions Yet",
                              style: GoogleFonts.oswald(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "Students who complete this quiz will appear here with their scores.",
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
                    padding: EdgeInsets.all(isTablet ? 24.r : 16.r),
                    itemCount: submissions.length,
                    itemBuilder: (context, index) {
                      final item = submissions[index];
                      final student = item['student'] as Map<String, dynamic>?;
                      final studentId = student?['id']?.toString() ?? '';
                      final studentName =
                          student?['name']?.toString() ?? 'Unknown Student';
                      final studentClass =
                          student?['studentClass']?.toString() ?? '';
                      final school = student?['school']?.toString() ?? '';
                      final score = item['score'] ?? 0;
                      final totalQuestions = item['totalQuestions'] ?? 0;
                      final percentage = item['percentage'] ?? 0;
                      final submittedAt = item['submittedAt']?.toString() ?? '';

                      String formattedDate = '';
                      if (submittedAt.isNotEmpty) {
                        try {
                          final dt = DateTime.parse(submittedAt).toLocal();
                          formattedDate =
                              DateFormat('dd MMM yyyy, hh:mm a').format(dt);
                        } catch (_) {
                          formattedDate = submittedAt;
                        }
                      }

                      final scoreColor = _getScoreColor(percentage);

                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: InkWell(
                          onTap: studentId.isNotEmpty
                              ? () => _openStudentProfile(studentId)
                              : null,
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.all(14.r),
                            child: Row(
                              children: [
                                // Student Avatar
                                CircleAvatar(
                                  radius: 22.r,
                                  backgroundColor: const Color(0xFF111212),
                                  child: Text(
                                    studentName.isNotEmpty
                                        ? studentName[0].toUpperCase()
                                        : 'S',
                                    style: GoogleFonts.oswald(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Student Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        studentName,
                                        style: GoogleFonts.oswald(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF111212),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        [
                                          if (studentClass.isNotEmpty)
                                            studentClass.toLowerCase().startsWith('class')
                                                ? studentClass
                                                : 'Class $studentClass',
                                          if (school.isNotEmpty) school,
                                        ].join(' • '),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                          fontSize: 11.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      if (formattedDate.isNotEmpty) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          formattedDate,
                                          style: GoogleFonts.roboto(
                                            fontSize: 10.sp,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                SizedBox(width: 8.w),

                                // Score Badge & View arrow
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: scoreColor.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(8.r),
                                        border: Border.all(
                                          color: scoreColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        "$score / $totalQuestions ($percentage%)",
                                        style: GoogleFonts.roboto(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: scoreColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "View Stats",
                                          style: GoogleFonts.roboto(
                                            fontSize: 10.sp,
                                            color: const Color(0xFF2B3D54),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 14.r,
                                          color: const Color(0xFF2B3D54),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= STUDENT PROFILE WITH MAJOR QUIZ STATS =================
class _StudentProfileWithStatsSheet extends StatelessWidget {
  final String studentId;

  const _StudentProfileWithStatsSheet({required this.studentId});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final sheetHeight = (mediaQuery.size.height * 0.90).clamp(420.0, 850.0);
    final isTablet = mediaQuery.size.width >= 600;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 240, 244),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Drag handle
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),

            // Sheet Title & Close
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 28.w : 18.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Student Performance Profile",
                    style: GoogleFonts.oswald(
                      fontSize: isTablet ? 22.sp : 19.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111212),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Profile & Stats Content
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: ApiService.getStudentQuizStats(studentId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF111212)),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Text(
                          "Failed to load student profile: ${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data ?? {};
                  final student = (data['student'] as Map<String, dynamic>?) ?? {};
                  final stats = (data['stats'] as Map<String, dynamic>?) ?? {};

                  final name = student['name']?.toString() ?? 'Student';
                  final email = student['email']?.toString() ?? 'N/A';
                  final phone = student['phoneNo']?.toString() ?? 'N/A';
                  final studentClass = student['studentClass']?.toString() ?? 'N/A';
                  final school = student['school']?.toString() ?? 'N/A';
                  final joinedAt = student['joinedAt']?.toString() ?? '';

                  final totalAttempts = stats['totalAttempts'] ?? 0;
                  final averagePercentage = stats['averagePercentage'] ?? 0;
                  final highestScore = stats['highestScore'] ?? 0;
                  final highestTotal = stats['highestTotal'] ?? 0;
                  final attempts = (stats['attempts'] as List?) ?? [];

                  String joinedFormatted = '';
                  if (joinedAt.isNotEmpty) {
                    try {
                      final dt = DateTime.parse(joinedAt).toLocal();
                      joinedFormatted = DateFormat('dd MMM yyyy').format(dt);
                    } catch (_) {
                      joinedFormatted = joinedAt;
                    }
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(isTablet ? 24.r : 16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Student Header Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28.r,
                                backgroundColor: const Color(0xFF111212),
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : 'S',
                                  style: GoogleFonts.oswald(
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: GoogleFonts.oswald(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF111212),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Wrap(
                                      spacing: 6.w,
                                      runSpacing: 4.h,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                          ),
                                          child: Text(
                                            studentClass.toLowerCase().startsWith('class')
                                                ? studentClass
                                                : 'Class $studentClass',
                                            style: GoogleFonts.roboto(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade900,
                                            ),
                                          ),
                                        ),
                                        if (school.isNotEmpty && school != 'N/A')
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              school,
                                              style: GoogleFonts.roboto(
                                                fontSize: 11.sp,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // ================= MAJOR SECTION: QUIZ STATS =================
                        Row(
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              size: 18.r,
                              color: const Color(0xFF111212),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "QUIZ PERFORMANCE & STATS",
                              style: GoogleFonts.oswald(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF111212),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),

                        // Metric Highlights Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF111212), Color(0xFF2B3D54)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Quizzes Taken
                              Expanded(
                                child: _buildStatItem(
                                  label: "Quizzes Taken",
                                  value: "$totalAttempts",
                                  icon: Icons.quiz_outlined,
                                  accentColor: Colors.lightBlueAccent,
                                ),
                              ),
                              Container(
                                height: 42.h,
                                width: 1,
                                color: Colors.white24,
                              ),
                              // Average Score
                              Expanded(
                                child: _buildStatItem(
                                  label: "Average Score",
                                  value: "$averagePercentage%",
                                  icon: Icons.trending_up_rounded,
                                  accentColor: Colors.amberAccent,
                                ),
                              ),
                              Container(
                                height: 42.h,
                                width: 1,
                                color: Colors.white24,
                              ),
                              // Best Score
                              Expanded(
                                child: _buildStatItem(
                                  label: "Highest Score",
                                  value: highestTotal > 0
                                      ? "$highestScore/$highestTotal"
                                      : "$highestScore",
                                  icon: Icons.military_tech_outlined,
                                  accentColor: Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 14.h),

                        // List of Quizzes Attempted
                        Text(
                          "Assessment History ($totalAttempts)",
                          style: GoogleFonts.oswald(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        if (attempts.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                "No quizzes attempted yet by this student.",
                                style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: attempts.length,
                            itemBuilder: (context, idx) {
                              final att = attempts[idx];
                              final qTitle =
                                  att['quizTitle']?.toString() ?? 'Quiz';
                              final score = att['score'] ?? 0;
                              final total = att['totalQuestions'] ?? 0;
                              final pct = att['percentage'] ?? 0;
                              final subAt =
                                  att['submittedAt']?.toString() ?? '';

                              String dateText = '';
                              if (subAt.isNotEmpty) {
                                try {
                                  final dt = DateTime.parse(subAt).toLocal();
                                  dateText =
                                      DateFormat('dd MMM yyyy, hh:mm a').format(dt);
                                } catch (_) {
                                  dateText = subAt;
                                }
                              }

                              Color badgeColor = Colors.green;
                              if (pct < 40) {
                                badgeColor = Colors.red;
                              } else if (pct < 70) {
                                badgeColor = Colors.orange;
                              }

                              return Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.r),
                                      decoration: BoxDecoration(
                                        color: badgeColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_circle_outline,
                                        size: 18.r,
                                        color: badgeColor,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            qTitle,
                                            style: GoogleFonts.roboto(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (dateText.isNotEmpty)
                                            Text(
                                              dateText,
                                              style: GoogleFonts.roboto(
                                                fontSize: 10.sp,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: badgeColor.withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        "$score/$total ($pct%)",
                                        style: GoogleFonts.roboto(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: badgeColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                        SizedBox(height: 20.h),

                        // ================= SECOND SECTION: SCHOOL & CONTACT INFO =================
                        Row(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 18.r,
                              color: const Color(0xFF111212),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "STUDENT & SCHOOL DETAILS",
                              style: GoogleFonts.oswald(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF111212),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),

                        Container(
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
                            children: [
                              _buildInfoRow(
                                icon: Icons.location_city_rounded,
                                label: "School",
                                value: school,
                              ),
                              const Divider(height: 16),
                              _buildInfoRow(
                                icon: Icons.school_rounded,
                                label: "Class",
                                value: studentClass.toLowerCase().startsWith('class')
                                    ? studentClass
                                    : 'Class $studentClass',
                              ),
                              const Divider(height: 16),
                              _buildInfoRow(
                                icon: Icons.email_outlined,
                                label: "Email",
                                value: email,
                              ),
                              const Divider(height: 16),
                              _buildInfoRow(
                                icon: Icons.phone_outlined,
                                label: "Phone",
                                value: phone,
                              ),
                              if (joinedFormatted.isNotEmpty) ...[
                                const Divider(height: 16),
                                _buildInfoRow(
                                  icon: Icons.calendar_today_outlined,
                                  label: "Enrolled On",
                                  value: joinedFormatted,
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: accentColor, size: 20.r),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.oswald(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 10.sp,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: const Color(0xFF2B3D54)),
        SizedBox(width: 12.w),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111212),
            ),
          ),
        ),
      ],
    );
  }
}
