import 'package:flutter/material.dart';
import 'package:myweatherapp/weather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My weather app',
      home: Weather(),
    );
  }
}
