const BorrowModel = require('../Models/borrowModel.js');

const BorrowController = {
    createBorrowRequest: (req, res) => {
        const { book_id, user_id } = req.body;

        if (!book_id || !user_id) {
            return res.status(400).json({ error: 'Book ID and User ID are required.' });
        }

        const borrowRequest = { book_id, user_id };
        BorrowModel.createBorrowRequest(borrowRequest, (err, result) => {
            if (err) return res.status(500).json({ error: err.message });
            res.status(201).json({ id: result.id, ...borrowRequest, status: 'pending' });
        });
    },

    getAllBorrowRequests: (req, res) => {
        BorrowModel.getBorrowRequests((err, rows) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(rows);
        });
    },

    updateBorrowStatus: (req, res) => {
        const { id } = req.params;
        const { status } = req.body;

        if (!['accepted', 'refused'].includes(status)) {
            return res.status(400).json({ error: 'Invalid status.' });
        }

        BorrowModel.updateBorrowStatus(id, status, (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: `Borrow request ${status}.` });
        });
    },

    getUserBorrowedBooks: (req, res) => {
        const { userId } = req.params;
        BorrowModel.getBorrowedBooksByUser(userId, (err, rows) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(rows);
        });
    },
};

module.exports = BorrowController;
