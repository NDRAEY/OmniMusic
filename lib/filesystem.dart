
import 'dart:io';

String? homeDir() {
  return Platform.environment['HOME'] // Linux
      ??
      Platform.environment['USERPROFILE']; // Windows
}