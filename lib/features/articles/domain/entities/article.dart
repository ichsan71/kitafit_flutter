import 'package:equatable/equatable.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/category.dart';

class ArticleAuthor extends Equatable {
  final int id;
  final String name;
  const ArticleAuthor({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class Article extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String? excerpt;
  final String? content;
  final String? thumbnail;
  final Category? category;
  final ArticleAuthor? author;
  final DateTime? publishedAt;

  const Article({
    required this.id,
    required this.title,
    required this.slug,
    this.excerpt,
    this.content,
    this.thumbnail,
    this.category,
    this.author,
    this.publishedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
    excerpt,
    content,
    thumbnail,
    category,
    author,
    publishedAt,
  ];
}
