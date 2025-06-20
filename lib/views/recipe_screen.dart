import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget{
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kumpulan Resep'),
      ),
      body: const Center(
        child: Text(
          'Halaman untuk menampilkan resep akan ada di sini!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}