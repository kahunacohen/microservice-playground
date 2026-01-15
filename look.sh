#!/usr/bin/env bash 
 
# uses tree and cat to print out essential file structure
# and contents for use to give to AI.
echo "file structure"
tree -L 3.
echo "docker-compose.yaml"
cat docker-compose.yaml
echo "Dockerfiles:"
find . -type f -name "Dockerfile" -print0 |
while IFS= read -r -d '' file; do
  echo "===== $file ====="
  cat "$file"
  echo
done
echo "protos:"
find . -type f -name "*.proto" -print0 |
while IFS= read -r -d '' file; do
  echo "===== $file ====="
  cat "$file"
  echo
done

