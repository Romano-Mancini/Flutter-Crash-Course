import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.loading,
    this.submit,
    required this.text,
  });

  final bool loading;
  final VoidCallback? submit;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading ? null : submit,
      child:
          loading
              ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : Text(text),
    );
  }
}
