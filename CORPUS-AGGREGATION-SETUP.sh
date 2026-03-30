#!/bin/bash
# corpus-aggregation-setup.sh
# Clones all legacy corpus repositories into a single aggregation directory
# Then creates a master manifest for distribution

set -e

# Configuration
AGGREGATION_ROOT="${1:-.}/modernization-corpus-aggregate"
MANIFEST_FILE="$AGGREGATION_ROOT/CORPUS-MANIFEST.json"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# All candidate repositories (prioritized by tier)
declare -A REPOS=(
    # TIER 1A: Large Enterprise (100K+ LOC)
    ["apache-ofbiz"]="https://github.com/apache/ofbiz-framework.git"
    ["odoo"]="https://github.com/odoo/odoo.git"
    ["alfresco-community"]="https://github.com/Alfresco/alfresco-community-repo.git"
    
    # TIER 1B: Medium-Large (10K-50K LOC)
    ["nuxeo"]="https://github.com/nuxeo/nuxeo.git"
    ["django-oscar"]="https://github.com/django-oscar/django-oscar.git"
    ["umbraco-cms"]="https://github.com/umbraco/Umbraco-CMS.git"
    
    # TIER 2: Medium (5K-20K LOC)
    ["mezzanine"]="https://github.com/stephenmcd/mezzanine.git"
    ["b2cweb"]="https://github.com/mission008/B2CWeb.git"
    ["dfe-net"]="https://github.com/ZeusAutomacao/DFe.NET.git"
    ["monolith-enterprise"]="https://github.com/colinbut/monolith-enterprise-application.git"
    ["cfwheels"]="https://github.com/wheels-dev/wheels.git"
)

echo "========================================"
echo "Legacy Rationalization Corpus Aggregation"
echo "========================================"
echo "Timestamp: $TIMESTAMP"
echo "Target Directory: $AGGREGATION_ROOT"
echo ""

# Create aggregation root
mkdir -p "$AGGREGATION_ROOT"
cd "$AGGREGATION_ROOT"

# Initialize manifest
cat > "$MANIFEST_FILE" << 'EOF'
{
  "version": "1.0.0",
  "generated": "TIMESTAMP_PLACEHOLDER",
  "aggregation_root": "modernization-corpus-aggregate",
  "total_repositories": 0,
  "repositories": []
}
EOF

# Placeholder for manifest array
MANIFEST_REPOS="[]"
REPO_COUNT=0

echo "Cloning repositories..."
echo ""

# Clone each repository
for repo_name in "${!REPOS[@]}"; do
    repo_url="${REPOS[$repo_name]}"
    repo_dir="$AGGREGATION_ROOT/$repo_name"
    
    echo "[$((++REPO_COUNT))] Cloning: $repo_name"
    echo "    URL: $repo_url"
    echo "    Target: $repo_dir"
    
    if [ -d "$repo_dir" ]; then
        echo "    ⚠️  Already exists, skipping..."
    else
        echo "    ⏳ Cloning (this may take a while for large repos)..."
        
        # Clone with depth to save time/space (can do full later)
        # Remove --depth=1 if you want full history
        if git clone --depth=50 "$repo_url" "$repo_dir" 2>&1 | tail -5; then
            echo "    ✅ Success"
            
            # Capture repo metadata
            cd "$repo_dir"
            CREATED=$(git log --follow --format=%ai | tail -1 | cut -d' ' -f1 || echo "unknown")
            LAST_UPDATE=$(git log -1 --format=%ai | cut -d' ' -f1 || echo "unknown")
            COMMIT=$(git rev-parse HEAD | cut -c1-12)
            
            # Count files by type
            JAVA_FILES=$(find . -name "*.java" 2>/dev/null | wc -l || echo "0")
            PY_FILES=$(find . -name "*.py" 2>/dev/null | wc -l || echo "0")
            CS_FILES=$(find . -name "*.cs" 2>/dev/null | wc -l || echo "0")
            CFM_FILES=$(find . -path "./.git" -prune -o -name "*.cfm" -o -name "*.cfc" 2>/dev/null | wc -l || echo "0")
            PHP_FILES=$(find . -name "*.php" 2>/dev/null | wc -l || echo "0")
            
            cd - > /dev/null
            
            echo "    Created: $CREATED"
            echo "    Last Update: $LAST_UPDATE"
            echo "    Commit: $COMMIT"
            echo "    Files: Java=$JAVA_FILES, Python=$PY_FILES, C#=$CS_FILES, PHP=$PHP_FILES"
        else
            echo "    ❌ Failed to clone"
        fi
    fi
    echo ""
done

echo "========================================"
echo "Cloning complete!"
echo ""
echo "Directory structure:"
ls -lh "$AGGREGATION_ROOT" | grep "^d" | awk '{print "  - " $NF}'
echo ""

# Generate distribution script
cat > "$AGGREGATION_ROOT/DISTRIBUTE.sh" << 'EOF'
#!/bin/bash
# distribute.sh - Copy aggregated corpus to target locations

TARGET_BASE="${1:-.}"

echo "Distributing corpus to: $TARGET_BASE"
echo ""

DIRS=$(ls -d */ 2>/dev/null | sed 's/\///g')
TOTAL=$(echo "$DIRS" | wc -w)
COUNT=0

for dir in $DIRS; do
    COUNT=$((COUNT + 1))
    TARGET="$TARGET_BASE/$dir"
    
    echo "[$COUNT/$TOTAL] Copying: $dir -> $TARGET"
    
    if [ -d "$TARGET" ]; then
        echo "  ⚠️  Target exists, skipping..."
    else
        cp -r "$dir" "$TARGET"
        echo "  ✅ Complete"
    fi
done

echo ""
echo "Distribution complete!"
echo "Total: $TOTAL repositories copied to $TARGET_BASE"
EOF

chmod +x "$AGGREGATION_ROOT/DISTRIBUTE.sh"

# Generate analysis script
cat > "$AGGREGATION_ROOT/ANALYZE-ALL.sh" << 'EOF'
#!/bin/bash
# analyze-all.sh - Run analysis on all corpus repositories

RESULTS_DIR="${1:-.}/corpus-analysis-results"
mkdir -p "$RESULTS_DIR"

echo "Analyzing all repositories..."
echo "Results: $RESULTS_DIR"
echo ""

DIRS=$(ls -d */ 2>/dev/null | sed 's/\///g')
TOTAL=$(echo "$DIRS" | wc -w)
COUNT=0

for dir in $DIRS; do
    COUNT=$((COUNT + 1))
    REPO_RESULTS="$RESULTS_DIR/$dir"
    
    echo "[$COUNT/$TOTAL] Analyzing: $dir"
    mkdir -p "$REPO_RESULTS"
    
    cd "$dir"
    
    # Lines of code
    echo "  - Counting lines..."
    cloc . --json > "$REPO_RESULTS/metrics-cloc.json" 2>/dev/null || echo "{}" > "$REPO_RESULTS/metrics-cloc.json"
    
    # Complexity (if lizard installed)
    if command -v lizard &> /dev/null; then
        echo "  - Analyzing complexity..."
        lizard -O json . > "$REPO_RESULTS/metrics-complexity.json" 2>/dev/null || echo "{}" > "$REPO_RESULTS/metrics-complexity.json"
    fi
    
    # Security (if semgrep installed)
    if command -v semgrep &> /dev/null; then
        echo "  - Scanning security..."
        semgrep --config=p/owasp-top-ten . --json > "$REPO_RESULTS/security-semgrep.json" 2>/dev/null || echo "{}" > "$REPO_RESULTS/security-semgrep.json"
    fi
    
    # File counts
    echo "  - File inventory..."
    {
        echo "Java files: $(find . -name "*.java" 2>/dev/null | wc -l)"
        echo "Python files: $(find . -name "*.py" 2>/dev/null | wc -l)"
        echo "C# files: $(find . -name "*.cs" 2>/dev/null | wc -l)"
        echo "PHP files: $(find . -name "*.php" 2>/dev/null | wc -l)"
        echo "CFML files: $(find . -name "*.cfm" -o -name "*.cfc" 2>/dev/null | wc -l)"
        echo "YAML files: $(find . -name "*.yaml" -o -name "*.yml" 2>/dev/null | wc -l)"
        echo "XML files: $(find . -name "*.xml" 2>/dev/null | wc -l)"
    } > "$REPO_RESULTS/file-inventory.txt"
    
    # Dependencies
    echo "  - Extracting dependencies..."
    if [ -f "pom.xml" ]; then
        mvn dependency:tree > "$REPO_RESULTS/dependencies-maven.txt" 2>/dev/null || echo "Maven analysis failed" > "$REPO_RESULTS/dependencies-maven.txt"
    fi
    if [ -f "build.gradle" ]; then
        gradle dependencies > "$REPO_RESULTS/dependencies-gradle.txt" 2>/dev/null || echo "Gradle analysis failed" > "$REPO_RESULTS/dependencies-gradle.txt"
    fi
    if [ -f "requirements.txt" ]; then
        cp requirements.txt "$REPO_RESULTS/dependencies-pip.txt"
    fi
    if [ -f "setup.py" ]; then
        cp setup.py "$REPO_RESULTS/setup.py"
    fi
    if [ -f "*.sln" ]; then
        find . -name "*.sln" -exec basename {} \; > "$REPO_RESULTS/dotnet-solutions.txt"
    fi
    
    cd - > /dev/null
    echo "  ✅ Complete"
done

echo ""
echo "Analysis complete!"
echo "Results in: $RESULTS_DIR"
EOF

chmod +x "$AGGREGATION_ROOT/ANALYZE-ALL.sh"

# Generate summary manifest
cat > "$AGGREGATION_ROOT/README.md" << 'EOF'
# Legacy Rationalization Corpus - Aggregation Repository

This directory contains all legacy code repositories for the modernization corpus.

## Contents

Clone status: See below

## Repository Manifest

| Repository | Language | Size | Created | Last Updated |
|-----------|----------|------|---------|--------------|
EOF

# Add manifest entries
for repo_name in "${!REPOS[@]}"; do
    if [ -d "$AGGREGATION_ROOT/$repo_name" ]; then
        cd "$AGGREGATION_ROOT/$repo_name"
        CREATED=$(git log --follow --format=%ai | tail -1 | cut -d' ' -f1 || echo "N/A")
        LAST_UPDATE=$(git log -1 --format=%ai | cut -d' ' -f1 || echo "N/A")
        JAVA_COUNT=$(find . -name "*.java" 2>/dev/null | wc -l)
        PY_COUNT=$(find . -name "*.py" 2>/dev/null | wc -l)
        CS_COUNT=$(find . -name "*.cs" 2>/dev/null | wc -l)
        
        if [ "$JAVA_COUNT" -gt 0 ]; then
            PRIMARY_LANG="Java ($JAVA_COUNT)"
        elif [ "$PY_COUNT" -gt 0 ]; then
            PRIMARY_LANG="Python ($PY_COUNT)"
        elif [ "$CS_COUNT" -gt 0 ]; then
            PRIMARY_LANG="C# ($CS_COUNT)"
        else
            PRIMARY_LANG="Mixed"
        fi
        
        cd - > /dev/null
        
        echo "| $repo_name | $PRIMARY_LANG | ~$(du -sh $AGGREGATION_ROOT/$repo_name 2>/dev/null | cut -f1) | $CREATED | $LAST_UPDATE |" >> "$AGGREGATION_ROOT/README.md"
    fi
done

cat >> "$AGGREGATION_ROOT/README.md" << 'EOF'

## Usage

### 1. Distribute to other locations
```bash
./DISTRIBUTE.sh /path/to/destination
```

### 2. Analyze all repositories
```bash
./ANALYZE-ALL.sh ./analysis-results
```

### 3. Work with individual repo
```bash
cd apache-ofbiz
git status
# ... make changes, create branches, etc.
```

## Repository Details

Each repository includes:
- Full git history (cloned with --depth=50, can fetch full history later)
- Original README and documentation
- Build files (pom.xml, setup.py, .sln, etc.)

## Analysis Tools

Install tools before running ANALYZE-ALL.sh:
```bash
pip install cloc lizard semgrep
brew install git
```

## Distribution

To copy entire aggregation to another location:
```bash
# Copy full directory
cp -r modernization-corpus-aggregate /target/location/

# Or use DISTRIBUTE.sh for individual repos
./DISTRIBUTE.sh /target/location/
```

## Size Information

Total aggregation size: Check with `du -sh modernization-corpus-aggregate/`

Individual repos can be large (100MB+). Use --depth cloning for faster initial clone.

## Next Steps

1. Run ANALYZE-ALL.sh to generate baseline metrics
2. Write acceptance tests per repository
3. Freeze baselines (git tag)
4. Document modernization narratives
5. Create CORPUS-METADATA.json

EOF

echo ""
echo "Summary created: $AGGREGATION_ROOT/README.md"
echo ""
echo "========================================"
echo "✅ Aggregation Complete!"
echo "========================================"
echo ""
echo "Quick reference:"
echo "  Distribution script: ./DISTRIBUTE.sh [target-path]"
echo "  Analysis script: ./ANALYZE-ALL.sh [results-path]"
echo ""
echo "Total repositories aggregated: $REPO_COUNT"
echo "Total space: $(du -sh $AGGREGATION_ROOT 2>/dev/null | cut -f1)"
echo ""
echo "Next: Copy this directory to other machines or repos as needed"
