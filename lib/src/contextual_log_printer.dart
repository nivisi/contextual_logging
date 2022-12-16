import 'dart:convert';

import 'package:contextual_logging/contextual_logging.dart';
import 'package:intl/intl.dart';

typedef _LogLevelLabelFunc = String Function(Level logLevel);

/// Contextualized printer for [Logger]s.
///
/// Prints messages like this:
/// ```dart
/// 10:10:10 [I] MyController : Info
/// 10:10:10 [W] MyController : Warning
/// 10:10:10 [E] MyController : Error
/// ```
///
/// If you want a custom time format, you can pass a [timeFormat].
/// If you don't want the time to be printed at all, set [printTime] to false.
///
/// After the time string the logger writes the log level of a message.
/// By default, it is simple "[I]"", "[W]" etc.
/// You can override this function in order to return a custom label:
///
/// ```dart
/// ContextualLogPrinter(
///   logLevelLabel: (level) {
///     // return a custom value for every level!
///   },
/// );
/// ```
///
/// For example, you can use the emoji label
/// provided by [ContextualLogPrinter.emojiLevelLabel]:
///
/// ```dart
/// ContextualizedLogPrinter(
///   logLevelLabel: ContextualLogPrinter.emojiLevelLabel,
/// );
/// ```
class ContextualLogPrinter extends LogPrinter {
  ContextualLogPrinter({
    Object? forObject,
    DateFormat? timeFormat,
    this.timeInUtc = false,
    this.printTime = true,
    _LogLevelLabelFunc? logLevelLabel,
  })  : _prefix = _getPrefix(forObject),
        _timeFormat = timeFormat ?? _defaultTimeFormat,
        logLevelLabel = logLevelLabel ?? _labelFor;

  static final _defaultTimeFormat = DateFormat('HH:mm:ss');

  static String _getPrefix(forObject) {
    if (forObject is ContextualLogger) {
      return forObject.logContext.isEmpty ? '' : '${forObject.logContext} : ';
    }

    if (forObject is String) {
      return forObject;
    }

    return forObject == null ? '' : '${forObject.toString()} :';
  }

  static String emojiLevelLabel(Level level) {
    return _emojiPrefixes[level] ?? '';
  }

  static String simpleLevelLabel(Level level) {
    return _levelPrefixes[level] ?? '';
  }

  final DateFormat _timeFormat;
  final String? _prefix;
  final bool printTime;
  final bool timeInUtc;
  final _LogLevelLabelFunc logLevelLabel;

  final prettyPrinter = PrettyPrinter(methodCount: 0);

  static final _levelPrefixes = {
    Level.nothing: '',
    Level.verbose: '[V]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.wtf: '[WTF]',
  };

  static final _emojiPrefixes = {
    Level.nothing: '',
    Level.verbose: '',
    Level.debug: '🐛',
    Level.info: '💡',
    Level.warning: '⚠️',
    Level.error: '⛔️',
    Level.wtf: '🗿',
  };

  static String _labelFor(Level level) {
    return _levelPrefixes[level]!;
  }

  String _stringifyMessage(dynamic message) {
    String msg;
    if (message is Map || message is Iterable) {
      const encoder = JsonEncoder.withIndent(null);
      msg = encoder.convert(message);
    } else {
      msg = message.toString();
    }

    return '$_prefix$msg';
  }

  String _getNow() {
    if (!printTime) {
      return '';
    }

    DateTime now = DateTime.now();
    if (timeInUtc) {
      now = now.toUtc();
    }

    return '${_timeFormat.format(now)} ';
  }

  @override
  List<String> log(LogEvent event) {
    final messageStr = _stringifyMessage(event.message);
    final errorStr = event.error != null ? '  ERROR: ${event.error}' : '';

    final now = _getNow();
    final label = logLevelLabel(event.level);
    final labelToPrint = label.isEmpty ? null : '$label ';

    final messageList = ['$now$labelToPrint$messageStr$errorStr'];

    if (event.stackTrace == null) {
      return messageList;
    }

    final stackTrace = prettyPrinter.formatStackTrace(event.stackTrace, 0);
    if (stackTrace != null) {
      messageList.add(stackTrace);
    }

    return messageList;
  }
}
