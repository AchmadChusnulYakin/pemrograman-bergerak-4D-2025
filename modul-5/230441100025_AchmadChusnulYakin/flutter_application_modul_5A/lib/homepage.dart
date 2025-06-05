import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _gunungController = TextEditingController();
  final _jumlahTiketController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedStatus;
  String? editingDocId;

  void _clearForm() {
    _namaController.clear();
    _gunungController.clear();
    _jumlahTiketController.clear();
    _selectedDate = null;
    _selectedStatus = null;
    editingDocId = null;
    setState(() {});
  }

  void _submitData() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedStatus != null) {
      final collection = FirebaseFirestore.instance.collection('tiket_pendakian');
      final data = {
        'namaPendaki': _namaController.text,
        'gunung': _gunungController.text,
        'jumlahTiket': int.tryParse(_jumlahTiketController.text) ?? 1,
        'statusPembayaran': _selectedStatus,
        'tanggalPendakian': Timestamp.fromDate(_selectedDate!),
      };

      if (editingDocId == null) {
        final docRef = await collection.add(data);
        await docRef.update({'id': docRef.id});
      } else {
        await collection.doc(editingDocId).update(data);
      }
      _clearForm();
    }
  }

  // void _deleteData(String docId) {
  //   FirebaseFirestore.instance.collection('tiket_pendakian').doc(docId).delete();
  // }

void _deleteData(String docId) async {
  // Menampilkan dialog konfirmasi sebelum menghapus
  final konfirmasi = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: const Text('Apakah Anda yakin ingin menghapus data pendaki ini?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Hapus'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  // Jika user menekan tombol "Hapus"
  if (konfirmasi == true) {
    await FirebaseFirestore.instance
        .collection('tiket_pendakian')
        .doc(docId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus')),
      );
    }
  }

  void _editData(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    setState(() {
      editingDocId = doc.id;
      _namaController.text = data['namaPendaki'] ?? '';
      _gunungController.text = data['gunung'] ?? '';
      _jumlahTiketController.text = (data['jumlahTiket'] ?? 1).toString();
      _selectedStatus = data['statusPembayaran'];
      _selectedDate = (data['tanggalPendakian'] as Timestamp).toDate();
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text('Tiket Pendakian'),
        backgroundColor: const Color(0xFF0A3D62),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 6,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Pendaki',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Wajib diisi' : null,
                      ),
                      TextFormField(
                        controller: _gunungController,
                        decoration: const InputDecoration(
                          labelText: 'Gunung',
                          prefixIcon: Icon(Icons.terrain),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Wajib diisi' : null,
                      ),
                      TextFormField(
                        controller: _jumlahTiketController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Tiket',
                          prefixIcon: Icon(Icons.confirmation_number),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Wajib diisi' : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status Pembayaran',
                          prefixIcon: Icon(Icons.payment),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'lunas', child: Text('Lunas')),
                          DropdownMenuItem(
                              value: 'belum lunas',
                              child: Text('Belum Lunas')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                        validator: (value) => value == null
                            ? 'Status pembayaran wajib dipilih'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Pilih Tanggal'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B3B98),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 18),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate == null
                                ? 'Belum dipilih'
                                : DateFormat('dd/MM/yyyy')
                                    .format(_selectedDate!),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: _submitData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: editingDocId == null
                              ? const Color(0xFF0A3D62)
                              : Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        
                        child: Text(
                          editingDocId == null ? 'Tambah Tiket' : 'Update Tiket',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (editingDocId != null)
                        TextButton(
                          onPressed: _clearForm,
                          child: const Text('Batal Edit'),
                        )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Daftar Tiket Pendakian',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tiket_pendakian')
                    .orderBy('tanggalPendakian')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Text('Belum ada data tiket.');
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final tanggal =
                          (data['tanggalPendakian'] as Timestamp).toDate();
                      final bool isLunas =
                          data['statusPembayaran'].toLowerCase() == 'lunas';

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            '${data['namaPendaki']} - ${data['gunung']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text('Jumlah Tiket: ${data['jumlahTiket']}'),
                              Text(
                                'Status: ${data['statusPembayaran']}',
                                style: TextStyle(
                                  color: isLunas ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Tanggal: ${DateFormat('dd/MM/yyyy').format(tanggal)}',
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Color(0xFF3B3B98)),
                                onPressed: () => _editData(doc),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () => _deleteData(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

