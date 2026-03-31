# Phishing Campaigns Bible

## Campaign Planning

### Reconnaissance
- Identify target organization
- Research employees, roles, departments
- Find email patterns (firstname.lastname@company.com)
- Identify valid emails via OSINT
- Determine communication patterns

### Pretext Development
- Create believable scenario
- Match company culture
- Urgency factors (deadline, action required)
- Authority impersonation (CEO, IT, HR)

### Infrastructure
- **Domain**: Register similar domain
  - typosquatting (googl.com, g00gle.com)
  - subdomain abuse (company.fake-domain.com)
  - TLD variation (.net, .org, .co)

- **Hosting**: Clean IP, no reputation
- **SSL**: Let's Encrypt (free)
- **Email**: Dedicated sending infrastructure

## Email Phishing

### Tools
- **GoPhish**
  - Install: `apt install gophish`
  - Default: port 3333 (admin), 80 (landing)
  - Create landing page (clone real site)
  - Create email template
  - Import user list
  - Launch campaign

- **Social-Engineer Toolkit (SET)**
  - `setoolkit` → Spear phishing
  - Clone website option
  - Mass mailer option

- **Swaks** - Swiss army knife for SMTP
  - `swaks --to victim@target.com --from it@company-support.com --server mail.smtp.com`

### Templates
- Password reset
- Invoice/payment
- Document sharing
- IT notification
- Executive message
- Voicemail notification

### Obfuscation
- HTML email with redirects
- URL shorteners (avoid - flagged)
- Homograph attacks (punycode)
- QR codes for links

## Landing Pages

### Cloning
- **HTTrack** - `httrack https://login.target.com -O "clone" "+*.target.com/*"`
- **wget** - `wget --mirror --convert-links --adjust-extension target.com`
- Manual inspection of HTML

### Credential Harvesting
- Modify forms to post to collector
- Use `SimplePhish` or similar
- Capture: username, password, IP, user-agent

### Multi-factor Bypass
- **CredSniper** - Real-time token capture
- **Gophish** - Session hijacking
- **evilginx2** - MITM proxy for 2FA

## Tracking

### Metrics
- Emails sent
- Emails delivered
- Links clicked
- Forms submitted
- Credentials captured

### Analysis
- Best performing subject lines
- Time-of-day analysis
- Target department analysis

## SMS/Text Phishing (Smishing)

### Services
- **Twilio** - SMS API
- **Nexmo** - Vonage SMS
- **TextBelt** - Free SMS API

### Tools
- **ShellPhish** - Phishing via SMS
- **Fatty** - Smishing framework

## Voice Phishing (Vishing)

### Tools
- **SpoofCard** - Call spoofing
- **Burner** - Temporary numbers
- **Asterisk** - VoIP setup

### Scenarios
- IT support calling
- Manager urgent request
- Vendor payment issue

## Defense

### Technical Controls
- Email filtering (SpamAssassin, Proofpoint)
- Link isolation/sandboxing
- DMARC/DKIM/SPF
- Attachment sandboxing

### User Training
- Phishing simulations
- Security awareness training
- Reporting procedures

### Detection
- Monitor for phishing domains
- Brand protection
- User reporting systems

## Tools
- GoPhish
- Social-Engineer Toolkit
- evilginx2
- CredSniper
- HTTrack
- Maltego
- SendGrid
- Twilio
- PhishTank

## References
- GoPhish Documentation
- MITRE ATT&CK - Phishing
- HackTricks - Phishing