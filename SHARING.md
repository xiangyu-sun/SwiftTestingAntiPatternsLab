# Sharing This Project

This package is intentionally safe to publish with the accompanying post.

## What It Contains

- Original generic sample code.
- No proprietary application source.
- No proprietary product names, endpoints, tickets, credentials, or user data.
- One test file per anti-pattern category.
- Passing reproductions of the mechanisms discussed in the post.

## License

The project uses the MIT license. Readers may copy, modify, run, and redistribute the examples as
long as they preserve the license notice.

## Suggested Source Caption

Use this beneath excerpts in the post:

> Original reproduction from Swift Testing Anti-Patterns Lab, verified with Apple Swift 6.4 and
> Testing Library 2084. MIT licensed.

If the project is published to GitHub, replace the plain project name with a public URL pinned to
the exact commit SHA used by the article.

## Before Publishing

1. Run `swift test` and save the output.
2. Publish the directory as its own repository or as a public subdirectory.
3. Pin all article links to the publication commit SHA.
4. Keep claims scoped to what the tests demonstrate. The project proves mechanisms, not CI failure
   frequency in another codebase.
