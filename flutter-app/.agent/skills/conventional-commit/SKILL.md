---
name: conventional-commit
description: Guidelines for standardized git commits.
triggers:
  - commit
  - git
  - message
role: developer
scope: workflow
---

# Conventional Commit

Follow the Conventional Commits specification for all Git commits.

## Format
`<type>(<scope>): <description>`

## Types
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools and libraries
