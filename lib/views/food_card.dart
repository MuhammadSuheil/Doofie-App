import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../models/food_item_model.dart';

class FoodCard extends StatelessWidget{
  final FoodItem item;
  final Color borderColor;

  const FoodCard({
    super.key,
    required this.item,
    required this.borderColor,
  });
  
  @override
  Widget build(BuildContext context) {
    //containercard
    return Container(
      width: 150,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3)
          )
        ]
      ),
      //image
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0), 
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
                        fontWeight: FontWeight.bold, fontSize: 16
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      'Exp Date: ${DateFormat('dd - MM - yy').format(item.expiryDate)}',
                      style: TextStyle(
                        color: Colors.grey.shade700, fontSize: 12),
                    )
                  ],
                ),))
        ],
      ),
    );
    
  }
}