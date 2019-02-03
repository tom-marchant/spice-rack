class StoredConsumable {
  final String name;
  StoredConsumableUserData userData;

  StoredConsumable(this.name, this.userData);

  StoredConsumable.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        userData = json['userData'] != null ? StoredConsumableUserData.fromJson(json['userData']) : null;

  Map<String, dynamic> toJson() => {
        'name': name,
        'userData': (userData != null) ? userData.toJson() : null,
      };
}

class StoredConsumableUserData {
  Level level;

  StoredConsumableUserData(this.level);

  StoredConsumableUserData.fromJson(Map<String, dynamic> json)
      : level = Level.values.firstWhere((e) => e.toString() == 'Level.' + json['level']);

  Map<String, dynamic> toJson() => {'level': this.level.toString().substring("Level.".length) };
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
