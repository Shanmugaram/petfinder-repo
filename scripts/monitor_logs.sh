#!/usr/bin/env bash
# scripts/monitor_logs.sh
# Usage:
#   ./scripts/monitor_logs.sh /path/to/logfile /path/to/alertfile THRESHOLD
LOG_FILE="${1:-./logs/petfinder/petfinder.log}"
ALERT_FILE="${2:-./logs/petfinder_alerts.log}"
THRESHOLD=${3:-5}

# Ensure files exist
mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"
touch "$ALERT_FILE"

# Count "500" occurrences in the last 60 seconds by timestampless fallback:
# If your logs have timestamps (ISO format), use more precise filtering; fallback to last 500 lines.
count=$(tail -n 500 "$LOG_FILE" | grep -E "\" 500 |  500 |HTTP.*500" | wc -l)

if [ "$count" -ge "$THRESHOLD" ]; then
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") ALERT: $count HTTP 500 errors (threshold $THRESHOLD)" | tee -a "$ALERT_FILE"
fi

# Rotate log when > 5MB (keep 5 backups)
MAX_BYTES=$((5 * 1024 * 1024))
if [ -f "$LOG_FILE" ]; then
  size=$(stat -c%s "$LOG_FILE")
  if [ "$size" -gt $MAX_BYTES ]; then
    for i in 4 3 2 1; do
      if [ -f "${LOG_FILE}.$i" ]; then
        mv "${LOG_FILE}.$i" "${LOG_FILE}.$((i+1))"
      fi
    done
    mv "$LOG_FILE" "${LOG_FILE}.1"
    touch "$LOG_FILE"
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") INFO: rotated log" >> "$ALERT_FILE"
  fi
fi
