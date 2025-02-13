// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pecut/widgets/stroke_text_widget.dart';

class LayananAsnDigitalWidget extends StatelessWidget {
  final Function onTap;
  const LayananAsnDigitalWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Animate(
            effects: const [FadeEffect(), MoveEffect()],
            delay: const Duration(milliseconds: 200),
            child: const Image(
              image: AssetImage('assets/images/illustration-asn-digital.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Layanan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.displaySmall?.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.95,
              child: StrokeText(
                text: 'ASN Digital',
                fontSize: Theme.of(context).textTheme.displayLarge!.fontSize!,
                fontWeight: FontWeight.w900,
                strokeColor: Theme.of(context).colorScheme.primary,
                innerColor: Theme.of(context).colorScheme.surface,
                height: 1,
                letterSpacing: 0,
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                onTap('asn_digital');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary),
              ),
              child: const Row(
                children: [
                  Text(
                    'Telusuri layanan',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
