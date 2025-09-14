#!/bin/bash

# Update Rhino compatibility results for compat-table
# This script:
# 1. Clones/updates compat-table repo
# 2. Builds latest Rhino JAR
# 3. Runs compat-table tests with Rhino
# 4. Updates results in compat-table format

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RHINO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMPAT_TABLE_DIR="$SCRIPT_DIR/compat-table-repo"

echo "Rhino Compat-Table Automation"
echo "=============================="

# Step 1: Clone or update compat-table repo
if [ ! -d "$COMPAT_TABLE_DIR" ]; then
    echo "Cloning compat-table repository..."
    git clone https://github.com/p-bakker/compat-table.git "$COMPAT_TABLE_DIR"
    cd "$COMPAT_TABLE_DIR"
    git checkout externalize-tests
else
    echo "Updating compat-table repository..."
    cd "$COMPAT_TABLE_DIR"
    git fetch origin
    git checkout externalize-tests
    git pull origin externalize-tests
fi

# Step 2: Build Rhino JAR
echo ""
echo "Building Rhino JAR..."
cd "$RHINO_ROOT"
./gradlew :rhino-all:build -q

# Get Rhino version
RHINO_VERSION=$(grep "^version=" gradle.properties | cut -d'=' -f2)
echo "Rhino version: $RHINO_VERSION"

# Copy JAR to compat-table directory
cp "$RHINO_ROOT/rhino-all/build/libs/rhino-all-${RHINO_VERSION}.jar" "$COMPAT_TABLE_DIR/rhino.jar"

# Step 3: Install compat-table dependencies
echo ""
echo "Installing compat-table dependencies..."
cd "$COMPAT_TABLE_DIR"
npm install

# Step 4: Run Rhino tests with update flag
echo ""
echo "Running compat-table tests with Rhino..."
node rhino.js --update

# Step 5: Show summary of changes
echo ""
echo "Checking for changes..."
git diff --stat results-*.json

# Step 6: Create commit if there are changes
if ! git diff --quiet results-*.json; then
    echo ""
    echo "Changes detected! Creating commit..."
    git add results-*.json
    git commit -m "Update Rhino $RHINO_VERSION test results

Automated update from Rhino build."
    
    echo ""
    echo "Commit created. To push to your fork:"
    echo "  cd $COMPAT_TABLE_DIR"
    echo "  git push origin externalize-tests"
else
    echo "No changes in test results."
fi

echo ""
echo "Done!"