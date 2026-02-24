Last Updated: 2025-01-14

# Implement Offline Sync Queue

**Date:** 2025-01-14
**Category:** Feature
**Type:** Feature

---

## Overview

Built the core offline sync engine for TaskFlow. Mutations made while offline are now queued in IndexedDB and replayed against the server when the connection is restored. Chose last-write-wins for conflict resolution.

---

## Problem / Objective

TaskFlow needs to work fully offline and sync without data loss when reconnected. Without a sync queue, any task created or modified offline would be silently lost when the app reloaded.

### Context

IndexedDB storage was already in place (merged 2025-01-13). This session added the mutation queue on top of it. The server API was also already live.

---

## Solution / Implementation

Added a `SyncQueue` class that sits between the UI and the server. Every mutation (create, update, delete) is written to IndexedDB first, then attempted against the server. If the server call fails or the user is offline, the mutation stays in the queue. On reconnect, the queue drains in order.

### Files Changed

#### Created
- `src/sync/SyncQueue.ts` — queue class: enqueue, drain, retry logic
- `src/sync/useSyncStatus.ts` — React hook exposing online/offline state and pending count

#### Modified
- `src/services/taskService.ts` — route all mutations through `SyncQueue` instead of calling the API directly
- `src/App.tsx` — added `useEffect` to call `syncQueue.drain()` when `navigator.onLine` becomes true

### Key Decisions

1. **Last-write-wins conflict resolution** — simpler than CRDT, acceptable for a single-user app. If the same task is edited on two devices, the later server timestamp wins. Documented in `activeContext.md`.
2. **idb over Dexie** — smaller bundle (~3KB vs ~25KB gzipped). The queue only needs basic get/put/delete; Dexie's query power isn't needed here.
3. **Drain on reconnect, not on interval** — polling wastes battery and creates unnecessary requests. Using the `online` event is sufficient.

---

## Issues Encountered

### Issue: Queue draining out of order on rapid reconnect
- **Cause:** Multiple `online` events firing in quick succession triggered concurrent drain calls, which raced each other.
- **Solution:** Added a `draining` boolean flag to the `SyncQueue` class so concurrent drain calls are no-ops if one is already running.

---

## Approaches Tried

1. **Attempted:** Using `navigator.sendBeacon` to flush the queue on page unload
   - **Result:** `sendBeacon` only supports POST with `text/plain` or `application/x-www-form-urlencoded` content types — incompatible with our JSON API
   - **Lesson:** `sendBeacon` is for analytics pings, not structured API calls

---

## Testing

- ✅ Offline task creation persists after page reload
- ✅ Queue drains correctly when going back online
- ✅ Concurrent drain calls are safely deduplicated
- ⏳ Integration test for conflict resolution (two-device scenario) — not yet written

---

## Follow-up Tasks

- [ ] Write integration test for conflict detection (server timestamp vs. local timestamp)
- [ ] Add keyboard shortcut overlay help panel (separate session)
- [ ] Consider showing a toast when queue drains successfully

---

## Notes

The sync queue is intentionally simple — it does not handle partial failures (e.g., 3 of 5 mutations succeed). In that case, the whole batch is retried. This is acceptable for now since mutations are small and idempotent.
