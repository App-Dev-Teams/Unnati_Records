import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/services/api_service.dart';
import 'package:unnati_app/l10n/app_localizations.dart';

class AttemptQuizScreen extends StatefulWidget {
  final String quizId;
  final String quizTitle;

  const AttemptQuizScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  State<AttemptQuizScreen> createState() => _AttemptQuizScreenState();
}

class _AttemptQuizScreenState extends State<AttemptQuizScreen> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  Map<String, dynamic>? _quizData;
  List<dynamic> _questions = [];
  int _currentIndex = 0;

  // Maps questionId -> selectedOptionId
  final Map<String, String> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _fetchQuizDetails();
  }

  Future<void> _fetchQuizDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getQuizById(widget.quizId);
      setState(() {
        _quizData = data;
        _questions = (data['questions'] as List?) ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _selectOption(String questionId, String optionId) {
    setState(() {
      _selectedAnswers[questionId] = optionId;
    });
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _goToNext() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _showQuestionGridSheet() {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final sheetMaxHeight = mediaQuery.size.height * 0.65;
    final isTablet = mediaQuery.size.width >= 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: sheetMaxHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 28.w : 20.w,
              vertical: 16.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.questionOverview,
                      style: GoogleFonts.oswald(
                        fontSize: isTablet ? 22.sp : 19.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111212),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "${_selectedAnswers.length}/${_questions.length} ${l10n.answered}",
                        style: GoogleFonts.roboto(
                          fontSize: isTablet ? 14.sp : 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: isTablet ? 16.w : 12.w,
                      runSpacing: isTablet ? 16.h : 12.h,
                      children: List.generate(_questions.length, (index) {
                        final qId = _questions[index]['questionId'];
                        final isAnswered = _selectedAnswers.containsKey(qId);
                        final isCurrent = index == _currentIndex;
                        final boxSize = isTablet ? 54.w : 44.w;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                            });
                            Navigator.pop(ctx);
                          },
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            width: boxSize,
                            height: boxSize,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? const Color(0xFF2B3D54)
                                  : isAnswered
                                      ? const Color(0xFF74ee15).withOpacity(0.2)
                                      : Colors.grey.shade100,
                              border: Border.all(
                                color: isCurrent
                                    ? const Color(0xFF111212)
                                    : isAnswered
                                        ? const Color(0xFF4CAF50)
                                        : Colors.grey.shade300,
                                width: isCurrent ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: GoogleFonts.oswald(
                                  fontSize: isTablet ? 18.sp : 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent
                                      ? Colors.white
                                      : isAnswered
                                          ? Colors.green.shade800
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleQuizSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    final unansweredCount = _questions.length - _selectedAnswers.length;

    if (unansweredCount > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            l10n.unanswered,
            style: GoogleFonts.oswald(
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            "$unansweredCount ${l10n.unanswered.toLowerCase()}",
            style: GoogleFonts.roboto(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.reviewAnswers,
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: const Color(0xFF2B3D54),
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          l10n.submitQuiz,
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          l10n.submitConfirmation,
          style: GoogleFonts.roboto(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              l10n.reviewAnswers,
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.submitQuiz,
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final answersPayload = _selectedAnswers.entries.map((entry) {
        return {
          'questionId': entry.key,
          'selectedOptionId': entry.value,
        };
      }).toList();

      final result = await ApiService.submitQuiz(
        quizId: widget.quizId,
        answers: answersPayload,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (result['success'] == true) {
        final data = result['data'] ?? {};
        final score = (data['score'] as num?)?.toInt() ?? 0;
        final total = (data['totalQuestions'] as num?)?.toInt() ?? _questions.length;

        // Save local attempt record
        await ApiService.saveLocalQuizAttempt(widget.quizId, score, total);

        if (!mounted) return;
        _showResultDialog(score, total);
      } else if (result['alreadySubmitted'] == true) {
        if (!mounted) return;
        _showAlreadySubmittedDialog();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to submit quiz'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error submitting quiz: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showResultDialog(int score, int total) {
    final l10n = AppLocalizations.of(context)!;
    final double percentage = total > 0 ? (score / total) * 100 : 0;
    final bool isPassed = percentage >= 50;
    final mediaQuery = MediaQuery.of(context);
    final dialogMaxHeight = mediaQuery.size.height * 0.85;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          contentPadding: EdgeInsets.all(18.r),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: dialogMaxHeight),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: (mediaQuery.size.height * 0.16).clamp(100.0, 150.0),
                    child: Lottie.asset(
                      isPassed
                          ? 'assets/lottie/congo.json'
                          : 'assets/lottie/sad_emotion.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    isPassed ? "Congratulations!" : "Good Try!",
                    style: GoogleFonts.oswald(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? const Color(0xFF1B5E20) : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${l10n.yourScore}: $score / $total (${percentage.toStringAsFixed(0)}%)",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F9),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem("Total", "$total"),
                        _buildStatItem("Correct", "$score", color: Colors.green),
                        _buildStatItem(
                          "Incorrect",
                          "${total - score}",
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF111212),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        l10n.backToQuizzes,
                        style: GoogleFonts.oswald(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.oswald(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color ?? const Color(0xFF111212),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 11.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _showAlreadySubmittedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          "Already Submitted",
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade800,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          "You have already submitted this quiz previously. Each quiz can only be attempted once.",
          style: GoogleFonts.roboto(fontSize: 14.sp),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111212),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, false);
            },
            child: Text(
              "OK",
              style: GoogleFonts.oswald(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_questions.isEmpty || _isSubmitting) return true;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          "Exit Quiz?",
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        content: Text(
          "If you leave now, your selected answers will not be saved.",
          style: GoogleFonts.roboto(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              "Stay",
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              "Exit",
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width >= 600;
    final horizontalPadding = isTablet ? 24.w : 16.w;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        appBar: AppBar(
          elevation: 2,
          backgroundColor: const Color.fromARGB(255, 9, 12, 19),
          foregroundColor: Colors.white,
          title: Text(
            widget.quizTitle,
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 20.sp : 17.sp,
            ),
          ),
          actions: [
            if (!_isLoading && _questions.isNotEmpty)
              IconButton(
                icon: Icon(
                  Icons.grid_view_rounded,
                  color: Colors.white,
                  size: isTablet ? 24.r : 20.r,
                ),
                tooltip: l10n.questionOverview,
                onPressed: _showQuestionGridSheet,
              ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF111212)),
              )
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48.r,
                            color: Colors.red,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF111212),
                            ),
                            onPressed: _fetchQuizDetails,
                            child: Text(
                              l10n.retry,
                              style: GoogleFonts.oswald(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _questions.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noQuestionsFound,
                          style: GoogleFonts.oswald(fontSize: 18.sp),
                        ),
                      )
                    : Stack(
                        children: [
                          Column(
                            children: [
                              // Top progress section
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                  vertical: 12.h,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${l10n.questionsCount} ${_currentIndex + 1} of ${_questions.length}",
                                          style: GoogleFonts.oswald(
                                            fontSize: isTablet ? 18.sp : 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF111212),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 3.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2B3D54)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                          ),
                                          child: Text(
                                            "${_selectedAnswers.length}/${_questions.length} ${l10n.answered}",
                                            style: GoogleFonts.roboto(
                                              fontSize: isTablet ? 13.sp : 11.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF2B3D54),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4.r),
                                      child: LinearProgressIndicator(
                                        value: (_currentIndex + 1) /
                                            _questions.length,
                                        backgroundColor: Colors.grey.shade200,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF2B3D54),
                                        ),
                                        minHeight: 6.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Question & Options Content
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(horizontalPadding),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Question Card
                                      Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(
                                            isTablet ? 22.r : 16.r,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 2.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color(0xFF111212),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.r),
                                                    ),
                                                    child: Text(
                                                      "Q${_currentIndex + 1}",
                                                      style:
                                                          GoogleFonts.oswald(
                                                        color: Colors.white,
                                                        fontSize: isTablet
                                                            ? 14.sp
                                                            : 12.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Text(
                                                    "Single Choice",
                                                    style: GoogleFonts.roboto(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12.h),
                                              Text(
                                                _questions[_currentIndex]
                                                        ['questionText'] ??
                                                    '',
                                                style: GoogleFonts.oswald(
                                                  fontSize: isTablet
                                                      ? 20.sp
                                                      : 17.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xFF111212),
                                                  height: 1.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 16.h),

                                      Text(
                                        "${l10n.selectAnOption}:",
                                        style: GoogleFonts.roboto(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),

                                      SizedBox(height: 10.h),

                                      // Options List
                                      ..._buildOptionCards(isTablet),

                                      SizedBox(height: 20.h),
                                    ],
                                  ),
                                ),
                              ),

                              // Bottom action buttons bar
                              _buildBottomNavBar(isTablet, l10n),
                            ],
                          ),

                          // Loading overlay during submission
                          if (_isSubmitting)
                            Container(
                              color: Colors.black45,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(24.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Color(0xFF111212),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        "Evaluating answers...",
                                        style: GoogleFonts.oswald(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
      ),
    );
  }

  List<Widget> _buildOptionCards(bool isTablet) {
    final currentQ = _questions[_currentIndex];
    final questionId = currentQ['questionId'] as String;
    final options = (currentQ['options'] as List?) ?? [];
    final selectedOptionId = _selectedAnswers[questionId];

    final optionLabels = ['A', 'B', 'C', 'D', 'E', 'F'];

    return List.generate(options.length, (optIndex) {
      final option = options[optIndex];
      final optionId = option['optionId'] as String;
      final text = option['text'] as String;
      final isSelected = selectedOptionId == optionId;
      final label = optIndex < optionLabels.length
          ? optionLabels[optIndex]
          : '${optIndex + 1}';

      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: InkWell(
          onTap: () => _selectOption(questionId, optionId),
          borderRadius: BorderRadius.circular(12.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: isTablet ? 16.h : 12.h,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2B3D54).withOpacity(0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2B3D54)
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: isTablet ? 36.w : 30.w,
                  height: isTablet ? 36.w : 30.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2B3D54)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2B3D54)
                          : Colors.grey.shade400,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: GoogleFonts.oswald(
                        fontSize: isTablet ? 15.sp : 13.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.roboto(
                      fontSize: isTablet ? 16.sp : 14.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFF111212)
                          : Colors.grey.shade800,
                      height: 1.25,
                    ),
                  ),
                ),
                if (isSelected)
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: const Color(0xFF2B3D54),
                      size: isTablet ? 24.r : 20.r,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomNavBar(bool isTablet, AppLocalizations l10n) {
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == _questions.length - 1;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 24.w : 16.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 22.w : 16.w,
                  vertical: 10.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: isFirst ? null : _goToPrevious,
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
              label: Text(
                l10n.previous,
                style: GoogleFonts.oswald(
                  fontSize: isTablet ? 15.sp : 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Next or Submit button
            if (!isLast)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111212),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24.w : 18.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: _goToNext,
                label: Text(
                  l10n.next,
                  style: GoogleFonts.oswald(
                    fontSize: isTablet ? 15.sp : 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              )
            else
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  elevation: 3,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 26.w : 18.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: _handleQuizSubmit,
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: Text(
                  l10n.submitQuiz,
                  style: GoogleFonts.oswald(
                    fontSize: isTablet ? 16.sp : 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
