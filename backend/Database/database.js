const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Path to SQLite database file
const dbPath = path.resolve(__dirname, 'books.db');

// Connect to the SQLite database
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error('Database connection error:', err.message);
    } else {
        console.log('Connected to SQLite database.');
    }
});

// Create the "books" table if it doesn't exist
db.serialize(() => {
    db.run(`
        CREATE TABLE IF NOT EXISTS books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            year INTEGER,
            image TEXT
        )
    `, (err) => {
        if (err) {
            console.error('Error creating table:', err.message);
        }
    });
});

module.exports = db;
