import 'package:flutter/material.dart';
import 'widgets.dart';

void main() => runApp(SpiceRackApp());

class SpiceRackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Spice Rack', home: SelectedConsumables());
  }
}