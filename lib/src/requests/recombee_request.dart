abstract class RecombeeRequest {
  String path;
  String method;
  int timeout;

  RecombeeRequest(
    this.method,
    this.path,
    this.timeout,
  );

  Map<String, dynamic> requestBody();
}
