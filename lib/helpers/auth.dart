import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class FirebaseAuthServices{

  // TODO: Agregar fucking verificacion de email Y *EDAD ESPECIALMENTE* y TAL VEZ de SMS si se puede con el plan gratis


  // Base de Datos
  FirebaseFirestore db = FirebaseFirestore.instance;
  // Instancia de Autenticación
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Agarrar usuario actual
  User? get currentUser => _firebaseAuth.currentUser;
  // asdasd
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();


  // sign in
  Future<void> signInWithEmailAndPassword ({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  checkVerificationStatus(){

    if (currentUser?.emailVerified == false){
      return false;
    } else {
      return true;
    }

  }

  // sign up
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification() async {

    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException {

    }

  }


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<FirebaseAuth> getInstanceData() async {

    FirebaseAuth firebaseAuthData = FirebaseAuth.instance;

    return firebaseAuthData;

  }

}
