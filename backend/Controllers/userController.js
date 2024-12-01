const UserModel = require('../Models/userModel');

const UserController = {
    createUser: (req, res) => {
        const { name, email, password, role } = req.body;

        // Valider les champs requis
        if (!name || !email || !password) {
            return res.status(400).json({ error: 'Name, email, and password are required.' });
        }

        const user = { name, email, password, role: role || 'user' };
        UserModel.createUser(user, (err, result) => {
            if (err) return res.status(500).json({ error: err.message });
            res.status(201).json({ id: result.id, ...user });
        });
    },

    getUserById: (req, res) => {
        const { id } = req.params;
        UserModel.getUserById(id, (err, row) => {
            if (err) return res.status(500).json({ error: err.message });
            if (!row) return res.status(404).json({ message: 'User not found' });
            res.json(row);
        });
    },

    getAllUsers: (req, res) => {
        UserModel.getAllUsers((err, rows) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(rows);
        });
    },

    updateUser: (req, res) => {
        const { id } = req.params;
        const { name, email, role } = req.body;

        if (!name || !email) {
            return res.status(400).json({ error: 'Name and email are required.' });
        }

        const user = { name, email, role: role || 'user' };
        UserModel.updateUser(id, user, (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: 'User updated successfully' });
        });
    },

    deleteUser: (req, res) => {
        const { id } = req.params;
        UserModel.deleteUser(id, (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: 'User deleted successfully' });
        });
    },
};

module.exports = UserController;
