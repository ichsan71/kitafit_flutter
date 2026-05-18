import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/experts/domain/entities/expert.dart';
import 'package:todo_clean_bloc/features/experts/domain/usecases/get_expert_detail.dart';

enum ExpertDetailStatus { initial, loading, success, failure }

class ExpertDetailState extends Equatable {
  final ExpertDetailStatus status;
  final Expert? expert;
  final String? errorMessage;

  const ExpertDetailState({
    required this.status,
    this.expert,
    this.errorMessage,
  });

  const ExpertDetailState.initial()
    : status = ExpertDetailStatus.initial,
      expert = null,
      errorMessage = null;

  ExpertDetailState copyWith({
    ExpertDetailStatus? status,
    Expert? expert,
    String? errorMessage,
  }) =>
      ExpertDetailState(
        status: status ?? this.status,
        expert: expert ?? this.expert,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, expert, errorMessage];
}

class ExpertDetailCubit extends Cubit<ExpertDetailState> {
  final GetExpertDetail _getExpertDetail;
  ExpertDetailCubit({required GetExpertDetail getExpertDetail})
    : _getExpertDetail = getExpertDetail,
      super(const ExpertDetailState.initial());

  Future<void> load(int id) async {
    emit(state.copyWith(status: ExpertDetailStatus.loading));
    final res = await _getExpertDetail.call(id);
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: ExpertDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (expert) => emit(
        state.copyWith(status: ExpertDetailStatus.success, expert: expert),
      ),
    );
  }
}
