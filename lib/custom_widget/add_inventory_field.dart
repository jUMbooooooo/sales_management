import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final bool readOnly;
  final Function onTap;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextFormField({
    required this.labelText,
    this.readOnly = false,
    required this.onTap,
    required this.controller,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: this.readOnly,
        decoration: InputDecoration(
          suffixText: this.suffixText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
          labelText: this.labelText,
          floatingLabelStyle: const TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        onTap: () => this.onTap(),
        controller: this.controller,
        validator: this.validator,
        keyboardType: this.keyboardType,
        inputFormatters: this.inputFormatters,
      ),
    );
  }
}

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<T> items;
  final ValueChanged<T>? onChanged;
  final String? Function(T) validator;
  final String Function(T) displayText;

  CustomDropdownButtonFormField({
    required this.labelText,
    this.value,
    required this.items,
    required this.onChanged,
    required this.validator,
    required this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
          labelText: this.labelText,
          floatingLabelStyle: const TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        value: this.value,
        items: this.items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(displayText(value)),
          );
        }).toList(),
        onChanged: (T? newValue) {
          if (newValue != null) {
            this.onChanged!(newValue);
          }
        },
        validator: (T? value) {
          if (value != null) {
            return this.validator(value);
          }
          return null;
        },
      ),
    );
  }
}
