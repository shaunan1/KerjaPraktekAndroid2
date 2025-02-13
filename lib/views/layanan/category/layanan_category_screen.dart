// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pecut/models/layanan_model.dart';
import 'package:pecut/views/layanan/esuket/esuket_screen.dart';
import 'package:pecut/widgets/stroke_text_widget.dart';

class LayananCategoryScreen extends StatefulWidget {
  final String categorySlug;
  final String categoryName;
  const LayananCategoryScreen({
    super.key,
    required this.categorySlug,
    required this.categoryName,
  });

  @override
  State<LayananCategoryScreen> createState() => _LayananCategoryScreenState();
}

class _LayananCategoryScreenState extends State<LayananCategoryScreen> {
  bool showSearchBar = false;

  Future<List<LayananModel>> fetchData() async {
    int categoryId = widget.categorySlug == 'public_digital' ? 1 : 2;
    final data = await rootBundle.loadString('assets/fake-api/layanan.json');
    Iterable decoded = await jsonDecode(data);
    List<LayananModel> lists = List<LayananModel>.from(
      decoded
          .map(
            (model) => LayananModel.fromJson(model),
          )
          .where((row) => row.categoryId == categoryId),
    );

    return lists;
  }

  void navigateTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => widget),
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.sizeOf(context).height / 3,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      showSearchBar = !showSearchBar;
                    });
                  },
                  icon: Icon(showSearchBar ? Icons.close : Icons.search),
                ),
              ],
              collapsedHeight: 75,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              flexibleSpace: FlexibleSpaceBar(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Layanan',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    StrokeText(
                      text: widget.categoryName,
                      fontSize:
                          Theme.of(context).textTheme.headlineLarge!.fontSize!,
                      fontWeight: FontWeight.w900,
                      strokeColor: Theme.of(context).colorScheme.primary,
                      innerColor: Theme.of(context).colorScheme.inversePrimary,
                      height: 1,
                      letterSpacing: 1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                background: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image(
                        image: AssetImage(widget.categorySlug ==
                                'public_digital'
                            ? 'assets/images/illustration-public-digital.png'
                            : 'assets/images/illustration-asn-digital.png'),
                      ),
                      showSearchBar
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: SearchBar(
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 20),
                                ),
                                leading: const Icon(Icons.search),
                                elevation: const WidgetStatePropertyAll(0),
                                backgroundColor: WidgetStatePropertyAll(
                                  Colors.white.withValues(alpha: .8),
                                ),
                                hintText: 'Telusuri layanan',
                              ).animate().fadeIn().slideY(),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  FutureBuilder<List<LayananModel>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        List items = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          padding: const EdgeInsets.all(10),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            LayananModel item = snapshot.data![index];
                            return GestureDetector(
                              onTap: () {
                                if (item.slug == 'e-suket') {
                                  navigateTo(context, const EsuketScreen());
                                } else {
                                  handleSnackbar(context,
                                      '${item.name}: under maintenance!');
                                }
                              },
                              child: Animate(
                                effects: const [FadeEffect(), MoveEffect()],
                                delay: Duration(milliseconds: index * 100),
                                child: Container(
                                  height: 200,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 5,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/layanan/${item.icon}'),
                                        height: 50,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            item.name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              height: 1,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            item.description ?? '-',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
