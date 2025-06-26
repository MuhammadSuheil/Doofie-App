import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_item_model.dart';
import '../services/notification_service.dart';

class FoodController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _getPrivateFoodCollection() {
    if (_userId == null) {
      throw Exception("User is not logged in, cannot access the fridge.");
    }
    return _firestore.collection('users').doc(_userId).collection('foodItems');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFoodStream() {
    if (_userId == null) {
      return Stream.value(Future.value(null) as QuerySnapshot<Map<String, dynamic>>);
    }
    return _getPrivateFoodCollection().snapshots();
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

      DocumentReference newDocument = await _getPrivateFoodCollection().add(foodData);
      
      final int notificationId = newDocument.id.hashCode;
      await newDocument.update({'notificationId': notificationId});
      
      final notificationDate = expiryDate.subtract(const Duration(days: 1)).copyWith(hour: 8, minute: 0, second: 0);

      if (notificationDate.isAfter(DateTime.now())) {
        await NotificationService().scheduleNotification(
          id: notificationId,
          title: 'Dont let it go to waste!',
          body: 'Food "$name" is going to expire soon. Lets go make something from this!',
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
      try {
        final newExpiryDate = _calculateExpiryDate(type);
        final Map<String, dynamic> dataToUpdate = {
          'name': name,
          'type': type.name,
          'imageUrl': imageUrl,
          'expiryDate': Timestamp.fromDate(newExpiryDate),
        };
        await _getPrivateFoodCollection().doc(id).update(dataToUpdate);
      } catch (e) {
        print("Error updating food: $e");
      }
  }
  
  Future<void> deleteFood(String id, int? notificationId) async {
    try {
      if (notificationId != null) {
        await NotificationService().cancelNotification(notificationId);
      }
      await _getPrivateFoodCollection().doc(id).delete();
    } catch (e) {
      print("Error deleting food: $e");
    }
  }
}