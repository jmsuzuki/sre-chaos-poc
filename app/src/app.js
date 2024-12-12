const { MeterProvider } = require('@opentelemetry/sdk-metrics');
const { PrometheusExporter } = require('@opentelemetry/exporter-prometheus');
const express = require('express');
const http = require('http'); // Import the HTTP module
const appConfig = require('./config/appConfig');
const infoRoutes = require('./routes/infoRoute');
const healthRoutes = require('./routes/healthRoute');

// Initialize Prometheus Exporter
console.log('Initializing Prometheus Exporter...');
const prometheusExporter = new PrometheusExporter(
    {
        port: 9464, // Port for Prometheus to scrape metrics
    },
    () => {
        console.log('Prometheus scrape endpoint running at http://localhost:9464/metrics');
    }
);

console.log('Initializing MeterProvider...');
const meterProvider = new MeterProvider({
    readers: [prometheusExporter],
});
console.log('MeterProvider initialized:', meterProvider);

const meter = meterProvider.getMeter('node-app');
console.log('Meter created:', meter);

// Create a custom histogram metric for response times
const responseTimeHistogram = meter.createHistogram('http_response_time_seconds', {
    description: 'Histogram of HTTP response times in seconds',
    unit: 'seconds',
});

// Express app setup
const app = express();

// Middleware to measure and record response times
app.use((req, res, next) => {
    const startTime = Date.now();

    res.on('finish', () => {
        const duration = (Date.now() - startTime) / 1000; // Convert to seconds

        // Determine the route path
        const routePath = req.route ? req.baseUrl + req.route.path : req.originalUrl;

        console.log(`Route: ${routePath}, Status: ${res.statusCode}, Duration: ${duration}s`);

        responseTimeHistogram.record(duration, {
            method: req.method,
            route: routePath, // Use the actual route or the original URL
            status_code: res.statusCode,
        });
    });

    next();
});

// Route configuration
app.use('/api/v1/info', infoRoutes);
app.use('/api/v1/health', healthRoutes);

// Start the server with Keep-Alive settings
const server = http.createServer(app);

server.keepAliveTimeout = 65000; // 65 seconds
server.headersTimeout = 66000;  // Slightly longer than keepAliveTimeout

server.listen(appConfig.port, () => {
    console.log(`Server running on http://localhost:${appConfig.port}`);
});
