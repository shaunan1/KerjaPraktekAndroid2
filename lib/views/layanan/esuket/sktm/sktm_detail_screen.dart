import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/models/theme_color_model.dart';
import 'package:provider/provider.dart';

final dio = Dio();

class EsuketSktmDetailScreen extends StatelessWidget {
  final int id;
  const EsuketSktmDetailScreen({super.key, required this.id});

  Future fetchData(String nik, String token) async {
    print('fetching data...');
    String url = '${dotenv.env['ESUKET_BASE_URL']}/api/sktm?nik=$nik';
    Response response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EsuketController>(
      builder: (context, esuket, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Detail Pengajuan: ${id.toString()}'),
          ),
          body: FutureBuilder(
            future: fetchData(esuket.user!.nik!, esuket.token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                List items = List.from(snapshot.data)
                    .where((item) => item['id'] == id)
                    .toList();
                if (items.isEmpty) {
                  return const Center(child: Text('Data tidak ditemukan'));
                }
                Map<String, dynamic> item = items[0];
                ThemeColorModel theme =
                    esuket.getThemeColor(item['st']['color']);
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ContentWidget(
                              label: 'Nomor Surat:',
                              value: item['nomor_surat']),
                          ContentWidget(
                              label: 'Kepada:', value: item['kepada']),
                          ContentWidget(label: 'NIK:', value: item['nik']),
                          ContentWidget(
                              label: 'Peruntukan:', value: item['peruntukan']),
                          ContentWidget(
                              label: 'Tanggal Surat:',
                              value: item['tgl_surat']),
                          ListTile(
                            title: const Text('Status:'),
                            subtitle: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: theme.bgColor,
                              ),
                              child: Text(
                                item['st']['name'],
                                style: TextStyle(color: theme.textColor),
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text('File:'),
                            subtitle: item['file'] != null
                                ? TextButton(
                                    child: const Text(
                                      'Download',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                    onPressed: () {
                                      String fileUrl =
                                          '${dotenv.env['ESUKET_BASE_URL']}${item['file']}'
                                              .replaceFirst(
                                                  'http://', 'https://');
                                      FileDownloader()
                                          .downloadFile(fileUrl, context);
                                    },
                                  )
                                : const Text('-'),
                          ),
                          const SizedBox(height: 10),
                          if (item['pengantar'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                '${dotenv.env['ESUKET_BASE_URL']!}${item['pengantar']}',
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}

class ContentWidget extends StatelessWidget {
  final String label;
  final dynamic value;
  const ContentWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value ?? '-'),
      ),
    );
  }
}

class FileDownloader {
  final Dio dio = Dio();

  Future<void> downloadFile(String url, BuildContext context) async {
    try {
      // Dapatkan folder unduhan
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory(
            '/storage/emulated/0/Download'); // Folder Downloads Android
      } else {
        dir = await getApplicationDocumentsDirectory(); // Folder dokumen di iOS
      }

      if (!dir.existsSync()) {
        dir.createSync(recursive: true); // Buat folder jika belum ada
      }

      String fileName = url.split('/').last;
      String savePath = '${dir.path}/$fileName';

      // Download file dengan Dio
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                'Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      // Beri tahu pengguna
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download selesai: $savePath')),
      );

      // Buka file setelah diunduh
      OpenFile.open(savePath);
    } catch (e) {
      print('Error saat mengunduh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunduh file')),
      );
    }
  }
}
