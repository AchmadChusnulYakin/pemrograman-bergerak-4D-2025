import 'package:flutter/material.dart';
import '../models/tiket.dart';
import '../services/tiket_service.dart';
import 'form_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TiketService _service = TiketService();
  late Future<List<Tiket>> _tiketList;

  @override
  void initState() {
    super.initState();
    _loadTikets();
  }

  void _loadTikets() {
    _tiketList = _service.getTikets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Tiket Pendakian"),
        backgroundColor: const Color(0xFF0A3D62),
      ),
      body: FutureBuilder<List<Tiket>>(
        future: _tiketList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Waduh error nih: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada tiket, buruan tambahin!"));
          }

          final tiketList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tiketList.length,
            itemBuilder: (context, index) {
              final tiket = tiketList[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: const Icon(Icons.terrain, color: Color(0xFF3B3B98)),
                  title: Text(
                    tiket.namaPendaki,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${tiket.gunung} - ${tiket.tanggalPendakian.toLocal().toIso8601String().split('T').first}',
                  ),
                  trailing: Text(
                    tiket.statusPembayaran,
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailScreen(tiket: tiket)),
                    );
                    if (result == true) {
                      setState(() => _loadTikets());
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3B3B98),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
          if (result == true) {
            setState(() => _loadTikets());
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../models/tiket.dart';
// import '../services/tiket_service.dart';
// import 'form_screen.dart';
// import 'detail_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TiketService _service = TiketService();
//   late Future<List<Tiket>> _tiketList;

//   @override
//   void initState() {
//     super.initState();
//     _loadTikets();
//   }

//   void _loadTikets() {
//     _tiketList = _service.getTikets();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Daftar Tiket Pendakian")),
//       body: FutureBuilder<List<Tiket>>(
//         future: _tiketList,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Waduh error nih: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("Belum ada tiket, buruan tambahin!"));
//           }

//           final tiketList = snapshot.data!;
//           return ListView.builder(
//             itemCount: tiketList.length,
//             itemBuilder: (context, index) {
//               final tiket = tiketList[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(tiket.namaPendaki),
//                   subtitle: Text('${tiket.gunung} - ${tiket.tanggalPendakian.toLocal().toIso8601String().split('T').first}'),
//                   trailing: Text(tiket.statusPembayaran),
//                   onTap: () async {
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => DetailScreen(tiket: tiket)),
//                     );
//                     if (result == true) {
//                       setState(() => _loadTikets());
//                     }
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const FormScreen()),
//           );
//           if (result == true) {
//             setState(() => _loadTikets());
//           }
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
