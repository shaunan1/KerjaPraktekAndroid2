// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/models/theme_color_model.dart';
import 'package:pecut/views/layanan/esuket/skbn/skbn_detail_screen.dart';
import 'package:pecut/views/layanan/esuket/skbn/skbn_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:pecut/widgets/datalistview_widget.dart';

class EsuketSkbnListScreen extends StatefulWidget {
  const EsuketSkbnListScreen({super.key});

  @override
  State<EsuketSkbnListScreen> createState() => _EsuketSkbnListScreenState();
}

class _EsuketSkbnListScreenState extends State<EsuketSkbnListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<List<dynamic>> fetchData(String nik, String token) async {
    final dio = Dio();
    String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skbn?nik=$nik';
    Response response = await dio.get(
      url,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
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
            title: Text(
              esuket.appName,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Syarat & Ketentuan'),
                Tab(text: 'List Izin Surat'),
              ],
              indicatorColor: Colors.blueAccent,
              labelStyle: GoogleFonts.inter(fontSize: 16),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildSyaratKetentuan(),
              _buildListSurat(esuket),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EsuketSkbnFormScreen(),
                ),
              );
            },
            label: const Text('Tambah Surat', style: TextStyle(fontSize: 16)),
            icon: const Icon(Icons.add, size: 28),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSyaratKetentuan() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Surat Keterangan Belum Menikah',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Surat ini diperlukan untuk berbagai keperluan seperti melamar kerja, kuliah, atau pernikahan.',
                style: GoogleFonts.inter(fontSize: 16),
              ),
              const SizedBox(height: 15),
              Divider(color: Colors.grey.shade300),
              Text(
                'Persyaratan:',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...[
                "- Fotokopi KTP",
                "- Fotokopi KK",
                "- Surat Pernyataan"
              ].map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(item, style: GoogleFonts.inter(fontSize: 16)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListSurat(EsuketController esuket) {
    return FutureBuilder(
      future: fetchData(esuket.user!.nik!, esuket.token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Gagal memuat data'));
        }

        List items = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> item = items[index];
              ThemeColorModel theme = esuket.getThemeColor(item['st']['color']);
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EsuketSkbnDetailScreen(id: item['id']),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DatalistviewWidget(
                    index: index,
                    noSurat: item['nomor_surat'],
                    tglSurat: item['tgl_surat'],
                    peruntukan: item['peruntukan'],
                    statusName: item['st']['name'],
                    bgColor: theme.bgColor,
                    textColor: theme.textColor,
                    onSelected: (val) {}, // Fungsi kosong agar tidak error
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
