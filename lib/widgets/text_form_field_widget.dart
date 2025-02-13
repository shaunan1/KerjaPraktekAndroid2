import 'package:flutter/material.dart';

const int alpha = 25;

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController attributeCtrl;
  final String labelText;
  final TextInputType? textInputType;
  final IconData iconData;
  final bool? isRequired;
  final int? minLines;
  final int? maxLines;
  final void Function(String)? onChanged;

  const TextFormFieldWidget({
    super.key,
    required this.attributeCtrl,
    required this.labelText,
    this.textInputType,
    required this.iconData,
    this.isRequired,
    this.minLines,
    this.maxLines,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: attributeCtrl,
      keyboardType: textInputType ?? TextInputType.text,
      minLines: minLines,
      maxLines: maxLines == null ? minLines : maxLines!,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        label: Text.rich(
          TextSpan(
            text: labelText,
            children: [
              TextSpan(
                text: isRequired == null || isRequired! == false ? null : ' *',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        prefixIcon: Icon(
          iconData,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      validator: (value) {
        if (isRequired == false) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return '$labelText field is required';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
