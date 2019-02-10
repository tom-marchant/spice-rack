import 'dart:collection';

import 'domain.dart';
import 'repositories.dart';

class ConsumablesProvider {
  ConsumablesRepository _repository;
  SplayTreeMap<String, Consumable> _allConsumables;
  List<SelectedConsumable> _selectedConsumables;

  ConsumablesProvider(this._repository) {
    List<StoredConsumable> storedConsumables = this._repository.get();

    List<Consumable> _rawConsumables = storedConsumables
        .map((storedConsumable) => Consumable(storedConsumable.name))
        .toList();

    _allConsumables = SplayTreeMap.fromIterables(
        _rawConsumables.map((c) => c.name).toList(), _rawConsumables);

    _selectedConsumables = storedConsumables
        .where((storedConsumable) => storedConsumable.userData != null)
        .toList()
        .map((storedConsumable) {
      var consumable = _allConsumables[storedConsumable.name];
      return SelectedConsumable(consumable, storedConsumable.userData.level);
    }).toList()
          ..sort();
  }

  List<Consumable> getAll() {
    return _allConsumables.values.toList();
  }

  List<SelectedConsumable> getSelected() {
    return _selectedConsumables;
  }

  List<Consumable> getFiltered(String filter) {
    filter = filter.toLowerCase();
    return _allConsumables.values
        .where((consumable) => consumable.name.toLowerCase().contains(filter))
        .toList();
  }

  bool isSelected(Consumable consumable) {
    return _selectedConsumables.map((f) => f.consumable).contains(consumable);
  }

  void setSelected(Consumable consumable, bool selected) {
    bool previouslySelected = isSelected(consumable);

    if (selected) {
      if (!previouslySelected) {
        _selectedConsumables.add(SelectedConsumable.full(consumable));
        _selectedConsumables.sort();
      }
    } else {
      if (previouslySelected) {
        _selectedConsumables = _selectedConsumables
            .where((selectedConsumable) =>
                selectedConsumable.consumable != consumable)
            .toList();
      }
    }

    this._repository.save(buildStoredConsumables());
  }

  void cycleLevel(SelectedConsumable selectedConsumable) {
    selectedConsumable.cycleLevel();
    this._repository.save(buildStoredConsumables());
  }

  List<StoredConsumable> buildStoredConsumables() {
    return _allConsumables.values.map((consumable) {
      StoredConsumableUserData userData;

      if (isSelected(consumable)) {
        SelectedConsumable selectedConsumable = _selectedConsumables
            .firstWhere((sc) => sc.consumable == consumable);

        userData = StoredConsumableUserData(selectedConsumable.level);
      }

      return StoredConsumable(consumable.name, userData);
    }).toList();
  }

  void add(String name) {
    var newConsumable = Consumable(name);
    _allConsumables.putIfAbsent(name, () => newConsumable);
    _selectedConsumables.add(SelectedConsumable.full(newConsumable));
    this._repository.save(buildStoredConsumables());
  }
}
