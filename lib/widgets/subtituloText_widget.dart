import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:flutter/material.dart';

class SubtituloTextWidget extends StatelessWidget {
  const SubtituloTextWidget({
    super.key,
    required this.texto,
    required this.width,
    required this.height
  });

  final String texto;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      alignment: Alignment.center,
      child: Text(texto, style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: ResponsiveSizes.getSizesCustom(width, height, 80),
      )),
    );
  }
}