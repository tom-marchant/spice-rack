import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class ConsumablesSource {
  List<StoredConsumable> get();
}

class BasicConsumablesSource extends ConsumablesSource {
  final List<StoredConsumable> _consumables;

  BasicConsumablesSource(this._consumables);

  @override
  List<StoredConsumable> get() {
    return _consumables;
  }
}

class FileSystemConsumablesSource extends ConsumablesSource {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/consumables.json');
  }

  @override
  List<StoredConsumable> get() {
    return null;
  }
}

class StoredConsumable {
  final String name;
  StoredConsumableUserData userData;

  StoredConsumable(this.name, this.userData);
}

class StoredConsumableUserData {
  Level level;
  StoredConsumableUserData(this.level);
}

class Consumable implements Comparable<Consumable> {
  final String name;

  Consumable(this.name);

  @override
  int compareTo(Consumable other) {
    return this.name.compareTo(other.name);
  }

  @override
  bool operator ==(other) {
    return (other is Consumable && this.name == other.name);
  }

  @override
  int get hashCode => name.hashCode;
}

class SelectedConsumable implements Comparable<SelectedConsumable> {
  final Consumable consumable;
  Level level;

  SelectedConsumable(this.consumable, this.level);
  SelectedConsumable.full(Consumable consumable) : this(consumable, Level.full);

  @override
  int compareTo(SelectedConsumable other) {
    return this.consumable.compareTo(other.consumable);
  }

  void cycleLevel() {
    switch (this.level) {
      case Level.full:
        this.level = Level.half;
        break;
      case Level.half:
        this.level = Level.low;
        break;
      case Level.low:
        this.level = Level.full;
        break;
    }
  }
}

enum Level { full, half, low }