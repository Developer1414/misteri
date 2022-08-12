import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileData extends StatelessWidget {
  const ProfileData(
      {Key? key, this.value = '0', this.dataName = '', required this.action})
      : super(key: key);

  final String value;
  final String dataName;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
      child: Material(
        shadowColor: Colors.black,
        elevation: 5,
        borderRadius: BorderRadius.circular(15.0),
        clipBehavior: Clip.antiAlias,
        color: Colors.deepPurple.shade400,
        child: InkWell(
          //onTap: () => action,
          child: Container(
            width: 100,
            margin: const EdgeInsets.all(20.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                    letterSpacing: 0.5,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  )),
                ),
                Text(
                  dataName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                    letterSpacing: 0.5,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  )),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
