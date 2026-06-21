const { v4: uuidv4 } = require('uuid');
const { getDb } = require('../config/database');

function uploadFiles(req, res) {
  if (!req.files || req.files.length === 0) {
    return res.status(400).json({ success: false, message: 'No se recibieron archivos' });
  }

  const db = getDb();
  const uploaded = [];
  const errors = [];

  const stmt = db.prepare(
    `INSERT INTO photos (id, user_id, filename, original_filename, file_path, file_size, file_type)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
  );

  for (const file of req.files) {
    const id = uuidv4();
    const fileType = file.mimetype.startsWith('video/') ? 'video' : 'image';
    const relPath = `uploads/${file.filename}`;

    try {
      stmt.run(id, req.userId, file.filename, file.originalname, relPath, file.size, fileType);
      uploaded.push({
        id,
        filename: file.filename,
        original_filename: file.originalname,
        file_type: fileType,
      });
    } catch (err) {
      errors.push({ file: file.originalname, error: err.message });
    }
  }

  stmt.finalize((err) => {
    if (err) return res.status(500).json({ success: false, message: 'Error al guardar metadatos' });
    res.json({ success: true, uploaded, errors });
  });
}

module.exports = { uploadFiles };
