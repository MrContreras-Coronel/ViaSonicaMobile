import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'objects.dart' as obj;
import 'package:audioplayers/audioplayers.dart';
//import 'package:simple_audio_player/simple_audio_player.dart';

const imag_url = "https://api.institutoalfa.org/api/songs/image/";
const song_url = "https://api.institutoalfa.org/api/songs/audio/";

class Track extends StatefulWidget {
  Track({super.key, required this.canciones, required this.index});
  final List<dynamic> canciones;
  final index;

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  late final cancion;
  final music = AudioPlayer();
  bool isPlaying = true;
  Duration? dur;
  Duration pos = Duration.zero;
  @override
  void initState() {
    cancion = widget.canciones[widget.index];
    super.initState();
    _initAudio();
    music.resume();
  }

  void changeSong(next) {
    if (next < 0) {
      next = widget.canciones.length - 1;
    } else if (next >= widget.canciones.length) {
      next = 0;
    }
    music.dispose();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Track(canciones: widget.canciones, index: next)));

  }

  void _initAudio() {
    music.setSourceUrl(song_url + cancion.audio);
    music.onDurationChanged.listen((d) {
      setState(() {
        dur = d;
      });
    });
    music.onPositionChanged.listen((d) {
      setState(() {
        pos = d;
      });
    });
  }

  void move(double x) {
    final sPos = Duration(milliseconds: x.toInt());
    music.seek(sPos);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    music.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: obj.applicationBar,
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
            ),
            child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                    child: Container(
                  decoration: obj.bxStyle,
                  child: Column(children: <Widget>[
                    Padding(
                        child: Image.network(imag_url + cancion.image,
                            height: 150, width: 150),
                        padding: EdgeInsets.all(18)),
                    Text(
                      'Titulo: ${cancion.title}',
                      style: obj.myStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text('Album: ${cancion.album}',
                        style: obj.myStyle, textAlign: TextAlign.center),
                    Text('Autor: ${cancion.author}',
                        style: obj.myStyle, textAlign: TextAlign.center),
                    Slider(
                      value: pos.inMilliseconds.toDouble(),
                      min: 0,
                      max: dur?.inMilliseconds.toDouble() ?? 0,
                      onChanged: (value) {
                        move(value);
                      },
                      activeColor: Color.fromARGB(255, 23, 21, 59),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                      FloatingActionButton(onPressed: (){
                        changeSong(widget.index-1);
                      },
                        child: Icon(Icons.arrow_back,size: 40)
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10,0,10,0),
                          child: botonPlay(
                              isPlaying: isPlaying,
                              songurl: song_url + cancion.audio,
                              func: () async {
                                if (!isPlaying) {
                                  await music.resume();
                                } else {
                                  music.pause();
                                }
                                isPlaying = !isPlaying;
                                setState(() {});
                              })),
                      FloatingActionButton(onPressed: (){
                        changeSong(widget.index+1);
                      },
                          child: Icon(Icons.arrow_forward,size: 40)
                      )
                    ])
                  ]),
                )))));
  }
}

class botonPlay extends StatefulWidget {
  botonPlay(
      {super.key,
      required this.isPlaying,
      required this.songurl,
      required this.func});
  final bool isPlaying;
  final String songurl;
  final void Function()? func;
  @override
  State<botonPlay> createState() => _botonPlayState();
}

class _botonPlayState extends State<botonPlay> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: widget.func,
        child:
            Icon(widget.isPlaying ? Icons.pause : Icons.play_arrow, size: 40));
  }
}
