import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Profile', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),),
        ),
      ),
      body: const Center(
        child: Text(
          'Halaman profil pengguna akan ada di sini!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}