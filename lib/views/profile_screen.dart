import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';
import '../../controller/recipe_controller.dart';
import '../../models/recipe_model.dart';
import '../../models/user_model.dart';
import 'auth/auth_wrapper.dart';
import 'recipe_detail_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  final RecipeController controller;
  const ProfileScreen({super.key, required this.controller});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = AuthController();
  late final Future<UserModel?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _authController.getCurrentUserData();
  }

  void _logout() async {
    final bool success = await _authController.logout();
    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
        (route) => false,
      );
    }
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Profil'),
              onTap: () {
                Navigator.pop(context);
                print('Navigasi ke Edit Profil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: _userDataFuture,
          builder: (context, userSnapshot) {

            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userSnapshot.hasError || !userSnapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Gagal memuat data profil.'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: _logout,
                          child: const Text('Coba Login Ulang'))
                    ],
                  ),
                ),
              );
            }

            final user = userSnapshot.data!;

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person,
                                    size: 50, color: Colors.white),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.email,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _showProfileMenu,
                                icon: const Icon(Icons.menu),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            user.bio.isNotEmpty
                                ? user.bio
                                : "Pengguna belum menambahkan bio.",
                            style:
                                const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Saved Recipes',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: widget.controller.getSavedRecipesStream(),
                builder: (context, recipeSnapshot) {
                  if (recipeSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (recipeSnapshot.hasError) {
                    return Center(
                      child: 
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/pana.png', height: 120,),
                          const SizedBox(height: 12,),
                          Text("Go save some recipe" ,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("your saved recipe will be displayed here")
                        ],
                      ),
                      
                      
                    );
                  }

                  if (!recipeSnapshot.hasData ||
                      recipeSnapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Anda belum menyimpan resep apapun.'),
                    );
                  }

                  final savedRecipes = recipeSnapshot.data!.docs
                      .map((doc) => Recipe.fromFirestore(doc))
                      .toList();

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0, 
                    ),
                    itemCount: savedRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = savedRecipes[index];
                      return SavedRecipeTile(
                        recipe: recipe,
                        controller: widget.controller,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}


class SavedRecipeTile extends StatelessWidget {
  const SavedRecipeTile({
    super.key,
    required this.recipe,
    required this.controller,
  });

  final Recipe recipe;
  final RecipeController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              controller: controller,
              recipe: recipe),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Hapus Resep'),
              content: Text('Anda yakin ingin menghapus "${recipe.name}" dari daftar simpanan?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal'),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    controller.unsaveRecipe(recipe.id);
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
        );
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center, 
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
