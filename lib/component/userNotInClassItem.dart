import 'package:flutter/material.dart';
import 'package:flutter_doan/model/user.dart';

class UserNotInClassItem extends StatefulWidget {
  final User user;
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  const UserNotInClassItem(
      {super.key,
      required this.user,
      required this.isChecked,
      required this.onChanged});

  @override
  State<UserNotInClassItem> createState() => _UserNotInclassCtemState();
}

class _UserNotInclassCtemState extends State<UserNotInClassItem> {
  bool _isChecked = false;
  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.user.toString()),
        trailing: Transform.scale(
          scale: 1.5,
          child: Checkbox(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
                widget.onChanged(value);
              });
            },
          ),
        ));
  }
}
