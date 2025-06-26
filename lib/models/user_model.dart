import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String bio;
  final Timestamp createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}