#!/bin/bash
# corpus-aggregation-setup.sh
# Selective cloning of legacy corpus repositories
# Use: ./CORPUS-AGGREGATION-SETUP.sh [--all] [--list] [system1] [system2] ...

set -e

# Configuration
AGGREGATION_ROOT="${1:-.}/modernization-corpus-aggregate"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Define all available repositories
get_repo_url() {
    case $1 in
        # TIER 1: Enterprise Monoliths
        apache-ofbiz) echo "https://github.com/apache/ofbiz-framework.git" ;;
        odoo) echo "https://github.com/odoo/odoo.git" ;;
        alfresco-community) echo "https://github.com/Alfresco/alfresco-community-repo.git" ;;
        
        # TIER 2: Enterprise Applications
        nuxeo) echo "https://github.com/nuxeo/nuxeo.git" ;;
        django-oscar) echo "https://github.com/django-oscar/django-oscar.git" ;;
        umbraco-cms) echo "https://github.com/umbraco/Umbraco-CMS.git" ;;
        mezzanine) echo "https://github.com/stephenmcd/mezzanine.git" ;;
        b2cweb) echo "https://github.com/mission008/B2CWeb.git" ;;
        dfe-net) echo "https://github.com/ZeusAutomacao/DFe.NET.git" ;;
        monolith-enterprise) echo "https://github.com/colinbut/monolith-enterprise-application.git" ;;
        cfwheels) echo "https://github.com/wheels-dev/wheels.git" ;;
        
        # TIER 3: Federal/Legacy Systems
        cics-banking-sample) echo "https://github.com/cicsdev/cics-banking-sample-cbsa.git" ;;
        nastran-95) echo "https://github.com/nasa/NASTRAN-95.git" ;;
        apollo-11) echo "https://github.com/chrislgarry/Apollo-11.git" ;;
        
        *) echo "" ;;
    esac
}

# List all available systems
list_repos() {
    echo "Available repositories:"
    echo ""
    echo "TIER 1: Enterprise Monoliths (Hardest Cases)"
    echo "  - apache-ofbiz       (500K LOC Java ERP)"
    echo "  - odoo               (200K LOC Python ERP)"
    echo "  - alfresco-community (100K LOC Java Content)"
    echo ""
    echo "TIER 2: Enterprise Applications (10-50K LOC)"
    echo "  - nuxeo              (50K LOC Java)"
    echo "  - umbraco-cms        (50K LOC C#)"
    echo "  - cfwheels           (50K LOC ColdFusion)"
    echo "  - django-oscar       (10K LOC Python)"
    echo "  - b2cweb             (5K LOC Java)"
    echo "  - mezzanine          (5K LOC Python)"
    echo "  - dfe-net            (5K LOC C#)"
    echo "  - monolith-enterprise (5K LOC Java)"
    echo ""
    echo "TIER 3: Federal/Legacy Systems (Real Production)"
    echo "  - cics-banking-sample (COBOL banking - IBM)"
    echo "  - nastran-95         (Fortran scientific - NASA)"
    echo "  - apollo-11          (Assembly code - 1969)"
}

# Parse command line arguments
CLONE_ALL=false
LIST_ONLY=false
SELECTED_REPOS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            CLONE_ALL=true
            shift
            ;;
        --list)
            LIST_ONLY=true
            shift
            ;;
        *)
            if [ -n "$(get_repo_url "$1")" ]; then
                SELECTED_REPOS+=("$1")
            else
                echo "Error: Unknown repository: $1"
                echo "Use --list to see available systems"
                exit 1
            fi
            shift
            ;;
    esac
done

# Show help if no arguments
if [ "$LIST_ONLY" = false ] && [ "$CLONE_ALL" = false ] && [ ${#SELECTED_REPOS[@]} -eq 0 ]; then
    echo "Legacy Modernization Corpus - Aggregation Setup"
    echo ""
    echo "Usage:"
    echo "  Clone all:           ./CORPUS-AGGREGATION-SETUP.sh --all"
    echo "  List available:      ./CORPUS-AGGREGATION-SETUP.sh --list"
    echo "  Clone specific:      ./CORPUS-AGGREGATION-SETUP.sh odoo django-oscar"
    echo ""
    echo "Examples:"
    echo "  # Clone only enterprise monoliths"
    echo "  ./CORPUS-AGGREGATION-SETUP.sh apache-ofbiz odoo alfresco-community"
    echo ""
    echo "  # Clone federal/legacy systems"
    echo "  ./CORPUS-AGGREGATION-SETUP.sh cics-banking-sample nastran-95 apollo-11"
    echo ""
    echo "  # Clone everything"
    echo "  ./CORPUS-AGGREGATION-SETUP.sh --all"
    exit 0
fi

# List and exit
if [ "$LIST_ONLY" = true ]; then
    list_repos
    exit 0
fi

# Determine which repos to clone
if [ "$CLONE_ALL" = true ]; then
    REPOS_TO_CLONE=(
        apache-ofbiz odoo alfresco-community
        nuxeo django-oscar umbraco-cms
        mezzanine b2cweb dfe-net monolith-enterprise cfwheels
        cics-banking-sample nastran-95 apollo-11
    )
else
    REPOS_TO_CLONE=("${SELECTED_REPOS[@]}")
fi

# Create aggregation directory
mkdir -p "$AGGREGATION_ROOT"
cd "$AGGREGATION_ROOT"

echo "🔨 Cloning legacy corpus systems..."
echo "Target: $AGGREGATION_ROOT"
echo "Systems: ${#REPOS_TO_CLONE[@]}"
echo ""

# Clone each repository
for repo_name in "${REPOS_TO_CLONE[@]}"; do
    repo_url=$(get_repo_url "$repo_name")
    
    if [ -z "$repo_url" ]; then
        echo "❌ Unknown repository: $repo_name"
        continue
    fi
    
    repo_path="$AGGREGATION_ROOT/$repo_name"
    
    if [ -d "$repo_path" ]; then
        echo "✓ Already cloned: $repo_name"
    else
        echo "📦 Cloning: $repo_name"
        git clone --depth=50 "$repo_url" "$repo_path" 2>&1 | head -3
    fi
done

echo ""
echo "✅ Aggregation complete!"
echo "📍 Systems in: $AGGREGATION_ROOT"
echo ""
echo "Next steps:"
echo "  cd $AGGREGATION_ROOT"
echo "  ls -la"
