import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';
import '../../controller/recipe_controller.dart';
import '../../models/recipe_model.dart';
import '../../models/user_model.dart';
import 'auth/auth_wrapper.dart';
import 'recipe_detail_screen.dart'; // Untuk navigasi saat grid di-tap

class ProfileScreen extends StatefulWidget {
  // Terima controller resep
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
                // TODO: Navigasi ke halaman Edit Profil
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
            // --- PERBAIKAN UTAMA ADA PADA STRUKTUR LOGIKA INI ---

            // 1. Saat data sedang dimuat
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Jika terjadi error atau tidak ada data (termasuk null)
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

            // 3. Jika semua aman, baru kita akses datanya.
            // Tidak perlu tanda '!' karena sudah di-handle oleh if di atas.
            final user = userSnapshot.data!;

            // Tampilkan UI utama setelah data berhasil didapatkan
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Header Profil Kustom ---
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
                        // --- Bio Pengguna ---
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
                        // --- Judul "Saved Recipes" ---
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
              // --- Grid Resep yang Disimpan ---
              body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: widget.controller.getSavedRecipesStream(),
                builder: (context, recipeSnapshot) {
                  if (recipeSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (recipeSnapshot.hasError) {
                    return Center(
                      child: Text("Gagal memuat resep: ${recipeSnapshot.error}"),
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
                      // Rasio 1:1 (persegi) untuk gambar
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
      // Gunakan Column untuk menata gambar di atas dan teks di bawah
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gambar menempati sisa ruang
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
          // Beri jarak antara gambar dan teks
          const SizedBox(height: 8),
          // Teks nama resep
          Text(
            recipe.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center, // Teks di tengah
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
