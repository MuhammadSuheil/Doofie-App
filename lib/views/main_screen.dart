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
    throw UnimplementedError();
  }
}