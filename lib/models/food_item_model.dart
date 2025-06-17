import 'package:cloud_firestore/cloud_firestore.dart';

enum FoodType { veggies, fruit, meat }

class FoodItem {
  final String id;
  final String name;
  final String imagePath;
  final FoodType type;
  final DateTime expiryDate;

  FoodItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.type,
    required this.expiryDate,
  });

  factory FoodItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final data = snapshot.data()!;
    return FoodItem(
      id: snapshot.id,
      name: data['name'],
      imagePath: data['imagePath'],
      type: FoodType.values.firstWhere((e) => e.name == data['type']),
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
    );  
  }

  Map<String, dynamic> toMap() {
    return{
      'name': name,
      'imagePath': imagePath,
      'type': type.name,
      'expiryDate': Timestamp.fromDate(expiryDate),
    };
  }
}