# Password Attacks Bible

## Password Cracking

### Hash Identification
- **hashID** - Identify hash types
  - `hashid hash.txt`
- **hash-identifier** - Another hash identifier
- **Name-That-Hash** - Modern hash identification

### Wordlists
- **SecLists** - Comprehensive wordlists
  - `/usr/share/seclists/Passwords/Common-Credentials/`
- **CrackStation** - 1.4B passwords
- **RockYou2024** - 100M+ passwords
- **WeakPass** - Collection of weak passwords
- **Passwords/Pro** - Leaked passwords database

### Rules-based Attacks
- **Hashcat**
  - `hashcat -m 1000 -a 0 hash.txt wordlist.txt -r rules/best64.rule`
  - `-m` = hash mode (1000=NTLM, 1800=unix, etc.)
  - `-a` = attack mode (0=straight, 1=combinator, 3=mask, 6=hybrid word+mask, 7=hybrid mask+word)

- **John the Ripper**
  - `john --format=nt hash.txt --wordlist=wordlist.txt`
  - `--rules` enable rule-based mangling

### Mask Attacks
- `hashcat -m 1000 hash.txt ?u?u?u?u?u?u?u?u` - 8 uppercase
- `?l` = lowercase, `?u` = uppercase, `?d` = digits, `?s` = special, `?a` = all

### Hybrid Attacks
- `hashcat -a 6 hash.txt wordlist.txt ?d?d?d` - wordlist + 3 digits
- `hashcat -a 7 hash.txt ?d?d?d wordlist` - mask + wordlist

### PRINCE Attack
- `hashcat -a 3 --stdout ?l?l?l?l | princeprocessor`
- Generate candidate passwords from password elements

### Dictionary Attacks
- **CeWL** - Generate wordlist from website
  - `cewl -d 5 -m 5 -w output.txt https://target.com`
- **Crunch** - Generate custom wordlists
  - `crunch 8 12 abcdefghijklmnopqrstuvwxyz -o wordlist.txt`

### Spraying
- **CrackMapExec**
  - `crackmapexec smb 10.10.10.0/24 -u user -p 'Password1'`
- **hydra**
  - `hydra -L users.txt -P passwords.txt 10.10.10.10 ssh`
- **Medusa**
  - `medusa -h 10.10.10.10 -U users.txt -P passwords.txt -M ssh`

### Pass-the-Hash
- **Impacket**
  - `psexec.py domain/user:hash@target`
  - `wmiexec.py domain/user:hash@target`
  - `smbexec.py domain/user:hash@target`
- **CrackMapExec**
  - `crackmapexec smb 10.10.10.10 -u user -H hash`
- **Mimikatz**
  - `sekurlsa::pth /user:admin /domain:domain /ntlm:hash`

## Credential Stuffing

### Tools
- **credential-stuffing-prioritizer** - Sort by likelihood
- **Snuffleupagus** - Credential stuffing tool
- **BBR** - Breach bag reconnaissance

### Checking
- **HaveIBeenPwned API**
  - Check if email compromised
  - `curl -s https://api.pwnedpasswords.com/range/ABCDE`
- **DeHashed** - Paid breach database
- **LeakCheck** - Free breach checker

## Password Reset Attacks

### Target: Reset Flow
- Token predictability
- Email enumeration
- Token expiration
- Account takeover via reset

### Tools
- **PasswordSprayer** - Password spraying
- **SPRT** - Service password reset tool

## Key Derivation

### Common Methods
- **MD5** - Fast, not secure (rainbow tables)
- **SHA-1** - Deprecated
- **SHA-256** - Better but not for passwords
- **bcrypt** - Slow, salted, recommended
- **Argon2** - Memory-hard, best practice
- **PBKDF2** - NIST recommended
- **scrypt** - CPU/memory intensive

## GPU Acceleration

### Hashcat Benchmarks
- RTX 4090: ~100 GH/s MD5
- Use `-d 1,2` for multiple GPUs
- `--optimized-kernel` for better performance

### CUDA vs OpenCL
- CUDA: NVIDIA only
- OpenCL: All GPUs

## Live Password Attacks

### Online Services
- Lockout detection required
- Rate limiting bypass
- Use different IPs/proxies

### Offline
- Most efficient (hash cracking)
- Get hashes first (mimikatz, responder)

## Defense

### Password Policy
- Minimum 12-16 characters
- Passphrases over complex passwords
- No password reuse
- Multi-factor authentication

### Monitoring
- Breached password notification
- Credential monitoring services
- 2FA/MFA enforcement

### Technical Controls
- Account lockout policies
- MFA everywhere
- Password managers
- JIT access

## Tools
- Hashcat
- John the Ripper
- Hash Identification Tools
- CrackMapExec
- Impacket
- Mimikatz
- Hydra
- Medusa
- CeWL
- Crunch
- Passware
- Elcomsoft
- Password Recovery Toolkit

## References
- Hashcat Wiki
- OpenWall Wiki
- HackTricks - Password Attacks