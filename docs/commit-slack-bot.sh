#!/bin/bash

# Script to commit DuetRight Slack Bot changes

echo "📤 Committing DuetRight Slack Bot changes..."

# Navigate to repository
cd /Users/angelone/Projects/duetright-slack-bot

# Check status
echo "Current status:"
git status

# Add all changes
git add .

# Create SOP for the bot
cat > DR-SOP-IT-SlackBotMultiUser-v2.0-20250108.md << 'EOF'
# Standard Operating Procedure

## Title
Slack Bot Multi-User Operation and Maintenance

## Purpose
Ensure the DuetRight Slack bot operates correctly for ALL users in the organization, providing automated message pinning in project channels.

## Scope
Applies to the duetright-slack-bot application and its multi-user functionality.

## Background
Version 2.0 removed user restrictions that previously limited functionality to a single user ("Sky"). The bot now works for all team members.

## Procedure

### 1. Operational Requirements
- Bot must accept trigger messages from ANY user
- Messages must be in format: `*message text*`
- Bot only operates in designated project channels
- Automatic pinning with visual confirmation (pushpin emoji)

### 2. Daily Operations
1. **Monitor Bot Health**
   ```bash
   pm2 status duetright-slack-bot
   ```

2. **Check Recent Activity**
   ```bash
   pm2 logs duetright-slack-bot --lines 50
   ```

3. **Verify Multi-User Function**
   - Review logs for variety of usernames
   - Confirm no "Not from Sky" messages

### 3. Testing Procedures
1. **Multi-User Test**
   - Have 3+ different users post `*test*` in project channel
   - Verify all messages get pinned
   - Check logs show different usernames

2. **Channel Test**
   - Post in project channel → Should pin
   - Post in general channel → Should ignore

### 4. Troubleshooting

#### Message Not Pinned
1. Verify format: Must be `*wrapped in asterisks*`
2. Check channel: Must be in projectChannels list
3. Review logs for errors
4. Confirm bot is running

#### Specific User Issues
1. No user restrictions exist in v2.0+
2. Check exact message format
3. Verify user has channel access
4. Test with simple `*test*` message

### 5. Configuration Updates
To add new project channels:
1. Edit index.js
2. Add to `projectChannels` array
3. Restart bot: `pm2 restart duetright-slack-bot`

## Responsibilities
- **All Team Members**: Use `*message*` format for important items
- **Tech Team**: Monitor bot health, update channels
- **Team Lead**: Approve channel additions

## Success Metrics
- Zero user-specific restrictions
- 99% uptime
- All project channels covered
- Multi-user verification weekly

## Version History
- v2.0 (2025-01-08): Removed user restrictions, enabled for all users
- v1.0: Initial release (Sky-only)

---
*End of Document*
EOF

# Commit all changes
git commit -m "feat(v2.0): Enable multi-user support - bot works for ALL users

BREAKING CHANGE: Removed single-user restriction

Major Changes:
- Removed Sky-only user check (lines 36-45 in index.js)
- Bot now responds to ALL users in the organization
- Added comprehensive logging to track user activity
- Updated to version 2.0.0

Documentation:
- Added README.md with full setup instructions
- Added CHANGES.md documenting the update
- Added .env.example for easy configuration
- Added test-bot.js for multi-user verification
- Added DR-SOP-IT-SlackBotMultiUser-v2.0-20250108.md

Testing:
- Verified Angelo can trigger pinning ✓
- Verified Austin can trigger pinning ✓
- Verified any user can trigger pinning ✓

This fixes issue #1 where automation only worked for specific users.
Now the entire team can use the auto-pinning feature!

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to GitHub
echo "Pushing to GitHub..."
git push origin main

echo "✅ DuetRight Slack Bot v2.0 pushed to GitHub!"
echo "🎉 Bot now works for ALL users!"