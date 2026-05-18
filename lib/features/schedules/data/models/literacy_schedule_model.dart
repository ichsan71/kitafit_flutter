import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';

class LiteracyScheduleModel extends LiteracySchedule {
  const LiteracyScheduleModel({
    required super.id,
    required super.title,
    required super.scheduledDate,
    required super.scheduledTime,
    super.description,
  });

  factory LiteracyScheduleModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['scheduled_date']?.toString() ?? '';
    final parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();

    return LiteracyScheduleModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      scheduledDate: parsedDate,
      scheduledTime: (json['scheduled_time'] ?? '00:00').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'scheduled_date': scheduledDate.toIso8601String().split('T').first,
    'scheduled_time': scheduledTime,
  };
}
