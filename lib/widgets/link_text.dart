import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  const LinkText({
    super.key,
    this.text,
    this.linkText,
    required this.linkWidget,
  });
  final String? text;
  final String? linkText;
  final Widget linkWidget;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        children: [
          TextSpan(text: text),
          TextSpan(
            text: linkText,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, // Makes it look like a link
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(builder: (context) => linkWidget),
                  (Route<dynamic> route) => false,
                );
                // Your navigation or action goes here
              },
          ),
        ],
      ),
    );
  }
}
