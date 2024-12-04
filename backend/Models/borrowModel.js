const db = require('../Database/database');

const BorrowModel = {
    createBorrowRequest: (borrowRequest, callback) => {
        const sql = `INSERT INTO borrow_requests (book_id, user_id, status) VALUES (?, ?, ?)`;
        db.run(sql, [borrowRequest.book_id, borrowRequest.user_id, 'pending'], function (err) {
            callback(err, { id: this.lastID });
        });
    },

    getBorrowRequests: (callback) => {
        const sql = `
            SELECT br.id, b.title, u.name, br.status, br.request_date
            FROM borrow_requests br
            JOIN books b ON br.book_id = b.id
            JOIN users u ON br.user_id = u.id
        `;
        db.all(sql, [], callback);
    },

    updateBorrowStatus: (id, status, callback) => {
        const sql = `UPDATE borrow_requests SET status = ? WHERE id = ?`;
        db.run(sql, [status, id], callback);
    },

    getBorrowedBooksByUser: (userId, callback) => {
        const sql = `
            SELECT b.id, b.title, b.author, br.status, br.request_date
            FROM borrow_requests br
            JOIN books b ON br.book_id = b.id
            WHERE br.user_id = ? 
        `;
        db.all(sql, [userId], callback);
    },
};

module.exports = BorrowModel;
