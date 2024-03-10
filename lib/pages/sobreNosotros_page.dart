import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:flutter/material.dart';

class SobreNosotrosPage extends StatelessWidget {
  const SobreNosotrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return Center(
      child: Text('Creado por Marcelo Escobar', style: TextStyle(
        fontSize: ResponsiveSizes.getSizesCustom(width, height, 50),
        fontWeight: FontWeight.bold,
        color: Colors.black,
      )),
    );
  }
}