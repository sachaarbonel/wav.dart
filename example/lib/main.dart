import 'package:flutter/services.dart';
import 'package:wav/wav.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String bitsPerSample;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Welcome to Flutter'),
          ),
          body: Center(
              child: Column(
            children: <Widget>[
              Text("Press on the play button to read sample count"),
              Text("bitsPerSample : $bitsPerSample"),
            ],
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final audioPath =
                  await loadFile("assets/oishii.wav", "oishii.wav");
              print(audioPath);
              final _wavReader = WavReader();
              await _wavReader.open(path: audioPath);
              setState(() {
                bitsPerSample = "${_wavReader.bitsPerSample}";
              });
            },
          ),
        ));
  }
}
