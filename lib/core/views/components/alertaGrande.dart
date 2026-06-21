import 'package:flutter/material.dart';
import 'package:a_galery_app/core/theme/app_colores.dart';

class AlertaGrande {
  static Future<bool?> mostrarConfirmacion(
    BuildContext context, {
    required String titulo,
    required String mensaje,
    String textoConfirmar = 'Aceptar',
    String textoCancelar = 'Cancelar',
    bool esDestructivo = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(textoCancelar, style: const TextStyle(color: AppColores.textoSecundario)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              textoConfirmar,
              style: TextStyle(
                color: esDestructivo ? AppColores.rojoAlerta : AppColores.azulAcento,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> mostrarInfo(
    BuildContext context, {
    required String titulo,
    required String mensaje,
    String textoBoton = 'Entendido',
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(textoBoton)),
        ],
      ),
    );
  }
}
