import 'package:financas_pessoais_flutter/database/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class ObjectBoxDatabase {
  static Store? _store;

  static Future<Store> getStore() async{
    return _store ??= await openStore();
  }
  
}