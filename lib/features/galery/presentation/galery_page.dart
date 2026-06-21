import 'package:a_galery_app/core/theme/app_colores.dart';
import 'package:a_galery_app/core/views/components/appBar_general.dart';
import 'package:a_galery_app/features/login/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Placeholder temporal — reemplazar cuando la feature de galería esté lista.
class GaleryMainPage extends StatelessWidget {
  const GaleryMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final usuario = auth.usuario;

    return Scaffold(
      appBar: AppBarGeneral(title: 'Mi Galería'),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_library_outlined, size: 64, color: AppColores.azulAcento),
            const SizedBox(height: 16),
            Text(
              '¡Bienvenido${usuario?.nombre != null ? ', ${usuario!.nombre}' : ''}!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(usuario?.correo ?? '', style: const TextStyle(color: AppColores.textoSecundario)),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => auth.cerrarSesion(),
              icon: const Icon(Icons.logout, color: AppColores.rojoAlerta),
              label: const Text('Cerrar sesión', style: TextStyle(color: AppColores.rojoAlerta)),
            ),
          ],
        ),
      ),
    );
  }
}
