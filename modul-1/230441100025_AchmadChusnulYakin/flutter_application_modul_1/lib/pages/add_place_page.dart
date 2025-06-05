import 'package:flutter/material.dart';
import '../models/place_model.dart';

class AddPlacePage extends StatefulWidget {
  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newPlace = PlaceModel(
        imagePath: _imagePathController.text.trim(),
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        type: _typeController.text.trim(),
        price: _priceController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      Navigator.pop(context, newPlace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Wisata')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Nama Wisata'),
              _buildTextField(_locationController, 'Lokasi'),
              _buildTextField(_typeController, 'Jenis'),
              _buildTextField(_priceController, 'Harga (contoh: 25000)', keyboardType: TextInputType.number),
              _buildTextField(_imagePathController, 'Path Gambar (contoh: assets/National_Park_Yosemite.jpg)'),
              _buildTextField(_descriptionController, 'Deskripsi', maxLines: 4),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Field tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}
