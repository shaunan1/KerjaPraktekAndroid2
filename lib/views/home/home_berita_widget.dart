// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final dio = Dio();

class HomeBeritaWidget extends StatefulWidget {
  const HomeBeritaWidget({super.key});

  @override
  State<HomeBeritaWidget> createState() => _HomeBeritaWidgetState();
}

class _HomeBeritaWidgetState extends State<HomeBeritaWidget> {
  Future fetchData() async {
    try {
      String url =
          'https://api-splp.layanan.go.id:443/t/kedirikota.go.id/web_kediri_kota/1.0/api/berita';
      Response response = await dio.get(url);
      List decoded = jsonDecode(response.data['berita']);
      return decoded;
    } on DioException catch (e) {
      print('fetchBeritaFailed: ${e.response?.data?.toString()}');
    }
  }

  Future _launchUrl(String id, String url) async {
    Uri uri = Uri.parse('https://kedirikota.go.id/p/berita/$id/$url');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Berita Terkini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            IconButton(
              onPressed: () => setState(() => fetchData()),
              icon: const Icon(Icons.refresh, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 15),
        FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                List items = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _launchUrl(
                          items[index]['idpost'],
                          items[index]['judulurl'],
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      NetworkImage(items[index]['linkgambar']),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    items[index]['judul'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 14),
                                      const SizedBox(width: 5),
                                      Text(
                                        DateFormat('dd MMM yyyy').format(
                                            DateTime.parse(
                                                items[index]['tgl'])),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return _buildEmptyState();
              }
            } else if (snapshot.hasError) {
              return const Center(child: Text('Cannot load data.'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Tidak ada berita tersedia',
        style: TextStyle(color: Colors.grey[600], fontSize: 16),
      ),
    );
  }
}
