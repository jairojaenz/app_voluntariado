import 'package:flutter/material.dart';
import 'api_crud/api_service.dart';

class SelectUsersDialog extends StatefulWidget {
  final List<User> users;
  final List<String> selectedUserNames;

  const SelectUsersDialog(
      {Key? key, required this.users, required this.selectedUserNames})
      : super(key: key);

  @override
  _SelectUsersDialogState createState() => _SelectUsersDialogState();
}

class _SelectUsersDialogState extends State<SelectUsersDialog> {
  late List<String> _selectedUserNames;

  @override
  void initState() {
    super.initState();
    _selectedUserNames = List.from(widget.selectedUserNames);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Users'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.users.map((user) {
            return CheckboxListTile(
              title: Text('${user.fullName}'),
              subtitle: Text('(${user.email})'),
              value: _selectedUserNames.contains(user.fullName),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedUserNames.add(user.fullName);
                  } else {
                    _selectedUserNames.remove(user.fullName);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedUserNames);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
