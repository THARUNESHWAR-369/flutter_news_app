import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer(
      {super.key,
      this.height = 125,
      required this.width,
      required this.imageUrl,
      this.child,
      this.padding,
      this.margin,
      this.borderRadius = 20});
  final double width;
  final double height;
  final String imageUrl;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? child;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      margin: margin,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(97, 97, 97, 0.384),
                Color.fromRGBO(97, 97, 97, 0.665),
              ],
              begin: Alignment.topCenter,
            ),
          ),
          child: child),
    );
  }
}
