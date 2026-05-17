//enum for absent present and deferred
enum AttendanceStatus { present, absent, deferred }

class Volunteer {
  final String id;
  final String email;
  final String name;
  final String program;

  Volunteer({required this.id, required this.email, required this.name, required this.program});

  factory Volunteer.fromJson(
      Map<String,dynamic> json){

    return Volunteer(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      program: json["program"]??"none",
    );
  }
}

// holds all three attendance types for a day
class AttendanceDay {
  final List<Volunteer> present;
  final List<Volunteer> absent;
  final List<Volunteer> deferred;

  AttendanceDay({
    this.present = const [],
    this.absent = const [],
    this.deferred = const [],
  });

  AttendanceDay copyWith({
    List<Volunteer>? present,
    List<Volunteer>? absent,
    List<Volunteer>? deferred,
  }) {
    return AttendanceDay(
      present: present ?? this.present,
      absent: absent ?? this.absent,
      deferred: deferred ?? this.deferred,
    );
  }
}
