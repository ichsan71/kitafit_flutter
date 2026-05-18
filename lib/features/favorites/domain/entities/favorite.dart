import 'package:equatable/equatable.dart';

class Favorite extends Equatable {
  final int id;
  final String favoritableType;
  final int favoritableId;
  final Map<String, dynamic>? favoritableData;

  const Favorite({
    required this.id,
    required this.favoritableType,
    required this.favoritableId,
    this.favoritableData,
  });

  @override
  List<Object?> get props => [
    id,
    favoritableType,
    favoritableId,
    favoritableData,
  ];
}
