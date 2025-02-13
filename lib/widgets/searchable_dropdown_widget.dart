import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class SearchableDropdownWidget extends StatefulWidget {
  const SearchableDropdownWidget({super.key});

  @override
  State<SearchableDropdownWidget> createState() =>
      _SearchableDropdownWidgetState();
}

class _SearchableDropdownWidgetState extends State<SearchableDropdownWidget> {
  late final dio = Dio();

  final SearchableDropdownController<int> searchableDropdownController =
      SearchableDropdownController<int>(
    initialItem: const SearchableDropdownMenuItem(
      value: 2,
      label: 'At',
      child: Text('At'),
    ),
  );

  @override
  void dispose() {
    searchableDropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
