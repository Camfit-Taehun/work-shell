#!/bin/bash
# work-shell 마켓플레이스 배포 스크립트
# Usage: ./publish.sh [patch|minor|major] [commit message]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}ℹ${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; exit 1; }

# 현재 디렉토리 확인
if [[ ! -f ".claude-plugin/plugin.json" ]]; then
    error "work-shell 프로젝트 루트에서 실행하세요."
fi

# 버전 타입 (기본: patch)
VERSION_TYPE=${1:-patch}
COMMIT_MSG=${2:-""}

# 현재 버전 읽기
CURRENT_VERSION=$(grep -o '"version": "[^"]*"' .claude-plugin/plugin.json | head -1 | cut -d'"' -f4)
info "현재 버전: v${CURRENT_VERSION}"

# 새 버전 계산
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

case $VERSION_TYPE in
    major)
        NEW_VERSION="$((MAJOR + 1)).0.0"
        ;;
    minor)
        NEW_VERSION="${MAJOR}.$((MINOR + 1)).0"
        ;;
    patch)
        NEW_VERSION="${MAJOR}.${MINOR}.$((PATCH + 1))"
        ;;
    *)
        error "버전 타입은 patch, minor, major 중 하나여야 합니다."
        ;;
esac

info "새 버전: v${NEW_VERSION}"

# 테스트 실행
echo ""
info "테스트 실행 중..."
if ./test.sh > /dev/null 2>&1; then
    success "모든 테스트 통과"
else
    error "테스트 실패. 배포를 중단합니다."
fi

# 변경사항 확인
echo ""
info "변경사항 확인..."
if [[ -z $(git status --porcelain) ]] && [[ -z "$COMMIT_MSG" ]]; then
    warn "변경사항이 없습니다. 버전만 업데이트합니다."
fi

# 버전 업데이트 - plugin.json
echo ""
info "plugin.json 버전 업데이트..."
sed -i '' "s/\"version\": \"${CURRENT_VERSION}\"/\"version\": \"${NEW_VERSION}\"/" .claude-plugin/plugin.json
success "plugin.json: v${CURRENT_VERSION} → v${NEW_VERSION}"

# 버전 업데이트 - marketplace.json
info "marketplace.json 버전 업데이트..."
sed -i '' "s/\"version\": \"${CURRENT_VERSION}\"/\"version\": \"${NEW_VERSION}\"/" marketplace.json
success "marketplace.json: v${CURRENT_VERSION} → v${NEW_VERSION}"

# Git 작업
echo ""
info "Git 커밋 및 푸시..."

git add -A

# 커밋 메시지 생성
if [[ -n "$COMMIT_MSG" ]]; then
    FULL_MSG="release: v${NEW_VERSION} - ${COMMIT_MSG}"
else
    FULL_MSG="release: v${NEW_VERSION}"
fi

git commit -m "$FULL_MSG"
success "커밋 완료: $FULL_MSG"

# 태그 생성
git tag -a "v${NEW_VERSION}" -m "Release v${NEW_VERSION}"
success "태그 생성: v${NEW_VERSION}"

# 푸시
git push origin master
git push origin "v${NEW_VERSION}"
success "푸시 완료"

# 완료 메시지
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}마켓플레이스 배포 완료!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "버전: v${CURRENT_VERSION} → v${NEW_VERSION}"
echo "GitHub: https://github.com/Camfit-Taehun/work-shell"
echo "태그: v${NEW_VERSION}"
echo ""
echo "사용자 업데이트 명령어:"
echo "  claude plugin update work-shell@camfit-plugins"
echo ""
