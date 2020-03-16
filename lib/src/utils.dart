import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<String> loadFile(String path, String filename) async {
  var bytes = await rootBundle.load(path);
  String dir = (await getApplicationDocumentsDirectory()).path;
  final file = await _writeToFile(bytes, '$dir/$filename');
  return file.path;
}

Future<File> _writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
