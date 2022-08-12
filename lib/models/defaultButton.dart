import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {Key? key,
      this.buttonName = '',
      this.buttonColor = Colors.green,
      required this.action,
      this.buttonSize = const Size(70, 55)})
      : super(key: key);

  final String buttonName;
  final Color buttonColor;
  final VoidCallback action;
  final Size buttonSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: buttonSize.height,
        width: buttonSize.width,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Material(
          borderRadius: BorderRadius.circular(15.0),
          clipBehavior: Clip.antiAlias,
          color: buttonColor,
          child: InkWell(
            onTap: () => action.call(),
            child: Center(
              child: Text(
                buttonName,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )),
              ),
            ),
          ),
          shadowColor: Colors.black,
          elevation: 5,
        ),
      ),
    );
  }
}
