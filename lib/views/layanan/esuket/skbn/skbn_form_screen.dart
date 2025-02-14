// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/widgets/form_upload_widget.dart';
import 'package:pecut/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

const String title = 'Surat Keterangan Belum Menikah';
final _formKey = GlobalKey<FormState>();
final dio = Dio();

class EsuketSkbnFormScreen extends StatefulWidget {
  final int? id;
  const EsuketSkbnFormScreen({super.key, this.id});

  @override
  State<EsuketSkbnFormScreen> createState() => _EsuketSkbnFormScreenState();
}

class _EsuketSkbnFormScreenState extends State<EsuketSkbnFormScreen> {
  TextEditingController nikCtrl = TextEditingController();
  TextEditingController kepadaCtrl = TextEditingController();
  TextEditingController peruntukanCtrl = TextEditingController();
  TextEditingController pengantarCtrl = TextEditingController();
  File? fileUpload;
  bool isLoadingSubmit = false;

  Future<void> handleFileUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print('filePicker: ${file.path}');
      pengantarCtrl.text = result.files.first.name;
      setState(() {
        fileUpload = file;
      });
    } else {
      print('filePicker: user canceled the picker!');
    }
  }

  Future<void> handleSubmit() async {
    if (fileUpload == null) {
      handleSnackbar(context, 'Silakan upload file pengantar!');
      return;
    }

    setState(() {
      isLoadingSubmit = true;
    });

    try {
      String? esuketToken = await EsuketController().getToken();
      FormData formData = FormData.fromMap({
        'nik': nikCtrl.text,
        'kepada': kepadaCtrl.text,
        'peruntukan': peruntukanCtrl.text,
        'pengantar': await MultipartFile.fromFile(
          fileUpload!.path,
          filename: pengantarCtrl.text,
        ),
      });
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skbn';
      print('Request URL: $url');

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $esuketToken',
          },
        ),
      );

      handleSnackbar(context, response.data['message']);
    } on DioException catch (e) {
      print('errorSubmit: ${e.response?.data ?? e.message}');
      handleSnackbar(context, 'Gagal mengirim data. Coba lagi!');
    } finally {
      setState(() {
        isLoadingSubmit = false;
      });
    }
  }

  void handleSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    nikCtrl.dispose();
    kepadaCtrl.dispose();
    peruntukanCtrl.dispose();
    pengantarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EsuketController>(
      builder: (context, esuket, child) {
        nikCtrl.text = esuket.user?.nik ?? '';
        kepadaCtrl.text = esuket.user?.name ?? '';

        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(esuket.appName),
              scrolledUnderElevation: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Wrap(
                        runSpacing: 15,
                        children: [
                          TextFormFieldWidget(
                            attributeCtrl: nikCtrl,
                            labelText: 'NIK',
                            iconData: Icons.badge,
                            isRequired: true,
                          ),
                          TextFormFieldWidget(
                            attributeCtrl: kepadaCtrl,
                            labelText: 'Kepada',
                            iconData: Icons.person,
                            isRequired: true,
                          ),
                          TextFormFieldWidget(
                            attributeCtrl: peruntukanCtrl,
                            labelText: 'Peruntukan',
                            iconData: Icons.more_horiz,
                            isRequired: true,
                          ),
                          FormUploadWidget(
                            label: const Text.rich(
                              TextSpan(
                                text: 'Upload file pengantar',
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            fileImage: fileUpload,
                            onTap: handleFileUpload,
                            onDelete: () {
                              setState(() {
                                fileUpload = null;
                                pengantarCtrl.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 15),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          handleSubmit();
                        }
                      },
                      icon: isLoadingSubmit
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                          : const Icon(Icons.check),
                      label: Text(
                        isLoadingSubmit ? 'Processing...' : 'Submit',
                        style: const TextStyle(fontSize: 18),
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
