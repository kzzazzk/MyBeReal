import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
  debug: false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Center(child: Text('MyBeReal')),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.center,
                colors: <Color>[Colors.deepPurpleAccent, Colors.indigo],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: <Color>[Colors.deepPurpleAccent, Colors.indigo],
            ),
          ),
        ),
      ),
    );
  }
}
