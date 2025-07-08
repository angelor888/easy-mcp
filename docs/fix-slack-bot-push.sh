#!/bin/bash

cd /Users/angelone/Projects/duetright-slack-bot

echo "Pulling latest changes..."
git pull origin main --rebase

echo "Pushing v2.0 changes..."
git push origin main

echo "✅ Slack bot v2.0 successfully pushed!"