import 'dart:async';

import 'package:flutter/material.dart';
import 'package:a_galery_app/core/theme/app_colores.dart';

/*
Sustituto del CircularProgressIndicator.

Uso básico (pantalla completa centrada):
  const AppLoader()

Uso dentro de un botón:
  const AppLoader(size: 5, color: Colors.black)

Uso en línea con texto:
  Row(children: [const AppLoader(size: 7), SizedBox(width: 10), Text('Cargando...')])
*/

class AppLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final int dotCount;

  const AppLoader({super.key, this.size = 10, this.color, this.dotCount = 3});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(widget.dotCount, (i) {
      return AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    });

    _animations = _controllers.map((c) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();

    // Arrancar cada punto con un delay escalonado
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.color ?? AppColores.azulPrincipal;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) {
            final t = _animations[i].value;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.3),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: dotColor.withOpacity(0.3 + 0.7 * t),
                shape: BoxShape.circle,
              ),
              transform: Matrix4.translationValues(0, -widget.size * 0.6 * t, 0),
            );
          },
        );
      }),
    );
  }
}

// Versión centrada para pantallas completas
class AppLoaderScreen extends StatefulWidget {
  final String? mensaje;
  final String? subMensaje;

  const AppLoaderScreen({super.key, this.mensaje, this.subMensaje});

  @override
  State<AppLoaderScreen> createState() => _AppLoaderScreenState();
}

class _AppLoaderScreenState extends State<AppLoaderScreen> with TickerProviderStateMixin {
  late final AnimationController _orbitA;
  late final AnimationController _orbitB;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _orbitA = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();
    _orbitB = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat(reverse: false);
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbitA.dispose();
    _orbitB.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Núcleo
                ScaleTransition(
                  scale: Tween(
                    begin: 1.0,
                    end: 1.15,
                  ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut)),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColores.azulAcento,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Órbita 1
                AnimatedBuilder(
                  animation: _orbitA,
                  builder: (_, __) => Transform.rotate(
                    angle: _orbitA.value * 2 * 3.14159,
                    child: Transform.translate(
                      offset: const Offset(22, 0),
                      child: Transform.rotate(
                        angle: -_orbitA.value * 2 * 3.14159,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColores.azulPrincipal,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Órbita 2 (inversa)
                AnimatedBuilder(
                  animation: _orbitB,
                  builder: (_, __) => Transform.rotate(
                    angle: -_orbitB.value * 2 * 3.14159,
                    child: Transform.translate(
                      offset: const Offset(34, 0),
                      child: Transform.rotate(
                        angle: _orbitB.value * 2 * 3.14159,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColores.azulPrincipal,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Column(
              key: ValueKey(widget.mensaje),
              children: [
                if (widget.mensaje != null) _DotsText(text: widget.mensaje!),
                if (widget.subMensaje != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.subMensaje!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColores.grisPrincipal.withOpacity(0.5),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Texto con "..." animado al final
class _DotsText extends StatefulWidget {
  final String text;
  const _DotsText({required this.text});

  @override
  State<_DotsText> createState() => _DotsTextState();
}

class _DotsTextState extends State<_DotsText> {
  int _dots = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 467), (_) {
      setState(() => _dots = (_dots + 1) % 4);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.text}${'.' * _dots}',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColores.grisPrincipal,
      ),
    );
  }
}
