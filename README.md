# Recombee Client

an **unofficial** Recombee Dart & Flutter Client

## Usage

This  package is still in a very early stage, needs heavy refactoring.

```dart
import 'package:recombee_client/recombee_client.dart';

void main() async {
  final client = RecombeeClient(
    databaseId: 'your database  id',
    publicToken: 'your public token',
    useHttps: true,
  );

  final request1 = AddDetailView(userId: 10, itemId: 1);

  await client.send(request1);

  final request2 = AddCartAddition(userId: 10, itemId: 1);
  
  await client.send(request2);

  // Make sure to always close the client
  client.close();
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/indmind/recombee-client/issues
