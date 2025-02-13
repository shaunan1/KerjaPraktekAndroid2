// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

const double iconSize = 28;

class ProfileListWidget extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Function onTap;
  const ProfileListWidget({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary.withAlpha(25),
      ),
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          title: Text(label),
          subtitle: Text(value),
          leading: Icon(
            icon,
            size: iconSize,
            color: Theme.of(context).colorScheme.primary,
          ),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
