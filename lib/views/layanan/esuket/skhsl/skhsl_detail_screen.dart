import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/models/theme_color_model.dart';
import 'package:pecut/widgets/timeline_pelayanan_widget.dart';
import 'package:provider/provider.dart';

final dio = Dio();

class EsuketSkhslDetailScreen extends StatelessWidget {
  final int id;
  const EsuketSkhslDetailScreen({super.key, required this.id});

  Future fetchData(String nik, String token) async {
    print('fetching data...');
    String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skhsl?nik=$nik';
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
        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Detail Pengajuan: ${id.toString()}'),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.file_copy),
                  ),
                  Tab(
                    icon: Icon(Icons.history),
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              FutureBuilder(
                future: fetchData(esuket.user!.nik!, esuket.token),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    List items = List.from(snapshot.data)
                        .where((item) => item['id'] == id)
                        .toList();
                    Map<String, dynamic> item = items[0];
                    ThemeColorModel theme =
                        esuket.getThemeColor(item['st']['color']);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Wrap(
                        runSpacing: 10,
                        children: [
                          Material(
                            elevation: 0.1,
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              title: const Text('Nomor Surat:'),
                              subtitle: Text(item['nomor_surat']),
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 0.1,
                            child: Wrap(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ContentWidget(
                                        value: item['kepada'],
                                        label: 'Kepada:',
                                      ),
                                    ),
                                    Expanded(
                                      child: ContentWidget(
                                        value: item['nik'],
                                        label: 'NIK:',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ContentWidget(
                                        value: item['peruntukan'],
                                        label: 'Peruntukan:',
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: const Text('Status:'),
                                        subtitle: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: theme.bgColor,
                                          ),
                                          child: Text(
                                            item['st']['name'],
                                            style: TextStyle(
                                                color: theme.textColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ContentWidget(
                                        value: item['tgl_surat'],
                                        label: 'Tgl. Surat:',
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: const Text('File:'),
                                        subtitle: item['file'] != null
                                            ? Row(
                                                children: [
                                                  TextButton(
                                                    child: const Text(
                                                      'Download',
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                        'readyToDownload: ${item['file']}',
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            : const Text('-'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Image(
                                        image: NetworkImage(
                                          '${dotenv.env['ESUKET_BASE_URL']!}${item['pengantar']}',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: fetchData(esuket.user!.nik!, esuket.token),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      List items = List.from(snapshot.data)
                          .where((item) => item['id'] == id)
                          .toList();
                      Map<String, dynamic> item = items[0];
                      return TimelinePelayananWidget(dataPelayanan: item);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class ContentWidget extends StatelessWidget {
  final dynamic value;
  final String label;
  const ContentWidget({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
