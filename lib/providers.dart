import 'domain.dart';
import 'repositories.dart';

class ConsumablesProvider {
  ConsumablesRepository _repository;
  List<Consumable> _allConsumables;
  List<SelectedConsumable> _selectedConsumables;

  ConsumablesProvider(this._repository) {
    List<StoredConsumable> storedConsumables = this._repository.get();

    _allConsumables = storedConsumables
        .map((storedConsumable) => Consumable(storedConsumable.name))
        .toList()
          ..sort();

    _selectedConsumables = storedConsumables
        .where((storedConsumable) => storedConsumable.userData != null)
        .toList()
        .map((storedConsumable) {
      var consumable = _allConsumables
          .firstWhere((consumable) => consumable.name == storedConsumable.name);
      return SelectedConsumable(consumable, storedConsumable.userData.level);
    }).toList()
          ..sort();
  }

  List<Consumable> getAll() {
    return _allConsumables;
  }

  List<SelectedConsumable> getSelected() {
    return _selectedConsumables;
  }

  List<Consumable> getFiltered(String filter) {
    filter = filter.toLowerCase();
    return _allConsumables
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
    return _allConsumables.map((consumable) {
      StoredConsumableUserData userData;

      if (isSelected(consumable)) {
        SelectedConsumable selectedConsumable = _selectedConsumables
            .firstWhere((sc) => sc.consumable == consumable);

        userData = StoredConsumableUserData(selectedConsumable.level);
      }

      return StoredConsumable(consumable.name, userData);
    }).toList();
  }
}
