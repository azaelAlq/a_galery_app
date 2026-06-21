import 'package:a_galery_app/core/theme/app_colores.dart';
import 'package:a_galery_app/core/views/components/alertaSmall.dart';
import 'package:a_galery_app/core/views/components/appBar_general.dart';
import 'package:a_galery_app/core/views/components/app_loader.dart';
import 'package:a_galery_app/features/login/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginOlvideContrasenaPage extends StatefulWidget {
  const LoginOlvideContrasenaPage({super.key});

  @override
  State<LoginOlvideContrasenaPage> createState() => _LoginOlvideContrasenaPageState();
}

class _LoginOlvideContrasenaPageState extends State<LoginOlvideContrasenaPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool _correoEnviado = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _enviarCorreo(AuthProvider auth) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final exito = await auth.enviarCorreoRecuperacion(emailController.text);
    if (exito && mounted) {
      setState(() => _correoEnviado = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: const AppBarGeneral(title: 'Recuperar contraseña'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _correoEnviado
                  ? _MensajeExito(correo: emailController.text)
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Ingresa el correo de tu cuenta y te enviaremos un enlace '
                            'para restablecer tu contraseña.',
                            style: TextStyle(color: AppColores.textoSecundario),
                          ),
                          const SizedBox(height: 20),
                          if (auth.error != null) ...[
                            AlertaSmall(mensaje: auth.error!),
                            const SizedBox(height: 16),
                          ],
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.email],
                            onFieldSubmitted: (_) => _enviarCorreo(auth),
                            decoration: const InputDecoration(labelText: 'Correo electrónico'),
                            validator: (valor) {
                              if (valor == null || valor.trim().isEmpty) return 'Ingresa tu correo';
                              if (!valor.contains('@')) return 'Correo no válido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: auth.cargando ? null : () => _enviarCorreo(auth),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColores.azulObscuro,
                              ),
                              child: auth.cargando
                                  ? const AppLoader(size: 20, color: AppColores.blancoAcento)
                                  : const Text('Enviar enlace'),
                            ),
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

class _MensajeExito extends StatelessWidget {
  final String correo;
  const _MensajeExito({required this.correo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.mark_email_read_outlined, size: 56, color: AppColores.azulAcento),
        const SizedBox(height: 16),
        Text(
          'Te enviamos un enlace a $correo para restablecer tu contraseña.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColores.textoSecundario),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Volver a iniciar sesión'),
          ),
        ),
      ],
    );
  }
}
