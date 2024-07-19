import 'package:lib/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> setUpFirebase() async{
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
  );
}