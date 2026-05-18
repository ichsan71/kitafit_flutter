import 'package:todo_clean_bloc/features/articles/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.slug,
    super.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: (json['id'] as num).toInt(),
    name: (json['name'] ?? '').toString(),
    slug: json['slug']?.toString(),
    type: json['type']?.toString(),
  );
}
