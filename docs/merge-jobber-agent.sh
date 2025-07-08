#!/bin/bash

cd /Users/angelone/easy-mcp/jobber-autonomous-agent

echo "Pulling existing content..."
git pull origin main --allow-unrelated-histories

echo "Pushing merged content..."
git push origin main

echo "✅ Jobber Autonomous Agent successfully pushed!"