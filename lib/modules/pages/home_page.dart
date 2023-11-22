
import 'package:financas_pessoais_flutter/modules/conta/pages/conta_list_page.dart';
import 'package:financas_pessoais_flutter/utils/AppRoutes.dart';
import 'package:financas_pessoais_flutter/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Pagina Inicial'),
      ),
      body: 
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        
        children: [
          SizedBox(
            height: 150,
            width: 190,
            child: InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.ContaListPage),
              child:  Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/bank-svgrepo.svg', width: 50,),
                  
                      Text('Conta'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 150,
            width: 190,
            child: InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.CategoriaListPage),
              child:  Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     SvgPicture.asset('assets/images/bankingsvgrepo.svg', width: 50,),
                      Text('Categoria'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}