import 'package:todo_clean_bloc/features/experts/domain/entities/expert.dart';

class ExpertModel extends Expert {
  const ExpertModel({
    required super.id,
    required super.name,
    required super.whatsappNumber,
    super.specialization,
    super.avatar,
    super.whatsappUrl,
    super.isActive = true,
  });

  factory ExpertModel.fromJson(Map<String, dynamic> json) => ExpertModel(
    id: (json['id'] as num).toInt(),
    name: (json['name'] ?? '').toString(),
    specialization: json['specialization']?.toString(),
    avatar: json['avatar']?.toString(),
    whatsappNumber: (json['whatsapp_number'] ?? '').toString(),
    whatsappUrl: json['whatsapp_url']?.toString(),
    isActive: json['is_active'] as bool? ?? true,
  );
}
