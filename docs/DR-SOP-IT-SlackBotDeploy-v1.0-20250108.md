# Standard Operating Procedure

## Title
Slack Bot Deployment and Multi-User Configuration

## Purpose
Standardize the deployment and configuration of the DuetRight Slack bot to ensure it works for all team members, not just specific users.

## Scope
Applies to the duetright-slack-bot deployment and any Slack automation integrations.

## Procedure

### 1. Pre-Deployment Setup
1. **Environment Configuration**
   ```bash
   cd ~/Projects/duetright-slack-bot
   cp .env.example .env
   ```

2. **Edit .env with Required Values**
   - `SLACK_BOT_TOKEN`: From Slack App settings
   - `SLACK_SIGNING_SECRET`: From Slack App settings  
   - `SLACK_APP_TOKEN`: For Socket Mode

3. **Install Dependencies**
   ```bash
   npm install
   ```

### 2. Multi-User Configuration
1. **Verify No User Restrictions**
   - Check index.js for any username checks
   - Ensure no hardcoded user limitations
   - Current version (v2.0.0) has removed all user restrictions

2. **Test with Multiple Users**
   ```bash
   node test-bot.js
   ```

### 3. Deployment Steps
1. **Local Testing**
   ```bash
   npm start
   ```

2. **Production Deployment**
   ```bash
   pm2 start index.js --name duetright-slack-bot
   pm2 save
   pm2 startup
   ```

3. **Verify in Slack**
   - Post `*test message*` in project channel
   - Confirm message is pinned
   - Test with different users

### 4. Channel Configuration
Current monitored channels:
- #proj-vladimir
- #proj-marina  
- #proj-sergei
- #proj-stanangelo
- #proj-cbti
- #proj-mike

To add channels, edit `projectChannels` array in index.js

### 5. Monitoring
1. **Check Bot Status**
   ```bash
   pm2 status duetright-slack-bot
   ```

2. **View Logs**
   ```bash
   pm2 logs duetright-slack-bot
   ```

3. **Monitor Usage**
   - Track which users trigger the bot
   - Review pinned messages weekly

### 6. Troubleshooting

#### Bot Not Responding
1. Check PM2 status
2. Verify environment variables
3. Check Slack token validity
4. Review error logs

#### User-Specific Issues
1. Confirm no user restrictions in code
2. Test with affected user's exact message format
3. Verify user is in monitored channel

## Responsibilities
- **Developer**: Maintain bot code, remove user restrictions
- **Ops Team**: Deploy and monitor bot
- **Team Members**: Use `*message*` format for important messages

## Version History
- v1.0 (2025-01-08): Initial SOP for multi-user Slack bot

---
*End of Document*