import 'package:flutter/material.dart';
import '../models/food_item_model.dart'; 
import '../controller/food_controller.dart';
import 'food_card.dart';

class FoodSection extends StatelessWidget{
  final String title;
  final List<FoodItem> items;
  final Color color;
  final FoodController controller;

  const FoodSection({
    super.key,
    required this.title,
    required this.items,
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const Spacer(),
            TextButton(
              onPressed: (){
                //TODO
              }, 
              child: Text('See more', style: TextStyle(color: Colors.grey.shade600),)
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index){
              final item = items[index];
              return FoodCard(
                item: items[index],
                cardColor: color,
                onLongPress: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext){
                      return AlertDialog(
                        title: const Text('Food Option'),
                        content: Text('What do you want to do on "${item.name}"?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Edit'),
                            onPressed: (){
                               Navigator.of(dialogContext).pop();
                               print('TODO: Navigasi ke halaman Edit');
                            } ),
                          TextButton(
                             child: const Text('Cancel'),
                              onPressed: (){
                                Navigator.of(dialogContext).pop();
                              },
                          ),
                          TextButton(
                           child: const Text('Delete'),
                           style: TextButton.styleFrom(foregroundColor: Colors.red.shade900),
                           onPressed: (){
                            controller.deleteFood(item.id);
                            Navigator.of(dialogContext).pop();
                           },
                           )
                        ],
                      );
                    });
                }
                );
            },
          ),
        )
      ],
    );
  }
}