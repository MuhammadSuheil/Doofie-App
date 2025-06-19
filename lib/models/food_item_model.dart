import 'package:cloud_firestore/cloud_firestore.dart';

enum FoodType { veggies, fruit, meat }

class FoodItem {
  final String id;
  final String name;
  final String imageUrl;
  final FoodType type;
  final DateTime expiryDate;

  FoodItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.expiryDate,
  });

  factory FoodItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final data = snapshot.data()!;
    return FoodItem(
      id: snapshot.id,
      name: data['name'],
      imageUrl: data['imagePath'],
      type: FoodType.values.firstWhere((e) => e.name == data['type']),
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
    );  
  }

  Map<String, dynamic> toMap() {
    return{
      'name': name,
      'imagePath': imageUrl,
      'type': type.name,
      'expiryDate': Timestamp.fromDate(expiryDate),
    };
  }
}