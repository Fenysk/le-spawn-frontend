import 'package:dio/dio.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class RefreshTokenInterceptor extends Interceptor {
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401 && error.response?.data['message'] == 'Token expired') {
      await serviceLocator<AuthRepository>().refresh();

      final newAccessToken = await serviceLocator<AuthLocalService>().getAccessToken();

      error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final response = await serviceLocator<DioClient>().retry(error.requestOptions);

      return handler.resolve(response);
    }

    return handler.next(error);
  }
}
