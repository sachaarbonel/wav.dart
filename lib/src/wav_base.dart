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
///   final wav = await WavReader.open(file: File('oishii.wav'));
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
/// }
/// ```

class WavReader {
  final String chunkID;
  final int chunkSize;
  final WavFormat format;
  final String rawFormat;
  final String subChunk1ID;
  final int subChunk1Size;
  final int rawEncoding;
  final Encoding encoding;
  final int numChannels;
  final int sampleRate;
  final int blockAlign;
  final int bitsPerSample;
  final String subChunk2ID;
  final int subChunk2Size;
  final double bytesPerSample;
  final int sampleCount;
  final double audioLength;
  final System system;
  WavReader._(
      {this.chunkID,
      this.chunkSize,
      this.format,
      this.rawFormat,
      this.subChunk1ID,
      this.subChunk1Size,
      this.encoding,
      this.rawEncoding,
      this.numChannels,
      this.system,
      this.sampleRate,
      this.blockAlign,
      this.bitsPerSample,
      this.subChunk2ID,
      this.subChunk2Size,
      this.bytesPerSample,
      this.sampleCount,
      this.audioLength});
  static Future<WavReader> open({File file}) async {
    final data = await file.open();
    final chunkIDBytes = await data.read(4);
    final chunkID = String.fromCharCodes(chunkIDBytes);
    assert(chunkID == 'RIFF');
    final chunkSizeBytes = await data.read(4);
    final chunkSize = chunkSizeBytes.buffer.asByteData().getInt8(0);
    // print(chunkSize);
    final formatBytes = await data.read(4);
    final formatStr = String.fromCharCodes(formatBytes);
    assert(formatStr == 'WAVE');
    final subChunk1IDBytes = await data.read(4);
    final subChunk1ID = String.fromCharCodes(subChunk1IDBytes);
    assert(subChunk1ID == 'fmt ');
    final subChunk1SizeBytes = await data.read(4);
    final subChunk1Size = subChunk1SizeBytes.buffer.asByteData().getInt8(0);
    //print(subChunk1Size);
    final encodingBytes = await data.read(2);
    final encodingInt = encodingBytes.buffer.asByteData().getInt8(0);
    //  print(encoding); //assert 1 == PCM Format: assumed PCM

    final numChannelsBytes = await data.read(2);
    final numChannels = numChannelsBytes.buffer.asByteData().getInt8(0);
    //print(numChannels); //'1 == Mono, 2 == Stereo: assumed Mono'

    final sampleRateBytes = await data.read(4);
    final sampleRate = sampleRateBytes.buffer.asByteData().getInt8(0);
    // print(sampleRate);

    final byteRateBytes = await data.read(4);
    final byteRate = byteRateBytes.buffer.asByteData().getInt8(0);
    // print(byteRate);

    final blockAlignBytes = await data.read(2);
    final blockAlign = blockAlignBytes.buffer.asByteData().getInt8(0);
    //print(blockAlign);

    final bitsPerSampleBytes = await data.read(2);
    final bitsPerSample = bitsPerSampleBytes.buffer.asByteData().getInt8(0);
    // print(bitsPerSample);

    var subChunk2IDBytes = await data.read(4);
    final subChunk2ID = String.fromCharCodes(subChunk2IDBytes);
    assert(subChunk2ID == 'data');

    final subChunk2SizeBytes = await data.read(4);
    final subChunk2Size = subChunk2SizeBytes.buffer.asByteData().getInt8(0);
    // print(subChunk2Size);
    final bytesPerSample = bitsPerSample / 8;
    // print(bytesPerSample);
    assert(subChunk2Size % bytesPerSample == 0);
    var sampleCount = (subChunk2Size / bytesPerSample).round();
    //print(sampleCount);
    final samples = [];
    for (var i = 0; i < sampleCount; i++) {
      var bytes = await data.read(2);
      samples.add(bytes.buffer.asByteData().getInt8(0));
    }
    assert(chunkSize ==
            formatStr.length +
                subChunk1ID.length +
                subChunk1Size +
                4 + //Full size of subchunk 1
                subChunk2ID.length +
                subChunk2Size +
                4 //Full size of subchunk 2

        );
    assert(subChunk1Size ==
            2 + // audio_format
                2 + // num_channels
                4 + // sample_rate
                4 + // byte_rate
                2 + // block_align
                2 // bits_per_sample
        );

    assert(byteRate == sampleRate * numChannels * bytesPerSample);
    assert(blockAlign == numChannels * bytesPerSample);
    assert(subChunk2Size == samples.length * bytesPerSample);
    final audioLength = (samples.length / sampleRate);
    //  print(audioLength);
    return WavReader._(
        chunkID: chunkID,
        chunkSize: chunkSize,
        format: getFormat(formatStr),
        rawFormat: formatStr,
        subChunk1ID: subChunk1ID,
        subChunk1Size: subChunk1Size,
        encoding: getEncoding(encodingInt),
        rawEncoding: encodingInt,
        system: getSystem(numChannels),
        numChannels: numChannels,
        sampleRate: sampleRate,
        blockAlign: blockAlign,
        bitsPerSample: bitsPerSample,
        subChunk2ID: subChunk2ID,
        subChunk2Size: subChunk2Size,
        bytesPerSample: bytesPerSample,
        sampleCount: sampleCount,
        audioLength: audioLength);
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
