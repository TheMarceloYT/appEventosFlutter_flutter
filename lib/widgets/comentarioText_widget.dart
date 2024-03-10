import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:flutter/material.dart';

class ComentarioTextWidget extends StatelessWidget {
  const ComentarioTextWidget({
    super.key,
    required this.comentario,
    required this.width,
    required this.height
  });

  final String comentario;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Text(comentario,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: ResponsiveSizes.getSizesCustom(width, height, 80),
      )
    );
  }
}