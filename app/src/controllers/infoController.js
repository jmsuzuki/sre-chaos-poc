const { cacheResponse, getCachedResponse } = require('../services/redisService');

const CACHE_KEY = 'info_response';
const CACHE_TIME = 5;

const getInfo = async (req, res) => {
    const cacheKey = 'info_response';

    try {
        // Check Redis for cached value
        const cachedResponse = await getCachedResponse(CACHE_KEY);
        if (cachedResponse) {
            return res.json({ source: 'cache', response: cachedResponse });
        }

        // Generate new response
        const response = {
            timestamp: new Date().toISOString(),
            message: 'Info endpoint'
        };

        // Cache the response
        await cacheResponse(CACHE_KEY, response, CACHE_TIME); // Cache for 30 seconds
        res.json({ source: 'server', response });
    } catch (err) {
        console.error('Error in /info:', err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

module.exports = {
    getInfo,
};
