import 'package:dashboard_manga_easy/core/services/apis/api_response_parse/api_erros/api_error.dart';

class AuthException implements ApiError {
  @override
  final String message;

  AuthException(this.message);
}
