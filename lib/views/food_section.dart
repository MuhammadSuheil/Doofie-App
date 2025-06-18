import 'package:flutter/material.dart';
import '../models/food_item_model.dart'; 
import 'food_card.dart';

class FoodSection extends StatelessWidget{
  final String title;
  final List<FoodItem> items;
  final Color color;

  const FoodSection({
    super.key,
    required this.title,
    required this.items,
    required this.color,
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
              return FoodCard(
                item: items[index],
                borderColor: color.withOpacity(0.5));
            },
          ),
        )
      ],
    );
  }
}