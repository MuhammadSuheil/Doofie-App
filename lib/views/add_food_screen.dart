import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/food_controller.dart';
import '../models/food_item_model.dart';

class AddFoodScreen extends StatefulWidget {
  final FoodItem? foodItem;
  final FoodController controller;

  const AddFoodScreen({
    super.key,
    this.foodItem,
    required this.controller});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  File? _selectedImage;
  FoodType? _selectedType;
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    
    if (widget.foodItem != null){
      _nameController.text = widget.foodItem!.name;
      _selectedType = widget.foodItem!.type;
    }
  }   

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isLoading) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  //DEBUGG
  Future<void> _saveFood() async {
  if (_isLoading) {
    return;
  }

  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() => _isLoading = true);

  String imageUrl;
  if (_selectedImage != null) {
    imageUrl = await widget.controller.uploadImage(_selectedImage!);
  } else {
    imageUrl = widget.foodItem?.imageUrl ?? '';
  }

  if (imageUrl.isEmpty) {
    if (mounted) setState(() => _isLoading = false);
    return;
  }

  final String name = _nameController.text;
  final FoodType? type = _selectedType;

  if (widget.foodItem == null) {
    await widget.controller.addFood(
      name: name,
      type: type!,
      imageUrl: imageUrl,
    );
  } else {
    await widget.controller.updateFood(
      id: widget.foodItem!.id,
      name: name,
      type: type!,
      imageUrl: imageUrl,
    );
  }

  if (mounted) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Makanan berhasil disimpan!')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.foodItem == null ? 'Add Food' : 'Edit Food',),
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
                      ? Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity) 
                      : (widget.foodItem?.imageUrl ?? '').isNotEmpty
                          ? Image.network(widget.foodItem!.imageUrl, fit: BoxFit.cover, width: double.infinity)
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
              const SizedBox(height: 40),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Makanan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_important_outline),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
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
                      icon: const Icon(Icons.kitchen_outlined, color: Colors.white,),
                      onPressed: _saveFood,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      label: const Text('Simpan ke Kulkas'),
                    ),
            ],
          )),
      ),
    );
  }
}