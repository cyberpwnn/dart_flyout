Simple flyouts

## Features

* Easy to call flyouts
* Scroll controller via context in child flyout

## Usage

```dart
import 'package:flyout/flyout.dart';

class SomeScreen extends StatelessWidget {
  const SomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Some Screen"),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => flyout(context, () => const ImAFlyoutScreen()),
            child: const Text("Show Flyout"),
          ),
        ),
      );
}

class ImAFlyoutScreen extends StatelessWidget {
  const ImAFlyoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      // Scrolling will move the flyout and the scroller
      controller: flyoutController(context),
      children: [],
    ),
  );
}
```