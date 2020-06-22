import 'package:flutter/material.dart';
import 'package:flutter_blog_app/authentication.dart';
import 'package:flutter_blog_app/mapping.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blog App",
      theme: ThemeData(
        primarySwatch: Colors.pink
      ),
      debugShowCheckedModeBanner: false,
      home: MappingPage(auth: Auth(),),
    );
  }
}