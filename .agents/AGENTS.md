# Maram Milk Franchise — Agent Rules

## Pre-completion Checklist (MANDATORY)

Before declaring any phase "done", before any `git push`, and before telling the user work is complete, you MUST run **both** of the following checks and confirm **both pass with zero errors**:

1. **Flutter (frontend)**
   ```
   flutter analyze
   ```
   Run from the `manager_app/` directory. Zero errors required.

2. **Backend (TypeScript)**
   ```
   npm run build
   ```
   Run from the `Backend/` directory. `tsc` must complete with zero output (zero errors).

**Both checks must pass before the work is considered done.** Do not skip one because the other passed. Do not push to GitHub until both are green.

> Background: A backend build error (`item.litres` referencing a non-existent Prisma field) was missed and pushed to GitHub before being caught. This rule prevents that from recurring.
