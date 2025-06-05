import 'package:flutter/material.dart';
import '../models/tiket.dart';
import '../services/tiket_service.dart';
import 'form_screen.dart';

class DetailScreen extends StatelessWidget {
  final Tiket tiket;

  const DetailScreen({Key? key, required this.tiket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TiketService _service = TiketService();

    void _deleteTiket() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hapus Tiket?'),
          content: const Text('Apakah Anda yakin ingin menghapus tiket ini?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await _service.deleteTiket(tiket.id);
        if (context.mounted) Navigator.pop(context, true);
      }
    }

    Widget _infoTile(String label, String value, IconData icon) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF3B3B98)),
          title: Text(label),
          subtitle: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Tiket"),
        backgroundColor: const Color(0xFF0A3D62),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTiket,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormScreen(tiket: tiket),
                ),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _infoTile("Nama Pendaki", tiket.namaPendaki, Icons.person),
            _infoTile("Gunung", tiket.gunung, Icons.terrain),
            _infoTile("Tanggal Pendakian",
                tiket.tanggalPendakian.toLocal().toIso8601String().split('T').first,
                Icons.calendar_today),
            _infoTile("Jumlah Tiket", tiket.jumlahTiket.toString(), Icons.confirmation_number),
            _infoTile("Status Pembayaran", tiket.statusPembayaran,
                tiket.statusPembayaran == 'lunas' ? Icons.check_circle : Icons.warning),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF3B3B98),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormScreen(tiket: tiket)),
                );
                if (result == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text("Edit Tiket"),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _deleteTiket,
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                "Hapus Tiket",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../models/tiket.dart';
// import '../services/tiket_service.dart';
// import 'form_screen.dart';

// class DetailScreen extends StatelessWidget {
//   final Tiket tiket;
//   const DetailScreen({Key? key, required this.tiket}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final service = TiketService();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Detail Tiket")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Nama: ${tiket.namaPendaki}"),
//             Text("Gunung: ${tiket.gunung}"),
//             Text("Tanggal: ${tiket.tanggalPendakian.toLocal()}"),
//             Text("Jumlah Tiket: ${tiket.jumlahTiket}"),
//             Text("Status: ${tiket.statusPembayaran}"),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => FormScreen(tiket: tiket),
//                       ),
//                     ).then((value) {
//                       if (value == true) Navigator.pop(context, true);
//                     });
//                   },
//                   child: const Text("Edit"),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await service.deleteTiket(tiket.id);
//                     if (context.mounted) Navigator.pop(context, true);
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   child: const Text("Hapus"),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../models/tiket.dart';
// import '../services/tiket_service.dart';
// import 'form_screen.dart';

// class DetailScreen extends StatelessWidget {
//   final Tiket tiket;
//   final TiketService _service = TiketService();

//   DetailScreen({Key? key, required this.tiket}) : super(key: key);

//   void _konfirmasiHapus(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Konfirmasi"),
//         content: const Text("Yakin ingin menghapus tiket ini?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("Batal"),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(ctx); // tutup dialog
//               await _service.deleteTiket(tiket.id);
//               if (context.mounted) {
//                 Navigator.pop(context, true); // kembali ke halaman sebelumnya
//               }
//             },
//             child: const Text("Hapus", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Detail Tiket")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Nama Pendaki: ${tiket.namaPendaki}", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Gunung: ${tiket.gunung}", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Tanggal Pendakian: ${tiket.tanggalPendakian.toLocal().toString().split(' ')[0]}", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Jumlah Tiket: ${tiket.jumlahTiket}", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Status Pembayaran: ${tiket.statusPembayaran}", style: const TextStyle(fontSize: 18)),
//             const Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () async {
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => FormScreen(tiket: tiket)),
//                     );
//                     if (result == true && context.mounted) {
//                       Navigator.pop(context, true); // kembali ke home
//                     }
//                   },
//                   icon: const Icon(Icons.edit),
//                   label: const Text("Edit"),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () => _konfirmasiHapus(context),
//                   icon: const Icon(Icons.delete),
//                   label: const Text("Hapus"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
