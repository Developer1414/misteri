import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/generated/l10n.dart';

class BanScreen extends StatefulWidget {
  const BanScreen({Key? key, this.unlockDate = ''}) : super(key: key);

  final String unlockDate;

  @override
  State<BanScreen> createState() => _BanScreenState();
}

class _BanScreenState extends State<BanScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ваш аккаунт временно заблокирован за нарушения правил!',
                    textAlign:
                        TextAlign.center, //S.of(context).register_withGoogle,
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    'Дата разблокировки:\n${widget.unlockDate}',
                    textAlign:
                        TextAlign.center, //S.of(context).register_withGoogle,
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
