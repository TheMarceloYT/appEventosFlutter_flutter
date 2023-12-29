import 'package:flutter/material.dart';

class SobreNosotrosPage extends StatelessWidget {
  const SobreNosotrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Creado por Marcelo Escobar', style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      )),
    );
  }
}