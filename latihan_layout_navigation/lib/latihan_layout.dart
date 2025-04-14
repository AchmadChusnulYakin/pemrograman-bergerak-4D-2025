import 'package:flutter/material.dart';
import 'package:latihan_layout_navigation/latihan_navigation.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan Layout'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Text(
            'Static ListView',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // START TODO 1
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            subtitle: Text('This is the home page'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            subtitle: Text('This is the settings page'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          // END TODO 1
          const SizedBox(height: 20),

          
          const Text(
            'ListView.builder (Vertical)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 300,
            // START TODO 2
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Item $index'),
                  subtitle: Text('This is a list item'),
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
            ),
            // END TODO 2
          ),
          const SizedBox(height: 20),

          
          const Text(
            'Horizontal ListView',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 100,
            // START TODO 3
            
            // END TODO 3
          ),
          const SizedBox(height: 20),

        
          const Text(
            'GridView',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 300,
            // START TODO 4
                      child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.dashboard_customize, color: Colors.white, size: 30),
                    const SizedBox(height: 8),
                    Text(
                      'Item $index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
            // END TODO 4
          ),

          const SizedBox(height: 20),
          const Text(
            'Navigation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // START TODO 5 : navigation.push
                   Navigator.push(
                  context,
      MaterialPageRoute(builder: (context) => const NavigationPage()),
    );
                // END TODO 5
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Pergi ke NavigationPage',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}