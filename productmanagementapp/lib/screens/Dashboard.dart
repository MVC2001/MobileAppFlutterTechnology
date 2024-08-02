import 'package:flutter/material.dart';
import 'package:productmanagementapp/screens/ProductManagement.dart';

import 'QrcodeScanner.dart';

void main() => runApp(Dashboard());

class Dashboard extends StatelessWidget {
  static const header = 'GeeksforGeeks';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: header,
      home: MyHomePage(title: header),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'Navigation Drawer Demo',
          style: TextStyle(fontSize: 20),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                'USER MENU',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_activity),
              title: const Text('Resert password'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: const Text('Scan Product'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRViewExample()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}