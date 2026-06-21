import 'package:a_galery_app/core/theme/app_colores.dart';
import 'package:a_galery_app/core/theme/app_temas.dart';
import 'package:a_galery_app/core/views/components/app_loader.dart';
import 'package:a_galery_app/features/galery/presentation/galery_page.dart';
import 'package:a_galery_app/features/login/presentation/login_main_page.dart';
import 'package:a_galery_app/features/login/presentation/provider/auth_provider.dart';
import 'package:a_galery_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Acá se agregan más providers conforme crezcan las features
        // (galería, perfil, etc).
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppEstiloTema.temaClaro,
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Decide qué pantalla mostrar según el estado de autenticación:
/// cargando inicial -> loader de pantalla completa
/// autenticado       -> Galería
/// no autenticado    -> Login
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.estado) {
      case EstadoAuth.cargandoInicial:
        return const Scaffold(
          backgroundColor: AppColores.blanco,
          body: AppLoaderScreen(mensaje: 'Cargando'),
        );
      case EstadoAuth.autenticado:
        return const GaleryMainPage();
      case EstadoAuth.noAutenticado:
        return const LoginMainPage();
    }
  }
}
