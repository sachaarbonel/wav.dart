import 'dart:io';

import 'package:wav/wav.dart';

main() async {
  final wav = await WavReader.open(file: File('oishii.wav'));

  print(wav.audioLength);
}
