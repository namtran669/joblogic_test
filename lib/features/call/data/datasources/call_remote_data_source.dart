import 'package:dio/dio.dart';
import '../models/call_model.dart';

abstract class CallRemoteDataSource {
  Future<Map<String, dynamic>> getCalls(int page);
}

class CallRemoteDataSourceImpl implements CallRemoteDataSource {
  final Dio dio;

  CallRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getCalls(int page) async {
    final response = await dio.get('/api/calls', queryParameters: {'page': page, 'limit': 15});
    final List data = response.data['data'];
    final bool hasMore = response.data['hasMore'];
    return {
      'calls': data.map((json) => CallModel.fromJson(json)).toList(),
      'hasMore': hasMore,
    };
  }
}
