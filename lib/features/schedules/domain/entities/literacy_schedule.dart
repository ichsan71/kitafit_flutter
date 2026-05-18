import 'package:equatable/equatable.dart';

class LiteracySchedule extends Equatable {
  final int id;
  final String title;
  final String? description;
  final DateTime scheduledDate;
  final String scheduledTime;

  const LiteracySchedule({
    required this.id,
    required this.title,
    required this.scheduledDate,
    required this.scheduledTime,
    this.description,
  });

  DateTime get scheduledDateTime {
    final parts = scheduledTime.split(':');
    final h = int.tryParse(parts.elementAt(0)) ?? 0;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      h,
      m,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    scheduledDate,
    scheduledTime,
  ];
}
