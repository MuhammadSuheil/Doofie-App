import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '/views/home_screen.dart'; // 1. TAMBAHKAN IMPORT INI (sesuaikan path jika perlu)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Opsional: untuk menghilangkan banner debug
      title: 'Food Reminder',
      // 2. UBAH BAGIAN 'home' DI BAWAH INI
      home: HomeScreen(), 
    );
  }
}