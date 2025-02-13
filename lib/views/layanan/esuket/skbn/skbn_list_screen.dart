// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/models/theme_color_model.dart';
import 'package:pecut/views/layanan/esuket/skbn/skbn_detail_screen.dart';
import 'package:pecut/views/layanan/esuket/skbn/skbn_form_screen.dart';
import 'package:pecut/widgets/datalistview_widget.dart';
import 'package:provider/provider.dart';

const String title = 'Surat Keterangan Belum Menikah';
final List<Map<String, dynamic>> actions = <Map<String, dynamic>>[
  {
    'value': 'view',
    'label': 'Detail',
  },
];

class EsuketSkbnListScreen extends StatefulWidget {
  const EsuketSkbnListScreen({super.key});

  @override
  State<EsuketSkbnListScreen> createState() => _EsuketSkbnListScreenState();
}

class _EsuketSkbnListScreenState extends State<EsuketSkbnListScreen> {
  Future fetchData(String nik, String token) async {
    final dio = Dio();
    String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skbn?nik=$nik';
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
            title: Text(esuket.appName),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Layanan $title',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder(
                  future: fetchData(esuket.user!.nik!, esuket.token),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      List items = snapshot.data;
                      return RefreshIndicator(
                        onRefresh: () =>
                            fetchData(esuket.user!.nik!, esuket.token),
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> item = items[index];
                            ThemeColorModel theme =
                                esuket.getThemeColor(item['st']['color']);
                            return DatalistviewWidget(
                              index: index,
                              noSurat: item['nomor_surat'],
                              tglSurat: item['tgl_surat'],
                              peruntukan: item['peruntukan'],
                              statusName: item['st']['name'],
                              bgColor: theme.bgColor,
                              textColor: theme.textColor,
                              actions: actions,
                              onSelected: (val) {
                                print('selected: $val, withID: ${item['id']}');
                                if (val == 'edit') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EsuketSkbnFormScreen(
                                        id: item['id'],
                                      ),
                                    ),
                                  );
                                } else if (val == 'view') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EsuketSkbnDetailScreen(
                                        id: item['id'],
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EsuketSkbnFormScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              size: 28,
            ),
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
              iconColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primary.withAlpha(50),
              ),
            ),
          ),
        );
      },
    );
  }
}
