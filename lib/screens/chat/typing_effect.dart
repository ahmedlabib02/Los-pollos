import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TypingEffect extends StatelessWidget {
  const TypingEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 14,
          backgroundColor: Color.fromRGBO(239, 180, 7, 1),
          child: Icon(Icons.auto_awesome, size: 14),
        ),
        const SizedBox(width: 10),
        // Animated "..." effect
        Animate(
          effects: [
            FadeEffect(duration: 500.ms), // Fades in and out
            ScaleEffect(
                duration: 500.ms,
                begin: Offset(0.9, 0.9),
                end: Offset(1.1, 1.1)), // Slight zoom
          ],
          onComplete: (controller) =>
              controller.repeat(), // Loops the animation
          child: const Text("...", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
