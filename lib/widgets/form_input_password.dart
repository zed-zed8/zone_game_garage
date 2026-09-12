import 'package:flutter/material.dart';

class FormInputPassword extends StatefulWidget {
  final String label;
  final int maxLength;
  final String? Function(String?)? validator;
  final FormFieldSetter<String>? onSaved;

  const FormInputPassword({
    super.key,
    required this.label,
    this.maxLength = 255,
    this.validator,
    this.onSaved,
  });

  @override
  State<FormInputPassword> createState() => _FormInputPasswordState();
}

class _FormInputPasswordState extends State<FormInputPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,

      enableSuggestions: false,
      autocorrect: false,
      autofillHints: const [
        AutofillHints.password,
      ], // Enable operating system / manager password autofilling

      decoration: InputDecoration(
        label: Text(widget.label),
        errorMaxLines: 3,
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),

      maxLength: widget.maxLength,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
