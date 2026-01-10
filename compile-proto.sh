#!/usr/bin/env bash
set -euo pipefail

API_DIR="api"

# Find all .proto files under api/
PROTOS=$(find "$API_DIR" -name "*.proto")

if [ -z "$PROTOS" ]; then
  echo "No proto files found in $API_DIR"
  exit 0
fi

echo "Found proto files:"
echo "$PROTOS"
echo

# Iterate through each service directory
for service in */; do
  # Skip non-service directories
  [[ "$service" == "api/" ]] && continue
  [[ "$service" == "tmp/" ]] && continue

  SERVICE_PROTO_DIR="${service}proto"

  # Only compile for services that have a proto/ directory
  if [ ! -d "$SERVICE_PROTO_DIR" ]; then
    echo "Skipping $service (no proto directory)"
    continue
  fi

  echo "Compiling protos for $service → $SERVICE_PROTO_DIR"

  # Compile protobuf messages
  protoc \
    --proto_path="$API_DIR" \
    --go_out="$SERVICE_PROTO_DIR" \
    --go_opt=paths=source_relative \
    $PROTOS

  # Compile gRPC service stubs
  protoc \
    --proto_path="$API_DIR" \
    --go-grpc_out="$SERVICE_PROTO_DIR" \
    --go-grpc_opt=paths=source_relative \
    $PROTOS

  echo "Running go mod tidy for $service"
  go mod tidy -C "$service"

  echo
done

echo "Done."

