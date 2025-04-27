#!/bin/bash

# Colors just for fun
PURPLE='\033[0;35m'
YELLOW='\033[0;33m'
NC='\033[0m'

# color-coded prefixes for terminal log clarity
BACKEND_PREFIX="$(printf "%b[backend]%b " "$PURPLE" "$NC")"
FRONTEND_PREFIX="$(printf "%b[frontend]%b " "$YELLOW" "$NC")"

# run backend and frontend watchers in parallel
parallel --line-buffer ::: \
  "air | stdbuf -oL sed 's/^/$BACKEND_PREFIX/'" \
  "chokidar 'frontend/src' -c 'cd frontend && npm run build' | stdbuf -oL sed 's/^/$FRONTEND_PREFIX/'"