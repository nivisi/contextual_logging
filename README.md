# contextual_logging [![pub version][pub-version-img]][pub-version-url]

✏️ A mixin for Dart classes that brings contextual logging functionality to your class.

Print messages like this w/o any effort.

```
10:03:00 [I] MyController : Initializing ...
10:03:01 [I] MyController : Initialized!
```

> 🌐 Is built on top of the [`logger`](https://pub.dev/packages/logger) package.

### Table of contents

- [What's contextual logging?](#whats-contextual-logging)
- [Logger](#logger)
  - [The mixin](#the-mixin)
  - [Configuration](#configuration)
    - [Context](#context)
    - [Custom logger](#custom-logger)
  - [Default logger config everywhere](#default-logger-config-everywhere)
- [Contextual log printer](#contextual-log-printer)
  - [What's this?](#whats-this)
  - [Configuring the printer](#configuring-the-printer)
    - [Example](#example)
    - [Log level label](#log-level-label)

---

## What's contextual logging?

We all know log messages. They are printed to the console, to the files or whatever. Dart provides us with methods for logging like:

```dart
print('A message');
debugPrint('Another message');
```

Good enough to debug. But when you actually need to investigate users' journey, it is not. You'll need context. The context here answers the question `who has printed the message?`.

Adding context could be done like this:

```dart
print('My Controller : A message');
debugPrint('My Controller : Another message');
```

... and it will work. Though to write the context every time is pretty boring. This is what `contextual_logging` solves.

## Logger

### The mixin

Attach the mixin it to your class that you want to use for logging:

```dart
class MyController with ContextualLogging
```

And now go for it!

```dart
class MyController with ContextualLogging {
  Future<void> init() async {
    log.i('Initializing ...'); // <-- Access logging via the log field
    await fetchData();
    log.i('Initialized!');
  }
}
```

You will see this in the console:

```
10:03:00 [I] MyController : Initializing ...
10:03:01 [I] MyController : Initialized!
```

### Configuration

By default, a logger is created for every object that has a `ContextualLogging` mixin attached to it. Once you attach the mixin, you'll be able to configure the logger for this object.

#### Context

`logContext` property is what Contextual Logger adds to the log message in front of the main message. By default it has a value of `this.toString()`. Override it to whatever you want:

```dart
class MyController with ContextualLogging {
  @override
  String get logContext => 'SomeOtherContext`;
  
  void test() {
    log.i('Test'); // 19:12:00 [I] SomeOtherContext : Test
  }
}
```

#### Custom logger

If you want to use a custom logger, feel free to override the `customLogger` property:

```dart
class MyController with ContextualLogging {
  @override
  Logger get customLogger => Logger(/* Configure it in whatever way you want! */);
  
  void test() {
    log.i('Test'); // Still access it via the `log` property!
  }
}
```

### Default logger config everywhere

If you want to reconfigure loggers for all the object at once, do this before your app starts:

```dart
// ContextualLogger mixin uses this defaultLogger by default to get a logger for the object it was attached to.
ContextualLoggingConfig.defaultLogger = (forObject) => MyBeautifulLogger(forObject);
```

Once you do it, every `ContextualLogger` mixin will create loggers like this.

## Contextual Log Printer

> 💡 A printer is what formats your messages.

### What's this?

When setting the `ContextualLoggingConfig.defaultLogger` property, you can create a logger and provide any printer you want. Or you can use the default printer used by `ContextualLogger`, the `ContextualLogPrinter`. This printer is what makes the messages look like this: 

```
12:01:00 [I] SomeOtherContext : Test
```

Instead of this:

```
Test
```

### Configuring the printer

There are plenty of properties you can change:

| Property      | Type       | Description                                  | Default      |
| :------------ | :--------- | :------------------------------------------- | :----------- |
| forObject     | Object     | The object for which the logger was created. Use a `string` if you want to have it as a prefix. | this |
| timeFormat    | DateFormat | Format of the current timestamp              | HH:mm:ss     |
| timeInUtc     | bool       | Whether the current timestamp must be in UTC | false        |
| printTime     | bool       | Whether to print the timestamp               | true         |
| logLevelLabel | Function   | Log level prefix for messages                | [I], [W] etc |

#### Example

So imagine you've overriden the printer like this:

```dart
ContextualLoggingConfig.defaultLogger = (forObject) {
  return Logger(
    printer: ContextualLogPrinter(
      forObject: forObject,
      printTime: false, // Note!
    ),
  );
};

// This will make your messages look like this:

[I] MyController : A message
```

#### Log level label

Log level lebel is what allows you to distinguish the level of a message. The [`logger`](https://pub.dev/packages/logger) package allows you to use these levels:

| Level   | Function                      | Default | Emoji |
| :------ | :---------------------------- | :------ | :---- |
| Verbose | `log.v`                       | [V]     |       |
| Debug   | `log.d`                       | [D]     | 🐛    |
| Info    | `log.i`                       | [I]     | 💡    |
| Warning | `log.w`                       | [W]     | ⚠️    |
| Error   | `log.e`                       | [E]     | ⛔️    |
| Wtf     | `log.wtf`                     | [WTF]   | 🗿    |
| Nothing | `log.log(Level.nothing, ...)` |         |       |

Override the `logLevelLabel` property to make your own prefixes!

```dart
ContextualLoggingConfig.defaultLogger = (forObject) {
  return Logger(
    printer: ContextualLogPrinter(
      forObject: forObject,
      logLevelLabel: (level) {
        /* Return a prefix for the given level! */
      },
    ),
  );
  
// Or do this to enable emojis level!
ContextualLoggingConfig.defaultLogger = (forObject) {
  return Logger(
    printer: ContextualLogPrinter(
      forObject: forObject,
      logLevelLabel: ContextualLogPrinter.emojiLevelLabel,
    ),
  );
```

<!-- References -->
[pub-version-img]: https://img.shields.io/badge/pub-v1.0.0-0175c2?logo=dart
[pub-version-url]: https://pub.dev/packages/contextual_logging