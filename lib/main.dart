import 'package:ai_bot/Services/auth_services.dart';
import 'package:ai_bot/Services/navigation_services.dart';
import 'package:ai_bot/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'Pages/Homepage.dart';

void main() async {
  await setUp();
  // Gemini.init(apiKey: 'AIzaSyDjbeC4_9HFkOLcHvmBloYxCtaFqqhNlGQ');
  runApp(MyApp());
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpFirebase();
   await setUpGetIt();
  Gemini.init(apiKey: 'AIzaSyDjbeC4_9HFkOLcHvmBloYxCtaFqqhNlGQ');
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late final AuthServices _authServices;
  late final NavigationService _navigationServices;

  MyApp({super.key}) {
    _authServices = _getIt.get<AuthServices>();
    _navigationServices = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationServices.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Allen',
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(textTheme: GoogleFonts.montserratTextTheme()),
      initialRoute: _authServices.user!=null ? '/home':'/login',
      routes: _navigationServices.routes!,
     
    );
  }
}
