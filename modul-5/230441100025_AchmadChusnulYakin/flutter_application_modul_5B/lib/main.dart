import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaCtrl = TextEditingController();
  TextEditingController gunungCtrl = TextEditingController();
  TextEditingController tiketCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  String pembayaran = 'lunas';
  int? editingId;

  Future<List> getData() async {
    var res = await http.get(Uri.parse("http://localhost/API/get.php"));
    return json.decode(res.body);
  }

  Future<void> addOrUpdate() async {
    if (_formKey.currentState!.validate()) {
      final url = editingId == null
          ? "http://localhost/API/add.php"
          : "http://localhost/API/update.php";
      await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'id': editingId,
          'nama_pendaki': namaCtrl.text,
          'gunung': gunungCtrl.text,
          'jumlah_tiket': int.parse(tiketCtrl.text),
          'status_pembayaran': pembayaran,
          'tanggal_pendakian': dateCtrl.text,
        }),
        headers: {"Content-Type": "application/json"},
      );
      resetForm();
      setState(() {});
    }
  }

  void deleteData(int id) async {
    await http.post(
      Uri.parse("http://localhost/API/delete.php"),
      body: jsonEncode({'id': id}),
      headers: {"Content-Type": "application/json"},
    );
    setState(() {});
  }

  void confirmDelete(int id, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Konfirmasi Hapus", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Hapus data pendaki '$nama'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              deleteData(id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text("Hapus"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void editData(Map<String, dynamic> item) {
    namaCtrl.text = item['nama_pendaki'];
    gunungCtrl.text = item['gunung'];
    tiketCtrl.text = item['jumlah_tiket'].toString();
    pembayaran = item['status_pembayaran'];
    dateCtrl.text = item['tanggal_pendakian'];
    editingId = int.tryParse(item['id'].toString());
    setState(() {});
  }

  void resetForm() {
    namaCtrl.clear();
    gunungCtrl.clear();
    tiketCtrl.clear();
    dateCtrl.clear();
    pembayaran = 'lunas';
    editingId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Tiket Pendakian',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0A3D62),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    TextFormField(
                      controller: namaCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nama Pendaki",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Wajib diisi' : null,
                    ),
                    TextFormField(
                      controller: gunungCtrl,
                      decoration: const InputDecoration(
                        labelText: "Gunung",
                        prefixIcon: Icon(Icons.landscape),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Wajib diisi' : null,
                    ),
                    TextFormField(
                      controller: tiketCtrl,
                      decoration: const InputDecoration(
                        labelText: "Jumlah Tiket",
                        prefixIcon: Icon(Icons.confirmation_number),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Wajib diisi' : null,
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      value: pembayaran,
                      decoration: const InputDecoration(
                        labelText: "Status Pembayaran",
                        prefixIcon: Icon(Icons.payment),
                      ),
                      items: ['lunas', 'belum lunas']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => pembayaran = val!),
                    ),
                    TextFormField(
                      controller: dateCtrl,
                      decoration: const InputDecoration(
                        labelText: "Tanggal Pendakian (YYYY-MM-DD)",
                        prefixIcon: Icon(Icons.date_range),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: addOrUpdate,
                      icon: Icon(editingId == null ? Icons.add : Icons.update),
                      label: Text(editingId == null ? "Tambah" : "Update"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B3B98),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    if (editingId != null)
                      TextButton(
                          onPressed: resetForm,
                          child: const Text("Batal Edit", style: TextStyle(color: Colors.grey)))
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Daftar Pendaki",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List>(
                future: getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      final item = data[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF3B3B98),
                            child: Icon(Icons.hiking, color: Colors.white),
                          ),
                          title: Text(
                            item['nama_pendaki'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "${item['gunung']} | Tiket: ${item['jumlah_tiket']} | ${item['status_pembayaran']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => editData(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever, color: Colors.red),
                                onPressed: () =>
                                    confirmDelete(int.parse(item['id']), item['nama_pendaki']),
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
