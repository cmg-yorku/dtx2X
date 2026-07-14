# dtx2X Site

dtx2X is an iStarDT-X deserializer that validates XML models, builds a common object model, and translates that model to downstream formal specifications.

## Quick Links

- [Project Documentation](documentation/README.md)
- [Contributor's Guide](contributors/README.md)
- [Current project README](../../README.md)
- [Versioned docs under docs/ver0.2](../../docs/ver0.2/README.md)
- [Grammar sources under docs/ver1.0](../../docs/ver1.0/grammar/grammar.tex)

## Site Generation

Use the Maven site lifecycle to render the markdown sources into HTML:

```bash
mvn clean site
```

Publish the generated site into `docs/site` without touching the existing versioned documentation under `docs/ver0.2` and `docs/ver1.0`:

```bash
mvn antrun:run@publish-docs
```

## Coverage

Generate the test report and JaCoCo output with:

```bash
mvn verify
```