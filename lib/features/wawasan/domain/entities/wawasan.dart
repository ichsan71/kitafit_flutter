import 'package:equatable/equatable.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/article.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/category.dart';

/// Wawasan/Insights — schema-nya identik dengan Article di backend,
/// hanya endpoint dan domain konsepnya berbeda. Reuse [ArticleAuthor]
/// dan [Category] entity untuk konsistensi.
class Wawasan extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String? excerpt;
  final String? content;
  final String? thumbnail;
  final Category? category;
  final ArticleAuthor? author;
  final DateTime? publishedAt;

  const Wawasan({
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
