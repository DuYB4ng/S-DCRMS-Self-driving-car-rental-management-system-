import 'package:flutter/material.dart';

class OwnerHomeView extends StatelessWidget {
  const OwnerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Owner Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.car_rental, size: 80, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text("Welcome, Car Owner!", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
