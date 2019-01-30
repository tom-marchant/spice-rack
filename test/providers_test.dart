import 'package:flutter_test/flutter_test.dart';
import 'package:spice_rack/providers.dart';
import 'package:spice_rack/domain.dart';

void main() {
  final _storedConsumables = [
    StoredConsumable("Ground Coriander", null),
    StoredConsumable("Garam Masala", null),
    StoredConsumable("Marjoram", StoredConsumableUserData(Level.full)),
    StoredConsumable("Chinese Five Spice", StoredConsumableUserData(Level.low)),
    StoredConsumable("Chilli Powder", StoredConsumableUserData(Level.half)),
    StoredConsumable("Cajun", null)
  ];

  final _source = BasicConsumablesSource(_storedConsumables);
  final _provider = ConsumablesProvider(_source);

  test('Provides list of consumables in alphabetical order', () {

    var allConsumables = _provider.getAll();
    var selected = _provider.getSelected();

    expect(allConsumables.length, 6);
    expect(allConsumables.first.name, "Cajun");

    expect(selected.length, 3);
  });

  test('Provides a filtered list of consumables', () {
    var filtered = _provider.getFiltered("ch");
    expect(filtered.length, 2);

    filtered = _provider.getFiltered("CH");
    expect(filtered.length, 2);
  });

  test('Returns selected state correctly', () {
    expect(_provider.isSelected(Consumable("Marjoram")), true);
    expect(_provider.isSelected(Consumable("Garam Masala")), false);
  });
}
