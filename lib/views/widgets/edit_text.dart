import 'package:alnoor/get_initial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditText extends StatefulWidget {
  const EditText(
      {super.key,
      required this.function,
      required this.controller,
      required this.validator,
      required this.hint,
      this.length,
      this.secure = false,
      this.number = false,
      required this.title});
  final String title;
  final bool number;
  final String hint;
  final int? length;
  final Function function;
  final bool secure;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  bool showPass = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: widget.length,
        keyboardType: widget.number ? TextInputType.number : null,
        obscureText: !showPass && widget.secure,
        cursorColor: appConstant.primaryColor,
        onFieldSubmitted: (value) => widget.function(),
        decoration: InputDecoration(
            hintText: widget.hint,
            labelStyle: TextStyle(color: appConstant.primaryColor),
            labelText: widget.title.tr,
            suffixIcon: widget.secure
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPass = !showPass;
                      });
                    },
                    icon: Icon(
                      showPass ? Icons.visibility : Icons.visibility_off,
                      color: appConstant.primaryColor,
                    ))
                : null,
            border: const OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15)),
        controller: widget.controller,
        validator: widget.validator);
  }
}
