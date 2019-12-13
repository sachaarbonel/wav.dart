A library for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'dart:io';

import 'package:wav/wav.dart';

main() async {
  final wav = await WavReader.open(file: File('oishii.wav'));
  print(wav.chunkID);
  print(wav.chunkSize);
  //final WavFormat format;
  print(wav.format);
  print(wav.subChunk1ID);
  print(wav.subChunk1Size);
  print(wav.encoding);
  // final Encoding encoding;
  print(wav.numChannels);
  print(wav.sampleRate);
  print(wav.blockAlign);
  print(wav.bitsPerSample);
  print(wav.subChunk2ID);
  print(wav.subChunk2Size);
  print(wav.bytesPerSample);
  print(wav.sampleCount);
  print(wav.audioLength);
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
