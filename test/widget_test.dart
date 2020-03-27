import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/screens/welcome_screen.dart';
import 'package:rapidpass_checkpoint/viewmodel/device_info_model.dart';

Widget createMaterialWidget({Widget child}) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  group('ViewModel test group', () {
    testWidgets('DeviceInfoModel provided properly inside WelcomeScreen',
        (WidgetTester tester) async {
      final _model = DeviceInfoModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<DeviceInfoModel>(
          create: (_) => _model,
          child: createMaterialWidget(child: WelcomeScreen()),
        ),
      );

      final context = tester.element(find.byType(WelcomeScreen));
      expect(Provider.of<DeviceInfoModel>(context, listen: false), _model);
    });
  });
}
