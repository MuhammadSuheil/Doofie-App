import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/food_item_model.dart';
import 'dart:math';

class FoodController {
  final CollectionReference _foodCollection =
    FirebaseFirestore.instance.collection('foodItems');
  
  Stream<QuerySnapshot<Map<String, dynamic>>> getFoodStream() {
    return _foodCollection.snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;

  }
  DateTime _calculateExpiryDate(FoodType type) {
    int averageDays = 7; // Default
    switch (type) {
      case FoodType.veggies:
        averageDays = 7;
        break;
      case FoodType.fruit:
        averageDays = 5;
        break;
      case FoodType.meat:
        averageDays = 3;
        break;
    }
    return DateTime.now().add(Duration(days: averageDays));
  }

  Future<void> addFood({
    required String name,
    required FoodType type,
    required String imagePath,
  }) async {
    try{
      final expiryDate = _calculateExpiryDate(type);
      final tempItem = FoodItem(id: '', name: name, imagePath: imagePath, type: type, expiryDate: expiryDate);

      await _foodCollection.add(tempItem.toMap());
    }
    catch(e){
      print("Error adding food: $e");
    }
  }
  Future<void> updateFood({
    required String id,
    required String name,
    required FoodType type,
    required String imagePath,
  }) async {
      try{
        final newExpiryDate = _calculateExpiryDate(type);

        final Map<String, dynamic> dataToUpdate = {
          'name': name,
          'type': type.name,
          'imagePath': imagePath,
          'expiryDate': Timestamp.fromDate(newExpiryDate),
        };
        
        await _foodCollection.doc(id).update(dataToUpdate);
      
      } catch(e){
          print("Error updating food: $e");
      }
  }

  Future<void> deleteFood(String id) async{
    try {
      await _foodCollection.doc(id).delete();
    } catch (e){
        print("Error deleting food");
    }
  }
}