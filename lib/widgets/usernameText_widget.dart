import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:flutter/material.dart';

class UserNameTextWidget extends StatelessWidget {
  const UserNameTextWidget({
    super.key,
    required this.userName,
    required this.width,
    required this.height
  });

  final String userName;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('@$userName',
        maxLines: 1,
        overflow: TextOverflow.ellipsis, 
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: ResponsiveSizes.getSizesCustom(width, height, 70),
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}