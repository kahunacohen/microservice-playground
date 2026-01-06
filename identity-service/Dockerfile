# Stage 1: Build
FROM golang:1.25-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git

# Copy module files and download dependencies
COPY go.mod ./
COPY go.sum ./
RUN go mod tidy

# Copy source code
COPY . .

# Build binary from cmd directory
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./cmd

# Stage 2: Minimal runtime
FROM alpine:3.18
RUN apk add --no-cache ca-certificates

COPY --from=builder /app/server /server
EXPOSE 8080 9090

ENTRYPOINT ["/server"]

