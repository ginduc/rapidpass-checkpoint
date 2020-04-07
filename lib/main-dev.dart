import 'app.dart';

void main() {
  final flavor = Flavor(
      environment: Environment.dev,
      apiBaseUrl: 'https://rapidpass-api-stage.azurewebsites.net/api/v1/');
  runRapidPassCheckpoint(flavor);
}
