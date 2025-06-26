import 'package:flutter/material.dart';
import '../models/recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
    final Recipe recipe;

    const RecipeDetailScreen({
        super.key,
        required this.recipe
    });

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Recipe Details', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                centerTitle: true, 
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Image.network(
                            recipe.imageUrl,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, StackTrace){
                                return SizedBox(
                                    height: 220,
                                    width: double.infinity,
                                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey,),
                                );
                            },
                        ),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                    )
                                ]
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        recipe.name.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.green,
                                        ),
                                    ),
                                    const SizedBox(height: 4,),
                                    Text(
                                        recipe.description,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                        ),
                                    ),
                                    const SizedBox(height: 16,),
                                    Text(
                                        'Ingredients',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: recipe.ingredients.map((ingredient) {
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Row(
                                            children: [
                                                const Icon(Icons.fiber_manual_record, size: 8, color: Colors.black87),
                                                const SizedBox(width: 8.0),
                                                Text(ingredient),
                                            ],
                                            ),
                                        );
                                        }).toList(),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                        'How to make:',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: recipe.steps.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        String step = entry.value;
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                CircleAvatar(
                                                backgroundColor: Colors.green,
                                                radius: 12,
                                                child: Text(
                                                    '${index + 1}',
                                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                                ),
                                                ),
                                                const SizedBox(width: 12.0),
                                                Expanded(child: Text(step)),
                                            ],
                                            ),
                                        );
                                    }).toList(),
                                ),
                                const SizedBox( height: 80,)
                                ],
                            ),
                        )
                    ],
                ),
            ),
            bottomSheet: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: (){
                            //TODO saveresep :D
                        },
                        child: const Text(
                            'Save Recipe',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                            ),
                        ),
                        ),
                ),
            ),
        );
    }
    }
