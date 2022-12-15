# contextual_logging [![pub version][pub-version-img]][pub-version-url]

✏️ A mixin for Dart classes that brings contextual logging functionality.

### What's contextual logging?

We all know log messages. They are printed to the console, to the files or whatever. Dart provides us with loggable methods like:

```dart
print('A message');
debugPrint('Another message');
```

Good enough to debug. But when you actually need to investigate users' journey, it is not. You'll need context. The context here answers the question `who has printed the message?`.

Bringing the context could be done like this:

```dart
print('My Controller : A message');
debugPrint('My Controller : Another message');
```

Though to write the context every time is pretty boring. This is what `contextual_logging` solves.

### How to use

Attach the mixin it to your class that you want to use for logging:

```dart
class MyController with ContextualLogging
```

And... Go for it!

```dart
class MyController with ContextualLogging {
  Future<void> init() async {
    log.i('Initializing ...'); // <-- Access logging via the log field
    await fetchData();
    log.i('Initialized!');
  }
}
```

### What will be printed?

In the console you'll see this:

```
10:03:00 [I] MyController : Initializing ...
10:03:01 [I] MyController : Initialized!
```

A timestamp, a log level, a context and a message.

#### Timestamp

// TODO...

#### Log level

// TODO...

#### Context

// TODO...

#### Message

// TODO...

<!-- References -->
[pub-version-img]: https://img.shields.io/badge/pub-v1.0.0-0175c2?logo=dart
[pub-version-url]: https://pub.dev/packages/contextual_logging
