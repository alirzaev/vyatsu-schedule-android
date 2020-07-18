import 'package:flutter/material.dart';

import 'GroupScheduleScreen.dart';

import '../utils/dto.dart' show Group;

class GroupChooserScreen extends StatelessWidget {
  final List<Group> _groups;

  GroupChooserScreen(this._groups);

  void _pushGroupSchedule(BuildContext context, Group group) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GroupScheduleScreen(group: group)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Выберите группу')),
        body: Center(
            child: ListView.separated(
                itemBuilder: (contex, index) => ListTile(
                      title: Text(_groups[index].name),
                      onTap: () {
                        _pushGroupSchedule(context, _groups[index]);
                      },
                    ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: _groups.length)));
  }
}
