import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final Function(String) onChanged;
  final String selectedSemester;

  CustomDropdownButton(
      {required this.onChanged, required this.selectedSemester});

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String _selectedItem = 'Học kỳ 1';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.only(
          right: MediaQuery.of(context).size.width *
              0.1), 
      alignment: Alignment.centerRight,
      child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: DropdownButton<String>(
            value: widget.selectedSemester,
            onChanged: (String? newValue) {
              setState(() {
                _selectedItem = newValue!;
                widget.onChanged(newValue!);
              });
            },
            items: <String>['Học kỳ 1', 'Học kỳ 2']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )),
    );
  }
}
