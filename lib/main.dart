import 'package:flutter/material.dart';
import 'widgets.dart';

import 'repositories.dart';
import 'providers.dart';

void main() {
  ConsumablesRepository _repository = new FileSystemConsumablesRepository();

  runApp(FutureBuilder(
      future: _repository.init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
            return SpiceRackApp(new ConsumablesProvider(_repository));
        } else {
            return MaterialApp(title: 'Spice Rack', home: Text("Loading..."));
        }
      }));
}

class SpiceRackApp extends StatelessWidget {

  final ConsumablesProvider _consumablesProvider;
  const SpiceRackApp(this._consumablesProvider);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Spice Rack', home: SelectedConsumables(_consumablesProvider));
  }
}