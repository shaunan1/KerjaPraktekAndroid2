import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MyDropDownItems {
  MyDropDownItems({
    required this.text,
    required this.value,
  });

  String text;
  String value;

  @override
  String toString() {
    return value;
  }
}

class DropdownWidget extends StatefulWidget {
  final List<MyDropDownItems> dropDownItems;
  final TextEditingController inputController;
  final Function onChanged;
  final String judul;
  const DropdownWidget({
    super.key,
    required this.dropDownItems,
    required this.inputController,
    required this.onChanged,
    required this.judul,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  // ignore: unused_field
  String _dropdownvalue = ' ';
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          Icons.more_horiz,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      hint: Text.rich(
        TextSpan(
          text: widget.judul,
          children: [
            TextSpan(
              text: ' *',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      items: widget.dropDownItems.map((MyDropDownItems myDropDownItems) {
        return DropdownMenuItem(
          value: myDropDownItems.value,
          child: Text(myDropDownItems.text),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Mohon Pilih Terlebih Dahulu.';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _dropdownvalue = value!;
        });
        widget.onChanged(_dropdownvalue);
      },
      onSaved: (value) {
        selectedValue = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      dropdownSearchData: DropdownSearchData(
          searchController: widget.inputController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: widget.inputController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Cari...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            final myItem = widget.dropDownItems
                .firstWhere((element) => element.value == item.value);
            return myItem.text
                    .toLowerCase()
                    .contains(searchValue.toLowerCase()) ||
                item.value
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
          }),
      onMenuStateChange: (isOpen) {
        if (!isOpen) {
          widget.inputController.clear();
        }
      },
    );
  }
}
