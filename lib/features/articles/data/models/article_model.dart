import 'package:todo_clean_bloc/features/articles/data/models/category_model.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/article.dart';

class ArticleAuthorModel extends ArticleAuthor {
  const ArticleAuthorModel({required super.id, required super.name});

  factory ArticleAuthorModel.fromJson(Map<String, dynamic> json) =>
      ArticleAuthorModel(
        id: (json['id'] as num).toInt(),
        name: (json['name'] ?? '').toString(),
      );
}

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.slug,
    super.excerpt,
    super.content,
    super.thumbnail,
    super.category,
    super.author,
    super.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      excerpt: json['excerpt']?.toString(),
      content: json['content']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      author: json['author'] is Map<String, dynamic>
          ? ArticleAuthorModel.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
    );
  }
}
