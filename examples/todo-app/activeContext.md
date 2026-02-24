# Active Context *(required)*

> The AI's working memory. Reflects the current state of work.
> Updated at the end of every work session and after significant tasks.
> The AI reads this at the start of every session.

---

## Current Focus

Building the offline sync engine — the core feature that queues mutations locally and replays them to the server when back online.

## Work in Progress

- [ ] Sync engine: conflict resolution for concurrent edits
- [ ] Keyboard shortcut overlay (help panel)

## Recently Completed

- [x] Basic CRUD API routes with Prisma — 2025-01-14
- [x] IndexedDB storage layer with idb wrapper — 2025-01-13
- [x] Clerk auth integration (sign-in, sign-up, protected routes) — 2025-01-12

## Immediate Next Steps

1. Implement queue-based sync: store mutations in IndexedDB, replay on reconnect
2. Add conflict detection: server timestamp vs. local timestamp comparison
3. Write integration tests for sync flow with mocked network

## Notes / Decisions Made

- 2025-01-14: Chose last-write-wins for conflict resolution. Simpler than CRDT, acceptable for a single-user todo app.
- 2025-01-13: Using idb (lightweight IndexedDB wrapper) instead of Dexie — smaller bundle, sufficient for our needs.

---

*Last updated: 2025-01-14*
