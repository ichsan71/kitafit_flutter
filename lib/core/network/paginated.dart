import 'package:equatable/equatable.dart';

class Paginated<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const Paginated({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;
  bool get isEmpty => items.isEmpty;

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final list = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(itemFromJson)
        .toList();
    final meta = (json['meta'] as Map<String, dynamic>?) ?? const {};
    return Paginated<T>(
      items: list,
      currentPage: (meta['current_page'] as int?) ?? 1,
      lastPage: (meta['last_page'] as int?) ?? 1,
      perPage: (meta['per_page'] as int?) ?? list.length,
      total: (meta['total'] as int?) ?? list.length,
    );
  }

  Paginated<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
  }) =>
      Paginated<T>(
        items: items ?? this.items,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        perPage: perPage ?? this.perPage,
        total: total ?? this.total,
      );

  Paginated<T> append(Paginated<T> next) => Paginated<T>(
    items: [...items, ...next.items],
    currentPage: next.currentPage,
    lastPage: next.lastPage,
    perPage: next.perPage,
    total: next.total,
  );

  static Paginated<T> empty<T>() => Paginated<T>(
    items: const [],
    currentPage: 1,
    lastPage: 1,
    perPage: 0,
    total: 0,
  );

  @override
  List<Object?> get props => [items, currentPage, lastPage, perPage, total];
}
