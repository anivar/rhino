# Rhino Compat-Table Integration

This directory contains tools for automating Rhino's compatibility testing with the [compat-table](https://github.com/compat-table/compat-table) project.

## Background

The compat-table project tracks ECMAScript feature support across JavaScript engines. With PR [#1881](https://github.com/compat-table/compat-table/pull/1881), test results are now externalized to JSON files, enabling automated updates.

## Prerequisites

- Java 11+ for building Rhino
- Node.js 14+ for running compat-table tests
- Git

## Usage

### Automated Update

Run the update script to automatically test Rhino against compat-table tests:

```bash
./update-rhino-compat.sh
```

This script will:
1. Clone/update the compat-table repository
2. Build the latest Rhino JAR
3. Run all compat-table tests with Rhino
4. Update the results JSON files
5. Create a commit with the changes

### Manual Testing

If you want to test manually:

1. Build Rhino JAR:
   ```bash
   cd ../..
   ./gradlew :rhino-all:build
   ```

2. Copy JAR to compat-table directory:
   ```bash
   cp rhino-all/build/libs/rhino-all-*.jar tools/compat-table/compat-table-repo/rhino.jar
   ```

3. Run tests:
   ```bash
   cd tools/compat-table/compat-table-repo
   node rhino.js --update
   ```

## How It Works

The compat-table tests are JavaScript code snippets that test specific ECMAScript features. The `rhino.js` runner:

1. Executes each test in Rhino using the JAR
2. Records whether the test passes or fails
3. Updates the results in `results-*.json` files
4. Stores results under a version-specific key (e.g., `rhino1_7_15`)

## Contributing Back

After running the automation:

1. Review the changes:
   ```bash
   cd compat-table-repo
   git diff results-*.json
   ```

2. Push to your fork:
   ```bash
   git push origin externalize-tests
   ```

3. Create a PR to the compat-table project

## File Structure

- `update-rhino-compat.sh` - Main automation script
- `compat-table-repo/` - Cloned compat-table repository (created by script)
- `README.md` - This file

## Notes

- The script uses p-bakker's `externalize-tests` branch which separates tests from results
- Results are stored with Rhino version keys for tracking changes over releases
- The automation helps keep Rhino's compatibility data current in compat-table