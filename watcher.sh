#!/bin/bash

LOG="coords.log"
TIMEOUT_1=120   # 2 minutes
TIMEOUT_2=300   # 5 minutes
TIMEOUT_3=600   # 10 minutes

echo "🎩 Copilot Watcher Activated"
echo "📡 Monitoring $LOG..."

LAST_TS=$(date +%s)

while true; do
  sleep 10
  if [[ ! -f "$LOG" ]]; then echo "Log file missing."; exit 1; fi

  NEW_TS=$(date +%s)
  LAST_LINE=$(tail -n 1 "$LOG")
  if [[ "$LAST_LINE" == *"https://maps.google.com/"* ]]; then
    LAST_TIME=$(echo "$LAST_LINE" | cut -d"|" -f1)
    LAST_TS=$(date -d "$LAST_TIME" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S%z" "$LAST_TIME" +%s)
    echo -e "\n📍 GPS received: $LAST_LINE"
  fi

  DIFF=$(( $(date +%s) - LAST_TS ))

  if [[ $DIFF -ge $TIMEOUT_3 ]]; then
    echo -e "\n❌ Timeout: No location for 10 min."
    echo "💡 Suggestion: Rotate QR, update scenario, or archive logs."
    break
  elif [[ $DIFF -ge $TIMEOUT_2 ]]; then
    echo -e "\n⚠️  Warning: No ping in 5 min."
    echo -e "🧠 Options:\n[1] Retry QR\n[2] Change theme\n[3] Abort"
  elif [[ $DIFF -ge $TIMEOUT_1 ]]; then
    echo -e "\n⏳ Still waiting (2+ min)... Stand by."
  fi
done

