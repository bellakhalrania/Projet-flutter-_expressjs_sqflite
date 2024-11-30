const multer = require('multer');
const path = require('path');
const BookModel = require('../Models/bookModel');

// Configure multer for file uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        // Ensure uploads folder exists
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}-${file.originalname}`);
    },
});
const upload = multer({ storage });

// Book Controller Logic
const BookController = {
    getAllBooks: (req, res) => {
        BookModel.getAllBooks((err, rows) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(rows);
        });
    },

    getBookById: (req, res) => {
        const { id } = req.params;
        BookModel.getBookById(id, (err, row) => {
            if (err) return res.status(500).json({ error: err.message });
            if (!row) return res.status(404).json({ message: 'Book not found' });
            res.json(row);
        });
    },

    createBook: (req, res) => {
        const book = {
            title: req.body.title,
            author: req.body.author,
            year: req.body.year,
            image: req.file ? req.file.path : null,
        };
        BookModel.createBook(book, (err, result) => {
            if (err) return res.status(500).json({ error: err.message });
            res.status(201).json({ id: result.lastID, ...book });
        });
    },

    updateBook: (req, res) => {
        const { id } = req.params;
        const book = {
            title: req.body.title,
            author: req.body.author,
            year: req.body.year,
            image: req.file ? req.file.path : req.body.image,
        };
        BookModel.updateBook(id, book, (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: 'Book updated successfully' });
        });
    },

    deleteBook: (req, res) => {
        const { id } = req.params;
        BookModel.deleteBook(id, (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: 'Book deleted successfully' });
        });
    },
};

module.exports = { BookController, upload };
