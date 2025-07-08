#!/bin/bash

cd /Users/angelone/Projects/duetright-slack-bot

echo "Aborting the failed rebase..."
git rebase --abort

echo "Pulling with merge strategy..."
git pull origin main --no-rebase

echo "Current status:"
git status

echo "Pushing merged changes..."
git push origin main

echo "✅ Slack bot repository updated!"