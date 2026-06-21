import 'package:flutter/material.dart';
import 'package:a_galery_app/core/theme/app_colores.dart';

enum TipoAlerta { error, exito, advertencia, info }

class AlertaSmall extends StatelessWidget {
  const AlertaSmall({super.key, required this.mensaje, this.tipo = TipoAlerta.error});

  final String mensaje;
  final TipoAlerta tipo;

  Color get _color => switch (tipo) {
    TipoAlerta.error => AppColores.rojoAlerta,
    TipoAlerta.exito => AppColores.verde,
    TipoAlerta.advertencia => AppColores.ambar,
    TipoAlerta.info => AppColores.azulAcento,
  };

  IconData get _icono => switch (tipo) {
    TipoAlerta.error => Icons.error_outline,
    TipoAlerta.exito => Icons.check_circle_outline,
    TipoAlerta.advertencia => Icons.warning_amber_outlined,
    TipoAlerta.info => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_icono, color: _color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(mensaje, style: TextStyle(color: _color, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  static void mostrarSnack(
    BuildContext context,
    String mensaje, {
    TipoAlerta tipo = TipoAlerta.error,
  }) {
    final color = switch (tipo) {
      TipoAlerta.error => AppColores.rojoAlerta,
      TipoAlerta.exito => AppColores.verde,
      TipoAlerta.advertencia => AppColores.ambar,
      TipoAlerta.info => AppColores.azulAcento,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  }
}
