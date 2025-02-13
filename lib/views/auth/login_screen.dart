// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

const int alpha = 25;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool _isSecure = true;

  void toggleSecure() {
    setState(() {
      _isSecure = !_isSecure;
    });
  }

  void handleSnackbar(String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(body),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SsoController>(
      builder: (context, sso, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Login'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      'PECUT',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Text(
                      'Portal Efisien Cepat Mudah Terpadu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const Text(
                      'Pemerintah Kota Kediri',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const Image(
                      image: AssetImage('assets/images/logo-app.png'),
                      height: 250,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormFieldWidget(
                            attributeCtrl: emailCtrl,
                            labelText: 'Email',
                            iconData: Icons.person,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: passwordCtrl,
                            obscureText: _isSecure,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              suffixIcon: InkWell(
                                child: Icon(
                                  _isSecure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey[400],
                                ),
                                onTap: () => toggleSecure(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password field is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 15),
                                ),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                                backgroundColor: WidgetStatePropertyAll(
                                  sso.isLoadingLogin
                                      ? Colors.black38
                                      : Colors.black,
                                ),
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.white),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  sso
                                      .login(emailCtrl.text, passwordCtrl.text)
                                      .then((res) {
                                    handleSnackbar(res['message'].toString());
                                  });
                                }
                              },
                              child: Text(sso.isLoadingLogin
                                  ? 'Processing...'
                                  : 'Login with SSO'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
