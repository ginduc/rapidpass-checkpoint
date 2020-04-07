import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';

enum Environment { dev, prod }

class Flavor {
  final Environment environment;
  final String apiBaseUrl;

  static Flavor _instance;

  factory Flavor(
      {@required Environment environment, @required String apiBaseUrl}) {
    _instance ??= Flavor._internal(environment, apiBaseUrl);
    return _instance;
  }

  Flavor._internal(this.environment, this.apiBaseUrl);

  static Flavor get instance => _instance;
  static bool get isProduction => _instance.environment == Environment.prod;
}
