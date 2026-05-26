#!/usr/bin/env bash
# Dbio skills installer for OpenAI Codex CLI
# Symlinks skills/ into ~/.agents/skills/ so Codex picks them up.
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/dbio-ai/codex-skills/main/install.sh | bash
# Or after cloning:
#   ./install.sh

set -e

REPO_URL="https://github.com/dbio-ai/codex-skills.git"
INSTALL_DIR="${DBIO_INSTALL_DIR:-$HOME/.dbio/codex-skills}"
SKILLS_DIR="$HOME/.agents/skills"

echo "Dbio Codex skills installer"
echo "==========================="

# Clone or update repo
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "→ Updating existing clone at $INSTALL_DIR"
  git -C "$INSTALL_DIR" pull --quiet
else
  echo "→ Cloning to $INSTALL_DIR"
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

# Create skills target dir
mkdir -p "$SKILLS_DIR"

# Symlink each skill
echo "→ Linking skills into $SKILLS_DIR"
linked=0
for skill_dir in "$INSTALL_DIR/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  target="$SKILLS_DIR/$skill_name"

  # Remove existing link/dir if it points to our repo
  if [ -L "$target" ]; then
    rm "$target"
  elif [ -d "$target" ]; then
    echo "  ! $skill_name already exists as a real directory — skipping. Remove it manually if you want to use Dbio's version."
    continue
  fi

  ln -s "$skill_dir" "$target"
  echo "  ✓ $skill_name"
  linked=$((linked + 1))
done

echo
echo "→ Linked $linked skills"

# Suggest MCP config
echo
echo "Next step: configure the Dbio MCP server in ~/.codex/config.toml"
echo
echo "  cat $INSTALL_DIR/config.toml.example >> ~/.codex/config.toml"
echo
echo "Then set your API key:"
echo
echo "  export DBIO_API_KEY=\"<get from https://dbio.ai/settings/api-keys>\""
echo
echo "Restart Codex and try:  /skills  (you should see dbio skills listed)"
