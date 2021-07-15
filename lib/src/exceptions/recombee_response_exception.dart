class RecombeResponseException implements Exception {
  final String? message;
  final int code;
  final StackTrace? stackTrace;

  const RecombeResponseException({
    this.message = 'Terjadi kesalahan!',
    this.code = 0,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'RecombeResponseException { message: $message, code: $code }';
  }
}
