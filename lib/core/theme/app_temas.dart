import 'package:flutter/material.dart';
import 'app_colores.dart';

class AppEstiloTema {
  // Gradiente compartido — mismo que SaldoRestante pero más sutil
  static const gradientePrincipal = LinearGradient(
    colors: [AppColores.azulPrincipal, AppColores.azulObscuro],
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  static ThemeData temaClaro = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'RobotoFlex',

    scaffoldBackgroundColor: AppColores.blanco,
    primaryColor: AppColores.azulObscuro,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    colorScheme: const ColorScheme.light(
      primary: AppColores.azulObscuro,
      secondary: AppColores.azulAcento,
      background: AppColores.blanco,
      surface: AppColores.blancoAcento,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: AppColores.negroGris,
      onSurface: AppColores.negroGris,
      error: Color(0xFFD32F2F),
    ),

    // AppBar: sin color sólido — el gradiente lo aplica AppBarGradiente
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 22,
        letterSpacing: 1.1,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),

    // ElevatedButton: transparente — el gradiente lo pone BtnGradiente
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        minimumSize: const Size(double.infinity, 54),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: .4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColores.azulPrincipal,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColores.azulObscuro,
        side: const BorderSide(color: Color(0xFFE2E6F0)),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColores.blancoAcento,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      hintStyle: const TextStyle(
        color: AppColores.grisPrincipal,
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      labelStyle: const TextStyle(color: AppColores.grisPrincipal, fontWeight: FontWeight.w500),
      prefixIconColor: AppColores.azulPrincipal,
      suffixIconColor: AppColores.negroGris,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E6F0), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E6F0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColores.azulAcento, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.4),
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColores.negroGris,
        fontWeight: FontWeight.w800,
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        color: AppColores.negroGris,
        fontWeight: FontWeight.w800,
        fontSize: 26,
      ),
      titleLarge: TextStyle(color: AppColores.negroGris, fontWeight: FontWeight.w700, fontSize: 22),
      titleMedium: TextStyle(
        color: AppColores.negroGris,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(color: AppColores.negroGris, fontWeight: FontWeight.w400, fontSize: 16),
      bodyMedium: TextStyle(color: AppColores.negroGris, fontWeight: FontWeight.w400, fontSize: 14),
      bodySmall: TextStyle(
        color: AppColores.grisPrincipal,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    ),

    iconTheme: const IconThemeData(color: AppColores.azulPrincipal, size: 24),

    dividerTheme: const DividerThemeData(color: Color(0xFFE2E6F0), thickness: 1, space: 1),

    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.white),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColores.azulObscuro;
        return Colors.transparent;
      }),
      side: const BorderSide(color: AppColores.grisPrincipal, width: 1.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColores.verde,
      linearTrackColor: Color(0xFFE2E6F0),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColores.blancoAcento,
      selectedItemColor: AppColores.azulObscuro,
      unselectedItemColor: AppColores.grisPrincipal,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColores.azulPrincipal,
      textColor: AppColores.negroGris,
      tileColor: AppColores.blancoAcento,
      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
  );
}
