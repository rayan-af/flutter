import 'dart:io';

void main() async {
  final outputFile = File('codebase_context.txt');
  final sink = outputFile.openWrite();

  final filesToInclude = ['pubspec.yaml', 'README.md'];
  final directoriesToScan = ['lib'];

  for (final fileName in filesToInclude) {
    final file = File(fileName);
    if (await file.exists()) {
      sink.writeln('--- File: $fileName ---');
      final content = await file.readAsString();
      sink.writeln(content);
      sink.writeln('\n');
    }
  }

  for (final dirName in directoriesToScan) {
    final dir = Directory(dirName);
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          sink.writeln('--- File: ${entity.path} ---');
          try {
            final content = await entity.readAsString();
            sink.writeln(content);
          } catch (e) {
            sink.writeln('Error reading file: $e');
          }
          sink.writeln('\n');
        }
      }
    }
  }

  await sink.close();
  print('Codebase successfully bundled into codebase_context.txt!');
}
