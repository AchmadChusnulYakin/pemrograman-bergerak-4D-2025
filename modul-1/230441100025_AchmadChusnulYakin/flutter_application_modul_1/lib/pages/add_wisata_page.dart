import 'package:flutter/material.dart';

class AddWisataPage extends StatefulWidget {
  @override
  State<AddWisataPage> createState() => _AddWisataPageState();
}

class _AddWisataPageState extends State<AddWisataPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk input
  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String? _jenisWisata;

  // Daftar pilihan jenis wisata
  final List<String> _jenisOptions = [
    'Wisata Alam',
    'Wisata Edukasi',
    'Wisata Budaya',
    'Wisata Kuliner',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _namaController.clear();
    _lokasiController.clear();
    _hargaController.clear();
    _deskripsiController.clear();
    setState(() {
      _jenisWisata = null;
    });
  }

  void _simpanWisata() {
    if (_formKey.currentState!.validate()) {
      // Di sinilah data bisa disimpan ke backend atau dikirim ke HomePage
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Data wisata berhasil disimpan!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke HomePage
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Wisata'),
        leading: const BackButton(),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar dummy
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: const Text('Upload Image'),
              ),
              const SizedBox(height: 16),

              // Input Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Wisata',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              // Input Lokasi
              TextFormField(
                controller: _lokasiController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi Wisata',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Lokasi wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              // Dropdown Jenis
              DropdownButtonFormField<String>(
                value: _jenisWisata,
                items: _jenisOptions
                    .map((jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _jenisWisata = value);
                },
                decoration: const InputDecoration(
                  labelText: 'Jenis Wisata',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Jenis wisata harus dipilih' : null,
              ),
              const SizedBox(height: 12),

              // Input Harga
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Tiket',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Harga wajib diisi';
                  if (int.tryParse(value) == null) return 'Harga harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input Deskripsi
              TextFormField(
                controller: _deskripsiController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 20),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanWisata,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Simpan'),
                ),
              ),

              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: _resetForm,
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
