const redis = require('redis');

// Create Redis client with a custom reconnect strategy
const redisClient = redis.createClient({
    socket: {
        host: process.env.REDIS_HOST || 'localhost',
        port: process.env.REDIS_PORT || 6379,
        reconnectStrategy: (retries) => {
            const retryInterval = 1000; // Retry every 1 second
            const maxRetryTime = 600 * 1000; // Stop retrying after 1 minute

            const elapsedTime = retries * retryInterval;

            if (elapsedTime > maxRetryTime) {
                console.error('Max reconnect attempts reached. Stopping reconnection.');
                return false; // Stop retrying after 1 minute
            }

            console.warn(`Redis reconnect attempt #${retries}, elapsed time: ${elapsedTime / 1000}s`);
            return retryInterval; // Retry after 1 second
        },
    },
});

// Event: Log successful connection
redisClient.on('connect', () => {
    console.log('Redis client connected');
});

// Event: Log errors
redisClient.on('error', (err) => {
    console.error('Redis client error:', err.message || err);
});

// Event: Log disconnection
redisClient.on('end', () => {
    console.warn('Redis client disconnected');
});

// Attempt initial connection
(async () => {
    try {
        await redisClient.connect();
        console.log('Redis client connected successfully');
    } catch (err) {
        console.error('Failed to connect to Redis:', err.message || err);
    }
})();

module.exports = redisClient;
