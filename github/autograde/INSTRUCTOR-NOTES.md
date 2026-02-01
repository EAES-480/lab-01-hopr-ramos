# Level 1 Autograding Setup (eaes480-lab01-hopr-level1-autograde)

This folder contains a minimal autograding setup for **lab-01-hopr**.

## What it checks
1. `lab-01-hopr.Rmd` successfully renders to HTML.
2. The required checkpoint objects exist and pass basic validation:
   - `student_name` (non-empty character)
   - `student_netid` (non-empty character)
   - `hopr_completed_chapters` (must include 1:8)
   - `reflection_notes` (character; can be empty)

## Files
- `lab-01-hopr.Rmd` — student-facing template (with checkpoint chunk added)
- `autograde.R` — grading script run in CI
- `.github/workflows/eaes480-lab01-hopr-level1-autograde.yml` — GitHub Actions workflow

## How to use
- Put these files at the root of your `lab-01-hopr` repo.
- Students complete and push `lab-01-hopr.Rmd`.
- GitHub Actions runs on every push/PR and will pass/fail.

## Notes
- This is intentionally *lightweight* and does not validate every exercise’s correctness.
- It is designed to enforce: "did it run?" + "did you complete chapters 1–8?"