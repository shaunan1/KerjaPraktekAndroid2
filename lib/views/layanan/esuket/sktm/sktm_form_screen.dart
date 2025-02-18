// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/widgets/datepicker_button_widget.dart';
import 'package:pecut/widgets/dropdown_widget.dart';
import 'package:pecut/widgets/form_upload_widget.dart';
import 'package:pecut/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

const String title = 'Surat Keterangan Miskin';
final _formKey = GlobalKey<FormState>();
final dio = Dio();

class EsuketSktmFormScreen extends StatefulWidget {
  final int? id;
  const EsuketSktmFormScreen({super.key, this.id});

  @override
  State<EsuketSktmFormScreen> createState() => _EsuketSktmFormScreenState();
}

class _EsuketSktmFormScreenState extends State<EsuketSktmFormScreen> {
  TextEditingController nikCtrl = TextEditingController();
  TextEditingController peruntukanCtrl = TextEditingController();
  TextEditingController pengantarCtrl = TextEditingController();
  String registerAsCtrl = 'perorangan';
  TextEditingController kepadaCtrl = TextEditingController();

  // Other controllers
  TextEditingController kepadaNamaAnakCtrl = TextEditingController();
  TextEditingController kepadaTempatLhrCtrl = TextEditingController();
  TextEditingController kepadaTglLhrCtrl = TextEditingController();
  TextEditingController kepadaGenderCtrl = TextEditingController();
  TextEditingController kepadaHubunganCtrl = TextEditingController();
  TextEditingController kepadaSekolahCtrl = TextEditingController();
  TextEditingController kepadaKelasCtrl = TextEditingController();
  TextEditingController kepadaAlamatSekolahCtrl = TextEditingController();
  TextEditingController kategoriCtrl = TextEditingController();

  File? fileUpload;
  bool isLoadingSubmit = false;

  final genderItems = [
    MyDropDownItems(text: "LAKI-LAKI", value: "1"),
    MyDropDownItems(text: "PEREMPUAN", value: "2"),
  ];

  final hubunganItems = [
    MyDropDownItems(text: "Putranya", value: "Putranya"),
    MyDropDownItems(text: "Putrinya", value: "Putrinya"),
    MyDropDownItems(text: "Cucunya", value: "Cucunya"),
    MyDropDownItems(text: "Keluarga", value: "Keluarga"),
  ];

  final kategoriItems = [
    MyDropDownItems(text: "DTKS", value: "DTKS"),
    MyDropDownItems(text: "Non DTKS", value: "Non DTKS"),
  ];

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
    } else {
      print('File picker canceled by the user.');
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
        'peruntukan': peruntukanCtrl.text,
        'pengantar': await MultipartFile.fromFile(fileUpload!.path,
            filename: pengantarCtrl.text),
        'register_as': registerAsCtrl,
        'kepada': (registerAsCtrl == 'sekolah'
            ? kepadaNamaAnakCtrl.text
            : kepadaCtrl.text),
        'kepada_tempat_lhr': kepadaTempatLhrCtrl.text,
        'kepada_tgl_lhr': kepadaTglLhrCtrl.text,
        'kepada_gender': kepadaGenderCtrl.text,
        'kepada_hubungan': kepadaHubunganCtrl.text,
        'kepada_sekolah': kepadaSekolahCtrl.text,
        'kepada_kelas': kepadaKelasCtrl.text,
        'kepada_alamat_sekolah': kepadaAlamatSekolahCtrl.text,
        'kategori': kategoriCtrl.text,
      });
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/sktm';
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
  void initState() {
    super.initState();
    registerAsCtrl = 'perorangan';
  }

  @override
  void dispose() {
    nikCtrl.dispose();
    kepadaCtrl.dispose();
    peruntukanCtrl.dispose();
    pengantarCtrl.dispose();
    kepadaTempatLhrCtrl.dispose();
    kepadaTglLhrCtrl.dispose();
    kepadaGenderCtrl.dispose();
    kepadaHubunganCtrl.dispose();
    kepadaSekolahCtrl.dispose();
    kepadaKelasCtrl.dispose();
    kepadaAlamatSekolahCtrl.dispose();
    kategoriCtrl.dispose();
    super.dispose();
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
                          DropdownWidget(
                            dropDownItems: kategoriItems,
                            inputController: kategoriCtrl,
                            onChanged: (value) {
                              kategoriCtrl.text = value;
                            },
                            judul: "Kategori DTSKS",
                          ),
                          FormUploadWidget(
                            label: const Text('Upload file pengantar *',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0))),
                            fileImage: fileUpload,
                            onTap: handleFileUpload,
                            onDelete: () => setState(() => fileUpload = null),
                          ),
                          ToggleSwitch(
                            initialLabelIndex:
                                registerAsCtrl == 'perorangan' ? 0 : 1,
                            fontSize: 16,
                            minWidth: double.infinity,
                            minHeight: 55,
                            activeBgColor: [Colors.black.withAlpha(150)],
                            inactiveBgColor: Colors.white,
                            labels: const ['Perorangan', 'Sekolah'],
                            icons: const [Icons.person, Icons.apartment],
                            iconSize: 22,
                            onToggle: (index) {
                              setState(() {
                                registerAsCtrl =
                                    index == 0 ? 'perorangan' : 'sekolah';
                              });
                            },
                          ),
                          if (registerAsCtrl == 'sekolah') ...[
                            TextFormFieldWidget(
                              attributeCtrl: kepadaNamaAnakCtrl,
                              labelText: 'Nama Anak',
                              iconData: Icons.more_horiz,
                              isRequired: true,
                            ),
                            TextFormFieldWidget(
                              attributeCtrl: kepadaTempatLhrCtrl,
                              labelText: 'Tempat Lahir',
                              iconData: Icons.more_horiz,
                              isRequired: true,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextFormFieldWidget(
                                    attributeCtrl: kepadaTglLhrCtrl,
                                    labelText: 'Tanggal Lahir',
                                    iconData: Icons.calendar_today,
                                    isRequired: true,
                                  ),
                                ),
                                DatepickerButtonWidget(
                                    attributeCtrl: kepadaTglLhrCtrl),
                              ],
                            ),
                            DropdownWidget(
                              dropDownItems: genderItems,
                              inputController: kepadaGenderCtrl,
                              onChanged: (value) {
                                kepadaGenderCtrl.text = value;
                              },
                              judul: "Jenis Kelamin",
                            ),
                            DropdownWidget(
                              dropDownItems: hubunganItems,
                              inputController: kepadaHubunganCtrl,
                              onChanged: (value) {
                                kepadaHubunganCtrl.text = value;
                              },
                              judul: "Hubungan Keluarga",
                            ),
                            TextFormFieldWidget(
                              attributeCtrl: kepadaSekolahCtrl,
                              labelText: 'Nama Sekolah',
                              iconData: Icons.more_horiz,
                              isRequired: true,
                            ),
                            TextFormFieldWidget(
                              attributeCtrl: kepadaKelasCtrl,
                              labelText: 'Kelas',
                              iconData: Icons.more_horiz,
                              isRequired: true,
                            ),
                            TextFormFieldWidget(
                              attributeCtrl: kepadaAlamatSekolahCtrl,
                              labelText: 'Alamat Sekolah',
                              iconData: Icons.more_horiz,
                              isRequired: true,
                            ),
                          ],
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
