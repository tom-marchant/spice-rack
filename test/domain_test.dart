import 'package:flutter_test/flutter_test.dart';
import 'package:spice_rack/domain.dart';

import 'dart:convert';
import 'dart:io';

void main() {
  test('Parses StoredConsumable list from JSON', () {
    final file = new File('assets/default-consumables.json');
    Map<String, dynamic> json = jsonDecode(file.readAsStringSync());

    final consumablesJson = json['consumables'] as List;

    List<StoredConsumable> storedConsumables = consumablesJson.map((consumable) {
      return StoredConsumable.fromJson(consumable);
    }).toList();

    expect(storedConsumables.isNotEmpty, true);
    expect(storedConsumables[0].name, "Ground Coriander");
    expect(storedConsumables[0].userData.level, Level.full);

    expect(storedConsumables[1].name, "Marjoram");
    expect(storedConsumables[1].userData, null);
  });
}
