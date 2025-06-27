import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';
import '../controller/recipe_controller.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final RecipeController controller;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.controller});

  @override
  Widget build(BuildContext context) {
    void openDetailPage() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(recipe: recipe, controller: controller,),
        ),
      );
    }
    // TODO: implement build
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      clipBehavior: Clip.antiAlias, //imageClip
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: openDetailPage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              recipe.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Icon(Icons.restaurant_menu, color: Colors.grey, size: 50),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    recipe.description,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton( 
                       onPressed: openDetailPage,
                       style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 30),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),
                       child: const Text('See Recipe'),
                       )
                    ],
                  ),
                  Row(
                    children: [
                      StreamBuilder<bool>(
                        stream: controller.isRecipeSavedStream(recipe.id),
                        builder: (context, snapshot){
                          final bool isSaved = snapshot.data ?? false;

                          return IconButton(
                                onPressed: () async {
                                  if (isSaved) {
                                    await controller.unsaveRecipe(recipe.id);
                                  } else {
                                    await controller.saveRecipe(recipe.id);
                                    if (context.mounted) {
                                      showSaveSuccessDialog(context);
                                    }
                                  }
                                },
                                icon: Icon(
                                  isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
                                  color: isSaved ? Colors.green : Colors.grey,
                                ),
                                tooltip: isSaved ? 'Unsave Recipe' : 'Save Recipe',
                              );
                        }),
                      IconButton(
                        onPressed: (){

                        },
                        icon: const Icon(Icons.send_outlined, color:  Colors.grey,),
                        tooltip: 'Share Recipe',
                      ),
                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),

    );
  }

  void showSaveSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Image.asset('assets/images/check.png', height: 100),
                  const SizedBox(height: 24),
                  const Text(
                    'Recipe is Saved!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Don't forget to check it out!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}