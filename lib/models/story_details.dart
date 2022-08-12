import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryDetail extends StatelessWidget {
  const StoryDetail(
      {Key? key,
      this.valueName = '',
      this.value = '0',
      this.iconColor = Colors.white,
      this.icon = Icons.favorite_rounded,
      required this.context})
      : super(key: key);

  final String valueName;
  final String value;
  final Color iconColor;
  final IconData icon;
  final BuildContext context;

  @override
  Widget build(context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 25,
          color: iconColor,
        ),
        const SizedBox(width: 5.0),
        Text(
          '$valueName: $value',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
            letterSpacing: 0.5,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87.withOpacity(0.7),
          )),
        ),
      ],
    );
  }
}
