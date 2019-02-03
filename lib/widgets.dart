import 'package:flutter/material.dart';

import 'domain.dart';
import 'providers.dart';

final _biggerFont = const TextStyle(fontSize: 18.0);

void showAddView(BuildContext context, Widget widget) {
  Navigator.push(context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
    return widget;
  }));
}

class Consumables extends StatefulWidget {
  final ConsumablesProvider _consumablesProvider;
  Consumables(this._consumablesProvider);

  @override
  ConsumablesState createState() => new ConsumablesState();
// TODO Add build() method
}

class ConsumablesState extends State<Consumables> {

  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add or Remove Spices')),
      body: Column(children: [
        Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration:
              InputDecoration(icon: Icon(Icons.search), hintText: 'Search...'),
              onChanged: ((searchText) {
                setSearchText(searchText);
              }),
            )),
        Expanded(child: _buildList())
      ]),
    );
  }

  Widget _buildList() {
    List<Consumable> consumables;

    print("Building consumables list. _searchText=$_searchText");

    if (_searchText == "") {
      consumables = this.widget._consumablesProvider.getAll();
    } else {
      consumables = this.widget._consumablesProvider.getFiltered(_searchText);
    }

    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
        itemCount: consumables.length * 2,
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;

          return _buildRow(consumables[index]);
        });
  }

  void setSearchText(searchText) {
    print("Setting searchText: $searchText");
    setState(() => this._searchText = searchText);
  }

  Widget _buildRow(Consumable consumable) {
    final _consumable = consumable;
    return ListTile(
        title: Text(
          _consumable.name,
          style: _biggerFont,
        ),
        leading: Checkbox(
            value: this.widget._consumablesProvider.isSelected(_consumable),
            onChanged: (selected) {
              setState(() {
                this.widget._consumablesProvider.setSelected(_consumable, selected);
              });
            }));
  }
}

class SelectedConsumables extends StatefulWidget {
  final ConsumablesProvider _consumablesProvider;
  const SelectedConsumables(this._consumablesProvider);

  @override
  SelectedConsumablesState createState() => new SelectedConsumablesState();
// TODO Add build() method
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
          onPressed: () => showAddView(context, Consumables(this.widget._consumablesProvider)),
          child: Icon(Icons.add)),
    );
  }

  Widget _buildList() {
    List<SelectedConsumable> selectedConsumables =
        this.widget._consumablesProvider.getSelected();

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
          style: _biggerFont,
        ),
        leading: getIcon(_selectedConsumable),
        onTap: () {
          setState(() {
            this.widget._consumablesProvider.cycleLevel(_selectedConsumable);
          });
        });
  }

  Icon getIcon(SelectedConsumable consumable) {
    switch (consumable.level) {
      case Level.full:
        return Icon(Icons.brightness_1, color: Colors.green);
      case Level.half:
        return Icon(Icons.brightness_2, color: Colors.amber);
      case Level.low:
        return Icon(Icons.brightness_3, color: Colors.red);
    }
    return null;
  }
}
