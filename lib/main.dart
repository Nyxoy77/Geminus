import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'Pages/Homepage.dart';

void main() {
  Gemini.init(apiKey: 'AIzaSyDjbeC4_9HFkOLcHvmBloYxCtaFqqhNlGQ');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Allen',
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true).copyWith(
            scaffoldBackgroundColor:const Color.fromARGB(91, 107, 108, 109))
          : ThemeData.light(useMaterial3: true),
      home: Homepage(onThemeToggle: () { 
      setState(() {
        isDarkMode = !isDarkMode;
      }); 
       
       }, isDarkMode : isDarkMode )
    );
  }
}
