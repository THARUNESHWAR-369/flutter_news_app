import 'package:flutter/material.dart';

class CustomTag extends StatelessWidget {
  const CustomTag({super.key, required this.bgColor, required this.children});
  final Color bgColor;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
