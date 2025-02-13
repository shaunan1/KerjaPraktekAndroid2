import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/models/theme_color_model.dart';
import 'package:pecut/views/layanan/esuket/suket/suket_detail_screen.dart';
import 'package:pecut/views/layanan/esuket/suket/suket_form_screen.dart';
import 'package:pecut/widgets/datalistview_widget.dart';
import 'package:provider/provider.dart';

const String title = 'Surat Keterangan';
final List<Map<String, dynamic>> actions = <Map<String, dynamic>>[
  {
    'value': 'view',
    'label': 'Detail',
  },
];

class EsuketSuketListScreen extends StatefulWidget {
  const EsuketSuketListScreen({super.key});

  @override
  State<EsuketSuketListScreen> createState() => _EsuketSuketListScreenState();
}

class _EsuketSuketListScreenState extends State<EsuketSuketListScreen> {
  Future fetchData(String nik, String token) async {
    final dio = Dio();
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
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Center(
                        child: Text(
                          'Layanan $title',
                          style: const TextStyle(fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                          height: 16), // Spasi tambahan sebelum kotak deskripsi

                      // Box Deskripsi
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'DESKRIPSI',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Surat Keterangan Belum Menikah Adalah Surat Yang Menerangkan Belum Pernah Menikah Alias Berstatus Lajang. '
                              'Pada Umumnya, Surat Ini Dibuat Sebagai Persyaratan Melamar Pekerjaan, Mengurus Pernikahan, Pengajuan Beasiswa, '
                              'Urusan Kampus, Maupun Keperluan Atau Perjanjian Tertentu.',
                              style: TextStyle(height: 1.5),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Output   : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                      'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Masa Berlaku   : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('5 Tahun'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height:
                              16), // Spasi tambahan sebelum kotak persyaratan

                      // Box Persyaratan
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'PERSYARATAN',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('1. Fotokopi KTP.',
                                    style: const TextStyle(height: 1.5)),
                                Text('2. Fotokopi Kartu Keluarga.',
                                    style: const TextStyle(height: 1.5)),
                                Text('3. Surat Pernyataan Belum Menikah.',
                                    style: const TextStyle(height: 1.5)),
                                Text('4. Surat Pengantar dari RT/RW.',
                                    style: const TextStyle(height: 1.5)),
                                Text('5. Pas Foto 3x4 (2 lembar).',
                                    style: const TextStyle(height: 1.5)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
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
                                          EsuketSuketFormScreen(
                                        id: item['id'],
                                      ),
                                    ),
                                  );
                                } else if (val == 'view') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EsuketSuketDetailScreen(
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
          floatingActionButton: SizedBox(
            width: 200,
            height: 60,
            child: FilledButton.tonal(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EsuketSuketFormScreen(),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
