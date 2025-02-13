import 'package:flutter/material.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/views/auth/login_screen.dart';
import 'package:pecut/views/layanan/esuket/esuket_authorized_widget.dart';
import 'package:pecut/views/layanan/esuket/esuket_services_widget.dart';
import 'package:provider/provider.dart';

class EsuketScreen extends StatelessWidget {
  const EsuketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SsoController, EsuketController>(
      builder: (context, sso, esuket, child) {
        if (!sso.isAuth) {
          return const LoginScreen();
        }

        if (esuket.isLoadingUser) {
          return Scaffold(
            appBar: AppBar(
              title: Text(esuket.appName),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              esuket.appName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: esuket.isAuth
              ? const EsuketServicesWidget()
              : const Center(
                  child: EsuketAuthorizedWidget(),
                ),
        );
      },
    );
  }
}
