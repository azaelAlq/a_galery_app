const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const { getDb } = require('../config/database');

function register(req, res) {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ success: false, message: 'Email y contraseña requeridos' });
  }
  if (password.length < 6) {
    return res
      .status(400)
      .json({ success: false, message: 'La contraseña debe tener al menos 6 caracteres' });
  }

  const db = getDb();
  const id = uuidv4();
  const passwordHash = bcrypt.hashSync(password, 10);

  db.run(
    'INSERT INTO users (id, email, password_hash) VALUES (?, ?, ?)',
    [id, email.trim().toLowerCase(), passwordHash],
    function (err) {
      if (err) {
        if (err.message.includes('UNIQUE constraint failed')) {
          return res.status(409).json({ success: false, message: 'El email ya está registrado' });
        }
        return res.status(500).json({ success: false, message: 'Error al registrar usuario' });
      }
      res.json({ success: true, message: 'Usuario registrado correctamente' });
    },
  );
}

function login(req, res) {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ success: false, message: 'Email y contraseña requeridos' });
  }

  const db = getDb();

  db.get('SELECT * FROM users WHERE email = ?', [email.trim().toLowerCase()], (err, user) => {
    if (err) return res.status(500).json({ success: false, message: 'Error del servidor' });
    if (!user) return res.status(401).json({ success: false, message: 'Credenciales inválidas' });

    const valid = bcrypt.compareSync(password, user.password_hash);
    if (!valid) return res.status(401).json({ success: false, message: 'Credenciales inválidas' });

    const token = jwt.sign({ userId: user.id, email: user.email }, process.env.JWT_SECRET, {
      expiresIn: '30d',
    });

    res.json({ success: true, token, user_id: user.id, email: user.email });
  });
}

module.exports = { register, login };
