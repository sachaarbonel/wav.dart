import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wav/src/wav_base.dart';

import 'painter.dart';

class AudioVisualizer extends StatelessWidget {
  final WavReader _wavReader = WavReader();
  AudioVisualizer({
    Key key,
    @required this.fileName,
  }) : super(key: key);

  final String fileName;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> _localFilePath({String fileName}) async {
    final path = await _localPath;
    return '$path/$fileName.wav';
  }

  Future<List<int>> readAudio() async {
    final path = await _localFilePath(fileName: fileName);
    await _wavReader.open(path: path);
    final samples = _wavReader.readSamples();
    print(samples);
    return samples;
  }

  @override
  Widget build(BuildContext context) {
    // final data = [
    //   73,
    //   70,
    //   73,
    //   82,
    //   7,
    //   0,
    //   84,
    //   102,
    //   103,
    //   0,
    //   73,
    //   70,
    //   14,
    //   0,
    //   76,
    //   118,
    //   53,
    //   46,
    //   52,
    //   49,
    //   49
    // ];
    // return Column(
    //   children: <Widget>[
    //     Text('hey'),
    //     CustomPaint(
    //       size: Size(300, 300),
    //       painter: WavPainter(
    //         data: data,
    //       ),
    //     ),
    //   ],
    // );
    return FutureBuilder(
      future: readAudio(),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        return snapshot.hasData
            ? CustomPaint(
                painter: WavPainter(
                  data: snapshot.data,
                ),
              )
            : CircularProgressIndicator();
      },
    );
  }
}
