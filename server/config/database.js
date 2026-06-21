const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');

const DB_DIR = path.join(__dirname, '../db');
const DB_PATH = path.join(DB_DIR, 'database.sqlite');

// Garantiza que la carpeta db/ exista
if (!fs.existsSync(DB_DIR)) fs.mkdirSync(DB_DIR, { recursive: true });

let db;

function getDb() {
  if (!db) {
    db = new sqlite3.Database(DB_PATH, (err) => {
      if (err) {
        console.error('❌ Error abriendo DB:', err.message);
        throw err;
      }
      console.log('✅ SQLite conectado en', DB_PATH);
    });
    db.run('PRAGMA foreign_keys = ON');
    db.run('PRAGMA journal_mode = WAL'); // mejor rendimiento con lecturas concurrentes
  }
  return db;
}

function initDb() {
  return new Promise((resolve, reject) => {
    const database = getDb();

    database.serialize(() => {
      database.run(`
        CREATE TABLE IF NOT EXISTS users (
          id           TEXT PRIMARY KEY,
          email        TEXT UNIQUE NOT NULL,
          password_hash TEXT NOT NULL,
          created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      `);

      database.run(
        `
        CREATE TABLE IF NOT EXISTS photos (
          id                TEXT PRIMARY KEY,
          user_id           TEXT NOT NULL,
          filename          TEXT NOT NULL,
          original_filename TEXT NOT NULL,
          file_path         TEXT NOT NULL,
          file_size         INTEGER NOT NULL,
          file_type         TEXT NOT NULL CHECK(file_type IN ('image', 'video')),
          uploaded_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
          deleted           INTEGER DEFAULT 0,
          FOREIGN KEY (user_id) REFERENCES users(id)
        )
      `,
        (err) => {
          if (err) reject(err);
          else {
            console.log('✅ Tablas listas');
            resolve();
          }
        },
      );
    });
  });
}

module.exports = { getDb, initDb };
