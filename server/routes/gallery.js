// ─── routes/gallery.js ────────────────────────────────────────────────────────
const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middleware/auth');
const { getGallery, getPhotoFile, deletePhoto } = require('../controllers/galleryController');

router.get('/', verifyToken, getGallery);
router.get('/:photoId/file', verifyToken, getPhotoFile);
router.delete('/:photoId', verifyToken, deletePhoto);

module.exports = router;
