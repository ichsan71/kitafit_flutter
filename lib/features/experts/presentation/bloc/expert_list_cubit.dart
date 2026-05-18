import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/experts/domain/entities/expert.dart';
import 'package:todo_clean_bloc/features/experts/domain/usecases/get_experts.dart';

enum ExpertListStatus { initial, loading, success, failure }

class ExpertListState extends Equatable {
  final ExpertListStatus status;
  final List<Expert> experts;
  final String? errorMessage;

  const ExpertListState({
    required this.status,
    this.experts = const [],
    this.errorMessage,
  });

  const ExpertListState.initial()
    : status = ExpertListStatus.initial,
      experts = const [],
      errorMessage = null;

  ExpertListState copyWith({
    ExpertListStatus? status,
    List<Expert>? experts,
    String? errorMessage,
  }) =>
      ExpertListState(
        status: status ?? this.status,
        experts: experts ?? this.experts,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, experts, errorMessage];
}

class ExpertListCubit extends Cubit<ExpertListState> {
  final GetExperts _getExperts;
  ExpertListCubit({required GetExperts getExperts})
    : _getExperts = getExperts,
      super(const ExpertListState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: ExpertListStatus.loading));
    final res = await _getExperts.call(NoParams());
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: ExpertListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (list) => emit(
        state.copyWith(status: ExpertListStatus.success, experts: list),
      ),
    );
  }
}
