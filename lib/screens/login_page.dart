
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sentinel/helpers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sentinel/models/generic_inputs/my_textfield.dart';
import 'package:sentinel/models/showcase_widget.dart';
import 'package:sentinel/screens/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:toastification/toastification.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../models/generic_inputs/my_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  bool isPasswordValid(String password) {
    // Ejemplo de validación: mínimo 8 caracteres, al menos una letra y un número
    if (password.length < 9) return false;

    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));

    return hasLetter && hasNumber;
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      // Validar la contraseña
      String password = _controllerPassword.text.trim();
      if (!isPasswordValid(password)) {
        toastification.show(
          context: context,
          title: const Text("Error al iniciar sesión!", style: TextStyle(fontWeight: FontWeight.bold)),
          autoCloseDuration: const Duration(seconds: 10),
          description: const Text("Credenciales invalidas.", style: TextStyle(fontWeight: FontWeight.bold)),
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
        );
        return;
      }

      await FirebaseAuthServices().signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (_controllerPassword.text.trim() == "" || _controllerEmail.text.trim() == "") {
          toastification.show(
            context: context,
            title: const Text("Error al iniciar sesión!", style: TextStyle(fontWeight: FontWeight.bold)),
            autoCloseDuration: const Duration(seconds: 10),
            description: const Text("Uno o más campos no han sido llenados. \nPor favor llenarlos e re-intentar.", style: TextStyle(fontWeight: FontWeight.bold)),
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
          );
          return;
        } if (e.code == "invalid-credential") {
          toastification.show(
              context: context,
              title: const Text("Error al iniciar sesión!", style: TextStyle(fontWeight: FontWeight.bold)),
              autoCloseDuration: const Duration(seconds: 10),
              description: const Text("Credenciales incorrectas, por favor intentar otra vez.", style: TextStyle(fontWeight: FontWeight.bold),),
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored
          );
          return;
        } if (e.code == "wrong-password") {
          toastification.show(
              context: context,
              title: const Text("Error al iniciar sesión!", style: TextStyle(fontWeight: FontWeight.bold)),
              autoCloseDuration: const Duration(seconds: 10),
              description: const Text("Credenciales incorrectas, por favor intentar otra vez.", style: TextStyle(fontWeight: FontWeight.bold),),
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored
          );
          return;
        } if (e.code == "too-many-requests") {
          toastification.show(
              context: context,
              title: const Text("Error al iniciar sesión!",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              autoCloseDuration: const Duration(seconds: 10),
              description: const Text("Esta cuenta ha sido temporalmente desactivada debido a un exceso de solicitudes. Por favor espere un rato para intentarlo otra vez.",
                style: TextStyle(fontWeight: FontWeight.bold),),
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored
          );
          return;
        } if (e.code == "invalid-email") {
          toastification.show(
              context: context,
              title: const Text("Error al iniciar sesión!",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              autoCloseDuration: const Duration(seconds: 10),
              description: const Text("El correo introducido no es valido.",
                style: TextStyle(fontWeight: FontWeight.bold),),
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored
          );
          return;
        } else {
          toastification.show(
              context: context,
              title: const Text("Error al inciar sesión!"),
              autoCloseDuration: const Duration(seconds: 10),
              description: Text("Error desconocido. Por favor contactar a un administrador. ${e.code.toString()}", style: const TextStyle(fontWeight: FontWeight.bold),),
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored
          );
          return;
        }

      });
    }
  }

  Future<void> getShowcaseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final showcaseDone = prefs.getBool("login_showcase_is_passed") ?? false;
    if (showcaseDone == false){
      ShowCaseWidget.of(context).startShowCase([_zeroLogin, _oneLogin, _twoLogin, _threeLogin]);
      prefs.setBool("login_showcase_is_passed", true);
    }
  }

  static final GlobalKey _zeroLogin = GlobalKey();
  static final GlobalKey _oneLogin = GlobalKey();
  static final GlobalKey _twoLogin = GlobalKey();
  static final GlobalKey _threeLogin = GlobalKey();
  static final GlobalKey _fourLogin = GlobalKey();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () => WidgetsBinding.instance.addPostFrameCallback((_) {
      getShowcaseStatus();
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 1), () => WidgetsBinding.instance.addPostFrameCallback((_) {
      getShowcaseStatus();
    }));

    return Scaffold(
      backgroundColor: const Color(0xFFFFFB8D),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF044389),
        actions: [
          CustomShowcaseWidget(
              globalKey: _fourLogin,
              description: "Si te perdiste o necesitas que te diga esto otra vez, solo presiona aqui!",
              child: IconButton(
                  onPressed: () => ShowCaseWidget.of(context).startShowCase([
                    _LoginPageState._zeroLogin,
                    _LoginPageState._oneLogin,
                    _LoginPageState._twoLogin,
                    _LoginPageState._threeLogin]),
                  icon: const Icon(Icons.help), color: Colors.white))
        ],
      ),
      body: Stack(
        children: [
          // Waves background
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              height: MediaQuery.sizeOf(context).height,
              color: const Color(0xFF044389),
              child: WaveWidget(
                config: CustomConfig(
                    colors: [const Color(0xFF044389), const Color(0xFFFFFB8D)],
                    durations: [5000, 5000],
                    heightPercentages: [-0.3, 0.76]),
                size: Size(MediaQuery.sizeOf(context).height, MediaQuery.sizeOf(context).width),
                backgroundColor: const Color(0xFFFFFB8D),
                waveFrequency: 1,
                waveAmplitude: 1,
                wavePhase: 1000,

              ),
            ),
          ),
          // Contenido
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  CustomShowcaseWidget(
                      globalKey: _LoginPageState._zeroLogin,
                      title: "Bienvenido!",
                      description: "Hola, soy Will, woof! Para empezar, te estaré mostrando brevemente varias partes de esta pantalla!",
                      child: const Image(
                        image: AssetImage('assets/ssi_logo.png'),
                        width: 130,
                      ),),

                  const SizedBox(height: 20,),

                  const Text("Sentinel", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), ),
                  const Text("Bienvenido, por favor inicia sesión.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), ),
                  const SizedBox(height: 10,),

                  CustomShowcaseWidget(
                    title: "Datos de sesión",
                    globalKey: _LoginPageState._oneLogin,
                    description: "Bienvenido a la aplicación! Si previamente ya tenias una cuenta, por favor ingresa los datos.",
                    child: Column(
                      children: [
                        SentinelTextfield(hintText: "E-mail", obscureText: false, icon: Icons.email, controller: _controllerEmail,
                          suffixButton: IconButton(
                          onPressed: _controllerEmail.clear,
                          icon: const Icon(Icons.clear, color: Colors.black,),
                          ),
                        ),
                        SentinelTextfield(hintText: "Contraseña", obscureText: true, icon: Icons.key, controller: _controllerPassword,
                          suffixButton: IconButton(
                            onPressed: _controllerPassword.clear,
                            icon: const Icon(Icons.clear, color: Colors.black,),
                          ),),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10,),
                  CustomShowcaseWidget(
                    globalKey: _LoginPageState._twoLogin,
                    description: "Al ingresar tus datos, presiona en inicia sesión.",
                    child: SizedBox(
                      width: 322,
                      child: MyButton(
                        buttonIcon: Icons.login,
                        direction: Axis.horizontal,
                        onTap: () {
                          signInWithEmailAndPassword();
                        },
                        insertText: "Iniciar Sesión",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  CustomShowcaseWidget(
                    globalKey: _LoginPageState._threeLogin,
                    description: "Si no tienes cuenta, presiona aqui!",
                    child: SizedBox(
                      width: 322,
                      child: MyButton(
                        buttonIcon: Icons.add_reaction_outlined,
                        direction: Axis.horizontal,
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: ShowCaseWidget(builder: (context) => const RegisterPage()),
                                type: PageTransitionType.fade,
                              )
                          );
                        },
                        insertText: "¿No tienes cuenta?",
                      ),
                    ),
                  ),

                ],
            )
            ),
                    ),

      ]
      ),
    );

    
    
  }
}
