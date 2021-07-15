import 'package:recombee_client/recombee_client.dart';

void main() async {
  final client = RecombeeClient(
    databaseId: 'your database  id',
    publicToken: 'your public token',
    useHttps: true,
  );

  try {
    final request1 = AddDetailView(userId: 10, itemId: 1);
    print(await client.send(request1));

    final request2 = AddCartAddition(userId: 10, itemId: 1);
    print(await client.send(request2));
  } on RecombeResponseException catch (e) {
    print(e.toString());
  }
}
