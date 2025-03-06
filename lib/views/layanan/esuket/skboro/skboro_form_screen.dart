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
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

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
  TextEditingController nikPengikutCtrl = TextEditingController();
  TextEditingController namaPengikutCtrl = TextEditingController();
  TextEditingController genderPengikutCtrl = TextEditingController();
  TextEditingController umurPengikutCtrl = TextEditingController();
  TextEditingController perkawinanPengikutCtrl = TextEditingController();
  TextEditingController hubunganPengikutCtrl = TextEditingController();

  File? fileUpload;
  bool isLoadingSubmit = false;
  String? selectedValue;
  // String _prop = '';
  // String _kabko = '';
  // String _kec = '';
  // String _kel = '';

  List<String> _pengikutNIK = [];
  List<String> _pengikutNama = [];
  List<String> _pengikutGender = [];
  List<String> _pengikutUmur = [];
  List<String> _pengikutPerkawinan = [];
  List<String> _pengikutHubungan = [];

  final genderList = ['LAKI-LAKI', 'PEREMPUAN'];
  final perkawinanList = [
    "KAWIN",
    "BELUM KAWIN",
    "CERAI HIDUP",
    "CERAI MATI",
  ];

  final genderItems = [
    MyDropDownItems(text: "LAKI-LAKI", value: "1"),
    MyDropDownItems(text: "PEREMPUAN", value: "2"),
  ];

  final perkawinanItems = [
    MyDropDownItems(text: "KAWIN", value: "1"),
    MyDropDownItems(text: "BELUM KAWIN", value: "2"),
    MyDropDownItems(text: "CERAI HIDUP", value: "3"),
    MyDropDownItems(text: "CERAI MATI", value: "4"),
  ];

  final hubunganItems = [
    MyDropDownItems(text: "KEPALA KELUARGA", value: "KEPALA KELUARGA"),
    MyDropDownItems(text: "SUAMI", value: "SUAMI"),
    MyDropDownItems(text: "ISTERI", value: "ISTERI"),
    MyDropDownItems(text: "ANAK", value: "ANAK"),
    MyDropDownItems(text: "MENANTU", value: "MENANTU"),
    MyDropDownItems(text: "CUCU", value: "CUCU"),
    MyDropDownItems(text: "ORANG TUA", value: "ORANG TUA"),
    MyDropDownItems(text: "MERTUA", value: "MERTUA"),
    MyDropDownItems(text: "FAMILI LAIN", value: "FAMILI LAIN"),
    MyDropDownItems(text: "PEMBANTU", value: "PEMBANTU"),
    MyDropDownItems(text: "LAINNYA", value: "LAINNYA"),
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
        'provinsi_boro': propinsiCtrl.text,
        'kabko_boro': kabkoCtrl.text,
        'kecamatan_boro': kecamatanCtrl.text,
        'kelurahan_boro': kelurahanCtrl.text,
        'alamat_boro': alamatCtrl.text,
        'tgl_awal': tglMulaiCtrl.text,
        'tgl_akhir': tglSelesaiCtrl.text,
        'add_nik[]': _pengikutNIK,
        'add_nama[]': _pengikutNama,
        'add_jk[]': _pengikutGender,
        'add_umr[]': _pengikutUmur,
        'add_stat[]': _pengikutPerkawinan,
        'add_hub[]': _pengikutHubungan,
        'peruntukan': peruntukanCtrl.text,
        'pengantar': await MultipartFile.fromFile(fileUpload!.path,
            filename: pengantarCtrl.text),
      });
      // print(kecamatanCtrl.text);
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skboro';
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bepergian/Boro ke',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SearchableDropdownFormField.paginated(
                                    backgroundDecoration: (child) => Card(
                                      margin: EdgeInsets.zero,
                                      color: Colors.white,
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: child,
                                      ),
                                    ),
                                    hintText: const Text('Search Propinsi'),
                                    paginatedRequest:
                                        (int page, String? searchKey) async {
                                      final List paginatedList =
                                          await getPropList(key: searchKey);
                                      return paginatedList
                                          .map(
                                            (e) => SearchableDropdownMenuItem(
                                              value: e['id'],
                                              label: e['text'] ?? '',
                                              child: Text(e['text'] ?? ''),
                                            ),
                                          )
                                          .toList();
                                    },
                                    validator: (val) {
                                      if (val == null) return 'Cant be empty';
                                      return null;
                                    },
                                    onChanged: (val) {
                                      // _prop = val.toString();
                                      propinsiCtrl.text = val.toString();
                                    },
                                  ),
                                  SearchableDropdownFormField.paginated(
                                    backgroundDecoration: (child) => Card(
                                      margin: EdgeInsets.zero,
                                      color: Colors.white,
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: child,
                                      ),
                                    ),
                                    hintText: const Text('Search Kabko'),
                                    paginatedRequest:
                                        (int page, String? searchKey) async {
                                      final List paginatedList =
                                          await getKabkoList(
                                              key: searchKey,
                                              kode: propinsiCtrl.text);
                                      return paginatedList
                                          .map(
                                            (e) => SearchableDropdownMenuItem(
                                              value: e['id'],
                                              label: e['text'] ?? '',
                                              child: Text(e['text'] ?? ''),
                                            ),
                                          )
                                          .toList();
                                    },
                                    validator: (val) {
                                      if (val == null) return 'Cant be empty';
                                      return null;
                                    },
                                    onChanged: (val) {
                                      // _prop = val.toString();
                                      kabkoCtrl.text = val.toString();
                                    },
                                  ),
                                  SearchableDropdownFormField.paginated(
                                    backgroundDecoration: (child) => Card(
                                      margin: EdgeInsets.zero,
                                      color: Colors.white,
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: child,
                                      ),
                                    ),
                                    hintText: const Text('Search Kecamatan'),
                                    paginatedRequest:
                                        (int page, String? searchKey) async {
                                      final List paginatedList =
                                          await getKecamatanList(
                                              key: searchKey,
                                              kode: kabkoCtrl.text);
                                      return paginatedList
                                          .map(
                                            (e) => SearchableDropdownMenuItem(
                                              value: e['id'],
                                              label: e['text'] ?? '',
                                              child: Text(e['text'] ?? ''),
                                            ),
                                          )
                                          .toList();
                                    },
                                    validator: (val) {
                                      if (val == null) return 'Cant be empty';
                                      return null;
                                    },
                                    onChanged: (val) {
                                      // _prop = val.toString();
                                      kecamatanCtrl.text = val.toString();
                                    },
                                  ),
                                  SearchableDropdownFormField.paginated(
                                    backgroundDecoration: (child) => Card(
                                      margin: EdgeInsets.zero,
                                      color: Colors.white,
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: child,
                                      ),
                                    ),
                                    hintText: const Text('Search Kelurahan'),
                                    paginatedRequest:
                                        (int page, String? searchKey) async {
                                      final List paginatedList =
                                          await getKelurahanList(
                                              key: searchKey,
                                              kode: kecamatanCtrl.text);
                                      return paginatedList
                                          .map(
                                            (e) => SearchableDropdownMenuItem(
                                              value: e['id'],
                                              label: e['text'] ?? '',
                                              child: Text(e['text'] ?? ''),
                                            ),
                                          )
                                          .toList();
                                    },
                                    validator: (val) {
                                      if (val == null) return 'Cant be empty';
                                      return null;
                                    },
                                    onChanged: (val) {
                                      // _prop = val.toString();
                                      kelurahanCtrl.text = val.toString();
                                    },
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: alamatCtrl,
                                    labelText: 'Alamat',
                                    iconData: Icons.more_horiz,
                                    isRequired: true,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextFormFieldWidget(
                                          attributeCtrl: tglMulaiCtrl,
                                          labelText: 'Tanggal Mulai',
                                          iconData: Icons.more_horiz,
                                        ),
                                      ),
                                      DatepickerButtonWidget(
                                          attributeCtrl: tglMulaiCtrl),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextFormFieldWidget(
                                          attributeCtrl: tglSelesaiCtrl,
                                          labelText: 'Tanggal Selesai',
                                          iconData: Icons.more_horiz,
                                        ),
                                      ),
                                      DatepickerButtonWidget(
                                          attributeCtrl: tglSelesaiCtrl),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Data Pengikut',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: nikPengikutCtrl,
                                    labelText: 'NIK',
                                    iconData: Icons.badge,
                                    isRequired: false,
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: namaPengikutCtrl,
                                    labelText: 'Nama',
                                    iconData: Icons.more_horiz,
                                    isRequired: false,
                                  ),
                                  DropdownWidget(
                                    dropDownItems: genderItems,
                                    inputController: genderPengikutCtrl,
                                    onChanged: (value) {
                                      genderPengikutCtrl.text = value;
                                    },
                                    judul: "Jenis Kelamin",
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: umurPengikutCtrl,
                                    labelText: 'Umur',
                                    iconData: Icons.more_horiz,
                                    isRequired: false,
                                  ),
                                  DropdownWidget(
                                    dropDownItems: perkawinanItems,
                                    inputController: perkawinanPengikutCtrl,
                                    onChanged: (value) {
                                      perkawinanPengikutCtrl.text = value;
                                    },
                                    judul: "Status Perkawinan",
                                  ),
                                  DropdownWidget(
                                    dropDownItems: hubunganItems,
                                    inputController: hubunganPengikutCtrl,
                                    onChanged: (value) {
                                      hubunganPengikutCtrl.text = value;
                                    },
                                    judul: "Hubungan Keluarga",
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton.icon(
                                      label: Text.rich(
                                          TextSpan(text: 'Tambah Pengikut')),
                                      icon: const Icon(Icons.person_add),
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.green.withValues(alpha: .9),
                                        ),
                                        foregroundColor:
                                            const WidgetStatePropertyAll(
                                                Colors.white),
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _pengikutNIK
                                              .add(nikPengikutCtrl.text);
                                          _pengikutNama
                                              .add(namaPengikutCtrl.text);
                                          _pengikutGender
                                              .add(genderPengikutCtrl.text);
                                          _pengikutUmur
                                              .add(umurPengikutCtrl.text);
                                          _pengikutPerkawinan
                                              .add(perkawinanPengikutCtrl.text);
                                          _pengikutHubungan
                                              .add(hubunganPengikutCtrl.text);
                                          nikPengikutCtrl.clear();
                                          namaPengikutCtrl.clear();
                                          genderPengikutCtrl.clear();
                                          umurPengikutCtrl.clear();
                                          perkawinanPengikutCtrl.clear();
                                          hubunganPengikutCtrl.clear();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    child: ListView.builder(
                                      itemCount: _pengikutNIK.length,
                                      itemBuilder: _itemPengikutBuilder,
                                      shrinkWrap: true,
                                    ),
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
                        // print(_pengikutNIK);
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

  Future getPropList({String? key}) async {
    try {
      String url =
          "${dotenv.env['ESUKET_BASE_URL']}/api/provinsi?term=$key&_type=query&q=$key";
      if (key != null && key.isNotEmpty) url += "&q=$key";
      var response = await dio.get(url);
      if (response.statusCode != 200) throw Exception(response.statusMessage);
      return response.data;
    } catch (exception) {
      throw Exception(exception);
    }
  }

  Future getKabkoList({String? key, String? kode}) async {
    try {
      String url =
          "${dotenv.env['ESUKET_BASE_URL']}/api/kabko?kode_provinsi=$kode&term=$key&_type=query&q=$key";
      if (key != null && key.isNotEmpty) url += "&q=$key";
      var response = await dio.get(url);
      if (response.statusCode != 200) throw Exception(response.statusMessage);
      return response.data;
    } catch (exception) {
      throw Exception(exception);
    }
  }

  Future getKecamatanList({String? key, String? kode}) async {
    try {
      String url =
          "${dotenv.env['ESUKET_BASE_URL']}/api/kecamatan?kode_kabkota=$kode&term=$key&_type=query&q=$key";
      print(url);
      if (key != null && key.isNotEmpty) url += "&q=$key";
      var response = await dio.get(url);
      if (response.statusCode != 200) throw Exception(response.statusMessage);
      return response.data;
    } catch (exception) {
      throw Exception(exception);
    }
  }

  Future getKelurahanList({String? key, String? kode}) async {
    try {
      String url =
          "${dotenv.env['ESUKET_BASE_URL']}/api/kelurahan?kode_kecamatan=$kode&term=$key&_type=query&q=$key";
      if (key != null && key.isNotEmpty) url += "&q=$key";
      var response = await dio.get(url);
      if (response.statusCode != 200) throw Exception(response.statusMessage);
      return response.data;
    } catch (exception) {
      throw Exception(exception);
    }
  }

  Widget _itemPengikutBuilder(BuildContext context, int index) {
    return Card(
      child: Wrap(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ContentWidget(
                  value: _pengikutNIK[index],
                  label: 'NIK:',
                ),
              ),
              Expanded(
                child: ContentWidget(
                  value: _pengikutNama[index],
                  label: 'Nama:',
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ContentWidget(
                  value: genderList[int.parse(_pengikutGender[index]) - 1],
                  label: 'Jenis Kelamin:',
                ),
              ),
              Expanded(
                child: ContentWidget(
                  value: _pengikutUmur[index],
                  label: 'Umur:',
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ContentWidget(
                  value:
                      perkawinanList[int.parse(_pengikutPerkawinan[index]) - 1],
                  label: 'Status:',
                ),
              ),
              Expanded(
                child: ContentWidget(
                  value: _pengikutHubungan[index],
                  label: 'Hubungan:',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  final dynamic value;
  final String label;
  const ContentWidget({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
