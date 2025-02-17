// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/models/esuket_layanan_model.dart';
import 'package:pecut/views/layanan/esuket/skbn/skbn_list_screen.dart';
import 'package:pecut/views/layanan/esuket/skboro/skboro_list_screen.dart';
import 'package:pecut/views/layanan/esuket/skdom/skdom_list_screen.dart';
import 'package:pecut/views/layanan/esuket/skhsl/skhsl_list_screen.dart';
import 'package:pecut/views/layanan/esuket/sktm/sktm_list_screen.dart';
import 'package:pecut/views/layanan/esuket/skusaha/skusaha_list_screen.dart';
import 'package:pecut/views/layanan/esuket/suket/suket_list_screen.dart';
import 'package:provider/provider.dart';

ValueNotifier<String> searchCtrl = ValueNotifier<String>('');

class EsuketServicesWidget extends StatefulWidget {
  const EsuketServicesWidget({super.key});

  @override
  State<EsuketServicesWidget> createState() => _EsuketServicesWidgetState();
}

class _EsuketServicesWidgetState extends State<EsuketServicesWidget> {
  Future<List<EsuketLayananModel>> fetchData() async {
    final data =
        await rootBundle.loadString('assets/fake-api/esuket_layanan.json');
    Iterable decoded = await jsonDecode(data);
    List<EsuketLayananModel> lists = List<EsuketLayananModel>.from(
      decoded.map((model) => EsuketLayananModel.fromJson(model)),
    );

    return lists;
  }

  List<EsuketLayananModel> handleSearch(List<EsuketLayananModel>? layanan) {
    if (searchCtrl.value.isNotEmpty) {
      return layanan
              ?.where(
                (item) =>
                    item.name!
                        .toLowerCase()
                        .contains(searchCtrl.value.toLowerCase()) ||
                    item.description!
                        .toLowerCase()
                        .contains(searchCtrl.value.toLowerCase()),
              )
              .toList() ??
          <EsuketLayananModel>[];
    }

    return layanan ?? <EsuketLayananModel>[];
  }

  void navigateTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  void handleSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EsuketController>(
      builder: (context, esuket, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/user-placeholder.png'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          esuket.user?.name ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          esuket.user?.email ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 0, right: 20, bottom: 20, left: 20),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: 'Telusuri layanan',
                  elevation: const WidgetStatePropertyAll(0.0),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (value) {
                    searchCtrl.value = value;
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      List<EsuketLayananModel> items = snapshot.data!;
                      return ValueListenableBuilder<String>(
                          valueListenable: searchCtrl,
                          builder: (context, searchListen, child) {
                            List<EsuketLayananModel> filtered =
                                handleSearch(items);
                            return ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                EsuketLayananModel item = filtered[index];
                                return Animate(
                                  effects: const [FadeEffect(), SlideEffect()],
                                  delay: Duration(milliseconds: index * 100),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 7,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        switch (item.slug) {
                                          case 'skbn':
                                            navigateTo(
                                              context,
                                              const EsuketSkbnListScreen(),
                                            );
                                            break;
                                          case 'skboro':
                                            navigateTo(
                                              context,
                                              const EsuketSkboroListScreen(),
                                            );
                                            break;
                                          case 'skdom':
                                            navigateTo(
                                              context,
                                              const EsuketSkdomListScreen(),
                                            );
                                            break;
                                          case 'sktm':
                                            navigateTo(
                                              context,
                                              const EsuketSktmListScreen(),
                                            );
                                            break;
                                          case 'skhsl':
                                            navigateTo(
                                              context,
                                              const EsuketSkhslListScreen(),
                                            );
                                            break;
                                          case 'skusaha':
                                            navigateTo(
                                              context,
                                              const EsuketSkusahaListScreen(),
                                            );
                                            break;
                                          case 'suket':
                                            navigateTo(
                                              context,
                                              const EsuketSuketListScreen(),
                                            );
                                            break;
                                          default:
                                            print('You tapped: ${item.slug}');
                                            handleSnackbar(
                                              context,
                                              '${item.name}: under maintenance.',
                                            );
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListTile(
                                        title: Text(
                                          item.name!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        subtitle: Text(
                                          item.description!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
