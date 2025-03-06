// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

const double fontSizeTitle = 12;

class DatalistviewWidget extends StatelessWidget {
  final int index;
  final String noSurat;
  final String tglSurat;
  final String peruntukan;
  final String statusName;
  final Color bgColor;
  final Color textColor;
  final Function onSelected;
  final List<Map<String, dynamic>>? actions;
  const DatalistviewWidget({
    super.key,
    required this.index,
    required this.noSurat,
    required this.tglSurat,
    required this.peruntukan,
    required this.statusName,
    required this.bgColor,
    required this.textColor,
    required this.onSelected,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect(), SlideEffect()],
      delay: Duration(milliseconds: index * 100),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'No. Surat:',
                style: TextStyle(
                  fontSize: fontSizeTitle,
                ),
              ),
              Text(
                noSurat,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tgl. Surat:',
                    style: TextStyle(fontSize: fontSizeTitle),
                  ),
                  Text(
                    DateFormat('dd MMMM yyyy')
                        .format(
                          DateTime.parse(tglSurat),
                        )
                        .toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Peruntukan:',
                    style: TextStyle(fontSize: fontSizeTitle),
                  ),
                  Text(
                    peruntukan,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: bgColor,
                ),
                child: Text(
                  statusName,
                  style: TextStyle(color: textColor),
                ),
              ),
<<<<<<< HEAD
=======
              // PopupMenuButton(
              //   onSelected: (value) {
              //     onSelected(value);
              //   },
              //   color: Theme.of(context).colorScheme.surface,
              //   itemBuilder: (context) => actions != null
              //       ? List.generate(actions!.length, (index) {
              //           return PopupMenuItem(
              //             value: actions![index]['value'],
              //             child: Text(actions![index]['label']),
              //           );
              //         })
              //       : [
              //           const PopupMenuItem(
              //             value: 'view',
              //             child: Text('Detail'),
              //           ),
              //           const PopupMenuItem(
              //             value: 'edit',
              //             child: Text('Edit'),
              //           ),
              //           const PopupMenuItem(
              //             value: 'delete',
              //             child: Text('Batalkan'),
              //           ),
              //         ],
              //   icon: const Icon(Icons.more_horiz),
              // ),
>>>>>>> 6e8e60511a91c7f1a3f93a2f241334bac0fe1b04
            ],
          ),
        ),
      ),
    );
  }
}
