import 'package:flutter/material.dart';
import '../models/tiket.dart';
import '../services/tiket_service.dart';

class FormScreen extends StatefulWidget {
  final Tiket? tiket;
  const FormScreen({Key? key, this.tiket}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TiketService _service = TiketService();

  late TextEditingController _namaController;
  late TextEditingController _gunungController;
  late TextEditingController _tanggalController;
  late TextEditingController _jumlahController;
  String _statusPembayaran = 'lunas';
  DateTime? _tanggalDipilih;

  @override
  void initState() {
    super.initState();
    final tiket = widget.tiket;
    _namaController = TextEditingController(text: tiket?.namaPendaki ?? '');
    _gunungController = TextEditingController(text: tiket?.gunung ?? '');
    _tanggalController = TextEditingController(
        text: tiket != null ? tiket.tanggalPendakian.toIso8601String().split('T')[0] : '');
    _jumlahController = TextEditingController(
        text: tiket != null ? tiket.jumlahTiket.toString() : '');
    _statusPembayaran = tiket?.statusPembayaran ?? 'lunas';
    _tanggalDipilih = tiket?.tanggalPendakian;
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate() || _tanggalDipilih == null) return;

    final newTiket = Tiket(
      id: widget.tiket?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      namaPendaki: _namaController.text,
      gunung: _gunungController.text,
      tanggalPendakian: _tanggalDipilih!.toUtc(),
      jumlahTiket: int.parse(_jumlahController.text),
      statusPembayaran: _statusPembayaran,
    );

    try {
      if (widget.tiket == null) {
        await _service.addTiket(newTiket);
      } else {
        await _service.updateTiket(widget.tiket!.id, newTiket);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalDipilih ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _tanggalDipilih = picked;
        _tanggalController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _gunungController.dispose();
    _tanggalController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.tiket != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Tiket" : "Tambah Tiket"),
        backgroundColor: const Color(0xFF0A3D62),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInput("Nama Pendaki", _namaController),
              _buildInput("Gunung", _gunungController),
              _buildInput(
                "Tanggal Pendakian",
                _tanggalController,
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              _buildInput(
                "Jumlah Tiket",
                _jumlahController,
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: _statusPembayaran,
                items: ['lunas', 'belum lunas']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _statusPembayaran = val!),
                decoration: _inputDecoration("Status Pembayaran"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF3B3B98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submitForm,
                child: Text(isEdit ? "Simpan Perubahan" : "Tambah Tiket"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        decoration: _inputDecoration(label),
        validator: (value) => value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: const Color(0xFFF0F4FF),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../models/tiket.dart';
// import '../services/tiket_service.dart';

// class FormScreen extends StatefulWidget {
//   final Tiket? tiket; // null jika tambah data

//   const FormScreen({Key? key, this.tiket}) : super(key: key);

//   @override
//   State<FormScreen> createState() => _FormScreenState();
// }

// class _FormScreenState extends State<FormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TiketService _service = TiketService();

//   late TextEditingController _namaController;
//   late TextEditingController _gunungController;
//   late TextEditingController _tanggalController;
//   late TextEditingController _jumlahController;
//   String _statusPembayaran = 'lunas';
//   DateTime? _tanggalDipilih;

//   @override
//   void initState() {
//     super.initState();
//     final tiket = widget.tiket;
//     _namaController = TextEditingController(text: tiket?.namaPendaki ?? '');
//     _gunungController = TextEditingController(text: tiket?.gunung ?? '');
//     _tanggalController = TextEditingController(
//         text: tiket != null ? tiket.tanggalPendakian.toIso8601String().split('T')[0] : '');
//     _jumlahController = TextEditingController(
//         text: tiket != null ? tiket.jumlahTiket.toString() : '');
//     _statusPembayaran = tiket?.statusPembayaran ?? 'lunas';
//     _tanggalDipilih = tiket?.tanggalPendakian;
//   }

//   void _submitForm() async {
//     if (!_formKey.currentState!.validate() || _tanggalDipilih == null) return;


//   final newTiket = Tiket(
//     id: widget.tiket?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//     namaPendaki: _namaController.text,
//     gunung: _gunungController.text,
//     tanggalPendakian: _tanggalDipilih!.toUtc(), // Langsung gunakan objek DateTime
//     jumlahTiket: int.parse(_jumlahController.text),
//     statusPembayaran: _statusPembayaran,
//   );

//     print('Menambahkan/Update tiket: ${newTiket.toJson()}');  // Log data tiket yang akan dikirim

//     try {
//       if (widget.tiket == null) {
//         print('Menambahkan tiket baru...');
//         await _service.addTiket(newTiket);
//       } else {
//         print('Mengupdate tiket yang ada...');
//         await _service.updateTiket(widget.tiket!.id, newTiket);
//       }

//       if (mounted) {
//         Navigator.pop(context, true); // kirim hasil ke halaman sebelumnya
//       }
//     } catch (e) {
//       print('Error saat menyimpan data: $e');  // Log jika terjadi error
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal menyimpan data: $e')),
//       );
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final initial = _tanggalDipilih ?? DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );

//     if (picked != null) {
//       setState(() {
//         _tanggalDipilih = picked;
//         _tanggalController.text = picked.toIso8601String().split('T')[0];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _namaController.dispose();
//     _gunungController.dispose();
//     _tanggalController.dispose();
//     _jumlahController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEdit = widget.tiket != null;

//     return Scaffold(
//       appBar: AppBar(title: Text(isEdit ? "Edit Tiket" : "Tambah Tiket")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _namaController,
//                 decoration: InputDecoration(labelText: "Nama Pendaki"),
//                 validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
//               ),
//               TextFormField(
//                 controller: _gunungController,
//                 decoration: InputDecoration(labelText: "Gunung"),
//                 validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
//               ),
//               TextFormField(
//                 controller: _tanggalController,
//                 decoration: InputDecoration(labelText: "Tanggal Pendakian"),
//                 readOnly: true,
//                 onTap: () => _selectDate(context),
//               ),
//               TextFormField(
//                 controller: _jumlahController,
//                 decoration: InputDecoration(labelText: "Jumlah Tiket"),
//                 keyboardType: TextInputType.number,
//                 validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
//               ),
//               DropdownButtonFormField<String>(
//                 value: _statusPembayaran,
//                 items: ['lunas', 'belum lunas']
//                     .map((s) => DropdownMenuItem(value: s, child: Text(s)))
//                     .toList(),
//                 onChanged: (val) => setState(() => _statusPembayaran = val!),
//                 decoration: InputDecoration(labelText: "Status Pembayaran"),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text(isEdit ? "Simpan Perubahan" : "Tambah Tiket"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../models/tiket.dart';
// import '../services/tiket_service.dart';

// class FormScreen extends StatefulWidget {
//   final Tiket? tiket; // null jika tambah data

//   const FormScreen({Key? key, this.tiket}) : super(key: key);

//   @override
//   State<FormScreen> createState() => _FormScreenState();
// }

// class _FormScreenState extends State<FormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TiketService _service = TiketService();

//   late TextEditingController _namaController;
//   late TextEditingController _gunungController;
//   late TextEditingController _tanggalController;
//   late TextEditingController _jumlahController;
//   String _statusPembayaran = 'lunas';
//   DateTime? _tanggalDipilih;

//   @override
//   void initState() {
//     super.initState();
//     final tiket = widget.tiket;
//     _namaController = TextEditingController(text: tiket?.namaPendaki ?? '');
//     _gunungController = TextEditingController(text: tiket?.gunung ?? '');
//     _tanggalController = TextEditingController(
//         text: tiket != null ? tiket.tanggalPendakian.toIso8601String().split('T')[0] : '');
//     _jumlahController = TextEditingController(
//         text: tiket != null ? tiket.jumlahTiket.toString() : '');
//     _statusPembayaran = tiket?.statusPembayaran ?? 'lunas';
//     _tanggalDipilih = tiket?.tanggalPendakian;
//   }

//   void _submitForm() async {
//     if (!_formKey.currentState!.validate() || _tanggalDipilih == null) return;

//     final newTiket = Tiket(
//       id: widget.tiket?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       namaPendaki: _namaController.text,
//       gunung: _gunungController.text,
//       tanggalPendakian: _tanggalDipilih!,
//       jumlahTiket: int.parse(_jumlahController.text),
//       statusPembayaran: _statusPembayaran,
//     );

//     try {
//       if (widget.tiket == null) {
//         await _service.addTiket(newTiket);
//       } else {
//         await _service.updateTiket(widget.tiket!.id, newTiket);
//       }

//       if (mounted) {
//         Navigator.pop(context, true); // kirim hasil ke halaman sebelumnya
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal menyimpan data: $e')),
//       );
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final initial = _tanggalDipilih ?? DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );

//     if (picked != null) {
//       setState(() {
//         _tanggalDipilih = picked;
//         _tanggalController.text = picked.toIso8601String().split('T')[0];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _namaController.dispose();
//     _gunungController.dispose();
//     _tanggalController.dispose();
//     _jumlahController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEdit = widget.tiket != null;

//     return Scaffold(
//       appBar: AppBar(title: Text(isEdit ? "Edit Tiket" : "Tambah Tiket")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _namaController,
//                 decoration: InputDecoration(labelText: "Nama Pendaki"),
//                 validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
//               ),
//               TextFormField(
//                 controller: _gunungController,
//                 decoration: InputDecoration(labelText: "Gunung"),
//                 validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
//               ),
//               TextFormField(
//                 controller: _tanggalController,
//                 decoration: InputDecoration(labelText: "Tanggal Pendakian"),
//                 readOnly: true,
//                 onTap: () => _selectDate(context),
//               ),
//               TextFormField(
//                 controller: _jumlahController,
//                 decoration: InputDecoration(labelText: "Jumlah Tiket"),
//                 keyboardType: TextInputType.number,
//                 validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
//               ),
//               DropdownButtonFormField<String>(
//                 value: _statusPembayaran,
//                 items: ['lunas', 'belum lunas']
//                     .map((s) => DropdownMenuItem(value: s, child: Text(s)))
//                     .toList(),
//                 onChanged: (val) => setState(() => _statusPembayaran = val!),
//                 decoration: InputDecoration(labelText: "Status Pembayaran"),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text(isEdit ? "Simpan Perubahan" : "Tambah Tiket"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
