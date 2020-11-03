# Protected Work

A Flutter package that helps you to protect your work against greedy clients
not willing to pay by letting you to remotely control the app's usability.

## Using

Wrap your app's builder widget in a `ProtectedWork`, provide a `url` and
`blockResponse`. `ProtectedWork` will send a GET request to `url` every
`checkInterval`, if the response is equal to `blockResponse`, `blockMessage`
will be displayed instead of `child`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_protected_work/flutter_protected_work.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ProtectedWork(
          url: 'https://example.org/alive',
          blockResponse: 'blockTheApp',
          blockMessage: 'A UFO arrived and made the app unusable',
          checkInterval: const Duration(minutes: 5),
          child: child,
        );
      },
    );
  }
}
```

## Notes

Please remove the package from your app after getting payed :)
