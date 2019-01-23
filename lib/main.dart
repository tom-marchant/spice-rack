import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: SpiceRackApp()));

final biggerFont = const TextStyle(fontSize: 18.0);

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

class SpiceRackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Spice Rack', home: SelectedConsumables());
  }
}

void showAddView(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
    return Consumables();
  }));
}

class SelectedConsumablesState extends State<SelectedConsumables> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spice Rack'),
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () => showAddView(context), child: Icon(Icons.add)),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: selectedConsumables.length * 2,
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;

          return _buildRow(selectedConsumables[index]);
        });
  }

  Widget _buildRow(SelectedConsumable consumable) {
    final _selectedConsumable = consumable;
    return ListTile(
        title: Text(
          _selectedConsumable.consumable.name,
          style: biggerFont,
        ),
        leading: getIcon(_selectedConsumable),
        onTap: () {
          setState(() {
            _selectedConsumable.cycleLevel();
          });
        });
  }

  Icon getIcon(SelectedConsumable consumable) {
    switch (consumable.level) {
      case Level.full:
        return Icon(
            Icons.brightness_1,
            color: Colors.green);
      case Level.half:
        return Icon(
            Icons.brightness_2,
            color: Colors.amber);
      case Level.low:
        return Icon(
          Icons.brightness_3,
          color: Colors.red,
        );
    }
  }
}

class SelectedConsumables extends StatefulWidget {
  @override
  SelectedConsumablesState createState() => new SelectedConsumablesState();
// TODO Add build() method
}

class ConsumablesState extends State<Consumables> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add or Remove Spices')),
      body: Column(children: [
        Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.search), hintText: 'Search...'),
            )),
        Expanded(
            child: _buildList())
      ]),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
        itemCount: consumables.length * 2,
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;

          return _buildRow(consumables[index]);
        });
  }

  Widget _buildRow(Consumable consumable) {
    final _consumable = consumable;
    return ListTile(
        title: Text(
          _consumable.name,
          style: biggerFont,
        ),
        leading: Checkbox(
            value: _isSelected(_consumable),
            onChanged: (bool) {
              setState(() {
                if (_isSelected(consumable)) {
                  SelectedConsumable selectedConsumable = selectedConsumables
                      .firstWhere((e) => e.consumable == consumable);
                  selectedConsumables.remove(selectedConsumable);
                } else {
                  selectedConsumables.add(SelectedConsumable.full(consumable));
                }
              });
            }));
  }

  bool _isSelected(Consumable consumable) {
    return selectedConsumables.map((f) => f.consumable).contains(consumable);
  }
}

class Consumables extends StatefulWidget {
  @override
  ConsumablesState createState() => new ConsumablesState();
// TODO Add build() method
}

enum Level { full, half, low }

class Consumable {
  final String name;

  Consumable(this.name);
}

class SelectedConsumable {
  final Consumable consumable;
  Level level;

  SelectedConsumable(this.consumable, this.level);

  SelectedConsumable.full(Consumable consumable) : this(consumable, Level.full);

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
