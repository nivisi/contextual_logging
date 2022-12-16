import 'package:contextual_logging/contextual_logging.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

typedef _GetLogger = Logger Function(dynamic forObject);

/// Configuration of [ContextualLogger].
///
/// [defaultLogger] allows you to set the default logger used by [ContextualLogger].
/// If you want to define a global logger, do it on startup:
///
/// ```dart
/// ContextualLoggingConfig.defaultLogger = (forObject) => MyBeautifulLogger(forObject);
/// ```
///
/// This will make [ContextualLogger] use that logger by default.
class ContextualLoggingConfig {
  const ContextualLoggingConfig._();

  static Logger _getDefaultLogger(dynamic forObject) => Logger(
        printer: ContextualLogPrinter(forObject: forObject),
      );

  static _GetLogger _getLogger = _getDefaultLogger;

  static set defaultLogger(_GetLogger logger) => _getLogger = logger;
}

/// A mixin that brings logging functionality to your class.
///
/// 1. Add this mixin to your class:
///
///    ```dart
///    class CityController with LoggableMixin {
///    ...
///    }
///    ```
///
/// 2. Now, inside `CityController`, you can log:
///
///    ```dart
///    Future<void> initialize() async {
///      try {
///        log.i('Initializing ...');
///        await fetchSomeData();
///        log.i('Initialized successfully!');
///      } on Exception catch (e, s) {
///        log.e('Failed to initialize', e, s);
///      }
///    }
///    ```
///
/// ---
///
/// If you want to set a custom context name for this object,
/// override the [logContext] property:
/// ```dart
/// @override
/// String get logContext => 'MyBeautifulObject';
/// ```
///
/// If you want to use a custom logger for this exact object,
/// override the [customLogger] property:
/// ```dart
/// @override
/// Logger get customLogger => /* your custom logger */;
/// ```
mixin ContextualLogger {
  late final Logger _log = customLogger;

  @protected
  @nonVirtual
  Logger get log => _log;

  /// Context name of a log message.
  ///
  /// Use it to contextualize your log messages.
  String get logContext => toString();

  /// Override this if you want to create a custom logger for this object.
  ///
  /// Specifying a custom value for this field will affect the [log] field
  /// only for this object.
  @protected
  Logger get customLogger => ContextualLoggingConfig._getLogger(this);
}
