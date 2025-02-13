// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/views/auth/login_screen.dart';
import 'package:pecut/widgets/profile_list_widget.dart';
import 'package:provider/provider.dart';

const double iconSize = 32;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SsoController>(builder: (context, sso, child) {
      if (sso.isLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (sso.isAuth == false) {
        return const LoginScreen();
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileListWidget(
                  value: sso.user.name!,
                  label: 'Nama',
                  icon: Icons.person,
                  onTap: () {
                    print('Edit: name');
                  },
                ),
                ProfileListWidget(
                  value: sso.user.email!,
                  label: 'Email',
                  icon: Icons.email,
                  onTap: () {
                    print('Edit: email');
                  },
                ),
                ProfileListWidget(
                  value: sso.user.phone!,
                  label: 'No. HP (WhatsApp)',
                  icon: Icons.phone,
                  onTap: () {
                    print('Edit: phone');
                  },
                ),
                ProfileListWidget(
                  value: sso.user.nik!,
                  label: 'NIK (Nomor KTP)',
                  icon: Icons.badge,
                  onTap: () {
                    print('Edit: nik');
                  },
                ),
                const SizedBox(height: 60),
                const Text('Preferensi',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ProfileListWidget(
                  value: 'Keluar dari aplikasi',
                  label: 'Keluar',
                  icon: Icons.logout,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: MediaQuery.sizeOf(context).height / 2.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/images/lottie/question.json',
                                  height: 100,
                                ),
                                const SizedBox(height: 40),
                                const Text(
                                  'Keluar dari aplikasi ?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                TextButton.icon(
                                  icon: const Icon(Icons.check,
                                      color: Colors.white),
                                  label: const Text(
                                    'Ya',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: const ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(horizontal: 60),
                                    ),
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.black),
                                  ),
                                  onPressed: () {
                                    sso.logout().then((res) {
                                      Navigator.pop(context);
                                      print(
                                        'logoutResponse: ${res.toString()}',
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
