import 'package:equatable/equatable.dart';

class Expert extends Equatable {
  final int id;
  final String name;
  final String? specialization;
  final String? avatar;
  final String whatsappNumber;
  final String? whatsappUrl;
  final bool isActive;

  const Expert({
    required this.id,
    required this.name,
    required this.whatsappNumber,
    this.specialization,
    this.avatar,
    this.whatsappUrl,
    this.isActive = true,
  });

  /// Fallback bila backend tidak mengirim `whatsapp_url`.
  String get resolvedWhatsappUrl =>
      whatsappUrl ?? 'https://wa.me/$whatsappNumber';

  @override
  List<Object?> get props => [
    id,
    name,
    specialization,
    avatar,
    whatsappNumber,
    whatsappUrl,
    isActive,
  ];
}
