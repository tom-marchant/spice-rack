import 'domain.dart';

class ConsumablesProvider {
  List<Consumable> _allConsumables;
  List<SelectedConsumable> _selectedConsumables;

  ConsumablesProvider(ConsumablesSource source) {
    _allConsumables = source.get()
        .map((storedConsumable) => Consumable(storedConsumable.name))
        .toList()
        ..sort();

    _selectedConsumables = source.get()
        .where((storedConsumable) => storedConsumable.userData != null)
        .toList()
        .map((storedConsumable) {
          var consumable = _allConsumables.firstWhere((consumable) => consumable.name == storedConsumable.name);
          return SelectedConsumable(consumable, storedConsumable.userData.level);
        })
        .toList()
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
        _selectedConsumables
            .add(SelectedConsumable.full(consumable));
        _selectedConsumables.sort();
      }
    } else {
      if (previouslySelected) {
        _selectedConsumables = _selectedConsumables.where((
            selectedConsumable) => selectedConsumable.consumable != consumable)
            .toList();
      }
    }
  }
}
