#!/bin/bash

# Alias Manager Script
zshrc=~/.zshrc

echo -e "\n========= ALIAS MANAGER =========\n"
grep "^alias " "$zshrc" | sed "s/^alias //" | while read -r line; do
  name=$(echo "$line" | cut -d= -f1)
  command=$(echo "$line" | cut -d= -f2- | sed "s/^'//;s/'$//")
  printf "\033[1;36m%-15s\033[0m → %s\n" "$name" "$command"
done
