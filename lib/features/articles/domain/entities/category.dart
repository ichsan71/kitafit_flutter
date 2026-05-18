import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String? slug;
  final String? type;

  const Category({
    required this.id,
    required this.name,
    this.slug,
    this.type,
  });

  @override
  List<Object?> get props => [id, name, slug, type];
}
