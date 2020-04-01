import 'package:flutter/material.dart';

class DialogHelper {
  /// Create a singleton instance for this class
  static final DialogHelper _instance = DialogHelper._internal();
  factory DialogHelper() => _instance;
  DialogHelper._internal();

  /// Shows an alert dialog,
  /// Follow the specs in https://material.io/components/dialogs/
  ///
  /// Usage:
  /// * Informative/Acknowledgement - Presents an information with a single action.
  ///   ```
  ///   @params {
  ///     title
  ///     message
  ///     confirmText (optional) = defaults to "OK"
  ///   }
  ///   ```
  ///   @code
  ///   ```dart
  ///   DialogHelper.showAlertDialog(context,
  ///     title: 'An error occured',
  ///     message: 'Something went wrong.',
  ///     confirmText: 'OK'
  ///   )
  ///   ```
  ///
  ///
  /// * Confirmation-like - Informs the user with some information and lets the user decide to proceed or not.
  ///   ```
  ///   @params {
  ///     title
  ///     message
  ///     dismissible (optional) = defaults to true
  ///     cancelText (optional) = defaults to "CANCEL"
  ///     confirmText (optional) = defaults to "OK"
  ///     cancelStyle (optional)
  ///     confirmStyle (optional)
  ///     onCancel (optional) = defaults to dismiss the dialog
  ///     onConfirm (required) = defaults to dismiss the dialog, and emits the callback,
  ///     actions (optional) = when you want to provide three or more actions, overrides with cancel and confirm
  ///   }
  ///   ```
  ///   @code
  ///   ```dart
  ///   DialogHelper.showAlertDialog(context,
  ///     title: 'Logout?',
  ///     message: 'Do you really want to logout?',
  ///     cancelText: 'CANCEL'
  ///     confirmText: 'LOGOUT',
  ///     onCancel: () { // Do something when cancel was tapped },
  ///     onConfirm: () { // Do something when confirm was tapped },
  ///   )
  ///   ```
  static Future showAlertDialog(BuildContext context,
      {String title,
      String message,
      String cancelText,
      String confirmText,
      TextStyle cancelStyle,
      TextStyle confirmStyle,
      VoidCallback onCancel,
      VoidCallback onConfirm,
      WillPopCallback onWillPop,
      List<Widget> actions,
      bool dismissible = true}) {
    TextStyle _defaultStyle = TextStyle(color: Theme.of(context).primaryColor);
    String _defaultCancelText = 'CANCEL';
    String _defaultConfirmText = 'OK';

    List<Widget> _buildActions() {
      if (actions != null) return actions;

      List<Widget> _actions = [];
      if ((cancelText != null && cancelText != '') || onCancel != null) {
        _actions.add(FlatButton(
          onPressed: () {
            Navigator.pop(context);
            if (onCancel != null) onCancel();
          },
          child: Text(cancelText ?? _defaultCancelText,
              style: _defaultStyle.merge(cancelStyle)),
        ));
      }
      if (confirmText != null || confirmText != '') {
        _actions.add(FlatButton(
          onPressed: () {
            Navigator.pop(context);
            if (onConfirm != null) onConfirm();
          },
          child: Text(confirmText ?? _defaultConfirmText,
              style: _defaultStyle.merge(confirmStyle)),
        ));
      }

      return _actions;
    }

    return showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: onWillPop ?? () async => true,
            child: AlertDialog(
                title: title != null ? Text(title) : const SizedBox(),
                contentPadding: message != null
                    ? const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0)
                    : const EdgeInsets.all(0),
                content: message != null
                    ? SingleChildScrollView(child: Text(message))
                    : const SizedBox(height: 12.0),
                actions: _buildActions().toList()),
          );
        });
  }
}
