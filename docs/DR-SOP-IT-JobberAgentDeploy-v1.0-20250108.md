# Standard Operating Procedure

## Title
Jobber Autonomous Agent Deployment for Multi-User Webhooks

## Purpose
Deploy and maintain the Jobber Autonomous Agent to ensure webhook processing for ALL users in the organization, not just the authenticated account.

## Scope
Applies to the jobber-autonomous-agent deployment for DuetRight's field service automation.

## Procedure

### 1. Pre-Deployment Requirements
1. **Create Jobber Developer Account**
   - Go to: https://developer.getjobber.com
   - Register as developer (separate from regular Jobber account)
   - Create new app: "DuetRight Autonomous Agent"

2. **Configure OAuth Application**
   - App Name: DuetRight Autonomous Agent
   - Redirect URI: https://your-domain.com/auth/callback
   - Required Scopes:
     - ✓ clients:read/write
     - ✓ jobs:read/write
     - ✓ quotes:read/write
     - ✓ invoices:read/write
     - ✓ users:read
     - ✓ schedule:read

3. **Save Credentials**
   - Client ID: _____________
   - Client Secret: _____________
   - Store in password manager

### 2. Webhook Configuration (CRITICAL)
1. **Set Webhook URL**
   ```
   https://your-domain.com/webhooks/jobber
   ```

2. **Select ALL Event Types**
   - JOB_CREATE
   - JOB_UPDATE
   - CLIENT_CREATE
   - QUOTE_CREATE
   - INVOICE_CREATE
   - All other relevant events

3. **Verify Organization-Wide**
   - Ensure webhooks trigger for ALL users
   - Not user-specific to authenticated account

### 3. Deployment Steps
1. **Clone Repository**
   ```bash
   git clone https://github.com/angelor888/jobber-autonomous-agent.git
   cd jobber-autonomous-agent
   ```

2. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit with your credentials
   ```

3. **Install Dependencies**
   ```bash
   npm install
   ```

4. **Run Pre-flight Checks**
   ```bash
   npm run preflight
   ```

5. **Deploy to Heroku**
   ```bash
   heroku create your-app-name
   heroku config:set $(cat .env | xargs)
   git push heroku main
   ```

### 4. Multi-User Verification
1. **Run Multi-User Test**
   ```bash
   npm test
   ```

2. **Manual Testing**
   - Angelo creates job → Webhook received ✓
   - Austin creates job → Webhook received ✓
   - Any user creates job → Webhook received ✓

3. **Check Status Endpoint**
   ```bash
   curl https://your-app.herokuapp.com/status
   ```
   - Verify `uniqueUsers` > 1
   - Check `multiUserEnabled: true`

### 5. Monitoring
1. **Daily Checks**
   - Review `/status` endpoint
   - Check unique user count
   - Monitor webhook success rate

2. **Weekly Review**
   - Analyze user distribution
   - Check for any single-user patterns
   - Review error logs

### 6. Troubleshooting

#### Only One User Triggering
1. Verify webhook configuration in Jobber
2. Check OAuth token has organization scope
3. Review agent configuration
4. Run multi-user test suite

#### Webhooks Not Receiving
1. Check webhook URL accessibility
2. Verify HMAC signature validation
3. Review Jobber Developer Portal for errors
4. Check SSL certificate validity

## Responsibilities
- **Developer**: Maintain agent code, ensure multi-user support
- **DevOps**: Deploy and monitor agent
- **Operations**: Review webhook processing metrics

## Critical Success Factors
- ✓ Webhooks work for ALL users (not just Angelo)
- ✓ 99.9% uptime
- ✓ < 1 second processing time
- ✓ Automatic error recovery

## Version History
- v1.0 (2025-01-08): Initial SOP for multi-user webhook agent

---
*End of Document*