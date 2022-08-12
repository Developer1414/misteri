import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget popUpDialog(
    {required BuildContext context,
    required String title,
    required String content,
    required List<Widget> buttons}) {
  return FutureBuilder<dynamic>(
    builder: (context, AsyncSnapshot<dynamic> snapshot) {
      return snapshot.data;
    },
    future: showDialog(
      context: context,
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: 25.0, right: 25.0, bottom: 10.0, top: 10.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.3),
                        blurStyle: BlurStyle.outer)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              )),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, bottom: 20.0, right: 20.0),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              content,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: buttons),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
