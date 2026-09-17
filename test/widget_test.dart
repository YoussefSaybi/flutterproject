import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:ecoar_kerkennah/main.dart';

void main() {
  testWidgets('EcoAR app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoArApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
