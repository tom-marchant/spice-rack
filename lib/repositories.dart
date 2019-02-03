import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'domain.dart';

abstract class ConsumablesRepository {
  Future<void> init();

  List<StoredConsumable> get();
  void save(List<StoredConsumable> storedConsumables);
}

class BasicConsumablesRepository extends ConsumablesRepository {
  List<StoredConsumable> _consumables;

  BasicConsumablesRepository(this._consumables);

  @override
  Future<void> init() {
    return Future.value(null);
  }

  @override
  List<StoredConsumable> get() {
    return _consumables;
  }

  @override
  void save(List<StoredConsumable> storedConsumables) {
    this._consumables = storedConsumables;
  }
}

class FileSystemConsumablesRepository extends ConsumablesRepository {
  List<StoredConsumable> _consumables;

  @override
  Future<void> init() async {
    File userConsumables = await _localFile;
    bool userHasSavedConsumables = await userConsumables.exists();

    if (!userHasSavedConsumables) {
      print("No saved consumables detected for user. Creating now");

      String defaultConsumables = await _defaultListFromAssets;
      userConsumables.writeAsStringSync(defaultConsumables);
    }

    this._consumables = _readJson(userConsumables.readAsStringSync());
    return Future.value(null);
  }

  @override
  void save(List<StoredConsumable> storedConsumables) async {
    File userConsumables = await _localFile;
    String json = _writeJson(storedConsumables);
    print("Saving JSON:\n$json");
    userConsumables.writeAsString(json, flush: true).then((file) {
      print("File saved: ${file.path}");
    });
  }

  Future<String> get _applicationDocumentsPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _applicationDocumentsPath;
    return File('$path/user-consumables.json');
  }

  Future<String> get _defaultListFromAssets async {
    return await rootBundle.loadString('assets/default-consumables.json');
  }

  @override
  List<StoredConsumable> get() {
    return _consumables;
  }
}

List<StoredConsumable> _readJson(String jsonStr) {
  Map<String, dynamic> json = jsonDecode(jsonStr);
  final consumablesJson = json['consumables'] as List;

  return consumablesJson.map((consumable) {
    return StoredConsumable.fromJson(consumable);
  }).toList();
}

String _writeJson(List<StoredConsumable> storedConsumables) {
  List<Map<String, dynamic>> encoded = storedConsumables.map((storedConsumable) {
    return storedConsumable.toJson();
  }).toList();

  Map wrapper = new Map();
  wrapper.putIfAbsent("consumables", () => encoded);

  return jsonEncode(wrapper);
}
