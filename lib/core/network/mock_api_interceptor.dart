import 'package:dio/dio.dart';
import 'dart:math';

class MockApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate occasional random network failure for Retry Logic (15% chance)
    if (Random().nextDouble() < 0.15 && options.path.contains('/api/calls')) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Simulated Network Error for Retry demonstration',
          type: DioExceptionType.unknown,
        ),
      );
    }

    if (options.path.contains('/api/calls')) {
      // Pagination logic
      final page = int.tryParse(options.queryParameters['page']?.toString() ?? '1') ?? 1;
      final limit = int.tryParse(options.queryParameters['limit']?.toString() ?? '10') ?? 10;
      
      final paginatedData = List.generate(limit, (index) {
        final id = (page - 1) * limit + index + 1;
        return {
          'id': id,
          'name': 'Person Caller $id',
          'phone': '555-010$id',
        };
      });

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'data': paginatedData,
            'page': page,
            'hasMore': page < 5, // We simulate 5 pages total max
          },
        ),
      );
    }

    if (options.path.contains('/api/buy')) {
       final data = List.generate(20, (index) {
        final id = index + 1;
        return {
          'id': 'B-$id',
          'name': 'Buyable Item $id',
          'price': 10.0 + (id * 2), // Mock pricing
        };
      });

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: data,
        ),
      );
    }
    
    if (options.path.contains('/api/sell')) {
      // Simulate sync
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'success': true},
        ),
      );
    }

    return super.onRequest(options, handler);
  }
}
