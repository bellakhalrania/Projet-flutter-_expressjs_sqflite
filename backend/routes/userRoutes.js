const express = require('express');
const UserController = require('../Controllers/userController');

const router = express.Router();

router.get('/', UserController.getAllUsers); // Obtenir tous les utilisateurs
router.get('/:id', UserController.getUserById); // Obtenir un utilisateur par ID
router.post('/', UserController.createUser); // Créer un utilisateur
router.put('/:id', UserController.updateUser); // Mettre à jour un utilisateur
router.delete('/:id', UserController.deleteUser); // Supprimer un utilisateur

module.exports = router;
