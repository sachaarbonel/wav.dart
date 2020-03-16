import 'dart:io';

enum WavFormat { WAVE, OTHER }
enum Encoding { PCM, OTHER }
enum System { MONO, STEREO }

/// Returns the lesser of two numbers.
///
/// ```dart
/// import 'dart:io';
/// import 'package:wav/wav.dart';
/// main() async {
///   final wav = WavReader();
///   await wav.open(file: File('oishii.wav'));
///   print(wav.chunkID);
///   print(wav.chunkSize);
///   ///final WavFormat format;
///   print(wav.format);
///   print(wav.subChunk1ID);
///   print(wav.subChunk1Size);
///   print(wav.encoding);
///   /// final Encoding encoding;
///   print(wav.numChannels);
///   print(wav.sampleRate);
///   print(wav.blockAlign);
///   print(wav.bitsPerSample);
///   print(wav.subChunk2ID);
///   print(wav.subChunk2Size);
///   print(wav.bytesPerSample);
///   print(wav.sampleCount);
///   print(wav.audioLength);
///   print(wav.readSamples());
/// }
/// ```

class WavReader {
  String chunkID;
  int chunkSize;
  WavFormat format;
  String rawFormat;
  String subChunk1ID;
  int subChunk1Size;
  int rawEncoding;
  Encoding encoding;
  int numChannels;
  int sampleRate;
  int blockAlign;
  int bitsPerSample;
  String subChunk2ID;
  int subChunk2Size;
  double bytesPerSample;
  int sampleCount;
  double audioLength;
  System system;
  final List<int> _samples = [];
  WavReader();

  List<int> readSamples() => _samples;

  void open({String path}) async {
    final data = await File(path).open();
    final chunkIDBytes = await data.read(4);
    chunkID = String.fromCharCodes(chunkIDBytes);
    // assert(chunkID == 'RIFF');
    final chunkSizeBytes = await data.read(4);
    chunkSize = chunkSizeBytes.buffer.asByteData().getInt8(0);
    final formatBytes = await data.read(4);
    final formatStr = String.fromCharCodes(formatBytes);
    // assert(formatStr == 'WAVE');
    format = getFormat(formatStr);
    final subChunk1IDBytes = await data.read(4);
    subChunk1ID = String.fromCharCodes(subChunk1IDBytes);
    // assert(subChunk1ID == 'fmt ');
    final subChunk1SizeBytes = await data.read(4);
    subChunk1Size = subChunk1SizeBytes.buffer.asByteData().getInt8(0);
    final encodingBytes = await data.read(2);
    final encodingInt = encodingBytes.buffer.asByteData().getInt8(0);
    encoding = getEncoding(encodingInt);
    //  print(encoding); //assert 1 == PCM Format: assumed PCM

    final numChannelsBytes = await data.read(2);
    numChannels = numChannelsBytes.buffer.asByteData().getInt8(0);
    system = getSystem(numChannels);
    //print(numChannels); //'1 == Mono, 2 == Stereo: assumed Mono'

    final sampleRateBytes = await data.read(4);
    sampleRate = sampleRateBytes.buffer.asByteData().getInt8(0);

    final byteRateBytes = await data.read(4);
    final byteRate = byteRateBytes.buffer.asByteData().getInt8(0);

    final blockAlignBytes = await data.read(2);
    blockAlign = blockAlignBytes.buffer.asByteData().getInt8(0);

    final bitsPerSampleBytes = await data.read(2);
    bitsPerSample = bitsPerSampleBytes.buffer.asByteData().getInt8(0);

    var subChunk2IDBytes = await data.read(4);
    subChunk2ID = String.fromCharCodes(subChunk2IDBytes);
    // assert(subChunk2ID == 'data');

    final subChunk2SizeBytes = await data.read(4);
    subChunk2Size = subChunk2SizeBytes.buffer.asByteData().getInt8(0);
    bytesPerSample = bitsPerSample / 8;
    // assert(subChunk2Size % bytesPerSample == 0);
    sampleCount = (subChunk2Size / bytesPerSample).round();
    for (var i = 0; i < sampleCount; i++) {
      var bytes = await data.read(2);
      _samples.add(bytes.buffer.asByteData().getInt8(0));
    }
    // assert(chunkSize ==
    //         formatStr.length +
    //             subChunk1ID.length +
    //             subChunk1Size +
    //             4 + //Full size of subchunk 1
    //             subChunk2ID.length +
    //             subChunk2Size +
    //             4 //Full size of subchunk 2

    //     );
    // assert(subChunk1Size ==
    //         2 + // audio_format
    //             2 + // num_channels
    //             4 + // sample_rate
    //             4 + // byte_rate
    //             2 + // block_align
    //             2 // bits_per_sample
    //     );

    // assert(byteRate == sampleRate * numChannels * bytesPerSample);
    // assert(blockAlign == numChannels * bytesPerSample);
    // assert(subChunk2Size == _samples.length * bytesPerSample);
    audioLength = (_samples.length / sampleRate);
  }

  static WavFormat getFormat(String formatStr) {
    switch (formatStr) {
      case 'WAVE':
        return WavFormat.WAVE;
        break;
      default:
        return WavFormat.OTHER;
    }
  }

  static Encoding getEncoding(int encodingInt) {
    switch (encodingInt) {
      case 1:
        return Encoding.PCM;
        break;
      default:
        return Encoding.OTHER;
    }
  }

  static System getSystem(int numChannels) {
    switch (numChannels) {
      case 1:
        return System.MONO;
        break;
      case 2:
        return System.STEREO;
        break;
      default:
        return System.MONO;
    }
  }
}
