import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'dart:async';

// Entitas Basis Data
@Entity(tableName: 'penerbangan')
class Penerbangan {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  String maskapai;
  String tujuan;
  String waktu;
  String gerbang;
  String status;

  Penerbangan({this.id, required this.maskapai, required this.tujuan, required this.waktu, required this.gerbang, required this.status});
}

// Data Access Object (DAO)
@dao
abstract class PenerbanganDao {
  @Query('SELECT * FROM penerbangan')
  Future<List<Penerbangan>> getSemuaPenerbangan();

  @insert
  Future<void> tambahPenerbangan(Penerbangan penerbangan);

  @update
  Future<void> perbaruiPenerbangan(Penerbangan penerbangan);

  @delete
  Future<void> hapusPenerbangan(Penerbangan penerbangan);
}

// UI Aplikasi
void main() {
  runApp(AplikasiPenerbangan());
}

class AplikasiPenerbangan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajer Penerbangan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      home: LayarDaftarPenerbangan(),
    );
  }
}

class LayarDaftarPenerbangan extends StatefulWidget {
  @override
  _LayarDaftarPenerbanganState createState() => _LayarDaftarPenerbanganState();
}

class _LayarDaftarPenerbanganState extends State<LayarDaftarPenerbangan> {
  List<Penerbangan> penerbangan = [];

  void _tambahAtauEditPenerbangan({Penerbangan? penerbanganLama}) {
    TextEditingController maskapaiController = TextEditingController(text: penerbanganLama?.maskapai ?? '');
    TextEditingController tujuanController = TextEditingController(text: penerbanganLama?.tujuan ?? '');
    TextEditingController waktuController = TextEditingController(text: penerbanganLama?.waktu ?? '');
    TextEditingController gerbangController = TextEditingController(text: penerbanganLama?.gerbang ?? '');
    TextEditingController statusController = TextEditingController(text: penerbanganLama?.status ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(penerbanganLama == null ? 'Tambah Penerbangan' : 'Edit Penerbangan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: maskapaiController, decoration: InputDecoration(labelText: 'Maskapai')),
              TextField(controller: tujuanController, decoration: InputDecoration(labelText: 'Tujuan')),
              TextField(controller: waktuController, decoration: InputDecoration(labelText: 'Waktu')),
              TextField(controller: gerbangController, decoration: InputDecoration(labelText: 'Gerbang')),
              TextField(controller: statusController, decoration: InputDecoration(labelText: 'Status')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (penerbanganLama == null) {
                    penerbangan.add(Penerbangan(
                      id: penerbangan.length + 1,
                      maskapai: maskapaiController.text,
                      tujuan: tujuanController.text,
                      waktu: waktuController.text,
                      gerbang: gerbangController.text,
                      status: statusController.text,
                    ));
                  } else {
                    penerbanganLama.maskapai = maskapaiController.text;
                    penerbanganLama.tujuan = tujuanController.text;
                    penerbanganLama.waktu = waktuController.text;
                    penerbanganLama.gerbang = gerbangController.text;
                    penerbanganLama.status = statusController.text;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(penerbanganLama == null ? 'Tambah' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _hapusPenerbangan(int id) {
    setState(() {
      penerbangan.removeWhere((p) => p.id == id);
    });
  }

  void _lihatDetail(Penerbangan penerbangan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detail Penerbangan'),
          content: Text('Maskapai: ${penerbangan.maskapai}\nTujuan: ${penerbangan.tujuan}\nWaktu: ${penerbangan.waktu}\nGerbang: ${penerbangan.gerbang}\nStatus: ${penerbangan.status}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Penerbangan')),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: penerbangan.length,
        itemBuilder: (ctx, index) {
          final p = penerbangan[index];
          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text(p.maskapai, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('Tujuan: ${p.tujuan}\nGerbang: ${p.gerbang}\nWaktu: ${p.waktu}\nStatus: ${p.status}'),
              onTap: () => _lihatDetail(p),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _tambahAtauEditPenerbangan(penerbanganLama: p)),
                  IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _hapusPenerbangan(p.id!)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tambahAtauEditPenerbangan(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
