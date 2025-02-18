import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Future handleFileUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      pengantarCtrl.text = result.files.first.name;
      setState(() {
        fileUpload = file;
      });
    }
  }

  Future handleSubmit() async {
    setState(() => isLoadingSubmit = true);
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
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $esuketToken',
        }),
      );
      handleSnackbar(context, response.data['message']);
    } catch (e) {
      handleSnackbar(context, 'Terjadi kesalahan saat mengirim data');
    }
    setState(() => isLoadingSubmit = false);
  }

  void handleSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EsuketController>(
      builder: (context, esuket, child) {
        nikCtrl.text = esuket.user!.nik!;
        kepadaCtrl.text = esuket.user!.name!;

        return Scaffold(
          appBar: AppBar(
            title: Text(esuket.appName,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            backgroundColor: Colors.blue.shade700,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Buat $title',
                    style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            iconData: Icons.description,
                            isRequired: true,
                          ),
                          FormUploadWidget(
                            label: const Text('Upload file pengantar *',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0))),
                            fileImage: fileUpload,
                            onTap: handleFileUpload,
                            onDelete: () => setState(() => fileUpload = null),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          fileUpload != null) {
                        handleSubmit();
                      } else {
                        handleSnackbar(context,
                            'Harap lengkapi semua data dan upload file!');
                      }
                    },
                    icon: isLoadingSubmit
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : const Icon(Icons.check, color: Colors.white),
                    label: Text(
                      isLoadingSubmit
                          ? 'Mengirim...'
                          : (widget.id == null ? 'Submit' : 'Update'),
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
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
