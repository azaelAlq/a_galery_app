require('dotenv').config();
const express = require('express');
const cors = require('cors');
const os = require('os');
const { initDb } = require('./config/database');

const authRoutes = require('./routes/auth');
const galleryRoutes = require('./routes/gallery');
const uploadRoutes = require('./routes/upload');

const app = express();
const PORT = process.env.PORT || 3000;

// ── Middleware ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ── Rutas ─────────────────────────────────────────────────────────────────────
app.use('/api/auth', authRoutes);
app.use('/api/gallery', galleryRoutes);
app.use('/api/upload', uploadRoutes);

// ── Health check (sin token) ──────────────────────────────────────────────────
app.get('/api/health', (_req, res) => {
  res.json({ success: true, message: 'Server is running', timestamp: new Date().toISOString() });
});

// ── 404 catch-all ─────────────────────────────────────────────────────────────
app.use((_req, res) => {
  res.status(404).json({ success: false, message: 'Ruta no encontrada' });
});

// ── Error handler global ──────────────────────────────────────────────────────
app.use((err, _req, res, _next) => {
  console.error('❌ Error:', err.message);
  res.status(500).json({ success: false, message: err.message || 'Error interno del servidor' });
});

// ── Helpers ───────────────────────────────────────────────────────────────────
function getLocalIp() {
  for (const ifaces of Object.values(os.networkInterfaces())) {
    for (const iface of ifaces) {
      if (iface.family === 'IPv4' && !iface.internal) return iface.address;
    }
  }
  return 'localhost';
}

// ── Arranque ──────────────────────────────────────────────────────────────────
initDb()
  .then(() => {
    app.listen(PORT, '0.0.0.0', () => {
      const ip = getLocalIp();
      console.log('\n🚀 Servidor iniciado');
      console.log(`   Local:   http://localhost:${PORT}`);
      console.log(`   Red:     http://${ip}:${PORT}`);
      console.log(`   Health:  http://${ip}:${PORT}/api/health\n`);
    });
  })
  .catch((err) => {
    console.error('❌ Error al inicializar DB:', err);
    process.exit(1);
  });
