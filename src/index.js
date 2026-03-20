import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';
import { Hono } from 'hono';

interface Env {
  SALSA_API_KEY: string;
  SALSA_BASE_URL: string;
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);

const app = new Hono<{ Bindings: Env }>();

app.post('/api/payroll/token', async (c) => {
  const { employerId, expiresInSeconds = 3600 } = await c.req.json<{
    employerId: string;
    expiresInSeconds?: number;
  }>();

  const res = await fetch(`${c.env.SALSA_BASE_URL}/v1/credentials/user-token`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${c.env.SALSA_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ employerId, expiresInSeconds }),
  });

  if (!res.ok) {
    return c.json({ error: 'Failed to generate token' }, 502);
  }

  const { token } = await res.json<{ token: string }>();
  return c.json({ token });
});

export default app;
