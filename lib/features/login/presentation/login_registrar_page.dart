import 'package:a_galery_app/core/theme/app_colores.dart';
import 'package:a_galery_app/core/views/components/alertaSmall.dart';
import 'package:a_galery_app/core/views/components/appBar_general.dart';
import 'package:a_galery_app/core/views/components/app_loader.dart';
import 'package:a_galery_app/core/views/components/contrasena_input.dart';
import 'package:a_galery_app/features/login/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRegistrarPage extends StatefulWidget {
  const LoginRegistrarPage({super.key});

  @override
  State<LoginRegistrarPage> createState() => _LoginRegistrarPageState();
}

class _LoginRegistrarPageState extends State<LoginRegistrarPage> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final contrasenaController = TextEditingController();
  final confirmarContrasenaController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    emailController.dispose();
    contrasenaController.dispose();
    confirmarContrasenaController.dispose();
    super.dispose();
  }

  Future<void> _registrar(AuthProvider auth) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final exito = await auth.registrarConEmail(
      emailController.text,
      contrasenaController.text,
      nombre: nombreController.text,
    );

    // Si funcionó, el AuthWrapper en main.dart detecta el cambio de
    // estado y navega solo a la galería. Acá solo volvemos al login
    // por si el registro falló y el usuario quiere ajustar algo.
    if (exito && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: const AppBarGeneral(title: 'Crear cuenta'),
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
                            controller: nombreController,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            decoration: const InputDecoration(labelText: 'Nombre'),
                            validator: (valor) {
                              if (valor == null || valor.trim().isEmpty) return 'Ingresa tu nombre';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
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
                            textInputAction: TextInputAction.next,
                            validator: (valor) {
                              if (valor == null || valor.isEmpty) return 'Ingresa una contraseña';
                              if (valor.length < 6) return 'Debe tener al menos 6 caracteres';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Contrasenainput(
                            controller: confirmarContrasenaController,
                            label: 'Confirmar contraseña',
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _registrar(auth),
                            validator: (valor) {
                              if (valor == null || valor.isEmpty) return 'Confirma tu contraseña';
                              if (valor != contrasenaController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: auth.cargando ? null : () => _registrar(auth),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColores.azulObscuro),
                        child: auth.cargando
                            ? const AppLoader(size: 20, color: AppColores.blancoAcento)
                            : const Text('Crear cuenta'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿Ya tienes una cuenta?'),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Inicia sesión',
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
