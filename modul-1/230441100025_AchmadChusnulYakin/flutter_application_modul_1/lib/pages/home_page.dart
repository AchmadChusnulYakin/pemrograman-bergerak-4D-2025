import 'package:flutter/material.dart';
import 'add_wisata_page.dart'; // pastikan file ini ada di folder 'pages'

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selamat Datang'),
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Wisata Populer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Pantai Kenjeran'),
                    subtitle: Text('Surabaya'),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Gunung Bromo'),
                    subtitle: Text('Probolinggo'),
                  ),
                  // Tambahkan data wisata lainnya jika perlu
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWisataPage()),
          );
        },
        label: const Text('Tambah Wisata'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../pages/detail_page.dart';
// import '../widgets/widgets/place_card.dart';

// class HomePage extends StatelessWidget {
//   final imageAsset = 'assets/National_Park_Yosemite.jpg';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(toolbarHeight: 0, elevation: 0),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: ListView(
//           children: [
//             const Text(
//               'Hi, User',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             // Hot Places Section
//             _buildSectionTitle('Hot Places'),
//             SizedBox(
//               height: 120,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(
//                         builder: (_) => DetailPage(),
//                       ));
//                     },
//                     child: PlaceCard(
//                       imageAssetPath: imageAsset,
//                       title: 'National Park Yosemite',
//                       subtitle: 'California',
//                     ),
//                   ),
//                   PlaceCard(
//                     imageAssetPath: imageAsset,
//                     title: 'National Park Yosemite',
//                     subtitle: 'California',
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Best Hotels Section
//             _buildSectionTitle('Best Hotels'),
//             const SizedBox(height: 8),
//             ...List.generate(
//               5,
//               (index) => GestureDetector(
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (_) => DetailPage(),
//                   ));
//                 },
//                 child: PlaceCard(
//                   imageAssetPath: imageAsset,
//                   title: 'National Park Yosemite',
//                   subtitle: 'Yosemite National Park adalah salah satu taman nasional paling ikonik di Amerika Serikat, terletak di Pegunungan Sierra Nevada, California. Dikenal karena pemandangan alamnya yang menakjubkan, taman ini menawarkan tebing granit megah, air terjun yang menjulang tinggi, dan hutan sequoia raksasa yang berusia ratusan tahun.',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const Text('See All', style: TextStyle(color: Colors.blue)),
//       ],
//     );
//   }
// }
