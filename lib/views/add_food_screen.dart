import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/food_controller.dart';
import '../models/food_item_model.dart';

class AddFoodScreen extends StatefulWidget {
  final FoodItem? foodItem;

  const AddFoodScreen({
    super.key,
    this.foodItem});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>{
  final FoodController _controller = FoodController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  File? _selectedImage;
  // String _itemName = '';
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

    String imageUrl;

    if (_selectedImage != null) {
      imageUrl = await _controller.uploadImage(_selectedImage!);
      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal meng-upload gambar. Coba lagi.')),
        );
        setState(() => _isLoading = false);
        return;
    }
    } else {
   
      imageUrl = widget.foodItem?.imageUrl ?? ''; 
    }

    if (imageUrl.isEmpty) {
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih gambar makanan.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    if (widget.foodItem == null) {
      await _controller.addFood(
        name: _nameController.text,
        type: _selectedType!,
        imageUrl: imageUrl,
      );
    } else {
      await _controller.updateFood(
        id: widget.foodItem!.id, 
        name: _nameController.text,
        type: _selectedType!,
        imageUrl: imageUrl,
      );
    }

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Makanan berhasil disimpan!')),
      );
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.foodItem == null ? 'Add Food' : 'Edit Food'),
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
                    ? Image.file(_selectedImage!, fit: BoxFit.cover) 
                    : (widget.foodItem?.imageUrl ?? '').isNotEmpty
                        ? Image.network(widget.foodItem!.imageUrl, fit: BoxFit.cover)
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
              SizedBox(height: 40,),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Makanan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_important_outline),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Food Name cannot be empty' : null,
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
                      icon: const Icon(Icons.kitchen_outlined, color: Colors.white),
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