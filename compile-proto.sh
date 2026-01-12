#!/usr/bin/env bash
set -euo pipefail

API_DIR="api"
OUT_DIR="proto-gen"

# Create output directory if missing
mkdir -p "$OUT_DIR"

# Find all .proto files under api/
PROTOS=$(find "$API_DIR" -name "*.proto")

if [ -z "$PROTOS" ]; then
  echo "No proto files found in $API_DIR"
  exit 0
fi

echo "Found proto files:"
echo "$PROTOS"
echo

echo "Generating protobuf code into $OUT_DIR"

# Compile protobuf messages
protoc \
  --proto_path="$API_DIR" \
  --go_out="$OUT_DIR" \
  --go_opt=paths=source_relative \
  $PROTOS

# Compile gRPC service stubs
protoc \
  --proto_path="$API_DIR" \
  --go-grpc_out="$OUT_DIR" \
  --go-grpc_opt=paths=source_relative \
  $PROTOS

go mod tidy -C $OUT_DIR
echo "Done."

