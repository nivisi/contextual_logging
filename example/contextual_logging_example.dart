import 'package:contextual_logging/src/contextual_logger.dart';

Future<void> main() async {
  final weatherController = WeatherController();
  final cityController = CityController();

  await weatherController.initialize();
  await cityController.initialize();
}

class WeatherController with ContextualLogger {
  Future<void> initialize() async {
    try {
      log.i('Initializing ...');
      await fetchSomeData();
      log.i('Initialized successfully!');
    } on Exception catch (e, s) {
      log.e('Failed to initialize', e, s);
    }
  }
}

class CityController with ContextualLogger {
  Future<void> initialize() async {
    try {
      log.i('Initializing ...');
      await fetchSomeData();
      log.i('Initialized successfully!');
    } on Exception catch (e, s) {
      log.e('Failed to initialize', e, s);
    }
  }
}

Future<void> fetchSomeData() {
  return Future.value();
}
