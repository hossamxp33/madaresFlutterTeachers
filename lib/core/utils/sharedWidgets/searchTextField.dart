import 'dart:async';


import 'package:flutter/material.dart';

import '../labelKeys.dart';
import '../styles/colors.dart';
import '../uiUtils.dart';

class CustomSearchTextField extends StatefulWidget {
  final TextEditingController textController;
  final Function(String) onSearch;
  final Function() onTextClear;
  const CustomSearchTextField(
      {super.key,
      required this.textController,
      required this.onSearch,
      required this.onTextClear});

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: widget.textController,
        autofocus: true,
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 14),
          hintText: UiUtils.getTranslatedLabel(context, searchHintKey),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          contentPadding: const EdgeInsets.all(5),
<<<<<<< HEAD
          prefixIcon: const Icon(
            Icons.search,
            color: primaryColor,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.clear,
              color: primaryColor,
=======
          prefixIcon:  Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: IconButton(
            icon:  Icon(
              Icons.clear,
              color: Theme.of(context).colorScheme.primary,
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
            ),
            onPressed: () {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              widget.onTextClear();
              widget.textController.clear();
              _formKey.currentState!.validate();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
<<<<<<< HEAD
            borderSide: const BorderSide(
              color: redColor,
=======
            borderSide:  BorderSide(
              color: Theme.of(context).colorScheme.error,
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
            ),
          ),
          errorStyle: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        validator: (value) {
          if (value == null || value.toString().trim().isEmpty) {
            return null;
          } else if (value.trim().length < 3) {
            return UiUtils.getTranslatedLabel(
                context, addMoreCharactorsToSearchKey);
          } else {
            return null;
          }
        },
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          //auto search after 1 second of typing
          _debounce = Timer(const Duration(milliseconds: 500), () {
            if (_formKey.currentState!.validate()) {
              if (widget.textController.text.trim().isNotEmpty) {
                widget.onSearch(widget.textController.text);
              }
            } else {
              widget.onTextClear();
            }
          });
        },
      ),
    );
  }
}
