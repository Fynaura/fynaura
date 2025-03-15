import 'package:flutter/material.dart';


void main() => runApp(MyApp());

  class MyApp extends StatelessWidget{
      const MyApp({Key? key}) :super(key: key);

      @override
    Widget build(BuildContext context) {
        return MaterialApp(
          title:'FynAuraBot',
          theme: ThemeData(
            brightness: Brightness.dark
          ),

        );

      }


  }




