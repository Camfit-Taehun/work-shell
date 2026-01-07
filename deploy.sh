#!/bin/bash
# work-shell 로컬 플러그인 배포 스크립트
# 사용법: ./deploy.sh

set -e

# 색상 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 경로 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_NAME="work-shell"
LOCAL_PLUGINS_DIR="$HOME/.claude/plugins/local"
TARGET_DIR="$LOCAL_PLUGINS_DIR/$PLUGIN_NAME"

echo -e "${BLUE}=== work-shell 배포 스크립트 ===${NC}"
echo ""

# 로컬 플러그인 디렉토리 생성
if [ ! -d "$LOCAL_PLUGINS_DIR" ]; then
    echo -e "${YELLOW}로컬 플러그인 디렉토리 생성 중...${NC}"
    mkdir -p "$LOCAL_PLUGINS_DIR"
fi

# 기존 설치 제거
if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}기존 설치 제거 중...${NC}"
    rm -rf "$TARGET_DIR"
fi

# 파일 복사 (개발용 파일 제외)
echo -e "${BLUE}플러그인 파일 복사 중...${NC}"
rsync -av --quiet \
    --exclude='.git' \
    --exclude='.work-shell' \
    --exclude='.claude' \
    --exclude='deploy.sh' \
    --exclude='*.log' \
    --exclude='.DS_Store' \
    "$SCRIPT_DIR/" "$TARGET_DIR/"

# 결과 출력
echo ""
echo -e "${GREEN}✓ 배포 완료!${NC}"
echo ""
echo "설치 위치: $TARGET_DIR"
echo ""
echo -e "${YELLOW}Claude 재시작 후 사용 가능합니다:${NC}"
echo "  claude --plugin-dir $TARGET_DIR"
echo ""
echo -e "${YELLOW}또는 별칭 설정 (~/.zshrc):${NC}"
echo "  alias claude='claude --plugin-dir $TARGET_DIR'"
echo ""

# 설치된 파일 개수 출력
FILE_COUNT=$(find "$TARGET_DIR" -type f | wc -l | tr -d ' ')
echo -e "${BLUE}설치된 파일: ${FILE_COUNT}개${NC}"
