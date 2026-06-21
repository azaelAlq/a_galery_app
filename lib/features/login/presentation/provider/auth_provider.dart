import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:a_galery_app/features/login/data/auth_repository.dart';
import 'package:a_galery_app/features/login/model/usuario_model.dart';

enum EstadoAuth { cargandoInicial, autenticado, noAutenticado }

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository}) : _repository = repository ?? AuthRepository.instance {
    _suscripcion = _repository.cambiosDeUsuario.listen(_alCambiarUsuario);
  }

  final AuthRepository _repository;
  late final StreamSubscription<UsuarioModel?> _suscripcion;

  EstadoAuth _estado = EstadoAuth.cargandoInicial;
  UsuarioModel? _usuario;
  bool _cargando = false;
  String? _error;

  EstadoAuth get estado => _estado;
  UsuarioModel? get usuario => _usuario;
  bool get cargando => _cargando;
  String? get error => _error;

  void _alCambiarUsuario(UsuarioModel? usuario) {
    _usuario = usuario;
    _estado = usuario != null ? EstadoAuth.autenticado : EstadoAuth.noAutenticado;
    notifyListeners();
  }

  void limpiarError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> loginConEmail(String correo, String contrasena) async {
    _setCargando(true);
    try {
      await _repository.loginConEmail(correo, contrasena);
      return true;
    } catch (e) {
      _error = _repository.mensajeError(e);
      return false;
    } finally {
      _setCargando(false);
    }
  }

  Future<bool> registrarConEmail(String correo, String contrasena, {String? nombre}) async {
    _setCargando(true);
    try {
      await _repository.registrarConEmail(correo, contrasena, nombre: nombre);
      return true;
    } catch (e) {
      _error = _repository.mensajeError(e);
      return false;
    } finally {
      _setCargando(false);
    }
  }

  Future<bool> enviarCorreoRecuperacion(String correo) async {
    _setCargando(true);
    try {
      await _repository.enviarCorreoRecuperacion(correo);
      return true;
    } catch (e) {
      _error = _repository.mensajeError(e);
      return false;
    } finally {
      _setCargando(false);
    }
  }

  /// Sin funcionalidad real todavía (ver AuthRepository.loginConGoogle).
  Future<bool> loginConGoogle() async {
    _setCargando(true);
    try {
      await _repository.loginConGoogle();
      return true;
    } catch (e) {
      _error = _repository.mensajeError(e);
      return false;
    } finally {
      _setCargando(false);
    }
  }

  Future<void> cerrarSesion() async {
    await _repository.cerrarSesion();
  }

  void _setCargando(bool valor) {
    _cargando = valor;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _suscripcion.cancel();
    super.dispose();
  }
}
