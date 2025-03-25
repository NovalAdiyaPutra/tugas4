import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tugas4/main.dart';

// Buat Mock Database (jika nanti diperlukan)
class MockDatabase extends Mock {}

void main() {
  testWidgets('Menampilkan daftar penerbangan', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LayarDaftarPenerbangan(),
    ));

    // Cek apakah ada teks "Daftar Penerbangan" di AppBar
    expect(find.text('Daftar Penerbangan'), findsOneWidget);
  });
}
