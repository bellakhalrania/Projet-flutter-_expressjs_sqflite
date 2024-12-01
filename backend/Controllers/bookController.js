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
        const { title, author, year } = req.body;

        // Validate required fields
        if (!title || !author || !year) {
            return res.status(400).json({ error: 'Title, author, and year are required.' });
        }

        const parsedYear = parseInt(year, 10);
        if (isNaN(parsedYear)) {
            return res.status(400).json({ error: 'Year must be a number.' });
        }

        const book = {
            title,
            author,
            year: parsedYear, // Use parsed year
            image: req.file ? req.file.path : null,
        };

        BookModel.createBook(book, (err, result) => {
            if (err) return res.status(500).json({ error: err.message });
            res.status(201).json({ id: result.lastID, ...book });
        });
    },

    updateBook: (req, res) => {
        const { id } = req.params;
        const { title, author, year } = req.body;

        const book = {
            title,
            author,
            year: year ? parseInt(year, 10) : undefined, // Parse only if provided
            image: req.file ? req.file.path : req.body.image,
        };

        // Validate required fields
        if (!title || !author || (year && isNaN(book.year))) {
            return res.status(400).json({ error: 'Title, author and valid year are required.' });
        }

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
