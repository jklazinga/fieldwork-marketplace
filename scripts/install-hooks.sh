#!/bin/sh
# Install git hooks for this repo.
# Run once after cloning: sh scripts/install-hooks.sh

HOOKS_DIR=".git/hooks"

cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/bin/sh
# Stamp version with current HEAD SHA before each commit.
# Version will reflect the previous commit — stable and loop-free.
SHA=$(git rev-parse --short HEAD)
PLUGIN_JSON=".claude-plugin/plugin.json"
MARKETPLACE_JSON=".claude-plugin/marketplace.json"

sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$SHA\"/g" "$PLUGIN_JSON"
sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$SHA\"/g" "$MARKETPLACE_JSON"
git add "$PLUGIN_JSON" "$MARKETPLACE_JSON"
EOF

chmod +x "$HOOKS_DIR/pre-commit"
echo "Hooks installed."
