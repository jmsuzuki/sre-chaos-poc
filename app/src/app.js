const express = require('express');
const appConfig = require('./config/appConfig');
const infoRoutes = require('./routes/infoRoute');
const healthRoutes = require('./routes/healthRoute');

const app = express();

// Route configuration with base paths
app.use('/api/v1/info', infoRoutes);
app.use('/api/v1/health', healthRoutes);

// Start the server
const { port } = appConfig;
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
