import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/widgets/form_upload_widget.dart';
import 'package:pecut/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

const String title = 'Surat Keterangan';
final _formKey = GlobalKey<FormState>();
final dio = Dio();

class EsuketSuketFormScreen extends StatefulWidget {
  final int? id;
  const EsuketSuketFormScreen({super.key, this.id});

  @override
  State<EsuketSuketFormScreen> createState() => _EsuketSuketFormScreenState();
}

class _EsuketSuketFormScreenState extends State<EsuketSuketFormScreen> {
  TextEditingController nikCtrl = TextEditingController();
  TextEditingController kepadaCtrl = TextEditingController();
  TextEditingController peruntukanCtrl = TextEditingController();
  TextEditingController keteranganCtrl = TextEditingController();
  TextEditingController pengantarCtrl = TextEditingController();
  File? fileUpload;
  bool isLoadingSubmit = false;

  Future handleFileUpload() async {
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
      // User canceled the picker
      print('filePicker: user canceled the picker!');
    }
  }

  Future handleSubmit() async {
    setState(() {
      isLoadingSubmit = true;
    });
    try {
      String? esuketToken = await EsuketController().getToken();
      FormData formData = FormData.fromMap({
        'nik': nikCtrl.text,
        'kepada': kepadaCtrl.text,
        'peruntukan': peruntukanCtrl.text,
        'keterangan': keteranganCtrl.text,
        'pengantar': await MultipartFile.fromFile(fileUpload!.path,
            filename: pengantarCtrl.text),
      });
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/suket';
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
      setState(() {
        isLoadingSubmit = false;
      });
    } on DioException catch (e) {
      setState(() {
        isLoadingSubmit = false;
      });
      print(
          'errorSubmit: ${e.response == null ? e.message : e.response?.data.toString()}');
    }
  }

  void handleSnackbar(BuildContext content, String message) {
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
    keteranganCtrl.dispose();
    pengantarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EsuketController>(
      builder: (context, esuket, child) {
        nikCtrl.text = esuket.user!.nik!;
        kepadaCtrl.text = esuket.user!.name!;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Form',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Buat $title',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
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
                                    iconData: Icons.co_present,
                                    isRequired: true,
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: peruntukanCtrl,
                                    labelText: 'Peruntukan',
                                    iconData: Icons.description,
                                    isRequired: true,
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: keteranganCtrl,
                                    labelText: 'Keterangan',
                                    iconData: Icons.web,
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
                                    onTap: () => handleFileUpload(),
                                    onDelete: () {
                                      setState(() {
                                        fileUpload = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 15),
                        ),
                        shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primary,
                        ),
                        overlayColor: WidgetStatePropertyAll(
                          Colors.black.withValues(alpha: .2),
                        ),
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {
                        if (pengantarCtrl.text.isEmpty) {
                          print('upload file dulu woy!!!');
                        }
                        if (_formKey.currentState!.validate() &&
                            fileUpload != null) {
                          print('you tapped the submit button');
                          handleSubmit();
                        }
                      },
                      label: const Icon(Icons.check),
                      icon: Text(
                        isLoadingSubmit
                            ? 'Processing...'
                            : (widget.id == null ? 'Submit' : 'Update'),
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
