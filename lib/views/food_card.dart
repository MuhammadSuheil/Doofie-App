import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../models/food_item_model.dart';

class FoodCard extends StatelessWidget{
  final FoodItem item;
  final Color cardColor;
  final VoidCallback onLongPress;

  const FoodCard({
    super.key,
    required this.item,
    required this.cardColor,
    required this.onLongPress,
  });
  
  @override
  Widget build(BuildContext context) {
    //containercard
    return InkWell(
      onLongPress: onLongPress, 
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: 160,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cardColor, width: 5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // Warna bayangan
              spreadRadius: 1, // Seberapa menyebar
              blurRadius: 2,   // Seberapa kabur
              offset: Offset(0, 6), // Posisi bayangan (x, y)
            ),
          ],
        ),
        //image
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0), 
                ),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,

                  //==HANDLING==
                  errorBuilder: (context, error, StackTrace){
                    return Icon(Icons.fastfood, color: Colors.grey.shade400, size: 50);
                  },
                  loadingBuilder: (context, child, loadingProgress){
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator(strokeWidth: 2),);
                  },
                ),
              ) ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 16,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        'Exp Date: ${DateFormat('dd - MM - yy').format(item.expiryDate)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 12),
                      )
                    ],
                  ),))
          ],
        ),
        )
      );
      
  }
}