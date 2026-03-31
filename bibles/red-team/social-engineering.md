# Social Engineering Bible

## Phishing

### Email Phishing
- **GoPhish** - Open-source phishing framework
  - `gophish` - Launch web UI (port 3333)
  - Create campaign with fake login page
  - Track clicks, credentials, credentials

- **Setoolkit** - Social-Engineer Toolkit
  - `setoolkit` → Select "Spear-Phishing"
  - Clone legitimate sites
  - Generate payloads

- **PhishingFrame** - Clone websites with iframe injection

### Credential Harvesting
- **CredSniper** - Phishing framework with 2FA support
- **SocialFish** - Social media phishing
- **PhishMan** - Enterprise phishing tool
- **BlackEye** - Complete phishing toolkit

### Landing Pages
- Clone login pages with `httrack`
- Use `wget --mirror` for site cloning
- Modify forms to post to collector

## Vishing (Voice Phishing)

### Tools
- **Social-Engineer Toolkit** - VoIP capabilities
- **Eleutheria** - Vishing campaigns
- **Swipley** - VoIP phishing

### Techniques
- Pretexting as IT support
- Urgency and authority
- Caller ID spoofing

## Smishing (SMS Phishing)

### Tools
- **Twilio** - SMS API
- **Nexmo** - SMS gateway
- **SMS Spoofing tools**

### Techniques
- Package delivery scams
- Bank alerts
- Fake prize claims

## Watering Hole Attacks

### Process
1. Identify target's commonly visited sites
2. Compromise one of those sites
3. Inject exploit/code that harvests credentials
4. Wait for target to visit and get compromised

### Tools
- **BeEF** - Browser Exploitation Framework
  - `beef-xss` - Start server
  - Hook browser via XSS
  - Run commands through hooked browser

- **MITMProxy** - Intercept traffic
- **Responder** - LLMNR/NBT-NS spoofing

## Pretexting

### Common Scenarios
- IT support needing to "fix" machine
- Manager needing urgent transfer
- Vendor needing payment update
- New employee needing system access
- Auditor needing credentials

### Building Rapport
- Research target on LinkedIn
- Use proper terminology
- Match communication style
- Create believable scenario

## Baiting

### USB Drops
- Label drives with enticing labels
- Place in parking lots, office
- Autorun or user-triggered payload

### Physical Access
- Fake USB cables with hidden chips
- Keyloggers
- Bash bunny
- Packet squirrel

### Digital Bait
- Free software downloads
- Fake updates
- Pirated content

## Impersonation

### Executive Spoofing
- Email from "CEO" demanding urgency
- Voicemail from "HR"
- Physical badge cloning

### IT Support
- Help desk calls
- Desktop support visits
- System maintenance

## Defense

### User Training
- Verify sender identity
- Don't click unknown links
- Report suspicious emails
- Never share credentials

### Technical Controls
- SPF/DKIM/DMARC for email
- Multi-factor authentication
- Email filtering
- URL sandboxing
- User awareness training

### Detection
- Monitor for phishing domains
- Brand monitoring
- URL pattern analysis
- User reporting systems

## Tools List
- GoPhish
- Social-Engineer Toolkit (SET)
- PhishTank
- URLScan
- Hatching Triage
- Any.run
- Hybrid Analysis
- PhishAlert
- Cofense
- Proofpoint

## References
- Social-Engineer Wiki
- MITRE ATT&CK - Phishing
- HackTricks - Social Engineering