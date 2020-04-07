import 'app.dart';
import 'flavor.dart';

void main() {
  final flavor = Flavor(
      environment: Environment.prod,
      apiBaseUrl: 'https://rapidpass-api.azurewebsites.net/api/v1/');
  runRapidPassCheckpoint(flavor);
}
