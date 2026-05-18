import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/schedules/domain/repository/schedule_repository.dart';

class DeleteSchedule implements UseCase<void, int> {
  final ScheduleRepository repository;
  DeleteSchedule({required this.repository});

  @override
  Future<Either<Failure, void>> call(int id) => repository.deleteSchedule(id);
}
