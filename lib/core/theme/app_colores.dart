import 'package:flutter/material.dart';

class AppColores {
  // ── Colores originales (sin modificar) ──────────────────────────────
  static const verde = Color(0xFF35C85A);
  static const cafe = Color(0xFF102A83);
  static const cafeOscuro = Color(0xFF030040);
  static const blanco = Color(0xFFF8F7FC);
  static const azulAcento = Color(0xFF4D7CFE);
  static const azulPrincipal = Color(0xFF102A83);
  static const azulObscuro = Color(0xFF05006D);
  static const blancoAcento = Color(0xFFFFFFFF);
  static const grisPrincipal = Color(0xFF667085);
  static const negroGris = Color(0xFF111827);

  static Color? get colorPrimario => azulObscuro;

  // ── Colores nuevos requeridos por los componentes ───────────────────

  // Superficies
  static const fondoClaro = Color(0xFFF8F7FC); // mismo que blanco, alias semántico
  static const superficieClara = Color(0xFFFFFFFF);
  static const superficieOscura = Color(0xFF0E1A3A); // azul muy oscuro para dark cards
  static const fondoOscuro = Color(0xFF05006D); // mismo que azulObscuro, alias

  // Bordes
  static const bordeClaro = Color(0xFFDDE3F0); // borde suave light mode
  static const bordeOscuro = Color(0xFF1C2D5A); // borde suave dark mode

  // Texto secundario (etiquetas, hints)
  static const textoSecundario = Color(0xFF667085); // mismo que grisPrincipal, alias

  // Alertas / semánticos
  static const rojoAlerta = Color(0xFFFF4757);
  static const ambar = Color(0xFFFFC107);
}
