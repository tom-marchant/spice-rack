// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spice_rack/domain.dart';

import 'package:spice_rack/main.dart';
import 'package:spice_rack/widgets.dart';

import 'package:spice_rack/providers.dart';
import 'package:spice_rack/repositories.dart';

void main() {
  final _storedConsumables = [
    StoredConsumable("Ground Coriander", null),
    StoredConsumable("Marjoram", StoredConsumableUserData(Level.full)),
  ];

  final _source = BasicConsumablesRepository(_storedConsumables);
  final _provider = ConsumablesProvider(_source);

  testWidgets('Loads the app', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(SpiceRackApp(_provider));

    expect(find.text('Spice Rack'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Shows full list of available consumables', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Consumables(_provider)));

    expect(find.byType(ListView), findsOneWidget);
  });
}
