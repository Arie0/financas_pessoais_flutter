// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class Categoria  {
    @Id()
    int? id;
    String? createdAt;
    String? updatedAt;
    String? nome;

  Categoria({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.nome,
  });

@override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }


}
