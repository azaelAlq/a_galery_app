// ─── routes/upload.js ─────────────────────────────────────────────────────────
const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const { verifyToken } = require('../middleware/auth');
const { uploadFiles } = require('../controllers/uploadController');

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, path.join(__dirname, '../uploads')),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    const name = `${Date.now()}-${Math.round(Math.random() * 1e9)}${ext}`;
    cb(null, name);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 500 * 1024 * 1024 }, // 500 MB por archivo
  fileFilter: (req, file, cb) => {
    const extOk = /\.(jpe?g|png|gif|mp4|mov|avi|mkv|heic|heif)$/.test(
      path.extname(file.originalname).toLowerCase(),
    );
    const mimeOk = /^(image|video)\//.test(file.mimetype);
    extOk && mimeOk ? cb(null, true) : cb(new Error('Tipo de archivo no permitido'));
  },
});

router.post('/', verifyToken, upload.array('files', 50), uploadFiles);

module.exports = router;
