import 'recombee_request.dart';

class AddCartAddition extends RecombeeRequest {
  dynamic userId;
  dynamic itemId;
  Map<String, dynamic> options;

  AddCartAddition({
    required this.userId,
    required this.itemId,
    this.options = const {},
    int timeout = 3000,
  }) : super('POST', '/cartadditions/', timeout);

  @override
  Map<String, dynamic> requestBody() {
    return {
      'userId': userId,
      'itemId': itemId,
      ...options,
    };
  }
}
