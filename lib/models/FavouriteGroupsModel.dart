import 'package:flutter/foundation.dart';
import 'dart:collection';

import '../utils/dto.dart' show Group;

class FavouriteGroupsModel extends ChangeNotifier {
  final Set<Group> _favouriteGroups = {};

  UnmodifiableListView<Group> get favouriteGroups =>
      UnmodifiableListView<Group>(_favouriteGroups);

  void add(Group group) {
    if (!_favouriteGroups.contains(group)) {
      _favouriteGroups.add(group);
      notifyListeners();
    }
  }

  void remove(Group group) {
    if (_favouriteGroups.contains(group)) {
      _favouriteGroups.remove(group);
      notifyListeners();
    }
  }

  bool contains(Group group) {
    return _favouriteGroups.contains(group);
  }
}
