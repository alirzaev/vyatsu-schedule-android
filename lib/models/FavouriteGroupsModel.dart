import 'package:flutter/foundation.dart';

import '../utils/dto.dart' show Group;
import '../repository/Database.dart' show DBProvider;

class FavouriteGroupsModel extends ChangeNotifier {
  Future<List<Group>> get favouriteGroups async =>
      DBProvider.db.all();

  Future<void> add(Group group) async {
    bool exist = await DBProvider.db.exist(group);
    if (!exist) {
      await DBProvider.db.insert(group);
      notifyListeners();
    }
  }

  Future<void> remove(Group group) async {
      await DBProvider.db.delete(group);
      notifyListeners();
  }

  Future<bool> contains(Group group) async {
    return (await DBProvider.db.exist(group));
  }
}
