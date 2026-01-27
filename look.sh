#!/usr/bin/env bash 
 
# uses tree and cat to print out essential file structure
# and file contents for use to give to AI for context about
# this repo.
echo "file structure"
tree -L 3.
echo "go.work"
cat go.work
echo "docker-compose.yaml"
cat docker-compose.yaml
echo "compile-proto.sh:"
cat compile-proto.sh
echo "Dockerfiles:"
find . -type f -name "Dockerfile" -print0 |
while IFS= read -r -d '' file; do
  echo "===== $file ====="
  cat "$file"
  echo
done
echo "protos:"
find api -type f -name '*.proto' -print0 |
while IFS= read -r -d '' file; do
  echo "===== $file ====="
  cat "$file"
  echo
done
echo "gateway-service/cmd/server.go:"
cat gateway-service/cmd/server.go

