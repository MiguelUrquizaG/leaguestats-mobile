import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/features/login/ui/menu_component.dart';

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(width: double.infinity, child: MenuComponent()),
    );
  }
}
