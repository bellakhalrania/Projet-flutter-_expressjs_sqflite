const db = require('../Database/database');

const UserModel = {
    createUser: (user, callback) => {
        const { name, email, password, role } = user;
        db.run(
            `INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)`,
            [name, email, password, role],
            function (err) {
                callback(err, { id: this.lastID });
            }
        );
    },

    getUserByEmail: (email, callback) => {
        db.get(`SELECT * FROM users WHERE email = ?`, [email], callback);
    },

    getUserById: (id, callback) => {
        db.get(`SELECT * FROM users WHERE id = ?`, [id], callback);
    },

    getAllUsers: (callback) => {
        db.all(`SELECT * FROM users`, [], callback);
    },

    updateUser: (id, user, callback) => {
        const { name, email, role } = user;
        db.run(
            `UPDATE users SET name = ?, email = ?, role = ? WHERE id = ?`,
            [name, email, role, id],
            callback
        );
    },

    deleteUser: (id, callback) => {
        db.run(`DELETE FROM users WHERE id = ?`, [id], callback);
    },
};

module.exports = UserModel;
