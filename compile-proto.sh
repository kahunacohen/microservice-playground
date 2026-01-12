#!/usr/bin/env bash
set -euo pipefail

API_DIR="api"
OUT_DIR="proto-gen"

go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest

# Ensure googleapis is present
mkdir -p third_party
if [ ! -d third_party/googleapis ]; then
  git clone https://github.com/googleapis/googleapis.git third_party/googleapis
fi

mkdir -p "$OUT_DIR"

PROTOS=$(find "$API_DIR" -name "*.proto")

echo "Generating protobuf code into $OUT_DIR"

protoc \
  -I "$API_DIR" \
  -I third_party/googleapis \
  --go_out="$OUT_DIR" \
  --go_opt=paths=source_relative \
  $PROTOS

protoc \
  -I "$API_DIR" \
  -I third_party/googleapis \
  --go-grpc_out="$OUT_DIR" \
  --go-grpc_opt=paths=source_relative \
  $PROTOS

protoc \
  -I "$API_DIR" \
  -I third_party/googleapis \
  --grpc-gateway_out="$OUT_DIR" \
  --grpc-gateway_opt=paths=source_relative \
  $PROTOS

go mod tidy -C "$OUT_DIR"
echo "Done."

