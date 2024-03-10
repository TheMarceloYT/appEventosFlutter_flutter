import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:flutter/material.dart';

class TituloTextWidget extends StatelessWidget {
  const TituloTextWidget({
    super.key,
    required this.titulo,
    required this.width,
    required this.height
  });

  final String titulo;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(titulo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: ResponsiveSizes.getSizesCustom(width, height, 65),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}