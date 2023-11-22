import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          UserAccountsDrawerHeader(
            accountName: Text("Ariele Financas"),
            accountEmail: Text("ariel@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/images/woman.png"),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: const Text(
          //     "Botão",
          //     style: TextStyle(
          //       color: MyColors.textLight,
          //     ),
          //   ),
          // ),
          
        ],
      ),
    );
  }
}