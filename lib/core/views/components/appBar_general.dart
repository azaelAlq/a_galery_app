import 'package:a_galery_app/core/theme/app_colores.dart';
import 'package:flutter/material.dart';

class AppBarGeneral extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarGeneral({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent, // el color lo pone flexibleSpace
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColores.azulPrincipal, AppColores.azulObscuro],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColores.blanco, fontFamily: 'RobotoFlex'),
      ),
    );
  }
}
