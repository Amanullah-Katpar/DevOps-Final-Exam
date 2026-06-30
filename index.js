const express = require('express');
const mongoose = require('mongoose');
const path = require('path');
const fs = require('fs');
const app = express();

// SABOTAGE 1 FIX: env var name matches what docker-compose.yml provides
const dbUri = process.env.DATABASE_URI || 'mongodb://localhost:27017/phoenix';

mongoose.connect(dbUri)
  .then(() => console.log('Connected to MongoDB!'))
  .catch(err => console.error('Failed to connect:', err));

// SABOTAGE 2 FIX: Vite outputs to 'dist' by default, not 'public'
const uiPath = path.join(__dirname, 'dist');
app.use(express.static(uiPath));

// Mission 3: write health-check hits to /app/logs/server.log
const logDir = path.join(__dirname, 'logs');
if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir, { recursive: true });
}
const logFile = path.join(logDir, 'server.log');

app.get('/api/health', (req, res) => {
  const entry = `[${new Date().toISOString()}] Health check hit - API is alive\n`;
  fs.appendFileSync(logFile, entry);
  res.json({ status: 'API is alive' });
});

app.listen(5000, () => console.log('Server running on port 5000'));
