import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk mendapatkan stream data resep secara real-time
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecipesStream() {
    return _db.collection('recipes').snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  String? get _userId => _auth.currentUser?.uid;

  Future<void> saveRecipe(String recipeId) async {
    if (_userId == null) return;
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('savedRecipes')
          .doc(recipeId) 
          .set({'savedAt': Timestamp.now()}); 
    } catch (e) {
      print('Error saving recipe: $e');
    }
  }

  Future<void> unsaveRecipe(String recipeId) async {
    if (_userId == null) return;
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('savedRecipes')
          .doc(recipeId)
          .delete();
    } catch (e) {
      print('Error unsaving recipe: $e');
    }
  }

  Stream<bool> isRecipeSavedStream(String recipeId) {
    if (_userId == null) return Stream.value(false);
    return _db
        .collection('users')
        .doc(_userId)
        .collection('savedRecipes')
        .doc(recipeId)
        .snapshots()
        .map((snapshot) => snapshot.exists); 
  }

  Future<bool> isRecipeSaved(String recipeId) async {
  if (_userId == null) return false;
  final doc = await _db
      .collection('users')
      .doc(_userId)
      .collection('savedRecipes')
      .doc(recipeId)
      .get();
  return doc.exists;
}

  Stream<QuerySnapshot<Map<String, dynamic>>> getSavedRecipesStream() {
     if (_userId == null) return Stream.empty();
     return _db
        .collection('users')
        .doc(_userId)
        .collection('savedRecipes')
        .snapshots()
        .asyncMap((snapshot) async {
          final recipeIds = snapshot.docs.map((doc) => doc.id).toList();
          if (recipeIds.isEmpty) {
            return _db.collection('recipes').where(FieldPath.documentId, whereIn: ['']).get();
          }
          return _db.collection('recipes').where(FieldPath.documentId, whereIn: recipeIds).get();
        });
  }
}