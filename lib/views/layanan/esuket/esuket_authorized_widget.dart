// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:provider/provider.dart';

class EsuketAuthorizedWidget extends StatelessWidget {
  const EsuketAuthorizedWidget({super.key});

  void handleSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SsoController, EsuketController>(
      builder: (context, sso, esuket, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo,',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  sso.user.name ?? '-',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(
                  style: const TextStyle(fontSize: 16),
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: esuket.appName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const TextSpan(
                          text: ' meminta izin untuk mengakses akun Anda.'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    print('you tapped: izinkan');
                    esuket.loginWithSso().then((res) {
                      print('loginWithSso: ${res.toString()}');
                      if (res['statusCode'] != 200) {
                        handleSnackbar(
                          context,
                          res['message']['message'].toString(),
                        );
                      }
                    });
                  },
                  label: esuket.isLoadingLogin
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check),
                  icon: const Text(
                    'Izinkan',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: .2),
                    ),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
