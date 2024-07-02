import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color cursorColor;

  const InputField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.cursorColor = const Color(0xFF00A2E1),
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            cursorColor: widget.cursorColor,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9E9E9E)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9E9E9E)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9E9E9E)),
              ),
              contentPadding: EdgeInsets.zero,
              isDense: true,
              labelStyle: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
          if (widget.obscureText)
            IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: _toggleVisibility,
            ),
        ],
      ),
    );
  }
}
