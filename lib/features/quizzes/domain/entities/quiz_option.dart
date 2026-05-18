import 'package:equatable/equatable.dart';

class QuizOption extends Equatable {
  final int id;
  final String optionText;
  final bool? isCorrect;

  const QuizOption({
    required this.id,
    required this.optionText,
    this.isCorrect,
  });

  @override
  List<Object?> get props => [id, optionText, isCorrect];
}
