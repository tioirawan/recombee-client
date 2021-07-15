import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:recombee_client/src/exceptions/recombee_response_exception.dart';

import 'requests/recombee_request.dart';

class RecombeeClient {
  late String _databaseId;
  late String _publicToken;
  late String _baseUri;
  late bool _useHttps;

  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'Content-Type': 'text/plain',
  };

  RecombeeClient({
    required String databaseId,
    required String publicToken,
    bool useHttps = false,
  }) {
    _databaseId = databaseId;
    _publicToken = publicToken;
    _useHttps = useHttps;

    _baseUri = 'client-rapi.recombee.com';
  }

  Future<String> send(RecombeeRequest request) async {
    try {
      final signedUrl = signUrl(request.path);
      final url = ((_useHttps) ? 'https://' : 'http://') + _baseUri + signedUrl;

      late Future<http.Response> callRequest;

      switch (request.method) {
        case 'POST':
          callRequest = http.post(
            Uri.parse(url),
            headers: _headers,
            body: jsonEncode(request.requestBody()),
          );
          break;
        default:
          callRequest = http.get(
            Uri.parse(url),
            headers: _headers,
          );
      }

      final response = await callRequest;

      if (response.statusCode == 200) {
        return response.body;
      } else {
        final responseBody = jsonDecode(response.body);

        throw RecombeResponseException(
          message: responseBody['message'],
          code: response.statusCode,
          stackTrace: StackTrace.current,
        );
      }
    } on SocketException catch (error, stackTrace) {
      throw RecombeResponseException(
        message: error.osError?.message ?? error.message,
        code: error.osError?.errorCode ?? 0,
        stackTrace: stackTrace,
      );
    }
  }

  String signUrl(req_part) {
    var url = '/' + _databaseId + req_part;

    url += (!url.contains('?') ? '?' : '&') +
        'frontend_timestamp=' +
        '${(DateTime.now().millisecondsSinceEpoch ~/ 1000)}';

    final keys = utf8.encode(_publicToken);
    final urlBytes = utf8.encode(url);

    final hmacSha1 = Hmac(sha1, keys);
    final digest = hmacSha1.convert(urlBytes);

    url = url + '&frontend_sign=' + digest.toString();

    return url;
  }
}
