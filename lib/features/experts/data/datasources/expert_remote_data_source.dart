import 'package:todo_clean_bloc/core/network/api_client.dart';
import 'package:todo_clean_bloc/features/experts/data/models/expert_model.dart';

abstract interface class ExpertRemoteDataSource {
  Future<List<ExpertModel>> getExperts();
  Future<ExpertModel> getExpertDetail(int id);
}

class ExpertRemoteDataSourceImpl implements ExpertRemoteDataSource {
  final ApiClient client;
  ExpertRemoteDataSourceImpl({required this.client});

  static const _basePath = '/experts';

  @override
  Future<List<ExpertModel>> getExperts() => client.get<List<ExpertModel>>(
    _basePath,
    parser: (raw) {
      final list = raw is List
          ? raw
          : (raw is Map<String, dynamic> && raw['data'] is List
                ? raw['data'] as List
                : const []);
      return list
          .whereType<Map<String, dynamic>>()
          .map(ExpertModel.fromJson)
          .toList();
    },
    requiresAuth: false,
  );

  @override
  Future<ExpertModel> getExpertDetail(int id) => client.get<ExpertModel>(
    '$_basePath/$id',
    parser: (raw) => ExpertModel.fromJson(raw as Map<String, dynamic>),
    requiresAuth: false,
  );
}
