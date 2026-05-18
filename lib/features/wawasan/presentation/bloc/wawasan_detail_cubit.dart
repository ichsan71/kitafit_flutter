import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/entities/wawasan.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/usecases/get_wawasan_detail.dart';

enum WawasanDetailStatus { initial, loading, success, failure }

class WawasanDetailState extends Equatable {
  final WawasanDetailStatus status;
  final Wawasan? wawasan;
  final String? errorMessage;

  const WawasanDetailState({
    required this.status,
    this.wawasan,
    this.errorMessage,
  });

  const WawasanDetailState.initial()
    : status = WawasanDetailStatus.initial,
      wawasan = null,
      errorMessage = null;

  WawasanDetailState copyWith({
    WawasanDetailStatus? status,
    Wawasan? wawasan,
    String? errorMessage,
  }) =>
      WawasanDetailState(
        status: status ?? this.status,
        wawasan: wawasan ?? this.wawasan,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, wawasan, errorMessage];
}

class WawasanDetailCubit extends Cubit<WawasanDetailState> {
  final GetWawasanDetail _getWawasanDetail;

  WawasanDetailCubit({required GetWawasanDetail getWawasanDetail})
    : _getWawasanDetail = getWawasanDetail,
      super(const WawasanDetailState.initial());

  Future<void> load(String slug) async {
    emit(state.copyWith(status: WawasanDetailStatus.loading));
    final res = await _getWawasanDetail.call(slug);
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: WawasanDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (wawasan) => emit(
        state.copyWith(
          status: WawasanDetailStatus.success,
          wawasan: wawasan,
        ),
      ),
    );
  }
}
