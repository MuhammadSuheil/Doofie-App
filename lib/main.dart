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
    url: 'https://tyixpruccfjrcaibrhtn.supabase.co',    
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5aXhwcnVjY2ZqcmNhaWJyaHRuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzMzE0OTIsImV4cCI6MjA2NTkwNzQ5Mn0.fSPAeR143HUKsx03L5JETlNRvyuadMfkFH3Ricayjoo', 
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