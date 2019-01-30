import 'domain.dart';

final consumables = [
  Consumable("Garam Masala"),
  Consumable("Ground Coriander"),
  Consumable("Marjoram"),
  Consumable("Chilli Powder"),
  Consumable("Mixed Herbs"),
  Consumable("Cajun"),
  Consumable("Fajita"),
  Consumable("Cumin Seeds"),
  Consumable("Cloves"),
  Consumable("Black Peppercorns"),
  Consumable("Ground Ginger"),
  Consumable("Chinese Five Spice"),
];

List<SelectedConsumable> selectedConsumables = [
  SelectedConsumable.full(consumables[0]),
  SelectedConsumable.full(consumables[1]),
  SelectedConsumable.full(consumables[3])
];

final storedConsumables = [
  StoredConsumable("Garam Masala", null),
  StoredConsumable("Ground Coriander", null),
  StoredConsumable("Marjoram", StoredConsumableUserData(Level.full)),
  StoredConsumable("Chilli Powder", StoredConsumableUserData(Level.half)),
  StoredConsumable("Chinese Five Spice", StoredConsumableUserData(Level.low)),
  StoredConsumable("Cajun", null)
];