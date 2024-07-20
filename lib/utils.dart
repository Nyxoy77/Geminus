import 'package:ai_bot/Services/auth_services.dart';
import 'package:ai_bot/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

Future<void> setUpFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> setUpGetIt() async {
  final GetIt _getIt = GetIt.instance;
  _getIt.registerSingleton<AuthServices>(AuthServices());
}
