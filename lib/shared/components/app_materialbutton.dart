import 'package:flutter/material.dart';

class AppMaterialButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Color background;
  final Color forground;
  final double borderRadius;
  final double fontSize;
  final Function onPressed;

  AppMaterialButton(
      {required this.title,
      this.width = double.infinity,
      this.height = 50,
      this.background = Colors.blue,
      this.forground = Colors.white,
      this.borderRadius = 10,
      this.fontSize = 20,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        color: background,
        child: Text(
          '$title',
          style: TextStyle(
            fontSize: fontSize,
            color: forground,
          ),
        ),
      ),
    );
    ;
  }
}
