import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/services/api_service.dart';

class QuestionFormModel {
  String questionId;
  TextEditingController textController;
  List<OptionFormModel> options;
  String? correctOptionId;

  QuestionFormModel({
    required this.questionId,
    required this.textController,
    required this.options,
    this.correctOptionId,
  });

  void dispose() {
    textController.dispose();
    for (final opt in options) {
      opt.dispose();
    }
  }
}

class OptionFormModel {
  String optionId;
  TextEditingController textController;

  OptionFormModel({
    required this.optionId,
    required this.textController,
  });

  void dispose() {
    textController.dispose();
  }
}

class QuizUploadPage extends StatefulWidget {
  const QuizUploadPage({super.key});

  @override
  State<QuizUploadPage> createState() => _QuizUploadPageState();
}

class _QuizUploadPageState extends State<QuizUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  String? _selectedClass = 'Class 8';
  String _quizStatus = 'published';
  bool _isUploading = false;

  final List<String> _classOptions = [
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

  final List<QuestionFormModel> _questions = [];

  @override
  void initState() {
    super.initState();
    // Start with 1 default question containing 4 options
    _addQuestion();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    final qIndex = _questions.length + 1;
    final qId = 'q_${DateTime.now().millisecondsSinceEpoch}_$qIndex';

    final options = [
      OptionFormModel(
        optionId: 'opt_${qId}_1',
        textController: TextEditingController(),
      ),
      OptionFormModel(
        optionId: 'opt_${qId}_2',
        textController: TextEditingController(),
      ),
      OptionFormModel(
        optionId: 'opt_${qId}_3',
        textController: TextEditingController(),
      ),
      OptionFormModel(
        optionId: 'opt_${qId}_4',
        textController: TextEditingController(),
      ),
    ];

    setState(() {
      _questions.add(
        QuestionFormModel(
          questionId: qId,
          textController: TextEditingController(),
          options: options,
          correctOptionId: options[0].optionId,
        ),
      );
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A quiz must have at least one question"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      final removed = _questions.removeAt(index);
      removed.dispose();
    });
  }

  void _addOption(QuestionFormModel question) {
    if (question.options.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Maximum 6 options allowed per question"),
        ),
      );
      return;
    }

    final optNum = question.options.length + 1;
    final newOptId = 'opt_${question.questionId}_$optNum';

    setState(() {
      question.options.add(
        OptionFormModel(
          optionId: newOptId,
          textController: TextEditingController(),
        ),
      );
    });
  }

  void _removeOption(QuestionFormModel question, int optIndex) {
    if (question.options.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Each question must have at least two options"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      final removed = question.options.removeAt(optIndex);
      if (question.correctOptionId == removed.optionId) {
        question.correctOptionId = question.options.first.optionId;
      }
      removed.dispose();
    });
  }

  Future<void> _handleUpload() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a quiz title"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedClass == null || _selectedClass!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a target class"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add at least one question"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate each question
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final qText = q.textController.text.trim();
      if (qText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Question ${i + 1} text cannot be empty"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (q.options.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Question ${i + 1} must have at least 2 options"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      for (int j = 0; j < q.options.length; j++) {
        final optText = q.options[j].textController.text.trim();
        if (optText.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Option ${j + 1} for Question ${i + 1} cannot be empty",
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      if (q.correctOptionId == null ||
          !q.options.any((o) => o.optionId == q.correctOptionId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please select a correct answer for Question ${i + 1}",
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final formattedQuestions = _questions.map((q) {
        return {
          'questionId': q.questionId,
          'questionText': q.textController.text.trim(),
          'options': q.options.map((opt) {
            return {
              'optionId': opt.optionId,
              'text': opt.textController.text.trim(),
            };
          }).toList(),
          'correctOptionId': q.correctOptionId,
        };
      }).toList();

      final result = await ApiService.uploadQuiz(
        title: title,
        targetClass: _selectedClass!,
        questions: formattedQuestions,
        status: _quizStatus,
      );

      setState(() {
        _isUploading = false;
      });

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Quiz uploaded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to upload quiz'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          'Upload Quiz',
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 22.sp : 19.sp,
          ),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14.h,
                horizontalPadding,
                mediaQuery.viewInsets.bottom + 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Details Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 20.r : 16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "QUIZ INFORMATION",
                            style: GoogleFonts.oswald(
                              fontSize: isTablet ? 18.sp : 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF111212),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Quiz Title
                          TextFormField(
                            controller: _titleController,
                            style: GoogleFonts.roboto(fontSize: 14.sp),
                            decoration: InputDecoration(
                              labelText: "Quiz Title",
                              hintText: "e.g., Mathematics Algebra Assessment",
                              prefixIcon: const Icon(Icons.edit_note_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),

                          // Target Class & Status Row
                          Row(
                            children: [
                              // Target Class Dropdown
                              Expanded(
                                flex: 3,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedClass,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: "Target Class",
                                    prefixIcon: const Icon(Icons.school_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  items: _classOptions.map((c) {
                                    return DropdownMenuItem<String>(
                                      value: c,
                                      child: Text(
                                        c,
                                        style: GoogleFonts.roboto(
                                          fontSize: isTablet ? 14.sp : 13.sp,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedClass = val;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 10.w),

                              // Status Dropdown
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<String>(
                                  value: _quizStatus,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: "Status",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "published",
                                      child: Text("Publish"),
                                    ),
                                    DropdownMenuItem(
                                      value: "draft",
                                      child: Text("Draft"),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _quizStatus = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // Questions Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "QUESTIONS (${_questions.length})",
                        style: GoogleFonts.oswald(
                          fontSize: isTablet ? 20.sp : 17.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _addQuestion,
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: Text(
                          "Add Question",
                          style: GoogleFonts.oswald(
                            fontSize: isTablet ? 15.sp : 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // List of Question Cards
                  ...List.generate(_questions.length, (qIndex) {
                    return _buildQuestionCard(qIndex, isTablet);
                  }),

                  SizedBox(height: 12.h),

                  // Big Add Question Button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF111212),
                      side: const BorderSide(
                        color: Color(0xFF111212),
                        width: 1.5,
                      ),
                      minimumSize: Size(double.infinity, 46.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(
                      "Add Another Question",
                      style: GoogleFonts.oswald(
                        fontSize: isTablet ? 16.sp : 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Upload Button
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF111212),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: _isUploading ? null : _handleUpload,
                        icon: const Icon(
                          Icons.cloud_upload_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Publish Quiz",
                          style: GoogleFonts.oswald(
                            fontSize: isTablet ? 17.sp : 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Loading Overlay
          if (_isUploading)
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
                      const CircularProgressIndicator(color: Color(0xFF111212)),
                      SizedBox(height: 16.h),
                      Text(
                        "Uploading Quiz...",
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
    );
  }

  Widget _buildQuestionCard(int qIndex, bool isTablet) {
    final question = _questions[qIndex];
    final optionLabels = ['A', 'B', 'C', 'D', 'E', 'F'];

    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 14.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 18.r : 14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111212),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "Q${qIndex + 1}",
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: isTablet ? 14.sp : 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Question ${qIndex + 1}",
                      style: GoogleFonts.oswald(
                        fontSize: isTablet ? 17.sp : 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (_questions.length > 1)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red.shade400,
                      size: isTablet ? 24.r : 20.r,
                    ),
                    tooltip: "Delete Question",
                    onPressed: () => _removeQuestion(qIndex),
                  ),
              ],
            ),
            SizedBox(height: 10.h),

            // Question Text Input
            TextFormField(
              controller: question.textController,
              maxLines: 2,
              style: GoogleFonts.roboto(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: "Enter question statement here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                contentPadding: EdgeInsets.all(12.r),
              ),
            ),
            SizedBox(height: 12.h),

            // Options Title & Hint
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Options (tap radio for correct answer):",
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _addOption(question),
                  child: Text(
                    "+ Option",
                    style: GoogleFonts.oswald(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B3D54),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // Options List
            ...List.generate(question.options.length, (optIndex) {
              final option = question.options[optIndex];
              final isCorrect = question.correctOptionId == option.optionId;
              final label = optIndex < optionLabels.length
                  ? optionLabels[optIndex]
                  : '${optIndex + 1}';

              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    // Radio button for correct option
                    InkWell(
                      onTap: () {
                        setState(() {
                          question.correctOptionId = option.optionId;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCorrect
                              ? Colors.green.shade100
                              : Colors.transparent,
                        ),
                        child: Icon(
                          isCorrect
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: isCorrect
                              ? Colors.green.shade800
                              : Colors.grey.shade500,
                          size: isTablet ? 24.r : 20.r,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),

                    // Option Label Badge
                    Container(
                      width: 22.w,
                      alignment: Alignment.center,
                      child: Text(
                        "$label.",
                        style: GoogleFonts.oswald(
                          fontSize: isTablet ? 15.sp : 13.sp,
                          fontWeight: FontWeight.bold,
                          color: isCorrect
                              ? Colors.green.shade900
                              : Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),

                    // Option Text Field
                    Expanded(
                      child: TextFormField(
                        controller: option.textController,
                        style: GoogleFonts.roboto(fontSize: 13.sp),
                        decoration: InputDecoration(
                          hintText: "Option $label text",
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: isCorrect
                                  ? Colors.green.shade700
                                  : Colors.grey.shade400,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: isCorrect
                                  ? Colors.green.shade700
                                  : Colors.grey.shade300,
                              width: isCorrect ? 1.5 : 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Delete option if > 2 options
                    if (question.options.length > 2)
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.grey.shade500,
                            size: 18.r,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _removeOption(question, optIndex),
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
  }
}
