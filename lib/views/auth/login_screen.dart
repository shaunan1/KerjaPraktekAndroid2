import 'package:flutter/material.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

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
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 200, 223, 255)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage('assets/images/logo-app.png'),
                            height: 150,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Welcome to PECUT',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text('Portal Efisien Cepat Mudah Terpadu',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          const SizedBox(height: 30),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // Form email dengan underline style
                                TextFormField(
                                  controller: emailCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                    border:
                                        UnderlineInputBorder(), // Garis bawah seperti form password
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                // Form password tetap dengan underline style
                                TextFormField(
                                  controller: passwordCtrl,
                                  obscureText: _isSecure,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: InkWell(
                                      child: Icon(
                                        _isSecure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onTap: toggleSecure,
                                    ),
                                    border:
                                        const UnderlineInputBorder(), // Garis bawah
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                // Tombol login
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        sso
                                            .login(emailCtrl.text,
                                                passwordCtrl.text)
                                            .then((res) {
                                          handleSnackbar(
                                              res['message'].toString());
                                        });
                                      }
                                    },
                                    child: Text(
                                      sso.isLoadingLogin
                                          ? 'Processing...'
                                          : 'Login with SSO',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
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
