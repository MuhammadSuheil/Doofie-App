import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'recipe_screen.dart';
import '../controller/food_controller.dart'; 

class MainScreen extends StatefulWidget{
  const MainScreen ({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState(); 
} 

class _MainScreenState extends State<MainScreen>{
  int _selectedIndex = 1;

  // 2. BUAT CONTROLLER DI SINI, HANYA SATU KALI SAAT STATE DIBUAT
  final FoodController _foodController = FoodController();


  // 3. UBAH LIST HALAMAN AGAR MENERIMA CONTROLLER
  // late final List<Widget> _widgetOptions;

  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const RecipeScreen(),
      // Oper instance controller yang sama ke HomeScreen
      HomeScreen(controller: _foodController), 
      const ProfileScreen(),
    ];
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex), 
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen_outlined),
            activeIcon: Icon(Icons.kitchen),
            label: 'Fridge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,  
      onTap: _onItemTapped,
      ),
    );
  }
}