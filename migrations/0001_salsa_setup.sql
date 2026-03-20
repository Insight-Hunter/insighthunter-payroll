
CREATE TABLE IF NOT EXISTS salsa_employers (
  id TEXT PRIMARY KEY,               -- InsightHunter companyId
  salsa_employer_id TEXT NOT NULL,   -- Salsa's employerId
  salsa_company_id TEXT,             -- Salsa's companyId (post-onboarding)
  created_at INTEGER NOT NULL DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS salsa_workers (
  id TEXT PRIMARY KEY,               -- InsightHunter employeeId
  employer_id TEXT NOT NULL REFERENCES salsa_employers(id),
  salsa_worker_id TEXT NOT NULL,
  worker_type TEXT NOT NULL CHECK(worker_type IN ('W2', '1099')),
  created_at INTEGER NOT NULL DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS salsa_payroll_runs (
  id TEXT PRIMARY KEY,
  employer_id TEXT NOT NULL REFERENCES salsa_employers(id),
  salsa_run_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  pay_period_start TEXT NOT NULL,
  pay_period_end TEXT NOT NULL,
  created_at INTEGER NOT NULL DEFAULT (unixepoch())
);
