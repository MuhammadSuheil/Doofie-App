import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/views/home_screen.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'URL_PROYEK_SUPABASE_ANDA',    
    anonKey: 'ANON_KEY_PROYEK_ANDA', 
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