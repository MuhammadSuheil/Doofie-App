import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';
import '../../models/user_model.dart';
import 'auth/auth_wrapper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
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
            
            final user = snapshot.data!;

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    user.bio.isNotEmpty ? user.bio : "Pengguna belum menambahkan bio.",
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
                
                const SizedBox(height: 24),
                const Divider(height: 1),

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Saved Recipes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  // TODO: Ganti placeholder ini dengan GridView.builder yang menampilkan resep asli
                  child: Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: const Text('Fitur resep tersimpan akan segera hadir!'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
