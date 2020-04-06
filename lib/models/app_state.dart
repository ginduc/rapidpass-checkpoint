import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class AppState extends ChangeNotifier {
  DateTime _databaseLastUpdated;

  static final DateFormat dateFormat = DateFormat.yMMMd('en_US').add_jm();

  String get databaseLastUpdatedText => (_databaseLastUpdated != null)
      ? 'Database last updated on ${dateFormat.format(_databaseLastUpdated)}'
      : null;

  void setDatabaseLastUpdated(final int timestamp) {
    debugPrint('databaseLastUpdated($timestamp)');
    this._databaseLastUpdated = timestamp > 0
        ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
        : null;
    notifyListeners();
  }
}
