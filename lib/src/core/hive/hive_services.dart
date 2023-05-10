import 'dart:developer';

import 'package:hive/hive.dart';

// @lazySingleton
class HiveService {
  isBoxExists({required String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  storeDataToHiveBox(name, value, String boxName) async {
    final openBox = await Hive.openBox(boxName);

    await openBox.put(name, value);
    log("$value", name: "GETTING DATA FROM BOX $boxName , with key: $name  FROM HIVE SERVICES");
  }

  getDataFromHiveBox(name, String boxName) async {
    final openBox = await Hive.openBox(boxName);
    final result = await openBox.get(name);
    log("$result", name: "GETTING DATA FROM BOX $boxName  , with key : $name FROM HIVE SERVICES");
    return result;
  }
}
