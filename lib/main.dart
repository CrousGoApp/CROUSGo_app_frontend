import 'package:crousgo/Pages/page_auth.dart';
import 'package:flutter/material.dart';
import 'pages/page_accueil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrousGO',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: PageAuth(),
    );
  }
}

