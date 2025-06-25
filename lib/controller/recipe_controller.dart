import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fungsi untuk mendapatkan stream data resep secara real-time
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecipesStream() {
    return _db.collection('recipes').snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }
}