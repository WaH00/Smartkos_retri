class ApiConstants {
  ApiConstants._();

  static const String serverBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const String apiV1 = '/api/v1';
  static const String searchKos = '$apiV1/search-kos';
  static const String chat = '$apiV1/chat';
  static const String health = '$apiV1/health';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const int defaultTopK = 10;
  static const int defaultNCandidates = 20;

  static String staticFileUrl(String fotoPath) {
    final normalizedPath = fotoPath.trim();
    if (normalizedPath.isEmpty) return '';
    if (normalizedPath.startsWith('http://') ||
        normalizedPath.startsWith('https://')) {
      return normalizedPath;
    }
    var path = normalizedPath.startsWith('/')
        ? normalizedPath.substring(1)
        : normalizedPath;
    if (path.startsWith('static/')) {
      path = path.substring('static/'.length);
    }
    return '$serverBaseUrl/static/$path';
  }
}
