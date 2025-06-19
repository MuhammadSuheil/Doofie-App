import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/food_controller.dart';
import '../models/food_item_model.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>{
  final FoodController _controller = FoodController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  String _itemName = '';
  FoodType? _selectedType;
  bool _isLoading = false;
  
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _saveFood() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan ambil gambar makanan terlebih dahulu!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    String imageUrl = await _controller.uploadImage(_selectedImage!);

    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal meng-upload gambar. Coba lagi.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    _formKey.currentState!.save(); 
    await _controller.addFood(
      name: _itemName,
      type: _selectedType!,
      imageUrl: imageUrl,
    );

    setState(() => _isLoading = false);
    

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Makanan berhasil ditambahkan!')),
      );
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add food'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity),
                    )
                    : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to take photo')
                      ],
                    ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Makanan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_important_outline),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Food Name cannot be empty' : null,
                onSaved: (value) => _itemName = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<FoodType>(
                decoration: const InputDecoration(
                  labelText: 'Tipe Makanan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                value: _selectedType,
                items: FoodType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          // Mengubah 'veggies' menjadi 'Veggies'
                          child: Text(type.name[0].toUpperCase() + type.name.substring(1)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value),
                validator: (value) => value == null ? 'Silakan pilih tipe makanan' : null,
              ),
              const SizedBox(height: 40),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.kitchen_outlined),
                      onPressed: _saveFood,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      label: const Text('Simpan ke Kulkas'),
                    ),
            ],
          )),
      ),
    );
  }
}