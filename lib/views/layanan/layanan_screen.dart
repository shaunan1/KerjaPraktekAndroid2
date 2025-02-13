import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/models/layanan_model.dart';
import 'package:pecut/views/layanan/esuket/esuket_screen.dart';
import 'package:provider/provider.dart';

class LayananScreen extends StatefulWidget {
  const LayananScreen({super.key});

  @override
  State<LayananScreen> createState() => _LayananScreenState();
}

class _LayananScreenState extends State<LayananScreen> {
  Future<List<LayananModel>> fetchData(int categoryId) async {
    final data = await rootBundle.loadString('assets/fake-api/layanan.json');
    Iterable decoded = jsonDecode(data);
    return List<LayananModel>.from(
      decoded.map((model) => LayananModel.fromJson(model)).where(
            (row) => row.categoryId == categoryId,
          ),
    );
  }

  void navigateTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  void handleSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    int categoryId = 1;

    return Consumer<SsoController>(
      builder: (context, sso, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              sso.isAuth ? 'Halo, ${sso.user.name!}' : 'Halo, Pengguna',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          body: FutureBuilder<List<LayananModel>>(
            future: fetchData(categoryId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Terjadi kesalahan saat memuat data.'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('Tidak ada layanan ditemukan.'));
              } else {
                List<LayananModel> items = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          LayananModel object = items[index];
                          if (object.slug == 'e-suket') {
                            navigateTo(context, const EsuketScreen());
                          } else {
                            handleSnackbar(
                                '${object.name}: sedang dalam pemeliharaan sistem!');
                          }
                        },
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Image.asset(
                                    'assets/images/layanan/${items[index].icon}',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    items[index].name!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    items[index].description!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
