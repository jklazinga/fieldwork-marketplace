#!/bin/sh
# Install git hooks for this repo.
# Run once after cloning: sh scripts/install-hooks.sh

HOOKS_DIR=".git/hooks"

cat > "$HOOKS_DIR/post-commit" << 'EOF'
#!/bin/sh
# Auto-update version to current git SHA after every commit.
SHA=$(git rev-parse --short HEAD)
PLUGIN_JSON=".claude-plugin/plugin.json"
MARKETPLACE_JSON=".claude-plugin/marketplace.json"

sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$SHA\"/g" "$PLUGIN_JSON"
sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$SHA\"/g" "$MARKETPLACE_JSON"

git add "$PLUGIN_JSON" "$MARKETPLACE_JSON"
git commit --amend --no-edit --no-verify -q
EOF

chmod +x "$HOOKS_DIR/post-commit"
echo "Hooks installed."
