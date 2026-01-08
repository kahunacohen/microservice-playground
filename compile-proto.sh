#!/usr/bin/env bash
set -euo pipefail

for service in */; do
  PROTO_DIR="${service}proto"
  GEN_DIR="${service}gen"

  [ -d "$PROTO_DIR" ] || continue

  # Find proto files
  PROTOS=$(find "$PROTO_DIR" -name "*.proto")

  # Skip if none found
  [ -n "$PROTOS" ] || {
    echo "No proto files in $PROTO_DIR, skipping"
    continue
  }

  echo "Compiling protos for ${service}"

  mkdir -p "$GEN_DIR"

  protoc \
    --proto_path="$PROTO_DIR" \
    --go_out="$GEN_DIR" \
    --go_opt=paths=source_relative \
    $PROTOS
done

