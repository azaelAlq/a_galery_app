class UsuarioModel {
  final String uid;
  final String? correo;
  final String? nombre;
  final bool correoVerificado;

  const UsuarioModel({required this.uid, this.correo, this.nombre, this.correoVerificado = false});
}
