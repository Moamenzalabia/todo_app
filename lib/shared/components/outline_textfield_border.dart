import 'package:flutter/material.dart';

class OutlineTextfieldBorder extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final String labelText;
  final bool isObscureText;
  final IconData prefixIcon;
  final IconData? suffix;
  final String? Function(String?) validate;
  final String? Function(String?)? onFieldSubmit;
  final String? Function(String?)? onChange;
  final Function()? suffixPressed;
  final Function()? onTap;

  OutlineTextfieldBorder({
    required this.controller,
    required this.textInputType,
    required this.labelText,
    this.isObscureText = false,
    required this.prefixIcon,
    this.suffix,
    required this.validate,
    this.onFieldSubmit,
    this.onChange,
    this.suffixPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validate,
      keyboardType: textInputType,
      onFieldSubmitted: onFieldSubmit,
      onChanged: onChange,
      onTap: onTap,
      obscureText: isObscureText,
      decoration: InputDecoration(
        labelText: '$labelText',
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(suffix),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );
  }
}
