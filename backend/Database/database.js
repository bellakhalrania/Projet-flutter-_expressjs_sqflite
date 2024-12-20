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


db.serialize(() => {
    db.run(`
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            role TEXT DEFAULT 'user'
        )
    `, (err) => {
        if (err) {
            console.error('Error creating users table:', err.message);
        }
    });
});



db.serialize(() => {
    // Table for borrow requests
    db.run(`
        CREATE TABLE IF NOT EXISTS borrow_requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            book_id INTEGER NOT NULL,
            user_id INTEGER NOT NULL,
            status TEXT DEFAULT 'pending', -- pending, accepted, refused
            request_date TEXT DEFAULT (datetime('now')),
            FOREIGN KEY (book_id) REFERENCES books(id),
            FOREIGN KEY (user_id) REFERENCES users(id)
        )
    `, (err) => {
        if (err) {
            console.error('Error creating borrow_requests table:', err.message);
        }
    });
});





module.exports = db;
