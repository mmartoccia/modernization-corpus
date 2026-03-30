# Legacy Rationalization Corpus

A curated collection of real legacy codebases for evaluating code modernization approaches.

## What You Get

**14 production-grade legacy systems (750K+ LOC). Real modernization challenges.**

Real enterprise monoliths + federal modernization targets. Every system represents actual production code that's genuinely difficult to modernize.

### Enterprise Monoliths (Hardest Cases - 100K+ LOC)
| System | Language | Size | Difficulty | Challenge |
|--------|----------|------|-----------|-----------|
| Apache OFBiz | Java | 500K+ LOC | ⭐⭐⭐⭐⭐ | 20-year monolith, global state |
| Odoo | Python | 200K+ LOC | ⭐⭐⭐⭐ | Multi-domain business logic |
| Alfresco | Java | 100K+ LOC | ⭐⭐⭐⭐ | Complex document model |

### Enterprise Applications (10K-50K LOC)
| System | Language | Size | Domain | Challenge |
|--------|----------|------|--------|-----------|
| Umbraco | C# | 50K+ LOC | CMS | .NET monolith patterns |
| CFWheels | ColdFusion | 50K+ LOC | Framework | Legacy web framework |
| Nuxeo | Java | 50K+ LOC | Document Management | Complex abstractions |
| Django Oscar | Python | 10K-15K LOC | E-Commerce | Architectural debt |
| B2CWeb | Java | 5K-8K LOC | E-Commerce | Tight coupling |
| Mezzanine | Python | 5K-10K LOC | CMS | Python legacy patterns |
| DFe.NET | C# | 5K LOC | Invoicing | Legacy integration |
| Monolith Enterprise | Java | 5K+ LOC | Generic Enterprise | Real monolith patterns |

### Federal/Legacy Systems (Hardest to Modernize - Real Code)
| System | Language | Size | Type | Challenge |
|--------|----------|------|------|-----------|
| **CICS Banking Sample** | COBOL | 30K+ LOC | Real Banking (IBM) | Mainframe coupling |
| **NASTRAN-95** | Fortran | 150K+ LOC | NASA Scientific | Numerical algorithms |
| **Apollo-11** | Assembly | 8K+ LOC | Mission Code (1969) | System-level, no tests |

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/mmartoccia/modernization-corpus.git
cd modernization-corpus

# 2. Clone legacy systems (SELECTION-BASED - you choose which ones)

# List all available systems
bash CORPUS-AGGREGATION-SETUP.sh --list

# Clone only the largest systems (recommended start)
bash CORPUS-AGGREGATION-SETUP.sh apache-ofbiz odoo alfresco-community

# Clone specific systems
bash CORPUS-AGGREGATION-SETUP.sh django-oscar umbraco-cms cics-banking-sample

# Clone ALL systems (30-60 min, ~1-2 GB)
bash CORPUS-AGGREGATION-SETUP.sh --all

# 3. Distribute or analyze
cd modernization-corpus-aggregate/
ls -la
```

## What's in Each System

- Complete legacy codebase (full git history with shallow cloning)
- Real production patterns and architectural challenges
- Genuine modernization difficulty (no toy examples)
- Diverse languages, frameworks, and domains

## Use Cases

- **Evaluate AI agents** - Test Claude, GPT-4, Gemini on real legacy code
- **Benchmark tools** - Compare modernization tools against production systems
- **Demonstrate capability** - Prove modernization approach to stakeholders
- **Research** - Study real code modernization patterns
- **Training** - Learn from authentic legacy systems
- **Federal procurement** - Align with GAO 2025 critical systems

## Files in This Repo

- **README.md** (you are here)
- **CORPUS-AGGREGATION-SETUP.sh** - Selection-based clone + aggregate
- **.gitignore** - Excludes process docs, local config

## Structure

```
modernization-corpus/
├── README.md
├── CORPUS-AGGREGATION-SETUP.sh
└── [After running aggregation script]
    modernization-corpus-aggregate/
    ├── apache-ofbiz/              [Monolith: 500K LOC Java ERP]
    ├── odoo/                      [Monolith: 200K LOC Python ERP]
    ├── alfresco-community/        [Enterprise: 100K LOC Java Content]
    ├── umbraco-cms/               [Enterprise: 50K LOC C# CMS]
    ├── cfwheels/                  [Enterprise: 50K LOC ColdFusion]
    ├── nuxeo/                     [Enterprise: 50K LOC Java Document]
    ├── django-oscar/              [Application: 10K LOC Python E-Com]
    ├── b2cweb/                    [Application: 5K LOC Java E-Com]
    ├── mezzanine/                 [Application: 5K LOC Python CMS]
    ├── dfe-net/                   [Application: 5K LOC C# Integration]
    ├── monolith-enterprise/       [Application: 5K LOC Java Monolith]
    ├── cics-banking-sample/       [Federal: COBOL Banking (Real)]
    ├── nastran-95/                [Federal: Fortran Scientific NASA]
    └── apollo-11/                 [Federal: Assembly Moon Landing]
```

## System Selection

Each system was chosen because:
- ✓ Real production use (enterprises depend on it / agencies maintain it)
- ✓ Substantial codebase (5K-500K LOC)
- ✓ Created pre-2017 (authentically legacy)
- ✓ Public & open-source (legally available)
- ✓ Clear modernization needs
- ✓ Diverse languages & domains
- ✓ Genuinely difficult to refactor

## Technology Breakdown

**Languages & Frameworks:**
- **Java**: 5 systems (OFBiz, Alfresco, Nuxeo, Monolith Enterprise, B2CWeb)
- **Python**: 3 systems (Odoo, Django Oscar, Mezzanine)
- **C#/.NET**: 2 systems (Umbraco, DFe.NET)
- **ColdFusion**: 1 system (CFWheels)
- **COBOL**: 1 system (CICS Banking - Real mainframe application)
- **Fortran**: 1 system (NASTRAN-95 - NASA scientific computing)
- **Assembly**: 1 system (Apollo-11 - Space systems mission code)

**Why This Selection:**
- ✅ Every system is production code (not benchmarks)
- ✅ Enterprise monoliths (OFBiz, Odoo) represent hardest cases
- ✅ Federal targets match GAO 2025 critical legacy systems
- ✅ Real COBOL from IBM, not simulations
- ✅ Genuine Fortran from NASA (still in use)
- ✅ Actual Assembly that flew to the moon
- ✅ Diversity of architecture problems & patterns

## Getting the Systems

### Option 1: Selection-Based (Recommended)
```bash
# Clone specific systems you want to evaluate
bash CORPUS-AGGREGATION-SETUP.sh apache-ofbiz odoo nastran-95

# Time: 10-20 minutes (depends on which systems)
# Space: 200 MB - 1 GB (depends on selection)
```

### Option 2: All at Once
```bash
bash CORPUS-AGGREGATION-SETUP.sh --all

# Time: 30-60 minutes (internet speed dependent)
# Space: ~1-2 GB
```

### Option 3: Clone Individual
```bash
git clone https://github.com/apache/ofbiz-framework.git apache-ofbiz
git clone https://github.com/odoo/odoo.git odoo
# ... etc
```

## Evaluating a Modernization Approach

1. **Get the corpus**
   ```bash
   bash CORPUS-AGGREGATION-SETUP.sh apache-ofbiz
   cd modernization-corpus-aggregate/apache-ofbiz
   ```

2. **Understand baseline**
   ```bash
   cat README.md              # System overview
   git log --oneline | head   # Commit history
   find . -name "*.java" | wc -l  # File count
   ```

3. **Modernize**
   - Apply your tool/agent/approach
   - Track changes
   - Document what works/what doesn't

4. **Measure improvement**
   - Before/after metrics
   - What challenges arose?
   - How difficult was it really?

5. **Report results**
   - Which approach worked best?
   - Time investment required?
   - Success criteria met?

## Requirements

### Minimum
- `git` (for cloning)
- 200 MB - 2 GB disk space (depends on selection)
- 10-60 minutes internet

### Optional (for deeper analysis)
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
- NASTRAN-95 → NASA Open Source Agreement
- Apollo-11 → MIT
- CICS Banking Sample → Apache 2.0
- Others → Per repository

Documentation and tools provided as-is.

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

**System not listed:**
```bash
bash CORPUS-AGGREGATION-SETUP.sh --list
```

**Help with script:**
```bash
bash CORPUS-AGGREGATION-SETUP.sh
```

**Space issues:**
- Use `--list` to pick smaller systems
- Clone only what you need (selection mode)
- Delete aggregation directory after copying elsewhere

## Status

**Live & Production Ready**  
Last Updated: March 30, 2026

---

**Start here:**
```bash
git clone https://github.com/mmartoccia/modernization-corpus.git
cd modernization-corpus
bash CORPUS-AGGREGATION-SETUP.sh --list
```
