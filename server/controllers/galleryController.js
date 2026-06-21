const path = require('path');
const fs = require('fs');
const { getDb } = require('../config/database');

function getGallery(req, res) {
  const db = getDb();

  db.all(
    `SELECT id, filename, original_filename, file_size, file_type, uploaded_at
     FROM photos
     WHERE user_id = ? AND deleted = 0
     ORDER BY uploaded_at DESC`,
    [req.userId],
    (err, photos) => {
      if (err) return res.status(500).json({ success: false, message: 'Error al obtener galería' });
      res.json({ success: true, photos });
    },
  );
}

function getPhotoFile(req, res) {
  const { photoId } = req.params;
  const db = getDb();

  db.get(
    'SELECT * FROM photos WHERE id = ? AND user_id = ? AND deleted = 0',
    [photoId, req.userId],
    (err, photo) => {
      if (err) return res.status(500).json({ success: false, message: 'Error del servidor' });
      if (!photo) return res.status(404).json({ success: false, message: 'Archivo no encontrado' });

      const filePath = path.join(__dirname, '..', photo.file_path);
      if (!fs.existsSync(filePath)) {
        return res.status(404).json({ success: false, message: 'Archivo no encontrado en disco' });
      }

      res.sendFile(filePath);
    },
  );
}

function deletePhoto(req, res) {
  const { photoId } = req.params;
  const db = getDb();

  db.get(
    'SELECT * FROM photos WHERE id = ? AND user_id = ? AND deleted = 0',
    [photoId, req.userId],
    (err, photo) => {
      if (err) return res.status(500).json({ success: false, message: 'Error del servidor' });
      if (!photo) return res.status(404).json({ success: false, message: 'Archivo no encontrado' });

      const filePath = path.join(__dirname, '..', photo.file_path);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }

      db.run('UPDATE photos SET deleted = 1 WHERE id = ?', [photoId], (err) => {
        if (err) return res.status(500).json({ success: false, message: 'Error al eliminar' });
        res.json({ success: true, message: 'Archivo eliminado correctamente' });
      });
    },
  );
}

module.exports = { getGallery, getPhotoFile, deletePhoto };
