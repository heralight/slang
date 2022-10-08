import 'package:slang/builder/model/i18n_locale.dart';

/// Operations on paths
class PathUtils {
  /// converts /some/path/file.json to file.json
  static String getFileName(String path) {
    return path.replaceAll('\\', '/').split('/').last;
  }

  /// converts /some/path/file.json to file
  static String getFileNameNoExtension(String path) {
    return getFileName(path).split('.').first;
  }

  /// converts /some/path/file.i18n.json to i18n.json
  static String getFileExtension(String path) {
    final fileName = getFileName(path);
    final firstDot = fileName.indexOf('.');
    return fileName.substring(firstDot + 1);
  }

  /// converts /a/b/file.json to b
  static String? getParentDirectory(String path) {
    final segments = path.replaceAll('\\', '/').split('/');
    if (segments.length == 1) {
      return null;
    }
    return segments[segments.length - 2];
  }

  /// converts /some/path/file.json to /some/path/newFile.json
  static String replaceFileName({
    required String path,
    required String newFileName,
    required String pathSeparator,
  }) {
    final index = path.lastIndexOf(pathSeparator);
    if (index == -1) {
      return newFileName;
    } else {
      return path.substring(0, index + pathSeparator.length) + newFileName;
    }
  }

  /// converts /some/path to /some/path/my_file.json
  static String withFileName({
    required String directoryPath,
    required String fileName,
    required String pathSeparator,
  }) {
    if (directoryPath.endsWith(pathSeparator)) {
      return directoryPath + fileName;
    } else {
      return directoryPath + pathSeparator + fileName;
    }
  }
}

class BuildResultPaths {
  static String mainPath(String outputPath) {
    return outputPath;
  }

  static String localePath({
    required String outputPath,
    required I18nLocale locale,
    required String pathSeparator,
  }) {
    final fileNameNoExtension = PathUtils.getFileNameNoExtension(outputPath);
    final localeExt = locale.languageTag.replaceAll('-', '_');
    final fileName = '${fileNameNoExtension}_$localeExt.g.dart';
    return PathUtils.replaceFileName(
      path: outputPath,
      newFileName: fileName,
      pathSeparator: pathSeparator,
    );
  }

  static String flatMapPath({
    required String outputPath,
    required String pathSeparator,
  }) {
    final fileNameNoExtension = PathUtils.getFileNameNoExtension(outputPath);
    final fileName = '${fileNameNoExtension}_map.g.dart';
    return PathUtils.replaceFileName(
      path: outputPath,
      newFileName: fileName,
      pathSeparator: pathSeparator,
    );
  }
}
