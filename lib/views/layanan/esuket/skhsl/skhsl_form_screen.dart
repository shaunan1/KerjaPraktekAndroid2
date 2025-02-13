import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/widgets/datepicker_button_widget.dart';
import 'package:pecut/widgets/dropdown_widget.dart';
import 'package:pecut/widgets/form_upload_widget.dart';
import 'package:pecut/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:terbilang_id/terbilang_id.dart';

const String title = 'Surat Keterangan Penghasilan';
final _formKey = GlobalKey<FormState>();
final dio = Dio();

class EsuketSkhslFormScreen extends StatefulWidget {
  final int? id;
  const EsuketSkhslFormScreen({super.key, this.id});

  @override
  State<EsuketSkhslFormScreen> createState() => _EsuketSkhslFormScreenState();
}

class _EsuketSkhslFormScreenState extends State<EsuketSkhslFormScreen> {
  TextEditingController nikCtrl = TextEditingController();
  TextEditingController kepadaCtrl = TextEditingController();
  TextEditingController peruntukanCtrl = TextEditingController();
  TextEditingController pengantarCtrl = TextEditingController();
  TextEditingController kepadaNamaAnakCtrl = TextEditingController();
  TextEditingController kepadaTempatLhrCtrl = TextEditingController();
  TextEditingController kepadaTglLhrCtrl = TextEditingController();
  TextEditingController kepadaGenderCtrl = TextEditingController();
  TextEditingController kepadaHubunganCtrl = TextEditingController();
  TextEditingController kepadaSekolahCtrl = TextEditingController();
  TextEditingController kepadaKelasCtrl = TextEditingController();
  TextEditingController kepadaAlamatSekolahCtrl = TextEditingController();
  TextEditingController penghasilanCtrl = TextEditingController();
  TextEditingController terbilangCtrl = TextEditingController();
  File? fileUpload;
  bool isLoadingSubmit = false;
  String? selectedValue;

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
        'peruntukan': peruntukanCtrl.text,
        'pengantar': await MultipartFile.fromFile(fileUpload!.path,
            filename: pengantarCtrl.text),
        'kepada': kepadaNamaAnakCtrl.text,
        'kepada_tempat_lhr': kepadaTempatLhrCtrl.text,
        'kepada_tgl_lhr': kepadaTglLhrCtrl.text,
        'kepada_gender': kepadaGenderCtrl.text,
        'kepada_hubungan': kepadaHubunganCtrl.text,
        'kepada_sekolah': kepadaSekolahCtrl.text,
        'kepada_kelas': kepadaKelasCtrl.text,
        'kepada_alamat_sekolah': kepadaAlamatSekolahCtrl.text,
        'penghasilan': penghasilanCtrl.text,
        'terbilang': terbilangCtrl.text,
      });
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skhsl';
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

  void handleNominal(String nominal, TextEditingController ctrl) {
    ctrl.text =
        Terbilang().terbilang(double.parse(nominal)).toUpperCase() + ' RUPIAH';
  }

  @override
  void dispose() {
    nikCtrl.dispose();
    kepadaCtrl.dispose();
    peruntukanCtrl.dispose();
    pengantarCtrl.dispose();
    kepadaNamaAnakCtrl.dispose();
    kepadaTempatLhrCtrl.dispose();
    kepadaTglLhrCtrl.dispose();
    kepadaGenderCtrl.dispose();
    kepadaHubunganCtrl.dispose();
    kepadaSekolahCtrl.dispose();
    kepadaKelasCtrl.dispose();
    kepadaAlamatSekolahCtrl.dispose();
    penghasilanCtrl.dispose();
    terbilangCtrl.dispose();
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
                                    labelText: 'Nama',
                                    iconData: Icons.more_horiz,
                                    isRequired: true,
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: peruntukanCtrl,
                                    labelText: 'Peruntukan',
                                    iconData: Icons.more_horiz,
                                    isRequired: true,
                                  ),
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
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextFormFieldWidget(
                                          attributeCtrl: kepadaTglLhrCtrl,
                                          labelText: 'Tanggal Lahir',
                                          iconData: Icons.more_horiz,
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
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: kepadaKelasCtrl,
                                    labelText: 'Kelas',
                                    iconData: Icons.more_horiz,
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: kepadaAlamatSekolahCtrl,
                                    labelText: 'Alamat Sekolah',
                                    iconData: Icons.more_horiz,
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: penghasilanCtrl,
                                    labelText: 'Penghasilan',
                                    iconData: Icons.more_horiz,
                                    textInputType: TextInputType.number,
                                    onChanged: (value) =>
                                        handleNominal(value, terbilangCtrl),
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: terbilangCtrl,
                                    labelText: 'Terbilang',
                                    iconData: Icons.more_horiz,
                                  ),
                                  const SizedBox(height: 75),
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
