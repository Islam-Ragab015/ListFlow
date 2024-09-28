import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student/cubit/main_states.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(InitState());

  static MainCubit get(context) => BlocProvider.of(context);
  final String dbName = 'th.db';
  var addTextController = TextEditingController();
  var editTextController = TextEditingController();
  List<Map> schoolStudent = [];

  initSQl() async {
    var dbPath = await getDatabasesPath();
    String fullPath = join(dbPath, dbName);
    // ignore: unused_local_variable
    Database dbase = await openDatabase(fullPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        '''
        CREATE TABLE Students (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
        )
        ''',
      );
    });
  }

  getData() async {
    var dbPath = await getDatabasesPath();
    String fullPath = join(dbPath, dbName);
    Database db = await openDatabase(fullPath);

    db.rawQuery('SELECT * FROM Students').then((value) {
      schoolStudent = value;
      emit(GetDataSuccessState());
    }).catchError((e) {
      emit(GetDataErorrState());
      print(e.toString());
    });
    db.close();
  }

  insertData(String name) async {
    var dbPath = await getDatabasesPath();
    String fullPath = join(dbPath, dbName);
    Database db = await openDatabase(fullPath);

    await db.rawInsert('Insert into Students(name) values (?)', [name]).then(
        (value) {
      emit(InsertDataSuccessState());
    }).catchError((e) {
      emit(InsertDataErorrState());
      print(e.toString());
    });
    db.close();
    getData();
  }

  updateData(String name, int id) async {
    var dbPath = await getDatabasesPath();
    String fullPath = join(dbPath, dbName);
    Database db = await openDatabase(fullPath);

    await db.rawUpdate('Update Students set name = ? Where id = ?',
        [name, '$id']).then((value) {
      emit(UpdateDataSuccessState());
    }).catchError((e) {
      emit(UpdateDataErorrState());
      print(e.toString());
    });
    db.close();
    getData();
  }

  deleteData(int id) async {
    var dbPath = await getDatabasesPath();
    String fullPath = join(dbPath, dbName);
    Database db = await openDatabase(fullPath);

    await db
        .rawUpdate('Delete from Students Where id = ?', ['$id']).then((value) {
      emit(RemoveDataSuccessState());
    }).catchError((e) {
      emit(RemoveDataErorrState());
      print(e.toString());
    });
    db.close();
    getData();
  }
}
