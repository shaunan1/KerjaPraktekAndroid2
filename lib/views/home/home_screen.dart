import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/views/home/home_berita_widget.dart';
import 'package:pecut/views/home/home_layanan_widget.dart';
import 'package:pecut/views/layanan/category/layanan_category_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Consumer<SsoController>(builder: (context, sso, child) {
      ImageProvider avatarWidget = sso.isAuth
          ? const NetworkImage('https://randomuser.me/api/portraits/men/64.jpg')
          : const AssetImage('assets/images/logo-instansi.png');

      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 253, 255),
          body: Column(
            children: [
              // Header Section (Updated)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nama Pengguna
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sso.isAuth
                                  ? 'Halo, ${sso.user.name!}'
                                  : 'Halo, Pengguna',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Ikon Dropdown, Scan QR, dan Notifikasi
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              print('Get notifications');
                            },
                            icon: const Icon(Icons.notifications,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Content Section
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Teks tambahan di atas layanan public digital
                        const Text(
                          'Kini Bikin Surat Lebih Gampang Loh!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fitur Layanan Digital',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 10),
                                const HomeLayananWidget(categoryId: 1),
                                const SizedBox(height: 10),
                                const HomeBeritaWidget(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
