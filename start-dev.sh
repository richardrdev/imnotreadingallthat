#!/bin/bash

# Colors just for fun
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

FRONTEND_PREFIX="$(printf "%b[frontend]%b " "$YELLOW" "$NC")"
BACKEND_PREFIX="$(printf "%b[backend]%b " "$PURPLE" "$NC")"

# frontend watcher
chokidar "frontend/src" -c "cd frontend && npm run build" \
  | tee /dev/tty &


# backend watcher
air \
  | sed "s/^/$BACKEND_PREFIX/"

wait -n
