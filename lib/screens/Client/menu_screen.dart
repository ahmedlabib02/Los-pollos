import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Color.fromRGBO(242, 194, 48, 1),
      ),
      body: Center(
        child: const Text('Menu Screen'),
      ),
    );
  }
}
