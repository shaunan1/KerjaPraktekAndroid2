import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class FormUploadWidget extends StatelessWidget {
  final Widget label;
  final File? fileImage;
  final Function onTap;
  final Function onDelete;
  final double? cardHeight;

  const FormUploadWidget({
    super.key,
    required this.label,
    this.fileImage,
    required this.onTap,
    required this.onDelete,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DottedBorder(
          radius: const Radius.circular(10),
          borderType: BorderType.RRect,
          dashPattern: const [5, 5],
          strokeWidth: 1.5,
          color: Theme.of(context).colorScheme.primary,
          child: Container(
            height: cardHeight ?? MediaQuery.sizeOf(context).height / 2.5,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              image: fileImage != null
                  ? DecorationImage(
                      image: FileImage(fileImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: fileImage == null
                        ? const Center(
                            child: Image(
                              image: AssetImage(
                                  'assets/images/image-placeholder.png'),
                              height: 100,
                            ),
                          )
                        : null,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    label: label,
                    icon: const Icon(Icons.file_upload_outlined),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.black.withValues(alpha: .5),
                      ),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      onTap();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: fileImage == null
              ? const SizedBox()
              : IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.error.withAlpha(150),
                    ),
                    iconColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  onPressed: () {
                    onDelete();
                  },
                  icon: const Icon(Icons.close),
                ),
        ),
      ],
    );
  }
}
