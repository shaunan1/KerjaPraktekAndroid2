// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pecut/models/layanan_model.dart';

class CardLayananWidget extends StatefulWidget {
  final List<LayananModel> layananItems;
  final Function onTap;
  const CardLayananWidget(
      {super.key, required this.layananItems, required this.onTap});

  @override
  State<CardLayananWidget> createState() => _CardLayananWidgetState();
}

class _CardLayananWidgetState extends State<CardLayananWidget> {
  @override
  Widget build(BuildContext context) {
    List<LayananModel> layananItems = widget.layananItems;
    return Container(
      padding: const EdgeInsets.all(10), // Jarak dalam container
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: layananItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              widget.onTap(layananItems[index]);
            },
            child: Animate(
              effects: const [FadeEffect(), SlideEffect()],
              delay: Duration(milliseconds: index * 100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Container(
                  width: 100,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Image(
                        image: AssetImage(
                            'assets/images/layanan/${layananItems[index].icon}'),
                        height: 35,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                layananItems[index].name!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.fontSize,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                layananItems[index].description!,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.fontSize,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
