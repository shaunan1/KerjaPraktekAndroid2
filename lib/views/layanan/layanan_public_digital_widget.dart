// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pecut/widgets/stroke_text_widget.dart';

class LayananPublicDigitalWidget extends StatelessWidget {
  final Function onTap;
  const LayananPublicDigitalWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 60),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layanan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        Theme.of(context).textTheme.displaySmall?.fontSize,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.7,
                  child: StrokeText(
                    text: 'Public Digital',
                    fontSize:
                        Theme.of(context).textTheme.displayLarge!.fontSize!,
                    fontWeight: FontWeight.w900,
                    strokeColor: Theme.of(context).colorScheme.surface,
                    innerColor: Theme.of(context).colorScheme.primary,
                    height: 1,
                    letterSpacing: 0,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    onTap('public_digital');
                  },
                  child: const Row(
                    children: [
                      Text('Telusuri layanan'),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_right_alt),
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
              child: Animate(
                effects: const [FadeEffect(), MoveEffect()],
                delay: const Duration(milliseconds: 100),
                child: const Image(
                  image: AssetImage(
                      'assets/images/illustration-public-digital.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
