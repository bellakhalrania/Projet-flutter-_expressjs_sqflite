const express = require('express');
const { BookController, upload } = require('../Controllers/bookController');

const router = express.Router();

router.get('/', BookController.getAllBooks);
router.get('/:id', BookController.getBookById);
router.post('/', upload.single('image'), BookController.createBook);
router.put('/:id', upload.single('image'), BookController.updateBook);
router.delete('/:id', BookController.deleteBook);

module.exports = router;
