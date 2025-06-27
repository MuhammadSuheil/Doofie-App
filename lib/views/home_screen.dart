import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/food_controller.dart'; 
import '../models/food_item_model.dart';   
import 'food_section.dart';                 
import 'add_food_screen.dart';

class HomeScreen extends StatelessWidget {
  final FoodController controller;

  HomeScreen({super.key, required this.controller});

  final Map<FoodType, Color> _foodtypeColor = {
    FoodType.veggies: Colors.green.shade600,
    FoodType.meat: const Color.fromARGB(255, 203, 21, 18),
    FoodType.fruit: Colors.amberAccent,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Center(
          child: Text('Fridge', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.getFoodStream(),
        builder: (context, snapshot) {
          //handle waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          //handle error
          if (snapshot.hasError) {
            return Center(child: Text("There was an error: ${snapshot.error}"));
          }
          //handle data error
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/pana.png', height: 120,),
                    const SizedBox(height: 12,),
                    const Text("There's nothing in the fridge right now",
                    style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("press (+) down below to add food to the fridge")
                    
                  ],
                ),
                );
          }
          //handle data to list
          final foodDocs = snapshot.data!.docs;
          final List<FoodItem> allItems =
              foodDocs.map((doc) => FoodItem.fromFirestore(doc)).toList();

          //handle grouping
          final Map<FoodType, List<FoodItem>> groupedItems = {};
          for (var item in allItems) {
            if (groupedItems[item.type] == null) {
              groupedItems[item.type] = [];
            }
            groupedItems[item.type]!.add(item);
          }

          final sortedKeys = groupedItems.keys.toList()
            ..sort((a, b) => a.index.compareTo(b.index));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              final type = sortedKeys[index];
              final items = groupedItems[type]!;
              final color = _foodtypeColor[type] ?? Colors.grey;
              final title =
                  type.name[0].toUpperCase() + type.name.substring(1);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FoodSection(
                    title: title,
                    items: items,
                    color: color,
                    controller: controller,
                  ),
                  if (index < sortedKeys.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0), 
                      child: Divider(
                        color: const Color.fromARGB(255, 164, 164, 164), 
                        thickness: 1.0, 
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
  
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFoodScreen(controller: controller,)));
        },
        tooltip: 'Add Food',
        shape: const CircleBorder(),
        backgroundColor: Colors.green, 
        foregroundColor: Colors.white,
        elevation: 0.0,
        highlightElevation: 0.0,
        child: const Text(
          '+',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}