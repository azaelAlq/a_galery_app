const jwt = require('jsonwebtoken');

function verifyToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader?.split(' ')[1]; // Bearer <token>

  if (!token) {
    return res.status(401).json({ success: false, message: 'Token requerido' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.userId;
    req.userEmail = decoded.email;
    next();
  } catch (err) {
    const msg =
      err.name === 'TokenExpiredError'
        ? 'Token expirado, inicia sesión de nuevo'
        : 'Token inválido';
    return res.status(403).json({ success: false, message: msg });
  }
}

module.exports = { verifyToken };
