---
description: Share session logs or handoffs with team
argument-hint: [session|handoff|summary] [--to <channel>]
allowed-tools: [Read, Bash(curl:*), AskUserQuestion]
---

# Share - Share with Team

Share work logs, handoffs, or summaries with your team.

## Parse Arguments

`$ARGUMENTS`:
- `session` - Share current session summary
- `handoff` - Share latest handoff document
- `summary` - Share today's summary
- `--to <channel>` - Specify destination

## Destinations

Configured in `.work-shell/config.yaml`:
```yaml
sharing:
  slack:
    webhook_url: "https://hooks.slack.com/..."
    default_channel: "#dev"
  notion:
    api_key: "..."
    database_id: "..."
```

## 1. Prepare Content

Based on type:
- `session`: Current session state and notes
- `handoff`: Latest `.work-shell/handoffs/*.md`
- `summary`: Today's `/summary` output

Format for destination:
- Slack: Markdown with blocks
- Notion: Page properties

## 2. Send

### Slack
```bash
curl -X POST {webhook_url} \
  -H 'Content-type: application/json' \
  -d '{formatted_payload}'
```

### Notion
```bash
curl -X POST 'https://api.notion.com/v1/pages' \
  -H 'Authorization: Bearer {api_key}' \
  -H 'Notion-Version: 2022-06-28' \
  -d '{page_data}'
```

## 3. Output

```
## 공유 완료

**타입**: {type}
**대상**: {destination}

### 공유된 내용
{content_preview}

---

{destination specific message}

**Tip**: `/config set sharing.slack.default_channel` 으로 기본 채널을 설정하세요.
```

If not configured:
```
## 공유 설정 필요

공유 기능을 사용하려면 설정이 필요합니다.

### Slack 설정
`/config set sharing.slack.webhook_url <url>`

### Notion 설정
`/config set sharing.notion.api_key <key>`
`/config set sharing.notion.database_id <id>`

---

또는 `.work-shell/config.yaml` 을 직접 수정하세요.
```

User argument: $ARGUMENTS
