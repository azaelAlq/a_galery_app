import 'package:flutter/material.dart';

// Clase para estilos de navegación personalizados, se aplica en todas la navegaciones del proyecto

/*

Navigator.push(
  context,
  AppNavigatorStyle.fade(LoginMainPage()),
);

*/
class AppNavigatorStyle {
  //Animación de deslizamiento lateral (usado para cambios pequeños cuando el contexto de lo que se esta haciendo no cambia)
  static Route slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  //Animación de desvanecimiento(Usado para cambios grandes o de contexto de la aplicación)
  static Route fade(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
