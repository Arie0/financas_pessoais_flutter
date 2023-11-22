import 'dart:developer';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:financas_pessoais_flutter/modules/categoria/controllers/categoria_controller.dart';
import 'package:financas_pessoais_flutter/modules/categoria/models/categoria_model.dart';
import 'package:financas_pessoais_flutter/modules/conta/models/ResumoDTO.dart';
import 'package:financas_pessoais_flutter/modules/conta/models/conta_model.dart';
import 'package:financas_pessoais_flutter/modules/conta/repository/conta_repository.dart';
import 'package:financas_pessoais_flutter/utils/back_routes.dart';
import 'package:financas_pessoais_flutter/utils/utils.dart';
import 'package:financas_pessoais_flutter/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class ContaController extends ChangeNotifier {
  List<Conta> contas = [];
  Categoria? categoriaSelecionada;
  String tipoSelecionado = 'Despesa';
  String groupValueTipoConta = "TipoConta";
  final dataController = TextEditingController();
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final destinoOrigemController = TextEditingController();
  
  Future<List<Conta>?> findAll() async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository
          .getAll(BackRoutes.baseUrl + BackRoutes.CONTA_ALL);
      if (response != null) {

        List<Conta> lista =
            response.map<Conta>((e) => Conta.fromMap(e)).toList();

        contas = lista;

        return contas;
        
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> save(Conta conta) async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository.save(
          BackRoutes.baseUrl + BackRoutes.CONTA_SAVE, conta);
      if (response != null) {
        Conta conta =
            Conta.fromMap(response as Map<String, dynamic>);
        contas.add(conta);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<ResumoDTO?>  findresumo() async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository
         .getAll(BackRoutes.baseUrl + BackRoutes.CONTA_RESUMO);
      if (response != null) {

        return ResumoDTO.fromMap(response);
        
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> update(Conta conta) async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository.update(
          BackRoutes.baseUrl + BackRoutes.CONTA_UPDATE, conta);
      if (response != null) {
        Conta contaEdit =
            Conta.fromMap(response as Map<String, dynamic>);
        contas.add(contaEdit);
        contas.remove(conta);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  create(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Nova Conta',
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Despesa',
                      child: Text('Despesa'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Receita',
                      child: Text('Receita'),
                    ),
                  ],
                  onChanged: (value) {
                    tipoSelecionado = value ?? 'Despesa';
                    notifyListeners();
                  },
                  decoration: const InputDecoration(
                        hintText: 'Tipo',
                      ),
                  
                  validator: (value) {
                        if(value == null){
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                ),
                FutureBuilder<List<Categoria>?>(
                  future: Provider.of<CategoriaController>(context, 
                  listen: false).findAll(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done){
                      var categorias = snapshot.data ?? [];

                    return DropdownButtonFormField(
                      items: categorias.map((e) => 
                      DropdownMenuItem<Categoria>(
                          value: e,
                          child: Text(e.nome),
                        ),
                      ).toList(),
                      onChanged: (value) {
                        categoriaSelecionada = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Categorias',
                      ),
                      validator: (value) {
                        if(value == null){
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    );
                    }
                    return const CircularProgressIndicator();
                  }
                ),
                TextFormField(
                  controller: dataController,
                  decoration: InputDecoration(labelText: Provider.of<ContaController>(context).tipoSelecionado == 'Despesa' ? 'Data de Pagamento' : 'Data de Recebimento'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                ),
                TextFormField(
                  controller: descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                TextFormField(
                  controller: destinoOrigemController,
                  decoration: InputDecoration(labelText: Provider.of<ContaController>(context).tipoSelecionado == 'Despesa' ? 'Destino' : 'Origem'),
                ),
                TextFormField(
                  controller: valorController,
                  decoration: const InputDecoration(labelText: 'Valor'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true),
                  ],
                  validator: Validatorless.multiple([
                    Validatorless.required('Campo obrigatório'),
                    Validators.minDouble(0.01, 'Valor inválido'),
                  ]),
                  // validator: (value) {
                  //   if(value == null || value.isEmpty){
                  //     return "Campo obrigatório";
                  //   }
                  //   return null;
                  // },
                ),
                
                
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                var conta = Conta(
                  categoria: categoriaSelecionada!, 
                  tipo: tipoSelecionado == 'Despesa' ? true : false, 
                  data: Utils.convertDate(dataController.text),
                  descricao: descricaoController.text, 
                  valor: UtilBrasilFields.converterMoedaParaDouble(valorController.text), 
                  destinoOrigem: destinoOrigemController.text, 
                  status: false,
                );
                await save(conta);
                notifyListeners();
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar'),
          )
        ],
      ),
    );
  }

  edit(BuildContext context, Conta data) {
    final formKey = GlobalKey<FormState>();
    categoriaSelecionada = data.categoria;
    tipoSelecionado = data.tipo == true?'Despesa': 'Receita';
    dataController.text = Utils.convertDate(data.data);
    descricaoController .text = data.descricao;
    destinoOrigemController.text = data.destinoOrigem;
    valorController.text = UtilBrasilFields.obterReal(data.valor);
    log(categoriaSelecionada.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Editar Conta',
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  value: tipoSelecionado,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Despesa',
                      child: Text('Despesa'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Receita',
                      child: Text('Receita'),
                    ),
                  ],
                  onChanged: (value) {
                    tipoSelecionado = value ?? 'Despesa';
                    notifyListeners();
                  },
                  decoration: const InputDecoration(
                        hintText: 'Tipo',
                      ),
                  
                  validator: (value) {
                        if(value == null){
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                ),
                FutureBuilder<List<Categoria>?>(
                  future: Provider.of<CategoriaController>(context, 
                  listen: false).findAll(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done){
                      var categorias = snapshot.data ?? [];

                    return DropdownButtonFormField(
                      //value: categoriaSelecionada,
                      items: categorias.map((e) => 
                      DropdownMenuItem<Categoria>(
                          value: e,
                          child: Text(e.nome),
                        ),
                      ).toList(),
                      onChanged: (value) {
                        categoriaSelecionada = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Categorias',
                      ),
                      validator: (value) {
                        if(value == null){
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    );
                    }
                    return const CircularProgressIndicator();
                  }
                ),
                TextFormField(
                  controller: dataController,
                  decoration: InputDecoration(labelText: Provider.of<ContaController>(context).tipoSelecionado == 'Despesa' ? 'Data de Pagamento' : 'Data de Recebimento'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                ),
                TextFormField(
                  controller: descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                TextFormField(
                  controller: destinoOrigemController,
                  decoration: InputDecoration(labelText: Provider.of<ContaController>(context).tipoSelecionado == 'Despesa' ? 'Destino' : 'Origem'),
                ),
                TextFormField(
                  controller: valorController,
                  decoration: const InputDecoration(labelText: 'Valor'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true),
                  ],
                  validator: Validatorless.multiple([
                    Validatorless.required('Campo obrigatório'),
                    Validators.minDouble(0.01, 'Valor inválido'),
                  ]),
                  // validator: (value) {
                  //   if(value == null || value.isEmpty){
                  //     return "Campo obrigatório";
                  //   }
                  //   return null;
                  // },
                ),
                
                
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                var conta = Conta(
                  categoria: categoriaSelecionada!, 
                  tipo: tipoSelecionado == 'Despesa' ? true : false, 
                  data: Utils.convertDate(dataController.text),
                  descricao: descricaoController.text, 
                  valor: UtilBrasilFields.converterMoedaParaDouble(valorController.text), 
                  destinoOrigem: destinoOrigemController.text, 
                  status: false,
                );
                await save(conta);
                notifyListeners();
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar'),
          )
        ],
      ),
    );
  }

  delete(Conta data)async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository.delete(
          BackRoutes.baseUrl + BackRoutes.CONTA_DELETE, data);
      if (response != null) {
        contas.remove(data);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}