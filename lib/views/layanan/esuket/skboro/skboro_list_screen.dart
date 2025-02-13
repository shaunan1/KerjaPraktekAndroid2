import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/models/theme_color_model.dart';
import 'package:pecut/views/layanan/esuket/skboro/skboro_detail_screen.dart';
import 'package:pecut/views/layanan/esuket/skboro/skboro_form_screen.dart';
import 'package:pecut/widgets/datalistview_widget.dart';
import 'package:provider/provider.dart';

const String title = 'Surat Keterangan Boro';
final List<Map<String, dynamic>> actions = <Map<String, dynamic>>[
  {
    'value': 'view',
    'label': 'Detail',
  },
];

class EsuketSkboroListScreen extends StatefulWidget {
  const EsuketSkboroListScreen({super.key});

  @override
  State<EsuketSkboroListScreen> createState() => _EsuketSkboroListScreenState();
}

class _EsuketSkboroListScreenState extends State<EsuketSkboroListScreen> {
  Future fetchData(String nik, String token) async {
    final dio = Dio();
    String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skboro?nik=$nik';
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
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Mengatur teks di tengah
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center, // Teks di tengah
                      ),
                    ),
                    const SizedBox(height: 7),
                    Center(
                      child: Text(
                        'Layanan $title',
                        style: const TextStyle(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center, // Teks di tengah
                      ),
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
                                          EsuketSkboroFormScreen(
                                        id: item['id'],
                                      ),
                                    ),
                                  );
                                } else if (val == 'view') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EsuketSkboroDetailScreen(
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
          floatingActionButton: Center(
            child: SizedBox(
              width: 200,
              height: 60,
              child: FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EsuketSkboroFormScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary.withAlpha(50),
                  ),
                ),
                child: const Text(
                  'Daftar Perizinan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
