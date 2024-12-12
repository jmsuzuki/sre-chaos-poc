const { cacheResponse, getCachedResponse } = require('../services/redisService');
const CACHE_KEY = 'health_response';

const getHealth = async (req, res) => {
    try {
        // Attempt to get the cached response with a timeout
        const redisTimeout = new Promise((resolve, reject) => {
            const timer = setTimeout(() => reject(new Error('Redis timeout')), 2000); // 2-second timeout
            getCachedResponse(CACHE_KEY)
                .then((data) => {
                    clearTimeout(timer);
                    resolve(data);
                })
                .catch((err) => {
                    clearTimeout(timer);
                    reject(err);
                });
        });

        const cachedResponse = await redisTimeout;

        if (cachedResponse) {
            return res.status(200).json({
                source: 'cache',
                response: cachedResponse,
            });
        }

        // Generate a new healthy response and cache it
        const response = {
            status: 'healthy',
            message: 'All systems operational',
            timestamp: new Date().toISOString(),
        };

        try {
            await cacheResponse(CACHE_KEY, response, 5); // Cache for 5 seconds
        } catch (cacheError) {
            console.warn('Unable to cache health response:', cacheError.message);
        }

        return res.status(200).json({
            source: 'server',
            response,
        });
    } catch (err) {
        console.error('Health endpoint error:', err.message || err);

        // Return 500 if Redis is not connected or unresponsive
        return res.status(500).json({
            status: 'unhealthy',
            message: 'Redis is not connected or unresponsive',
            timestamp: new Date().toISOString(),
        });
    }
};

module.exports = {
    getHealth,
};
