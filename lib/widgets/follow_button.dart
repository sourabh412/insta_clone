import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? cusMethod;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String text;
  const FollowButton({Key? key, this.cusMethod, required this.backgroundColor, required this.borderColor, required this.text, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: cusMethod,
        child: Container(
          width: 250,
          height: 27,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
