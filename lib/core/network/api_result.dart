// Tipe hasil API — digunakan nanti saat integrasi backend
sealed class ApiResult<T> {
  const ApiResult();
}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

final class ApiError<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  const ApiError(this.message, {this.statusCode});
}

final class ApiLoading<T> extends ApiResult<T> {
  const ApiLoading();
}
