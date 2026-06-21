import 'package:a_galery_app/core/theme/app_colores.dart';
import 'package:a_galery_app/core/views/components/alertaSmall.dart';
import 'package:a_galery_app/core/views/components/appBar_general.dart';
import 'package:a_galery_app/core/views/components/app_loader.dart';
import 'package:a_galery_app/core/views/components/contrasena_input.dart';
import 'package:a_galery_app/core/views/navegacion_animacion.dart';
import 'package:a_galery_app/features/login/presentation/login_olvideContrasena_page.dart';
import 'package:a_galery_app/features/login/presentation/login_registrar_page.dart';
import 'package:a_galery_app/features/login/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginMainPage extends StatefulWidget {
  const LoginMainPage({super.key});

  @override
  State<LoginMainPage> createState() => _LoginMainPageState();
}

class _LoginMainPageState extends State<LoginMainPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final contrasenaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _loginConEmail(AuthProvider auth) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await auth.loginConEmail(emailController.text, contrasenaController.text);
    // La navegación a la galería la maneja el AuthWrapper en main.dart
    // al escuchar el cambio de estado, no hace falta navegar manualmente acá.
  }

  Future<void> _loginConGoogle(AuthProvider auth) async {
    await auth.loginConGoogle();
  }

  void _irARegistro() {
    Navigator.push(context, AppNavigatorStyle.slide(const LoginRegistrarPage()));
  }

  void _irARecuperarContrasena() {
    Navigator.push(context, AppNavigatorStyle.slide(const LoginOlvideContrasenaPage()));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: const AppBarGeneral(title: 'Iniciar sesión'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (auth.error != null) ...[
                      AlertaSmall(mensaje: auth.error!),
                      const SizedBox(height: 16),
                    ],
                    AutofillGroup(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            decoration: const InputDecoration(labelText: 'Correo electrónico'),
                            validator: (valor) {
                              if (valor == null || valor.trim().isEmpty) return 'Ingresa tu correo';
                              if (!valor.contains('@')) return 'Correo no válido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Contrasenainput(
                            controller: contrasenaController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _loginConEmail(auth),
                            validator: (valor) =>
                                (valor == null || valor.isEmpty) ? 'Ingresa tu contraseña' : null,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _irARecuperarContrasena,
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: AppColores.azulAcento),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: auth.cargando ? null : () => _loginConEmail(auth),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColores.azulObscuro),
                        child: auth.cargando
                            ? const AppLoader(size: 20, color: AppColores.blancoAcento)
                            : const Text('Acceder'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColores.bordeClaro)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('o', style: TextStyle(color: AppColores.textoSecundario)),
                        ),
                        Expanded(child: Divider(color: AppColores.bordeClaro)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: auth.cargando ? null : () => _loginConGoogle(auth),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColores.bordeClaro),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: auth.cargando ? const AppLoader(size: 18) : const _GoogleLogo(),
                        label: Text(
                          auth.cargando ? 'Conectando…' : 'Continuar con Google',
                          style: const TextStyle(
                            color: AppColores.negroGris,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes una cuenta?'),
                        TextButton(
                          onPressed: _irARegistro,
                          child: const Text(
                            'Regístrate',
                            style: TextStyle(color: AppColores.azulAcento),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder del logo de Google — cámbialo luego por el SVG/PNG oficial.
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: Text(
        'G',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4285F4)),
      ),
    );
  }
}
