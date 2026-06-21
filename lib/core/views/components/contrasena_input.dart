import 'package:flutter/material.dart';

class Contrasenainput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;

  const Contrasenainput({
    super.key,
    required this.controller,
    this.label = 'Contraseña',
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.onSubmitted,
  });

  @override
  State<Contrasenainput> createState() => _ContrasenainputState();
}

class _ContrasenainputState extends State<Contrasenainput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autofillHints: const [AutofillHints.password],
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
          icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
        ),
      ),
    );
  }
}
