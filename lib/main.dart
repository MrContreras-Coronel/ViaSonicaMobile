import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'objects.dart' as obj;
import 'songpage.dart';

const imag_url = "https://api.institutoalfa.org/api/songs/image/";
const song_url = "https://api.institutoalfa.org/api/songs/audio/";

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Via Sonica Movil',
      theme: ThemeData(
        // This is the theme of your application.

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Via Sonica Movil'),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var insti_url = Uri.https('api.institutoalfa.org', '/api/songs/');
  late Future<List<dynamic>> canciones;

  Future<List<dynamic>> getSongs() async {
    var insti_url = Uri.https('api.institutoalfa.org', '/api/songs/');

    var lista_canciones = await http.get(insti_url);

    if (lista_canciones.statusCode != 200) {
      throw Exception('Error cargando la data');
    } else {
      var jsonresp = convert.jsonDecode(lista_canciones.body);
      return jsonresp['songs'].map((x) => obj.JObject.fromJson(x)).toList();
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    canciones = getSongs();
  }

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
                child: Text(widget.title, style: obj.myStyle)),
          ]),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/fondo.jpg',
                  ),
                  fit: BoxFit.cover)),
          child: FutureBuilder(
              future: canciones,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(child: Text('Error ${snap.error}'));
                } else if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                      itemCount: snap.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(child: Center(
                            child: Container(
                              width: 280,
                              height: 350,
                              // color: Color.fromARGB(255, 179, 77, 158),
                              child: Column(
                                children: <Widget>[
                                  Padding(child: Image.network(
                                      imag_url + snap.data![index].image,
                                      height: 150,
                                      width: 150),
                                      padding: EdgeInsets.all(18)),
                                  Text(
                                    'Titulo: ${snap.data![index].title}',
                                    style: obj.myStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text('Album: ${snap.data![index].album}',
                                      style: obj.myStyle,
                                      textAlign: TextAlign.center),
                                  Text('Autor: ${snap.data![index].author}',
                                      style: obj.myStyle,
                                      textAlign: TextAlign.center),
                                  Center(
                                      child: FloatingActionButton(
                                          onPressed: () {
                                           Navigator.push(
                                               context,
                                               MaterialPageRoute(builder:
                                            (context) => Track(cancion: snap.data![index]))
                                             );},
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 40
                                          )))
                                ],
                              ),
                              decoration: obj.bxStyle,
                            )
                        ),
                            padding: EdgeInsets.all(15));
                      });
                }
              }),
        ));
  }
}
