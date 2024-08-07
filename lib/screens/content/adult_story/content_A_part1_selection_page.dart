import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sentinel/screens/content/adult_story/content_A_bad_ending_page.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../../../models/generic_inputs/my_button.dart';
import 'content_A_introduction_page.dart';
import 'content_A_part2_intermission_page.dart';

class ACSelectionPage1 extends StatefulWidget {
  const ACSelectionPage1({super.key});

  @override
  State<ACSelectionPage1> createState() => _ACSelectionPage1State();
}

class _ACSelectionPage1State extends State<ACSelectionPage1> {
  bool _showCorrectAnswer = false;

  final FlutterTts _flutterTts = FlutterTts();
  Future<void> _speakText() async {
    await _flutterTts.setLanguage("es-ES"); // Establecer el idioma
    await _flutterTts.setPitch(1.0); // Ajustar el tono
    await _flutterTts.speak("El correo, supuestamente enviado por su banco, le informa que hay un problema con su cuenta y le pide que haga clic en un enlace para verificar su información.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFB8D),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _speakText();
            },
            icon: const Icon(Icons.volume_up_outlined),
            color: Colors.black,
            tooltip: "Activar narrador",
          )
        ],
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              title: "Advertencia",
              text: "Estás seguro que deseas salir del juego? Perderás tu progreso!",
              confirmBtnColor: const Color(0xFF044389),
              confirmBtnText: "OK",
              cancelBtnText: "Cancelar",
              onConfirmBtnTap: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: const ACIntroductionPage(),
                    type: PageTransitionType.fade,
                  ),
                );
              },
            );
          },
        ),
        title: const Text(
          "Historia",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      backgroundColor: const Color(0xFFFFFB8D),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              height: MediaQuery.sizeOf(context).height,
              color: const Color(0xFFFFFB8D),
              child: WaveWidget(
                config: CustomConfig(
                  colors: [const Color(0xFFFFFB8D), const Color(0xFF044389)],
                  durations: [5000, 5000],
                  heightPercentages: [-0.3, 0.002],
                ),
                size: Size(
                  MediaQuery.sizeOf(context).height,
                  MediaQuery.sizeOf(context).width,
                ),
                backgroundColor: const Color(0xFF044389),
                waveFrequency: 1,
                waveAmplitude: 1,
                wavePhase: 1000,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    "El correo, supuestamente enviado por su banco, le informa que hay un problema con su cuenta y le pide que haga clic en un enlace para verificar su información.",
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "¿Qué hará Don Ramon?",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: MyButton(
                    direction: Axis.horizontal,
                    textColor: Colors.black,
                    buttonColor: const Color(0xFFFFFB8D),
                    buttonIconColor: Colors.black,
                    buttonIcon: Icons.ads_click,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const ACBadEndingPage1(gameOverReason: "El correo que cliqueaste tenia virus! Don Ramon ha perdido todos su datos importantes..."),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                    insertText: "Clic en el enlace",
                  ).animate(),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: MyButton(
                    direction: Axis.horizontal,
                    textColor: Colors.black,
                    buttonColor: const Color(0xFFFFFB8D),
                    buttonIconColor: Colors.black,
                    buttonIcon: Icons.warning_amber,
                    onTap: () {
                      setState(() {
                        _showCorrectAnswer = true;
                      });

                      Future.delayed(const Duration(milliseconds: 1500), () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: const ACIntermissionPage2(),
                            type: PageTransitionType.rightToLeftJoined,
                            childCurrent: widget,
                          ),
                        );
                      });
                    },
                    insertText: "Duda del correo",
                  ),
                ),
              ],
            ),
          ),
          if (_showCorrectAnswer)
            Positioned.fill(
              child: Container(
                color: Colors.green,
                child: Center(
                  child: const Text(
                    "Respuesta correcta!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate()
                      .fade(duration: 300.ms)
                      .scaleXY(begin: 0.7, end: 1, duration: 300.ms)
                      .then(delay: 700.ms)
                      .fade(duration: 300.ms, end: 0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
