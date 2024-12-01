const db = require('../Database/database');

const UserModel = {
    createUser: (user, callback) => {
        const sql = `INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)`;
        db.run(sql, [user.name, user.email, user.password, user.role], function (err) {
            callback(err, { id: this.lastID });
        });
    },

    getUserById: (id, callback) => {
        const sql = `SELECT id, name, email, role FROM users WHERE id = ?`;
        db.get(sql, [id], callback);
    },

    getAllUsers: (callback) => {
        const sql = `SELECT id, name, email, role FROM users`;
        db.all(sql, [], callback);
    },

    updateUser: (id, user, callback) => {
        const sql = `
            UPDATE users
            SET name = ?, email = ?, role = ?
            WHERE id = ?
        `;
        db.run(sql, [user.name, user.email, user.role, id], callback);
    },

    deleteUser: (id, callback) => {
        const sql = `DELETE FROM users WHERE id = ?`;
        db.run(sql, [id], callback);
    },
};

module.exports = UserModel;
