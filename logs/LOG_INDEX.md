# Log Index

This file is the master index of all development log files.
The AI reads this at the start of every session to find the most recent log.

**How to use**: Read the last row in the table — that is the active log file. Never edit old log files.

---

## Index

| File | Date | Summary |
|------|------|---------|
| [LOG_001.md](logs/LOG_001.md) | [DATE] | Initial project setup — boilerplate configured |

---

## How this system works

- Each log file is append-only. Entries are added; nothing is deleted or summarized.
- When a log file exceeds ~5000 characters, create the next numbered file (LOG_002.md, LOG_003.md, ...) and add a new row to this index.
- The most recent row in the table above is always the active log file.
- This index stays small and scannable. The detail is in the individual log files.
