import 'package:ai_bot/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'Pages/Homepage.dart';
import 'Pages/login_page.dart';

void main() async {
  await setUp();
  await setUpGetIt();
  Gemini.init(apiKey: 'AIzaSyDjbeC4_9HFkOLcHvmBloYxCtaFqqhNlGQ');
  runApp(const MyApp());
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpFirebase();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Allen',
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true).copyWith(
              scaffoldBackgroundColor: const Color.fromARGB(91, 107, 108, 109),
              textTheme: GoogleFonts.montserratTextTheme())
          : ThemeData.light(
              useMaterial3: true,
            ).copyWith(textTheme: GoogleFonts.montserratTextTheme()),
      home: LoginPage(),
      // Homepage(onThemeToggle: () {
      // setState(() {
      //   isDarkMode = !isDarkMode;
      // });

      //  }, isDarkMode : isDarkMode )
    );
  }
}
