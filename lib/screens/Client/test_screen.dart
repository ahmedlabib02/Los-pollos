import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        _build()
      ],
    ));
  }

  Widget _build() {
    return Ink(
      decoration: BoxDecoration(color: Colors.blue, border: Border.all()),
      child: InkWell(
          onTap: () {},
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text('Hi There \n It is me'),
            
          )),
    );
  }
}
