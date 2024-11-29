import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();
  static final String tableNote = "noteData";
  static final String columnNoteSNo = "s_no";
  static final String columnNoteTitle = "title";
  static final String columnNoteDesc = "desc";
  Database? myDB;

  Future<Database> getDb() async {
    myDB ??= await openDb();
    return myDB!;
  }

  Future<Database> openDb() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String rootPath = appDirectory.path;
    String dbPath = join(rootPath, "notes.db");
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.rawQuery(
            "create table $tableNote($columnNoteSNo integer primary key autoincrement,$columnNoteTitle,$columnNoteDesc)");
      },
    );
  }

  //queries
  //insert data
  Future<bool> addNote({required String title, required String desc}) async {
    var db = await getDb();
    int rowsEffected = await db
        .insert(tableNote, {columnNoteTitle: title, columnNoteDesc: desc});
    return rowsEffected > 0;
  }

  //get all data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDb();
    var allNotes = await db.query(tableNote);
    return allNotes;
  }

  //update note
  Future<bool> updateNote(
      {required String title, required String desc, required int sno}) async {
    var db = await getDb();
    int rowsEffected = await db.update(
        tableNote,
        {
          columnNoteTitle: title,
          columnNoteDesc: desc,
        },
        where: "$columnNoteSNo = $sno");
    return rowsEffected > 0;
  }

  //delete note
  Future<bool> deleteNote({required int sno}) async {
    var db = await getDb();
    int rowsEffected = await db
        .delete(tableNote, where: "$columnNoteSNo = ?", whereArgs: ['$sno']);
    return rowsEffected > 0;
  }
}
