import 'package:equatable/equatable.dart';

class QuizAnswer extends Equatable {
  final int questionId;
  final int optionId;

  const QuizAnswer({required this.questionId, required this.optionId});

  Map<String, dynamic> toJson() => {
    'question_id': questionId,
    'option_id': optionId,
  };

  @override
  List<Object?> get props => [questionId, optionId];
}
