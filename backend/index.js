const express = require('express');
const bodyParser = require('body-parser');
const bookRoutes = require('./routes/bookRoutes');
const userRoutes = require('./routes/userRoutes');


const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());
app.use('/uploads', express.static('uploads'));
 // Serve images from the uploads directory

// Routes


app.use('/api/users', userRoutes);
app.use('/api/books', bookRoutes);

// Start the server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
