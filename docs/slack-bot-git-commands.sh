#!/bin/bash

# Commands to commit and push the Slack bot changes to GitHub

echo "📤 Committing DuetRight Slack Bot changes..."

# Navigate to the repository
cd /Users/angelone/Projects/duetright-slack-bot

# Check current status
echo "📊 Current git status:"
git status

# Add all changes
git add .

# Commit with descriptive message
git commit -m "feat: Remove user restrictions - bot now works for ALL users

BREAKING CHANGE: Removed Sky-only restriction

- Any user can now trigger auto-pinning (not just Sky)
- Added user tracking in logs to see who triggers the bot
- Updated to version 2.0.0
- Added comprehensive documentation (README, CHANGES.md)
- Added test script to verify multi-user functionality
- Added .env.example for easier setup
- Fixed package.json dependencies

The bot now works for Angelo, Austin, and all team members!
Fixes #1 - automation only triggers for specific users

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push origin main

echo "✅ Done! Changes pushed to GitHub."