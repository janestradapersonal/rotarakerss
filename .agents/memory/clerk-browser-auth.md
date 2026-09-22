---
name: Clerk browser auth
description: Browser auth and admin protection use Clerk cookies with a server middleware bridge.
---

Browser API requests rely on Clerk’s same-origin session cookie; do not add bearer-token handling to web clients. The Express server must mount Clerk middleware before API routes, and production admin writes should be restricted by an explicit administrator identity.

**Why:** Replit-managed Clerk provisions the browser key and server key separately and the browser SDK owns the cookie session.

**How to apply:** When adding protected web features, use the Clerk React provider/components in the client and `getAuth`/server middleware in the API; reserve bearer tokens for mobile clients.