import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String label;
  final int maxLength;
  final String? Function(String?)? validator;
  final FormFieldSetter? onSaved;
  final FormFieldSetter? onChanged;
  final TextInputType? keyboardType;
  final dynamic inputFormatters;

  const FormInput({
    super.key,
    required this.label,
    this.maxLength = 255,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      decoration: InputDecoration(labelText: label, errorMaxLines: 3),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }
}
