import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/food_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';
import 'dart:io';
import '../services/notification_service.dart';

class FoodController {
  final CollectionReference _foodCollection =
    FirebaseFirestore.instance.collection('foodItems');
  
  final SupabaseClient _supabase = Supabase.instance.client;
  
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
    required String imageUrl,
  }) async {
  try {
      final expiryDate = _calculateExpiryDate(type);

      final foodData = {
        'name': name,
        'imageUrl': imageUrl,
        'type': type.name,
        'expiryDate': Timestamp.fromDate(expiryDate),
      };
      DocumentReference newDocument = await _foodCollection.add(foodData);

      final int notificationId = newDocument.id.hashCode;

      await newDocument.update({'notificationId': notificationId});
      
      // final notificationDate = expiryDate.subtract(const Duration(days: 1)).copyWith(hour: 8, minute: 0, second: 0);
      final notificationDate = DateTime.now().add(const Duration(seconds: 15));

      if (notificationDate.isAfter(DateTime.now())) {
        await NotificationService().scheduleNotification(
          id: notificationId,
          title: 'Dont let it go to waste!',
          body: 'Food "$name" is going to expire soon. Come and make something with it!',
          scheduledDate: notificationDate,
        );
      }
    } catch (e) {
      print("Error adding food: $e");
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try{
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      await _supabase.storage.from('food-images').upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      final String publicUrl = _supabase.storage.from('food-images').getPublicUrl(fileName);
      
      return publicUrl;
    } catch (e) {
      print("Error Uploading Image $e");
      return "";
    }
  }

  Future<void> updateFood({
    required String id,
    required String name,
    required FoodType type,
    required String imageUrl,
  }) async {
      try{
        final newExpiryDate = _calculateExpiryDate(type);

        final Map<String, dynamic> dataToUpdate = {
          'name': name,
          'type': type.name,
          'imageUrl': imageUrl,
          'expiryDate': Timestamp.fromDate(newExpiryDate),
        };
        
        await _foodCollection.doc(id).update(dataToUpdate);
      
      } catch(e){
          print("Error updating food: $e");
      }
  }
  
  Future<void> deleteFood(String id, int? notificationId) async{
    try {
      await _foodCollection.doc(id).delete();

      if (notificationId != null) {
        await NotificationService().cancelNotification(notificationId);
      }

    } catch (e){
        print("Error deleting food");
    }
  }
}