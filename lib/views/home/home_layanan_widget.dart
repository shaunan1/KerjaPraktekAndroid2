// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pecut/models/layanan_model.dart';
import 'package:pecut/views/layanan/esuket/esuket_screen.dart';
import 'package:pecut/widgets/card_layanan_widget.dart';

class HomeLayananWidget extends StatefulWidget {
  final int categoryId;
  const HomeLayananWidget({super.key, required this.categoryId});

  @override
  State<HomeLayananWidget> createState() => _HomeLayananWidgetState();
}

class _HomeLayananWidgetState extends State<HomeLayananWidget> {
  Future<List<LayananModel>> fetchData() async {
    final data = await rootBundle.loadString('assets/fake-api/layanan.json');
    Iterable decoded = await jsonDecode(data);
    List<LayananModel> lists = List<LayananModel>.from(
        decoded.map((model) => LayananModel.fromJson(model)));

    return lists;
  }

  void handleSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void navigateTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Untuk menggantikan Card
      child: SizedBox(
        height: 160,
        child: FutureBuilder<List<LayananModel>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List<LayananModel> layananItems = snapshot.data!
                  .where((row) => row.categoryId == widget.categoryId)
                  .toList();
              return CardLayananWidget(
                layananItems: layananItems,
                onTap: (LayananModel object) {
                  if (object.slug == 'e-suket') {
                    navigateTo(context, const EsuketScreen());
                  } else {
                    handleSnackbar(
                        '${object.name}: sedang dalam pemeliharaan sistem!');
                  }
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
