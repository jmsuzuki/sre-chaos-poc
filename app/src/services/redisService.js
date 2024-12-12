const redisClient = require('../config/redisConfig');

// Wrap Redis operation with a timeout
const withTimeout = (promise, timeoutMs) =>
    new Promise((resolve, reject) => {
        const timer = setTimeout(() => reject(new Error('Operation timeout')), timeoutMs);
        promise
            .then((result) => {
                clearTimeout(timer);
                resolve(result);
            })
            .catch((err) => {
                clearTimeout(timer);
                reject(err);
            });
    });

// Cache a response
const cacheResponse = async (key, data, expiry = 30) => {
    try {
        if (!redisClient.isOpen) {
            throw new Error('Redis is not connected');
        }
        await withTimeout(
            redisClient.set(key, JSON.stringify(data), { EX: expiry }),
            2000 // 2-second timeout
        );
    } catch (err) {
        console.error(`Error setting Redis cache for key ${key}:`, err.message);
        throw err;
    }
};

// Get cached response
const getCachedResponse = async (key) => {
    try {
        if (!redisClient.isOpen) {
            throw new Error('Redis is not connected');
        }
        const cachedData = await withTimeout(redisClient.get(key), 2000); // 2-second timeout
        return cachedData ? JSON.parse(cachedData) : null;
    } catch (err) {
        console.error(`Error getting Redis cache for key ${key}:`, err.message);
        throw err;
    }
};

module.exports = {
    cacheResponse,
    getCachedResponse,
};
