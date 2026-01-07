#!/bin/bash
# work-shell validation test script
# Usage: ./test.sh

# set -e  # Disabled to allow tests to continue on failure

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0

pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

warn() {
    echo -e "${YELLOW}!${NC} $1"
}

section() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ═══════════════════════════════════════════════════════
# 1. Command File Structure Tests
# ═══════════════════════════════════════════════════════

section "1. Command Files (commands/)"

REQUIRED_COMMANDS=(
    "hello"
    "bye"
    "log"
    "status"
    "todo"
    "focus"
    "commit"
)

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if [[ -f "commands/${cmd}.md" ]]; then
        pass "Command exists: ${cmd}.md"
    else
        fail "Command missing: ${cmd}.md"
    fi
done

# Check Korean aliases
section "1.1 Korean Aliases"

KOREAN_ALIASES=(
    "안녕"
    "바이"
    "기록"
)

for alias in "${KOREAN_ALIASES[@]}"; do
    if [[ -f "commands/${alias}.md" ]]; then
        pass "Korean alias exists: ${alias}.md"
    else
        fail "Korean alias missing: ${alias}.md"
    fi
done

# Check YAML frontmatter
section "1.2 YAML Frontmatter Validation"

check_frontmatter() {
    local file=$1
    local name=$(basename "$file")

    if head -1 "$file" | grep -q "^---$"; then
        # Check for description field
        if grep -q "^description:" "$file"; then
            pass "Valid frontmatter: ${name}"
        else
            warn "Missing description in frontmatter: ${name}"
        fi
    else
        fail "No YAML frontmatter: ${name}"
    fi
}

for file in commands/*.md; do
    if [[ -f "$file" ]]; then
        check_frontmatter "$file"
    fi
done

# ═══════════════════════════════════════════════════════
# 2. State/Config JSON Validation
# ═══════════════════════════════════════════════════════

section "2. State & Config Files"

# Check state.json structure
if [[ -f ".work-shell/state.json" ]]; then
    pass "state.json exists"

    # Validate JSON syntax
    if python3 -c "import json; json.load(open('.work-shell/state.json'))" 2>/dev/null; then
        pass "state.json is valid JSON"

        # Check required fields
        if python3 -c "
import json
data = json.load(open('.work-shell/state.json'))
required = ['version', 'pending_todos']
missing = [f for f in required if f not in data]
exit(0 if not missing else 1)
" 2>/dev/null; then
            pass "state.json has required fields"
        else
            fail "state.json missing required fields"
        fi
    else
        fail "state.json is invalid JSON"
    fi
else
    fail "state.json missing"
fi

# Check config.yaml structure
if [[ -f ".work-shell/config.yaml" ]]; then
    pass "config.yaml exists"

    # Basic YAML validation (check it's not empty and has content)
    if [[ -s ".work-shell/config.yaml" ]]; then
        pass "config.yaml is not empty"
    else
        fail "config.yaml is empty"
    fi
else
    fail "config.yaml missing"
fi

# ═══════════════════════════════════════════════════════
# 3. Directory Structure
# ═══════════════════════════════════════════════════════

section "3. Directory Structure"

REQUIRED_DIRS=(
    ".claude-plugin"
    "commands"
    "skills"
    "hooks"
    "templates"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        pass "Directory exists: ${dir}"
    else
        fail "Directory missing: ${dir}"
    fi
done

# ═══════════════════════════════════════════════════════
# 4. Plugin Configuration
# ═══════════════════════════════════════════════════════

section "4. Plugin Configuration"

if [[ -f ".claude-plugin/plugin.json" ]]; then
    pass ".claude-plugin/plugin.json exists"

    if python3 -c "import json; json.load(open('.claude-plugin/plugin.json'))" 2>/dev/null; then
        pass "plugin.json is valid JSON"

        # Check required plugin fields
        if python3 -c "
import json
data = json.load(open('.claude-plugin/plugin.json'))
required = ['name', 'version', 'description']
missing = [f for f in required if f not in data]
exit(0 if not missing else 1)
" 2>/dev/null; then
            pass "plugin.json has required fields"
        else
            fail "plugin.json missing required fields (name, version, description)"
        fi
    else
        fail "plugin.json is invalid JSON"
    fi
else
    warn "plugin.json not found (optional)"
fi

# ═══════════════════════════════════════════════════════
# 5. Hooks Configuration
# ═══════════════════════════════════════════════════════

section "5. Hooks Configuration"

if [[ -f "hooks/hooks.json" ]]; then
    pass "hooks.json exists"

    if python3 -c "import json; json.load(open('hooks/hooks.json'))" 2>/dev/null; then
        pass "hooks.json is valid JSON"
    else
        fail "hooks.json is invalid JSON"
    fi
else
    warn "hooks/hooks.json not found (optional)"
fi

# ═══════════════════════════════════════════════════════
# 6. Templates
# ═══════════════════════════════════════════════════════

section "6. Templates"

TEMPLATES=(
    "templates/config.yaml"
    "templates/state.json"
    "templates/work-shell.md"
)

for tmpl in "${TEMPLATES[@]}"; do
    if [[ -f "$tmpl" ]]; then
        pass "Template exists: ${tmpl}"
    else
        warn "Template missing: ${tmpl}"
    fi
done

# ═══════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════

section "Summary"

TOTAL=$((PASS + FAIL))
echo ""
echo -e "Total: ${TOTAL} tests"
echo -e "${GREEN}Passed: ${PASS}${NC}"
echo -e "${RED}Failed: ${FAIL}${NC}"
echo ""

if [[ $FAIL -eq 0 ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
