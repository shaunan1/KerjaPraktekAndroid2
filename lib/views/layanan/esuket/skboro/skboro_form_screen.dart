// ignore_for_file: avoid_print, use_build_context_synchronously

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
import 'package:intl/intl.dart';

const String title = 'Surat Keterangan Boro';
final _formKey = GlobalKey<FormState>();
final dio = Dio();

class EsuketSkboroFormScreen extends StatefulWidget {
  final int? id;
  const EsuketSkboroFormScreen({super.key, this.id});

  @override
  State<EsuketSkboroFormScreen> createState() => _EsuketSkboroFormScreenState();
}

class _EsuketSkboroFormScreenState extends State<EsuketSkboroFormScreen> {
  TextEditingController nikCtrl = TextEditingController();
  TextEditingController kepadaCtrl = TextEditingController();
  TextEditingController peruntukanCtrl = TextEditingController();
  TextEditingController propinsiCtrl = TextEditingController();
  TextEditingController kabkoCtrl = TextEditingController();
  TextEditingController kecamatanCtrl = TextEditingController();
  TextEditingController kelurahanCtrl = TextEditingController();
  TextEditingController alamatCtrl = TextEditingController();
  TextEditingController tglMulaiCtrl = TextEditingController();
  TextEditingController tglSelesaiCtrl = TextEditingController();
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
        'provinsi_boro': propinsiCtrl.text,
        'kabko_boro': kabkoCtrl.text,
        'kecamatan_boro': kecamatanCtrl.text,
        'kelurahan_boro': kelurahanCtrl.text,
        'alamat_boro': alamatCtrl.text,
        'tgl_awal': tglMulaiCtrl.text,
        'tgl_akhir': tglSelesaiCtrl.text,
        'pengantar': await MultipartFile.fromFile(
          fileUpload!.path,
          filename: pengantarCtrl.text,
        ),
      });
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skboro';
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

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
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
                          TextFormFieldWidget(
                            attributeCtrl: propinsiCtrl,
                            labelText: 'Propinsi',
                            iconData: Icons.location_on,
                            isRequired: true,
                          ),
                          TextFormFieldWidget(
                            attributeCtrl: kabkoCtrl,
                            labelText: 'Kabupaten/Kota',
                            iconData: Icons.location_city,
                            isRequired: true,
                          ),
                          TextFormFieldWidget(
                            attributeCtrl: kecamatanCtrl,
                            labelText: 'Kecamatan',
                            iconData: Icons.map,
                            isRequired: true,
                          ),
                          TextFormFieldWidget(
                            attributeCtrl: kelurahanCtrl,
                            labelText: 'Kelurahan',
                            iconData: Icons.place,
                            isRequired: true,
                          ),
                          TextFormFieldWidget(
                            attributeCtrl: alamatCtrl,
                            labelText: 'Alamat',
                            iconData: Icons.home,
                            isRequired: true,
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(tglMulaiCtrl),
                            child: AbsorbPointer(
                              child: TextFormFieldWidget(
                                attributeCtrl: tglMulaiCtrl,
                                labelText: 'Tanggal Mulai',
                                iconData: Icons.calendar_today,
                                isRequired: true,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(tglSelesaiCtrl),
                            child: AbsorbPointer(
                              child: TextFormFieldWidget(
                                attributeCtrl: tglSelesaiCtrl,
                                labelText: 'Tanggal Selesai',
                                iconData: Icons.calendar_today,
                                isRequired: true,
                              ),
                            ),
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
