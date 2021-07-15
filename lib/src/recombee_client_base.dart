import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'requests/recombee_request.dart';

class RecombeeClient {
  late String _databaseId;
  late String _publicToken;
  late String _baseUri;
  late bool _useHttps;

  late http.Client _client;

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

    _client = http.Client();
  }

  // Dont forget to close the connection after using it.
  void close() {
    _client.close();
  }

  Future<bool> send(RecombeeRequest request) async {
    final signedUrl = signUrl(request.path);
    final url = ((_useHttps) ? 'https://' : 'http://') + _baseUri + signedUrl;

    late Future<http.Response> callRequest;

    switch (request.method) {
      case 'POST':
        callRequest = _client.post(
          Uri.parse(url),
          headers: _headers,
          body: jsonEncode(request.requestBody()),
        );
        break;
      default:
        callRequest = _client.get(
          Uri.parse(url),
          headers: _headers,
        );
    }

    final response = await callRequest;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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
