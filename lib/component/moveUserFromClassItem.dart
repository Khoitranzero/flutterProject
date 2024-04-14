import 'package:flutter/material.dart';
import 'package:flutter_doan/model/user.dart';

class MoveUserClassItem extends StatefulWidget {
  final User user;
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  const MoveUserClassItem(
      {super.key,
      required this.user,
      required this.isChecked,
      required this.onChanged});

  @override
  State<MoveUserClassItem> createState() => _UserNotInclassCtemState();
}

class _UserNotInclassCtemState extends State<MoveUserClassItem> {
  bool _isChecked = false;
  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isChecked,
      onChanged: (value) {
        setState(() {
          _isChecked = value!;
          widget.onChanged(value);
        });
      },
    );
  }
}
