import 'recombee_request.dart';

class AddDetailView extends RecombeeRequest {
  dynamic userId;
  dynamic itemId;

  AddDetailView({
    required this.userId,
    required this.itemId,
    int timeout = 3000,
  }) : super('POST', '/detailviews/', timeout);

  @override
  Map<String, dynamic> requestBody() {
    return {
      'userId': userId,
      'itemId': itemId,
    };
  }
}
