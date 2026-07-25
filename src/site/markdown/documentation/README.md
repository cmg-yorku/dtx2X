# Project Documentation

This folder contains the markdown sources for the generated Maven site. The rendered HTML is produced under `target/site` and can be published to `docs/site` with the Maven Antrun copy task.

## What belongs here

- Documentation pages that explain the codebase, file formats, and usage patterns.
- Links to the versioned documentation already stored under `docs/ver0.2` and `docs/ver1.0`.
- Any project-facing docs that should be published as part of the site output.

## How to build the docs

```bash
mvn clean site
```

That command renders the markdown files into HTML under `target/site`.

To publish the generated site without overwriting the existing versioned docs, copy it to `docs/site`:

```bash
mvn antrun:run@publish-docs
```

## Existing documentation sources

- [Version 0.2 documentation](../../../docs/ver0.2/README.md)
- [Version 1.0 grammar sources](../../../docs/ver1.0/grammar/grammar.tex)
- [Root project README](../../../README.md)