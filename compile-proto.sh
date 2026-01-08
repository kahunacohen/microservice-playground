#!/usr/bin/env bash
set -euo pipefail

for service in */; do
  PROTO_DIR="${service}proto"

  [ -d "$PROTO_DIR" ] || continue

  # Find proto files
  PROTOS=$(find "$PROTO_DIR" -name "*.proto")

  # Skip if none found
  [ -n "$PROTOS" ] || {
    echo "No proto files in $PROTO_DIR, skipping"
    continue
  }

  echo "Compiling protos for ${service}"

  # Compile standard protobuf structs into the proto folder
  protoc \
    --proto_path="$PROTO_DIR" \
    --go_out="$PROTO_DIR" \
    --go_opt=paths=source_relative \
    $PROTOS

  # Compile gRPC server/client code into the proto folder
  protoc \
    --proto_path="$PROTO_DIR" \
    --go-grpc_out="$PROTO_DIR" \
    --go-grpc_opt=paths=source_relative \
    $PROTOS
  echo "running go mod tidy"
  go mod tidy -C $service
done

