import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:a_galery_app/features/login/model/usuario_model.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleSignInInicializado = false;

  Future<void> _asegurarGoogleSignInInicializado() async {
    if (_googleSignInInicializado) return;
    await _googleSignIn.initialize();
    _googleSignInInicializado = true;
  }

  /// Stream del estado de autenticación, null = no hay sesión
  Stream<UsuarioModel?> get cambiosDeUsuario {
    return _firebaseAuth.authStateChanges().map(_mapearUsuario);
  }

  UsuarioModel? get usuarioActual => _mapearUsuario(_firebaseAuth.currentUser);

  UsuarioModel? _mapearUsuario(User? user) {
    if (user == null) return null;
    return UsuarioModel(
      uid: user.uid,
      correo: user.email,
      nombre: user.displayName,
      correoVerificado: user.emailVerified,
    );
  }

  Future<UsuarioModel?> loginConEmail(String correo, String contrasena) async {
    final credencial = await _firebaseAuth.signInWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );
    return _mapearUsuario(credencial.user);
  }

  Future<UsuarioModel?> registrarConEmail(
    String correo,
    String contrasena, {
    String? nombre,
  }) async {
    final credencial = await _firebaseAuth.createUserWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );

    if (nombre != null && nombre.trim().isNotEmpty) {
      await credencial.user?.updateDisplayName(nombre.trim());
      await credencial.user?.reload();
    }

    return _mapearUsuario(_firebaseAuth.currentUser);
  }

  Future<void> enviarCorreoRecuperacion(String correo) async {
    await _firebaseAuth.sendPasswordResetEmail(email: correo.trim());
  }

  Future<UsuarioModel?> loginConGoogle() async {
    await _asegurarGoogleSignInInicializado();

    final cuentaGoogle = await _googleSignIn.authenticate();

    final autenticacion = cuentaGoogle.authentication;
    final credencial = GoogleAuthProvider.credential(idToken: autenticacion.idToken);

    final resultado = await _firebaseAuth.signInWithCredential(credencial);
    return _mapearUsuario(resultado.user);
  }

  Future<void> cerrarSesion() async {
    await _firebaseAuth.signOut();
  }

  /// Traduce los códigos de error de Firebase a mensajes en español
  /// entendibles para el usuario.
  String mensajeError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'El correo no es válido.';
        case 'user-disabled':
          return 'Esta cuenta fue deshabilitada.';
        case 'user-not-found':
          return 'No existe una cuenta con ese correo.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Correo o contraseña incorrectos.';
        case 'email-already-in-use':
          return 'Ya existe una cuenta con ese correo.';
        case 'weak-password':
          return 'La contraseña es muy débil, usa al menos 6 caracteres.';
        case 'too-many-requests':
          return 'Demasiados intentos. Intenta de nuevo más tarde.';
        case 'network-request-failed':
          return 'Sin conexión a internet.';
        default:
          return 'Ocurrió un error. Intenta de nuevo.';
      }
    }
    if (error is GoogleSignInException) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return 'Cancelaste el inicio de sesión.';
      }
      return 'No se pudo conectar con Google. Intenta de nuevo.';
    }
    if (error is UnimplementedError) {
      return 'Esta función todavía no está disponible.';
    }
    return 'Ocurrió un error inesperado.';
  }
}
