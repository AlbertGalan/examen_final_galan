import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pokemon;

  UserDetailScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user['name']}'),
            Text('Email: ${user['email']}'),
            Text('Address: ${user['address']}'),
            Text('Phone: ${user['phone']}'),
            Text('Website: ${user['website']}'),
            SizedBox(height: 20),
            Image.network(user['photo']),
          ],
        ),
      ),
    );
  }
}
