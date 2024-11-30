const db = require('../Database/database');

const BookModel = {
    getAllBooks: (callback) => {
        db.all('SELECT * FROM books', [], callback);
    },

    getBookById: (id, callback) => {
        db.get('SELECT * FROM books WHERE id = ?', [id], callback);
    },

    createBook: (book, callback) => {
        const query = 'INSERT INTO books (title, author, year, image) VALUES (?, ?, ?, ?)';
        db.run(query, [book.title, book.author, book.year, book.image], function (err) {
            callback(err, this);
        });
    },

    updateBook: (id, book, callback) => {
        const query = 'UPDATE books SET title = ?, author = ?, year = ?, image = ? WHERE id = ?';
        db.run(query, [book.title, book.author, book.year, book.image, id], callback);
    },

    deleteBook: (id, callback) => {
        db.run('DELETE FROM books WHERE id = ?', [id], callback);
    },
};

module.exports = BookModel;
