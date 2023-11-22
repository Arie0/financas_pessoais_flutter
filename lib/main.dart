import 'package:financas_pessoais_flutter/modules/categoria/controllers/categoria_controller.dart';
import 'package:financas_pessoais_flutter/modules/categoria/pages/categoria_list_page.dart';
import 'package:financas_pessoais_flutter/modules/conta/controllers/conta_controller.dart';
import 'package:financas_pessoais_flutter/modules/conta/pages/conta_list_page.dart';
import 'package:financas_pessoais_flutter/modules/pages/home_page.dart';
import 'package:financas_pessoais_flutter/theme/my_theme.dart';
import 'package:financas_pessoais_flutter/utils/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoriaController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContaController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicio',
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: HomePage(),
      routes: {
        AppRoutes.HOME: (context) => HomePage(),
        AppRoutes.ContaListPage: (context) => ContaListPage(),
        AppRoutes.CategoriaListPage: (context) => CategoriaListPage(),
  },
    );
  }
}