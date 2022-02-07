import 'dart:async';

import 'package:flutter/services.dart';

class IoDldbSdk {
  static const MethodChannel _channel = MethodChannel('io_dldb_sdk');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> init(
      String dldbApiKey, String eventsDictionaryAsJson) async {
    await _channel.invokeMethod('init', {
      'dldbApiKey': dldbApiKey,
      'eventsDictionaryAsJson': eventsDictionaryAsJson
    });
  }

  static Future<void> heartbeat() async {
    await _channel.invokeMethod('heartbeat');
  }

  static Future<void> runQueriesIfAny() async {
    await _channel.invokeMethod('runQueriesIfAny');
  }

  static Future<void> close() async {
    await _channel.invokeMethod('close');
  }

  static Future<void> addEvents(String eventsAsJson) async {
    await _channel.invokeMethod('addEvents', {'eventsAsJson': eventsAsJson});
  }

  static Future<void> addEventsWithLocation(
      String eventsAsJson,
      double longitudeInDegrees,
      double latitudeInDegrees,
      double horizontalAccuracy) async {
    await _channel.invokeMethod('addEventsWithLocation', {
      'eventsAsJson': eventsAsJson,
      'longitudeInDegrees': longitudeInDegrees,
      'latitudeInDegrees': latitudeInDegrees,
      'horizontalAccuracy': horizontalAccuracy
    });
  }

  static Future<void> addLocation(double longitudeInDegrees,
      double latitudeInDegrees, double horizontalAccuracy) async {
    await _channel.invokeMethod('addLocation', {
      'longitudeInDegrees': longitudeInDegrees,
      'latitudeInDegrees': latitudeInDegrees,
      'horizontalAccuracy': horizontalAccuracy
    });
  }

  static Future<String?> queriesLog(int maxEntries) async {
    final String? log =
        await _channel.invokeMethod('queriesLog', {'maxEntries': maxEntries});
    return log;
  }

  static Future<String?> locationsLog(
      int durationInSeconds, int maxEntries, int resolution) async {
    final String? log = await _channel.invokeMethod('locationsLog', {
      'durationInSeconds': durationInSeconds,
      'maxEntries': maxEntries,
      'resolution': resolution
    });
    return log;
  }
}
