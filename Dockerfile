# ========================================
# Base Layer: Common Config & Dependencies
# ========================================
FROM golang:1.24 AS base
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download



# ==================================
# Production Layer: Optimized Binary
# ==================================
FROM base AS builder
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
COPY . .
RUN go build -buildvcs=false -o main .

FROM alpine:latest AS prod
WORKDIR /root/
COPY --from=builder /app/main .
COPY --from=builder /app/frontend/dist/ ./frontend/dist/

CMD ["./main"]



# =========================================
# Development Layer: Debugging & Hot Reload
# =========================================
FROM base AS dev

# Install bash, node, npm, air, chokidar, and parallel for hot reload
RUN apt-get update && apt-get install -y bash
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs
RUN apt install -y parallel
RUN npm install -g chokidar-cli
RUN go install github.com/air-verse/air@latest


ENV SHELL=/bin/sh

COPY . .

RUN go build -buildvcs=false -o /app/.air_tmp/main .

RUN cd frontend && npm install
WORKDIR /app

CMD ["bash", "start-dev.sh"]