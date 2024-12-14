import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/services/dummy.dart';

class DummyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pick a Restaurant',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Optional: Make the title bold
          ),
        ),
        backgroundColor: Color.fromRGBO(242, 194, 48, 1),
        centerTitle: true, // Centers the title
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await populateDummy(10);
          },
          child: Text('Populate Dummy Menu Items'),
        ),
      ),
    );
  }
}
