import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/models/theme_color_model.dart';
import 'package:provider/provider.dart';

final dio = Dio();

class EsuketSuketDetailScreen extends StatelessWidget {
  final int id;
  const EsuketSuketDetailScreen({super.key, required this.id});

  Future fetchData(String nik, String token) async {
    print('fetching data...');
    String url = '${dotenv.env['ESUKET_BASE_URL']}/api/suket?nik=$nik';
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
                              label: 'Keterangan:', value: item['keterangan']),
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
                                    onPressed: () =>
                                        print('Download: ${item['file']}'),
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
