const express = require('express');
const UserController = require('../Controllers/userController');
const router = express.Router();

router.post('/register', UserController.register);
router.post('/login', UserController.login);
router.get('/', UserController.getAllUsers); // Pour admin uniquement
router.get('/:id', UserController.getUserById);
router.put('/:id', UserController.updateUser);
router.delete('/:id', UserController.deleteUser);

module.exports = router;
