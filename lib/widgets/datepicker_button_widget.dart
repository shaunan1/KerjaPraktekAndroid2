import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatepickerButtonWidget extends StatelessWidget {
  final TextEditingController attributeCtrl;
  const DatepickerButtonWidget({
    super.key,
    required this.attributeCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (dateTime != null) {
          attributeCtrl.text =
              DateFormat("yyyy-MM-dd").format(dateTime).toString();
        }
      },
      child: Icon(Icons.calendar_month_outlined),
    );
  }
}
