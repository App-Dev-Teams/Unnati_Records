class Doubt {
  final String id;
  final String title;
  final String subject;
  final String status;
  final String? studentId;
  final String? studentName;
  final DateTime? createdAt;
  final DateTime? resolvedAt;

  const Doubt({
    required this.id,
    required this.title,
    required this.subject,
    required this.status,
    this.studentId,
    this.studentName,
    this.createdAt,
    this.resolvedAt,
  });

  bool get isOpen => status.toLowerCase() == 'open';

  factory Doubt.fromJson(Map<String, dynamic> json) {
    final student = json['studentId'];
    String? parsedStudentId;
    String? parsedStudentName;

    if (student is Map<String, dynamic>) {
      parsedStudentId = student['_id']?.toString();
      parsedStudentName = student['name']?.toString();
    } else if (student != null) {
      parsedStudentId = student.toString();
    }

    return Doubt(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      status: json['status']?.toString() ?? 'open',
      studentId: parsedStudentId,
      studentName: parsedStudentName,
      createdAt: _parseDateTime(json['createdAt']),
      resolvedAt: _parseDateTime(json['resolvedAt']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

class DoubtMessage {
  final String id;
  final String doubtId;
  final String? senderId;
  final String senderRole;
  final String senderName;
  final String message;
  final DateTime? createdAt;

  const DoubtMessage({
    required this.id,
    required this.doubtId,
    required this.senderId,
    required this.senderRole,
    required this.senderName,
    required this.message,
    required this.createdAt,
  });

  bool get isStudent => senderRole.toLowerCase() == 'student';

  factory DoubtMessage.fromJson(Map<String, dynamic> json) {
    final sender = json['senderId'];
    String? parsedSenderId;
    String parsedSenderName = 'User';

    if (sender is Map<String, dynamic>) {
      parsedSenderId = sender['_id']?.toString();
      parsedSenderName = sender['name']?.toString() ?? 'User';
    } else if (sender != null) {
      parsedSenderId = sender.toString();
    }

    return DoubtMessage(
      id: json['_id']?.toString() ?? '',
      doubtId: json['doubtId']?.toString() ?? '',
      senderId: parsedSenderId,
      senderRole: json['senderRole']?.toString() ?? 'student',
      senderName: parsedSenderName,
      message: json['message']?.toString() ?? '',
      createdAt: Doubt._parseDateTime(json['createdAt']),
    );
  }
}
