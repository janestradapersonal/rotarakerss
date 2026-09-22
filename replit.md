# Rotaract Attendance

Mobile-first attendance app for Rotaract clubs: members check into the active meeting in seconds, while administrators manage rosters, meeting lifecycle, corrections, and club analytics.

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server (port 5000)
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — Postgres connection string

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)

## Where things live

- `artifacts/rotaract-attendance` — public check-in experience, member profiles, calendar, rankings, statistics, Clerk auth screens, and admin studio.
- `artifacts/api-server/src/routes/attendance.ts` — public read/check-in endpoints and admin attendance corrections.
- `artifacts/api-server/src/routes/admin.ts` — authenticated member and meeting CRUD/lifecycle endpoints.
- `artifacts/api-server/src/lib/attendance.ts` — attendance aggregation, streak calculation, badges, funny percentage messages, rankings, and dashboard summaries.
- `lib/db/src/schema/rotaract.ts` — PostgreSQL tables for members, meetings, and attendance with a unique member/meeting constraint.
- `lib/api-spec/openapi.yaml` — source-of-truth API contract; generated clients live in `lib/api-client-react` and `lib/api-zod`.

## Architecture decisions

- Meeting dates are calendar-only PostgreSQL `date` values so weekly meeting days do not shift with timezone conversion.
- Browser authentication uses Replit-managed Clerk session cookies; admin API writes require Clerk auth and production additionally requires `ADMIN_CLERK_USER_ID`.
- The public dashboard and authenticated admin summary poll every five seconds so check-ins from another device appear without a manual refresh.
- Normal check-ins are intentionally public and do not require an account; only management actions are protected.

## Product

Members can search their name and check into the active weekly meeting, receive immediate streak and attendance feedback, and browse profiles, meeting history, rankings, and club statistics. Administrators can sign in, create/activate/close meetings, manage members, and correct attendance records.

## User preferences

_Populate as you build — explicit user instructions worth remembering across sessions._

## Gotchas

- After editing `lib/api-spec/openapi.yaml`, run `pnpm --filter @workspace/api-spec run codegen` before typechecking clients or the server.
- The admin area is usable in development for any signed-in Clerk user; production should set `ADMIN_CLERK_USER_ID` to the club administrator’s Clerk user ID.
- `PORT` and `BASE_PATH` are supplied by the managed artifact workflow; direct Vite builds need both variables set.

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
