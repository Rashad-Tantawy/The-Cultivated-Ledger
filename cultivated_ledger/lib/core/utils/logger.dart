import 'package:logger/logger.dart';
import '../config/app_config.dart';

final appLogger = Logger(
  printer: PrettyPrinter(methodCount: 2, errorMethodCount: 8),
  level: AppConfig.isProduction ? Level.warning : Level.debug,
);
