const express = require('express');
const BorrowController = require('../Controllers/borrowController');

const router = express.Router();

router.post('/', BorrowController.createBorrowRequest); // Create a borrow request
router.get('/', BorrowController.getAllBorrowRequests); // Admin: Get all borrow requests
router.put('/:id', BorrowController.updateBorrowStatus); // Admin: Accept or refuse a request
router.get('/user/:userId', BorrowController.getUserBorrowedBooks); // User: Get borrowed books

module.exports = router;
