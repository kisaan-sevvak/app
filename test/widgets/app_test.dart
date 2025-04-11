import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_sevak/main.dart';

void main() {
  testWidgets('App should build without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
} 