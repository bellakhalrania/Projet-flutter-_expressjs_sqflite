const bcrypt = require('bcrypt'); // Pour le hachage de mot de passe
const jwt = require('jsonwebtoken'); // Pour générer des tokens JWT
const UserModel = require('../Models/userModel');
const SECRET_KEY = 'your_secret_key'; // Remplace par une clé secrète sécurisée

const UserController = {
    // Enregistrement d'un utilisateur
    register: async (req, res) => {
        const { name, email, password, role } = req.body;

        // Valider les champs requis
        if (!name || !email || !password) {
            return res.status(400).json({ error: 'Name, email, and password are required.' });
        }

        try {
            // Vérifier si l'utilisateur existe déjà
            const existingUser = await UserModel.getUserByEmail(email);
            if (existingUser) {
                return res.status(400).json({ error: 'Email is already in use.' });
            }

            // Hacher le mot de passe
            const hashedPassword = await bcrypt.hash(password, 10);
            const user = { name, email, password: hashedPassword, role: role || 'user' };

            // Créer l'utilisateur
            UserModel.createUser(user, (err, result) => {
                if (err) return res.status(500).json({ error: err.message });
                res.status(201).json({ message: 'User registered successfully', id: result.id });
            });
        } catch (err) {
            res.status(500).json({ error: 'An error occurred while registering the user.' });
        }
    },

   // Connexion d'un utilisateur
login: (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ error: 'Email and password are required.' });
    }

    // Vérifier si l'utilisateur existe
    UserModel.getUserByEmail(email, async (err, user) => {
        if (err) return res.status(500).json({ error: err.message });
        if (!user) return res.status(404).json({ error: 'User not found.' });

        // Vérifier le mot de passe
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ error: 'Invalid email or password.' });
        }

        // Générer un token JWT
        const token = jwt.sign({ id: user.id, role: user.role }, SECRET_KEY, { expiresIn: '1h' });

        // Retourner les informations de l'utilisateur
        res.json({
            message: 'Login successful',
            token,
            user: {
                id: user.id,
                name: user.name,
                role: user.role,
            },
        });
    });
},


    // Obtenir tous les utilisateurs (admin uniquement)
    getAllUsers: (req, res) => {
        UserModel.getAllUsers((err, rows) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(rows);
        });
    },

    // Obtenir un utilisateur par ID
    getUserById: (req, res) => {
        const { id } = req.params;
        UserModel.getUserById(id, (err, row) => {
            if (err) return res.status(500).json({ error: err.message });
            if (!row) return res.status(404).json({ message: 'User not found' });
            res.json(row);
        });
    },

    // Mise à jour d'un utilisateur
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

    // Suppression d'un utilisateur
    deleteUser: (req, res) => {
        const { id } = req.params;
        UserModel.deleteUser(id, (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: 'User deleted successfully' });
        });
    },
};

module.exports = UserController;
