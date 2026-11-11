abstract final class AppConfig {
  static const version = String.fromEnvironment(
    'FLUTTER_BUILD_NAME',
    defaultValue: '0.2.0',
  );
}
