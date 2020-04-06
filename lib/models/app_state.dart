import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rapidpass_checkpoint/services/app_storage.dart';

import 'app_secrets.dart';

class AppState extends ChangeNotifier {
  DateTime _databaseLastUpdated;
  String _masterQrCode;
  AppSecrets _appSecrets;

  static final DateFormat dateFormat = DateFormat.yMMMd('en_US').add_jm();

  String get databaseLastUpdatedText => (_databaseLastUpdated != null)
      ? 'Database last updated on ${dateFormat.format(_databaseLastUpdated)}'
      : null;

  set databaseLastUpdated(final int timestamp) {
    debugPrint('databaseLastUpdated($timestamp)');
    this._databaseLastUpdated = timestamp > 0
        ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
        : null;
    notifyListeners();
  }

  String get masterQrCode => this._masterQrCode;
  set masterQrCode(final String masterQrCode) {
    this._masterQrCode = masterQrCode;
    AppStorage.setMasterQrCode(masterQrCode).then((_) {
      debugPrint('Master QR Code saved!');
      notifyListeners();
    });
  }

  AppSecrets get appSecrets => this._appSecrets;
  set appSecrets(final AppSecrets appSecrets) {
    this._appSecrets = appSecrets;
    AppStorage.setAppSecrets(appSecrets).then((_) => notifyListeners());
  }
}
