# Tech Context *(required)*

> The technology stack and development environment.
> The AI reads this before proposing any technical implementation.
> Update whenever the stack, tooling, or constraints change.

---

## Technology Stack

<!-- Fill in each layer relevant to your project. Add or remove rows as needed. -->

| Layer | Technology | Version | Notes |
|-------|-----------|---------|-------|
| Language | TypeScript | 5.3 | Strict mode enabled |
| Runtime | Node.js | 20 LTS | Also runs in browser |
| Framework | React | 18.x | With React Router v6 |
| Build | Vite | 5.x | |
| Database | PostgreSQL | 16 | Server-side |
| ORM | Prisma | 5.x | |
| Offline Storage | IndexedDB | — | Via idb library |
| Auth | Clerk | — | |
| Hosting | Vercel | — | Edge functions for API |

## Local Development Setup

### Prerequisites
<!-- List tools and versions needed to run this project locally. -->
- Node.js 20+
- pnpm 8+
- PostgreSQL 16 (or Docker)

### Key commands
<!-- The commands a developer runs daily. Keep this short and accurate. -->
```
pnpm dev              # Start dev server on :3000
pnpm test             # Run unit tests (Vitest)
pnpm build            # Production build
pnpm db:push          # Push Prisma schema to DB
pnpm db:seed          # Seed with sample data
```

## Technical Constraints

<!-- Hard rules the AI must never violate. -->
- Must run on Node 20 LTS — no Node 22+ APIs
- All secrets via environment variables, never hardcoded
- No external network calls in unit tests — mock all APIs
- Bundle size budget: < 150KB gzipped for initial load

## Environment Variables

<!-- List every env var the project needs. The AI uses this to know what's available. -->
```
DATABASE_URL          # PostgreSQL connection string
CLERK_SECRET_KEY      # Clerk authentication
CLERK_PUBLISHABLE_KEY # Clerk frontend key
```

---

*Last updated: 2025-01-15*
