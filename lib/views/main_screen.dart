import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'recipe_screen.dart';

class MainScreen extends StatefulWidget{
  const MainScreen ({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState(); 
} 

class _MainScreenState extends State<MainScreen>{
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    const RecipeScreen(),
    HomeScreen(),        
    const ProfileScreen(),
  ];
  
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), 
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