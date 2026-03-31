# OSINT Bible

## Search Engines

### Google Dorks
- `site:target.com` - Specific domain
- `filetype:pdf` - File type search
- `intitle:"index of"` - Directory listing
- `inurl:admin` - Admin pages
- `ext:log username` - Log files
- `"password" filetype:xls` - Passwords in spreadsheets
- `intext:"confidential" filetype:doc` - Sensitive docs

### Specialized Search
- **Shodan** - Internet-connected devices
- **Censys** - SSL certificates, hosts
- **ZoomEye** - Chinese IoT search
- **Hunter** - Email discovery
- **HaveIBeenPwned** - Breach data

## People Search

### Email
- **Hunter.io** - Find emails by domain
- **EmailHunter** - Email finder
- **VoilaNorbert** - Email discovery
- **RocketReach** - People search

### Social Media
- **Social Searcher** - Multi-platform
- **Social Mention** - Social monitoring
- **Intel Techniques** - OSINT framework

### Person Search
- **TruePeopleSearch**
- **FastPeopleSearch**
- **Spokeo**
- **PeopleFinder**

## Domain/Network OSINT

### WHOIS
- `whois domain.com`
- **WhoisXML API**
- **RDAP** - Registration data access

### DNS
- `dig any domain.com`
- `dig -x IP`
- **dnsdumpster.com** - DNS enumeration
- **ViewDNS.info** - DNS tools
- **SecurityTrails** - Historical DNS

### Subdomain
- **Sublist3r** - Subdomain enumeration
- **Assetfinder** - Find subdomains
- **Amass** - Subdomain enumeration
- **Knockpy** - DNS subdomain scan
- **crt.sh** - Certificate transparency

### Port/Service
- **Shodan** - Device search
- **Censys** - Port scanning
- **ZoomEye** - Device search

## Image OSINT

### Reverse Image
- **Google Images** - Upload image
- **TinEye** - Reverse image search
- **Yandex Images** - Russian search
- **Reverse Image Search** - Multi-engine

### Metadata
- **ExifTool** - Read metadata
- **ExifCleaner** - Remove metadata
- **Metada** - Online metadata viewer
- **Jeffrey's Exif Viewer**

### Geo-location
- **GeoGUesser** - Location from image
- **Lensoo** - Image location
- **InVID/WeVerify** - Video verification

## Social Media OSINT

### Platforms
- **Twitter** - Tweet metadata, archives
- **Instagram** - Photos, stories, followers
- **LinkedIn** - Professional info
- **Facebook** - Public posts, groups
- **TikTok** - Video metadata

### Tools
- **Social Bookmarking** - Track mentions
- **TweetDeck** - Twitter monitoring
- **Talkwalker** - Social listening
- **Brandwatch** - Social analytics

## Company OSINT

### Business Info
- **LinkedIn** - Employees, company info
- **Crunchbase** - Funding, acquisitions
- **ZoomInfo** - B2B database
- **Company House** - UK companies
- **SEC EDGAR** - US filings

### Technology Stack
- **Wappalyzer** - Technology profiler
- **BuiltWith** - Technology lookup
- **Whatruns** - Browser extension
- **CMS Detector** - CMS identification

## Password/Breach OSINT

### Breach Databases
- **HaveIBeenPwned** - Check email
- **DeHashed** - Breach search (paid)
- **LeakCheck** - Free breach check
- **GhostProject** - Breach database
- **Snusbase** - Breach search

### Credential Stuffing
- **Breach-Comparator** - Check reused passwords
- **PwnedPasswords** - Check password hashes

## Documentation

### Note Taking
- **Obsidian** - Local-first notes
- **CherryTree** - Hierarchical notes
- **Maltego** - Link analysis
- **SpiderFoot** - Automated OSINT

### Sharing
- **IntelOwl** - Open-source threat intel
- **MISP** - Threat intel sharing
- **OpenCTI** - Cyber threat intel

## Techniques

### Passive Recon
- No direct interaction
- Search engines, public databases
- Metadata analysis

### Active Recon
- Direct scanning, enumeration
- More likely to be detected

### Social Engineering
- Pretexting based on OSINT
- Pre-research targets

## Tools
- Maltego
- SpiderFoot
- theHarvester
- Recon-ng
- OSINT Framework
- Sherlock
- Social Analyzer
- Wappalyzer
- Hunter.io
- Shodan
- Censys

## References
- OSINT Framework (osintframework.com)
- MITRE ATT&CK - Recon
- HackTricks - OSINT