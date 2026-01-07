---
description: Write a longer form note
argument-hint: [title]
allowed-tools: [Read, Write, Bash(date:*), AskUserQuestion]
---

# Note - Long Form Note

Write a longer, more detailed note than /log provides.

## Parse Arguments

`$ARGUMENTS` can be:
- Empty: Ask for title and content
- `<title>`: Use as note title, ask for content

## 1. Gather Note Content

If no title provided, ask user for:
- Note title
- Note content (can be multi-line)
- Tags/categories (optional)

## 2. Create Note File

Create `.work-shell/notes/{date}-{title-slug}.md`:
```markdown
# {title}

**Date**: {YYYY-MM-DD HH:MM}
**Session**: {session_id}
**Tags**: {tags}

---

{content}

---

*Related*:
- Focus: {current_focus}
- Branch: {current_branch}
```

## 3. Update References

Add reference to:
- `.work-shell/logs/{date}.md`
- `.work-shell/state.json` quick_notes

## 4. Output

```
## Note 저장됨

**제목**: {title}
**파일**: .work-shell/notes/{filename}

---

{content preview}

---

**Tip**: `/history notes` 로 모든 노트를 조회하세요.
```

User argument: $ARGUMENTS
