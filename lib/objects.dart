import 'package:flutter/material.dart';
class JObject{
  final String id;
  final String title;
  final String author;
  final String album;
  final String audio;
  final String image;
  JObject({required this.id, required this.title, required this.author, required this.album, required this.audio,
      required this.image});

  factory JObject.fromJson(Map<String, dynamic> json){
      return JObject(id: json['_id']!,
      title : json['title']!,
      album : json['album']!,
      author : json['author']!,
      audio : json['audio']['filename']!,
      image : json['image']['filename']!);
  }
}

const myStyle = TextStyle(
   color: Colors.white,
   fontWeight: FontWeight.w400,
   fontSize: 18,

  );
var color_cuadro = int.parse("b34d9e",radix: 16);

var bxStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Color.fromARGB(255, 179, 77, 158)
);

var applicationBar = AppBar(
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
        child: Text('Via Sonica Movil', style: myStyle)),
  ]),
);