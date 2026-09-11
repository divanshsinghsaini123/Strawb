
### Local Installation

> **Prerequisites:
>
> - [Node.js](https://nodejs.org/) v20+
> - [PostgreSQL](https://www.postgresql.org/) v15+
> - [pnpm](https://pnpm.io/) v10+

1. Clone the repository and install dependencies:

```bash
git clone https://github.com/medusajs/dtc-starter.git
cd dtc-starter
pnpm install
```

2. Set up environment variables for the backend:

```bash
cp apps/backend/.env.template apps/backend/.env
```


3. Set the database URL in `apps/backend.env`:

```bash
# Replace with actual database URL, make sure the database exists.
DATABASE_URL=postgres://postgres:@localhost:5432/medusa-dtc-starter
```

4. Run migrations:

```bash
cd apps/backend
pnpm medusa db:migrate
```

5. Add admin user:

```bash
cd apps/backend
pnpm medusa user -e admin@test.com -p supersecret
```

6. Start Medusa backend:

```bash
cd apps/backend
pnpm dev
```

7. Open the admin dashboard at `localhost:9000/app` and log in. Retrieve your publishable API key at Settings > Publishable API key.

8. Set up environment variables for the storefront:

```bash
cp apps/storefront/.env.template apps/storefront/.env.local
```

9. Update `apps/storefront/.env.local` with your Medusa publishable API key:

```bash
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_6c3...
```

10.  Start storefront:

```bash
cd apps/storefront
pnpm dev
```

The storefront runs on `http://localhost:8000`.

You can slo run the following command from the root to start both backend and storefront:

```bash
pnpm dev
```

## Configuration

The storefront is configured via environment variables in `apps/storefront/.env.local`:

| Variable | Description | Default |
|----------|-------------|---------|
| `NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY` | Publishable API key from your Medusa backend | — |
| `NEXT_PUBLIC_MEDUSA_BACKEND_URL` | URL of your Medusa backend | `http://localhost:9000` |
| `NEXT_PUBLIC_DEFAULT_REGION` | Default region country code | `dk` |
| `NEXT_PUBLIC_BASE_URL` | Base URL of the storefront | `https://localhost:8000` |
| `NEXT_PUBLIC_STRIPE_KEY` | Stripe publishable key (optional) | — |

## Resources

- [Medusa Documentation](https://docs.medusajs.com)
- [Medusa Cloud](https://cloud.medusajs.com)


## Production Deployment Guide

### 1. Build and Setup (Monorepo Root)
From the project root:

```bash
# 1. Install all dependencies across backend and storefront
npm install

# 2. Build both backend and storefront via Turborepo
npm run build
```

### 2. Medusa Production Server Setup (Official Medusa Standard)
Medusa v2 outputs the production build to `apps/backend/.medusa/server`. Configure and install its dependencies:

```bash
cd apps/backend/.medusa/server

# 1. Install dependencies in the build output
npm install

# 2. Copy your .env file
cp ../../.env .env.production
cp ../../.env .env

# 3. Set NODE_ENV
export NODE_ENV=production

# 4. Return to root
cd ../../../
```

### 3. Start Production Services with PM2

```bash
# Start or restart Medusa backend with NODE_ENV=production
pm2 restart medusa-backend --update-env || pm2 start npm --name "medusa-backend" --env NODE_ENV=production -- cwd apps/backend/.medusa/server -- run start

# Start or restart Storefront
pm2 restart storefront || pm2 start npm --name "storefront" -- cwd apps/storefront -- run start

# Save PM2 process list
pm2 save
```

---

## Production Environment Variables (`apps/backend/.env`)

Make sure your environment variables in `apps/backend/.env` point to your VM's public IP:

```env
ADMIN_CORS=http://<your-vm-ip>:9000
STORE_CORS=http://<your-vm-ip>:8000
AUTH_CORS=http://<your-vm-ip>:9000,http://<your-vm-ip>:8000
MEDUSA_BACKEND_URL=http://<your-vm-ip>:9000
```

> **Note (HTTP only):** If you are running on HTTP (without SSL/HTTPS), ensure `cookieOptions` in `apps/backend/medusa-config.ts` is set to:
> ```ts
> cookieOptions: {
>   sameSite: "lax",
>   secure: false,
> }
> ```

---

## Database Backup

To take a local database backup, navigate to `apps/postgress`:

```bash
cd apps/postgress
```

- **PowerShell / Windows:**
  ```powershell
  .\backup.bat
  # or: .\backup.ps1
  ```
- **Linux / Git Bash:**
  ```bash
  ./backup.sh
  ```

This automatically:
- Creates/updates `apps/postgress/latest.sql` (latest backup).
- Saves a timestamped history copy in `apps/postgress/backups/backup_YYYYMMDD_HHMMSS.sql`.


