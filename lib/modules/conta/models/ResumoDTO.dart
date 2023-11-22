// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:financas_pessoais_flutter/modules/abstract/models/abstract_entity_model.dart';

class ResumoDTO extends AbstractEntity {
  
   
    double totalreceita;
    double totaldespesa;
    double saldo;
  
  ResumoDTO({
    required this.totalreceita,
    required this.totaldespesa,
    required this.saldo,
  });
    
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
     'totaldespesa' : totaldespesa,
     'totalreceita' : totalreceita,
     'saldo' : saldo 

    };
  }
  factory ResumoDTO.fromMap(Map<String, dynamic> map, ) {
    return ResumoDTO(
      totaldespesa: map['totaldespesa'] as double,
      totalreceita: map['totalreceita'] as double,
      saldo : map['saldo'] as double,
    

    );
  }
}
