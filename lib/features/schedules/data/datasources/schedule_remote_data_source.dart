import 'package:todo_clean_bloc/core/network/api_client.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/schedules/data/models/literacy_schedule_model.dart';

abstract interface class ScheduleRemoteDataSource {
  Future<Paginated<LiteracyScheduleModel>> getSchedules({
    int page = 1,
    int perPage = 15,
    String? date,
    bool? upcoming,
  });

  Future<LiteracyScheduleModel> getScheduleDetail(int id);

  Future<LiteracyScheduleModel> createSchedule(Map<String, dynamic> body);

  Future<LiteracyScheduleModel> updateSchedule(
    int id,
    Map<String, dynamic> body,
  );

  Future<void> deleteSchedule(int id);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final ApiClient client;
  ScheduleRemoteDataSourceImpl({required this.client});

  static const _basePath = '/schedules';

  @override
  Future<Paginated<LiteracyScheduleModel>> getSchedules({
    int page = 1,
    int perPage = 15,
    String? date,
    bool? upcoming,
  }) {
    final query = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (date != null) 'date': date,
      if (upcoming != null) 'upcoming': upcoming,
    };
    return client.getPaginated<LiteracyScheduleModel>(
      _basePath,
      query: query,
      itemFromJson: LiteracyScheduleModel.fromJson,
    );
  }

  @override
  Future<LiteracyScheduleModel> getScheduleDetail(int id) =>
      client.get<LiteracyScheduleModel>(
        '$_basePath/$id',
        parser: (raw) =>
            LiteracyScheduleModel.fromJson(raw as Map<String, dynamic>),
      );

  @override
  Future<LiteracyScheduleModel> createSchedule(Map<String, dynamic> body) =>
      client.post<LiteracyScheduleModel>(
        _basePath,
        body: body,
        parser: (raw) =>
            LiteracyScheduleModel.fromJson(raw as Map<String, dynamic>),
      );

  @override
  Future<LiteracyScheduleModel> updateSchedule(
    int id,
    Map<String, dynamic> body,
  ) => client.put<LiteracyScheduleModel>(
    '$_basePath/$id',
    body: body,
    parser: (raw) =>
        LiteracyScheduleModel.fromJson(raw as Map<String, dynamic>),
  );

  @override
  Future<void> deleteSchedule(int id) =>
      client.delete<dynamic>('$_basePath/$id');
}
