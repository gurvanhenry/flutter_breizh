import 'package:flutter/material.dart';

void main() => runApp(BreizhApp());

class BreizhApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Breizh',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Breizh'),
        ),
        body: Center(
          child: Text('Bonjour DevFest du Bout du Monde !'),
        ),
      ),
    );
  }
}