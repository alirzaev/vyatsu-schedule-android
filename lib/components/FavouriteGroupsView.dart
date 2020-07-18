import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/GroupScheduleScreen.dart';
import '../models/FavouriteGroupsModel.dart';
import '../utils/dto.dart' show Group;

class FavouriteGroupsView extends StatelessWidget {
  void _pushGroupSchedule(BuildContext context, Group group) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GroupScheduleScreen(
        group: group,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteGroupsModel>(
      builder: (context, favouriteGroupsModel, child) {
        final favouriteGroups = favouriteGroupsModel.favouriteGroups.toList();

        return ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  title: Text(favouriteGroups[index].name),
                  onTap: () {
                    _pushGroupSchedule(context, favouriteGroups[index]);
                  },
                ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: favouriteGroups.length);
      },
    );
  }
}
