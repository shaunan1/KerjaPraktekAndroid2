import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/views/auth/login_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showEmail = false;
  bool _showNik = false;

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

      if (!sso.isAuth) {
        return const LoginScreen();
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kartu Identitas
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: const NetworkImage(
                                'https://randomuser.me/api/portraits/men/64.jpg'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            sso.user.name!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(height: 30),
                        _buildProfileRow(
                          label: 'Emailo',
                          value:
                              _showEmail ? sso.user.email! : '******@****.***',
                          onTap: () {
                            setState(() {
                              _showEmail = !_showEmail;
                            });
                          },
                          isHidden: !_showEmail,
                        ),
                        const SizedBox(height: 10),
                        _buildProfileRow(
                          label: 'NIK (Nomor KTP)',
                          value:
                              _showNik ? sso.user.nik! : '**** **** **** ****',
                          onTap: () {
                            setState(() {
                              _showNik = !_showNik;
                            });
                          },
                          isHidden: !_showNik,
                        ),
                        const SizedBox(height: 10),
                        _buildProfileRow(
                          label: 'No. HP (WhatsApp)',
                          value: sso.user.phone!,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Preferensi',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Keluar dari aplikasi'),
                  onTap: () {
                    _showLogoutConfirmation(context, sso);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileRow({
    required String label,
    required String value,
    VoidCallback? onTap,
    bool isHidden = false,
  }) {
    String formattedValue = value;
    if (label == 'No. HP (WhatsApp)') {
      formattedValue = _formatPhone(value, isHidden);
    } else if (label == 'Email') {
      formattedValue = _formatEmail(value, isHidden);
    } else if (label == 'NIK (Nomor KTP)') {
      formattedValue = _formatNik(value, isHidden);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedValue,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          IconButton(
            icon: Icon(
              isHidden ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: onTap,
          ),
      ],
    );
  }

  String _formatPhone(String phone, bool isHidden) {
    if (isHidden)
      return '${phone.substring(0, 3)}****${phone.substring(phone.length - 3)}';
    return phone;
  }

  String _formatEmail(String email, bool isHidden) {
    if (isHidden) {
      final atIndex = email.indexOf('@');
      if (atIndex > 2) {
        final prefix = email.substring(0, 1);
        final suffix = email.substring(atIndex - 1, atIndex);
        return '$prefix****$suffix${email.substring(atIndex)}';
      }
    }
    return email;
  }

  String _formatNik(String nik, bool isHidden) {
    if (isHidden && nik.length > 6) {
      return '${nik.substring(0, 3)}****${nik.substring(nik.length - 3)}';
    }
    return nik;
  }

  void _showLogoutConfirmation(BuildContext context, SsoController sso) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/images/lottie/question.json',
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Keluar dari aplikasi?',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    'Ya',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    sso.logout().then((res) {
                      Navigator.pop(context);
                      print('logoutResponse: ${res.toString()}');
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
