import 'package:flutter/material.dart';
import '../models/place_model.dart';


class DetailPage extends StatelessWidget {
  final image = 'National_Park_Yosemite.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('National Park Yosemite'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Image.asset(image, height: 200, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Yosemite National Park adalah salah satu taman nasional paling ikonik di Amerika Serikat, terletak di Pegunungan Sierra Nevada, California. Dikenal karena pemandangan alamnya yang menakjubkan, taman ini menawarkan tebing granit megah, air terjun yang menjulang tinggi, dan hutan sequoia raksasa yang berusia ratusan tahun',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}