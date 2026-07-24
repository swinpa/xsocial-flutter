import 'package:logger/logger.dart';

var logger = Logger(
  printer: SimplePrinter(
    printTime: false,
    colors: false,
  ),
);
