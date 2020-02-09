import 'dart:io';

import 'package:wav/wav.dart';

void main() async {
  final wav = WavReader();
  await wav.open(file: File('oishii.wav'));
  print(wav.chunkID);
  print(wav.chunkSize);
  print(wav.format);
  print(wav.subChunk1ID);
  print(wav.subChunk1Size);
  print(wav.encoding);
  print(wav.numChannels);
  print(wav.sampleRate);
  print(wav.blockAlign);
  print(wav.bitsPerSample);
  print(wav.subChunk2ID);
  print(wav.subChunk2Size);
  print(wav.bytesPerSample);
  print(wav.sampleCount);
  print(wav.audioLength);
  print(wav.readSamples());
}
