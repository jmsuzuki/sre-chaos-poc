import http from 'k6/http';
import { sleep, check } from 'k6';

// Load test configuration
export let options = {
    stages: [
        { duration: '30s', target: 10 },   // Ramp up to 10 users
        { duration: '1m', target: 50 },   // Maintain 50 users for 1 minute
        { duration: '1m', target: 100 },  // Increase to 100 users for 1 minute
        { duration: '30s', target: 200 }, // Ramp up to 200 users
        { duration: '1m', target: 0 },    // Ramp down to 0 users
    ],
    thresholds: {
        // Fail the test if response times exceed 2s for 95% of requests
        http_req_duration: ['p(95)<2000'],
    },
};

const BASE_URL = 'http://localhost:8080/api/v1';

// Simulate requests to both endpoints
export default function () {
    // Test /info endpoint
    let infoRes = http.get(`${BASE_URL}/info`);
    check(infoRes, {
        'status is 200': (r) => r.status === 200,
    });

    // Test /health endpoint
    let healthRes = http.get(`${BASE_URL}/health`);
    check(healthRes, {
        'status is 200 or 500': (r) => r.status === 200 || r.status === 500,
    });

    sleep(1); // Simulate real user behavior with a delay between requests
}
