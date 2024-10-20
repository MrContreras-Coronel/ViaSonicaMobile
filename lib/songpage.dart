import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'objects.dart' as obj;
import 'package:audioplayers/audioplayers.dart';
//import 'package:simple_audio_player/simple_audio_player.dart';

const imag_url = "https://api.institutoalfa.org/api/songs/image/";
const song_url = "https://api.institutoalfa.org/api/songs/audio/";

class Track extends StatelessWidget {
  Track({super.key,required this.cancion});
  final obj.JObject cancion;
  final music = AudioPlayer();
 // final SimpleAudioPlayer play = SimpleAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 23, 21, 59),
        title: Row(children: [
          CircleAvatar(
            child: Padding(
                padding: const EdgeInsets.all(1),
                child: ClipOval(
                    child: Image(image: AssetImage('assets/vector.jpg')))),
            radius: 15,
          ),
          Padding(
              padding: EdgeInsets.all(5),
              child: Text('Via Sonica Movil', style: obj.myStyle)),
        ]),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image:AssetImage('assets/fondo.jpg'),
            fit: BoxFit.cover),
          ),
          child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(child: Container(
                    width: 280,
                    height: 350,
                    decoration: obj.bxStyle,
                    child: Column(
                      children: <Widget>[
                        Padding(child: Image.network(
                            imag_url + cancion.image,
                            height: 150,
                            width: 150),
                            padding: EdgeInsets.all(18)),
                        Text(
                          'Titulo: ${cancion.title}',
                          style: obj.myStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text('Album: ${cancion.album}',
                            style: obj.myStyle,
                            textAlign: TextAlign.center),
                        Text('Autor: ${cancion.author}',
                            style: obj.myStyle,
                            textAlign: TextAlign.center),
                        Center(
                            child: FloatingActionButton(
                                onPressed: () async {
                                  await music.play(UrlSource(song_url + cancion.audio));
                                },
                                child: Icon(
                                    Icons.play_arrow,
                                    size: 40
                                )))
                      ],
                    ),

                  )))

          )
    );
  }
}
