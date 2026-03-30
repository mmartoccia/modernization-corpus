# Legacy Rationalization Corpus

A curated collection of real legacy codebases for evaluating code modernization approaches.

## What You Get

**8 production-grade legacy systems. 480K+ lines of code. Real modernization challenges.**

| System | Language | Size | Domain |
|--------|----------|------|--------|
| Apache OFBiz | Java | 100K+ LOC | ERP/CRM/E-Commerce |
| Odoo | Python | 200K+ LOC | ERP/Business Apps |
| Alfresco | Java | 100K+ LOC | Enterprise Content Mgmt |
| Django Oscar | Python | 10K-15K LOC | E-Commerce |
| Umbraco | C# | 50K+ LOC | Content Management |
| B2CWeb | Java | 5K-8K LOC | E-Commerce |
| Mezzanine | Python | 5K-10K LOC | CMS |
| DFe.NET | C# | 5K LOC | Invoicing |

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/mmartoccia/modernization-corpus.git
cd modernization-corpus

# 2. Clone all legacy systems (30-60 min)
bash CORPUS-AGGREGATION-SETUP.sh

# 3. Distribute or analyze
cd modernization-corpus-aggregate/
./DISTRIBUTE.sh /path/to/destination/
# or
./ANALYZE-ALL.sh ./results/
```

## What's in Each System

- Complete legacy codebase (full git history)
- BASELINE.json (metrics snapshot: LOC, complexity, security, tests)
- tests/acceptance/ (20-50 contract tests, all passing on baseline)
- MODERNIZATION.md (goals, constraints, phases, success criteria)

## Use Cases

- **Evaluate AI agents** - Test Claude, GPT-4, Gemini on real legacy code
- **Benchmark tools** - Compare modernization tools against production systems
- **Demonstrate capability** - Prove modernization approach to stakeholders
- **Research** - Study real code modernization patterns
- **Training** - Learn from authentic legacy systems

## Files in This Repo

- **README.md** (you are here)
- **CORPUS-AGGREGATION-SETUP.sh** - One-command clone + analyze all 8 systems
- **CORPUS-SEARCH-RESULTS.md** - How we found these systems (reference only)

## Structure

```
modernization-corpus/
├── README.md
├── CORPUS-AGGREGATION-SETUP.sh
├── CORPUS-SEARCH-RESULTS.md
└── [After running aggregation script]
    modernization-corpus-aggregate/
    ├── apache-ofbiz/          [Full codebase + metrics + tests]
    ├── odoo/                  [Full codebase + metrics + tests]
    ├── alfresco-community/    [Full codebase + metrics + tests]
    ├── ... (5 more systems)
    ├── DISTRIBUTE.sh          [Copy repos elsewhere]
    ├── ANALYZE-ALL.sh         [Batch metrics]
    └── README.md              [Repository manifest]
```

## System Selection

Each system was chosen because:
- ✓ Real production use (enterprises depend on it)
- ✓ Substantial codebase (5K-200K LOC)
- ✓ Created pre-2017 (authentically legacy)
- ✓ Public & open-source
- ✓ Clear modernization needs
- ✓ Diverse languages & domains

## Metrics Captured

Per system:
- **Size**: LOC, file counts, complexity
- **Quality**: Test coverage, cyclomatic complexity
- **Security**: OWASP violations, hardcoded secrets, CVEs
- **Dependencies**: Count, outdated, vulnerable
- **Buildability**: Compiles, tests pass, build time

## Acceptance Tests

**210+ tests total** across all systems:
- Pass on frozen baseline
- Exercise external contracts (API, DB, auth)
- Define "what can't break" during modernization
- All pass cleanly in <10 minutes per system

## Modernization Narratives

Each system includes MODERNIZATION.md with:
- Current state & tech stack
- Phase-based modernization plan (2-3 phases)
- Goals (testability, security, architecture, etc.)
- Constraints (what can't change)
- Success criteria (measurable outcomes)
- Estimated effort (weeks to months)
- Difficulty assessment

## Getting the Systems

### Option 1: Aggregate Script (Recommended)
```bash
bash CORPUS-AGGREGATION-SETUP.sh
# Creates modernization-corpus-aggregate/ with all 8 systems + helper scripts
# Time: 30-60 minutes (internet speed dependent)
# Space: ~1-2 GB
```

### Option 2: Clone Individual
```bash
git clone https://github.com/apache/ofbiz-framework.git apache-ofbiz
git clone https://github.com/odoo/odoo.git odoo
# ... etc for each system
```

### Option 3: Mirror from This Org
```bash
# (Coming: mirrors available at github.com/modernization-corpus/)
```

## Evaluating a Modernization Approach

1. **Get the corpus**
   ```bash
   bash CORPUS-AGGREGATION-SETUP.sh
   cd modernization-corpus-aggregate/apache-ofbiz
   ```

2. **Understand baseline**
   ```bash
   cat BASELINE.json          # Current metrics
   cat MODERNIZATION.md       # Goals & constraints
   pytest tests/acceptance/   # All should pass
   ```

3. **Modernize**
   - Apply your tool/agent/approach
   - Keep acceptance tests passing
   - Document changes

4. **Measure improvement**
   - Re-run metrics (LOC, complexity, coverage, security)
   - Compare before/after
   - Validate against success criteria

5. **Report results**
   - Metrics comparison
   - Which success criteria met?
   - What risks remain?

## Technology Breakdown

- **Java**: 3 systems (OFBiz, Alfresco, B2CWeb)
- **Python**: 3 systems (Odoo, Django Oscar, Mezzanine)
- **C#**: 2 systems (Umbraco, DFe.NET)

## Requirements

### Minimum
- `git` (for cloning)
- ~2 GB disk space
- 30-60 minutes internet

### Optional (for analysis)
```bash
pip install cloc lizard semgrep
```

### Build Tools (if compiling)
```bash
brew install maven gradle python dotnet
```

## License

This corpus aggregates open-source projects under their original licenses:
- Apache OFBiz → Apache 2.0
- Odoo → LGPL 3.0
- Alfresco → LGPL 3.0
- Django Oscar → BSD 3-Clause
- Umbraco → MIT
- Others → Per repository

Documentation and analysis tools are provided as-is.

## Contributing

Found a legacy system that should be in the corpus? Submit an issue with:
- Repository URL
- Language & framework
- Problem domain
- System size
- Creation date
- Why it should be included

## Troubleshooting

**Clone fails:**
- Check internet connection
- Hit rate limit? Use GitHub Personal Access Token

**Build fails:**
- Some systems may need specific Java/Python/Node versions
- See system-specific README files

**Tests failing:**
- Ensure you're on baseline commit (see git log)
- Some tests may need external services (DB, etc.)

**Space issues:**
- Use `--depth=5` or `--single-branch` cloning for smaller repos
- Delete aggregation directory after copying systems

## More Info

- Check CORPUS-SEARCH-RESULTS.md to see how these systems were discovered
- Each system has its own README with details

## Status

**Live & Ready to Use**  
Last Updated: March 30, 2026

---

**Start here:**
```bash
git clone https://github.com/mmartoccia/modernization-corpus.git
cd modernization-corpus
bash CORPUS-AGGREGATION-SETUP.sh
```
