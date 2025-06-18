import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/food_controller.dart';
import '../models/food_item_model.dart';

class HomeScreen extends StatelessWidget{
  HomeScreen({super.key});

  final FoodController _controller = FoodController();

  final Map<FoodType, Color> _foodtypeColor ={
    FoodType.veggies: Colors.green.shade600,
    FoodType.meat: Colors.red.shade400,
    FoodType.fruit: Colors.amberAccent,
  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return Scaffold(
        appBar: AppBar(title: const Text("Fridge")),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _controller.getFoodStream(), 
          builder: (context, snapshot){
            //handle waiting
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            //handle error
            if (snapshot.hasError){
              return Center(child: Text("There was an error: ${snapshot.error}"),);
            }
            //handle data error
            if (!snapshot.hasData || snapshot.data! .docs.isEmpty){
              return const Center(child: Text("There was a data error"),);
            }
            //handle data to list
            final foodDocs = snapshot.data!.docs;
            final List<FoodItem> allItems = foodDocs.map((doc) => FoodItem.fromFirestore(doc)).toList();

            return ListView(
              children: [
                
              ],
            );
          }),
      );
  }
}