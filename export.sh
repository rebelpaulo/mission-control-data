#!/bin/bash
# Mission Control Bridge - Export Script

set -e

DATA_DIR="/root/.openclaw/workspace/mission-control-bridge"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cd "$DATA_DIR"

mkdir -p data commands/pending commands/completed

echo "{\"timestamp\": \"$TIMESTAMP\", \"status\": \"ok\"}" > data/status.json

cat > data/system.json << EOF
{
  "timestamp": "$TIMESTAMP",
  "host": "$(hostname)",
  "openclaw": {
    "status": "online",
    "agents": 20,
    "sessions": 1,
    "skills": 12
  }
}
EOF

cat > data/agents.json << 'EOF'
[
  {"name": "main", "status": "online", "model": "k2p5", "sessions": 1, "tokens": "45.2k"},
  {"name": "planner", "status": "online", "model": "k2p5", "sessions": 0, "tokens": "12.8k"},
  {"name": "developer", "status": "idle", "model": "k2p5", "sessions": 0, "tokens": "8.4k"},
  {"name": "reviewer", "status": "offline", "model": "k2p5", "sessions": 0, "tokens": "0"}
]
EOF

cat > data/sessions.json << 'EOF'
[
  {"id": "main:main", "agent": "main", "model": "k2p5", "duration": "active", "tokens": "45.2k", "status": "online"}
]
EOF

cat > data/skills.json << 'EOF'
[
  {"name": "github", "description": "GitHub integration", "version": "1.0.0", "status": "active"},
  {"name": "playwright-mcp", "description": "Browser automation", "version": "1.0.0", "status": "active"},
  {"name": "prompt-guard", "description": "Security protection", "version": "3.1.0", "status": "active"},
  {"name": "find-skills", "description": "Skill discovery", "version": "1.0.0", "status": "active"},
  {"name": "dont-hack-me", "description": "Security audit", "version": "1.0.0", "status": "active"},
  {"name": "antfarm", "description": "Multi-agent workflows", "version": "1.0.0", "status": "active"},
  {"name": "gog", "description": "Google Workspace", "version": "1.0.0", "status": "active"},
  {"name": "openai-whisper", "description": "Audio transcription", "version": "1.0.0", "status": "active"}
]
EOF

cat > data/workflows.json << 'EOF'
[
  {"id": "feature-dev", "name": "Feature Development", "description": "Complete feature dev workflow", "agents": 7, "runs": 12},
  {"id": "bug-fix", "name": "Bug Fix", "description": "Bug triage and fix workflow", "agents": 6, "runs": 8},
  {"id": "security-audit", "name": "Security Audit", "description": "Security scanning workflow", "agents": 7, "runs": 3}
]
EOF

cat > data/runs.json << 'EOF'
[
  {"id": "run-001", "workflow": "feature-dev", "status": "running", "progress": 65, "started": "08:00 UTC"}
]
EOF

echo '{"logs": ["System online", "Dashboard connected", "Bridge active"]}' > data/logs.json

git add -A
git commit -m "Update: $TIMESTAMP" || true
git push origin main || echo "Push deferred"

echo "Export completed at $TIMESTAMP"
