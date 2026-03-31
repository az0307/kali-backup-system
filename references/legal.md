# Legal & Authorization Templates

## WARNING
**Only test systems you own or have explicit written permission to test.**
Unauthorized access is illegal and may result in criminal charges.

---

## Penetration Test Authorization Letter

```
[Company Letterhead]

DATE: [Date]

TO: [Testing Company/Consultant Name]

RE: Authorization for Penetration Testing

Dear [Consultant Name],

This letter authorizes [Your Company Name] to conduct a penetration test 
on our network infrastructure.

SCOPE OF TESTING
================
Target Systems:
- IP Range: [XXX.XXX.XXX.XXX/XX]
- Domain: [example.com]
- Wireless Networks: [SSIDs if applicable]
- Specific Systems: [List specific systems]

Testing Type:
- [ ] External Network
- [ ] Internal Network
- [ ] Wireless Security
- [ ] Web Application
- [ ] Social Engineering
- [ ] Physical Security

TIME PERIOD
===========
Start Date: [Date]
End Date: [Date]
Testing Hours: [e.g., 9AM-5PM EST]

AUTHORIZED TECHNIQUES
====================
The following techniques are authorized:
- Network scanning and enumeration
- Vulnerability assessment
- Password cracking (on authorized systems only)
- Wireless security testing
- Exploitation (non-destructive only)
- [Other techniques as needed]

RESTRICTIONS
============
The following are NOT authorized:
- Denial of Service attacks
- Modifying data
- Accessing systems outside scope
- Testing third-party systems without approval
- Physical access attempts

CONTACTS
========
Primary Contact:
- Name: [Name]
- Phone: [Phone]
- Email: [Email]

Security Contact:
- Name: [Name]
- Phone: [Phone]
- Email: [Email]

Emergency Contact (24/7):
- Name: [Name]
- Phone: [Phone]

REPORTING
=========
Daily Status: [Email to security contact]
Critical Findings: Within [X] hours
Final Report: By [Date]

This authorization is valid only for the systems and time period 
listed above. Any testing outside this scope requires additional 
authorization.

Sincerely,

___________________________
[Authorized Person Name]
[Title]
[Company Name]
[Date]
```

---

## Rules of Engagement Template

```
RULES OF ENGAGEMENT
===================

1. SCOPE DEFINITION
   - In-scope: [List target systems]
   - Out-of-scope: [List excluded systems]
   - IP ranges: [XXX.XXX.XXX.XXX/XX]

2. TIME WINDOWS
   - Testing dates: [Start] to [End]
   - Preferred hours: [e.g., 9AM-5PM EST]
   - Maintenance windows: [Any blackout periods]

3. CONTACT INFORMATION
   - Client POC: [Name/Phone/Email]
   - Security team: [Name/Phone/Email]
   - On-call for emergencies: [Name/Phone]

4. AUTHORIZED TECHNIQUES
   [ ] Network reconnaissance
   [ ] Port scanning
   [ ] Vulnerability scanning
   [ ] Password attacks
   [ ] Wireless testing
   [ ] Web app testing
   [ ] Social engineering
   [ ] Physical testing

5. RESTRICTIONS
   - No DoS/DDoS testing
   - No destructive exploits
   - No data modification
   - No exfiltration of data
   - No targeting of third parties

6. DATA HANDLING
   - Sensitive data must be encrypted
   - Minimize data retention
   - Secure storage required
   - Delete after reporting

7. ESCALATION PROCEDURE
   - Critical findings: Immediate notification
   - High findings: Within 4 hours
   - Medium/Low: In final report

8. LEGAL COMPLIANCE
   - Follow local laws
   - No illegal activities
   - Respect privacy
   - Document everything

9. REPORTING REQUIREMENTS
   - Executive summary
   - Technical details
   - Risk ratings
   - Remediation steps
   - Proof of concept

10. SIGN-OFF
    Client: _________________ Date: _______
    Tester: _________________ Date: _______
```

---

## Safe Harbor Clause

```
SAFE HARBOR CLAUSE
==================

This agreement includes a Safe Harbor clause specifying that:

1. Any vulnerabilities discovered during testing that could 
   have been exploited by malicious actors will be handled 
   confidentially.

2. The client agrees not to pursue legal action against the 
   tester for activities conducted within the authorized scope.

3. Both parties agree to work in good faith to remediate 
   any discovered vulnerabilities.

4. Test results will be used solely for security improvement 
   and not for any other purpose.

5. Confidentiality obligations survive the termination of 
   this engagement.
```

---

## Non-Disclosure Agreement (NDA) Summary

```
CONFIDENTIALITY AGREEMENT
=========================

By signing this document, all parties agree to:

1. Keep all findings confidential
2. Not disclose vulnerabilities to third parties
3. Use findings only for remediation
4. Secure all documentation
5. Return or destroy materials at engagement end

Duration: [X] years from engagement completion

This agreement is legally binding and survives termination.
```

---

## Pre-Engagement Checklist

- [ ] Signed SOW (Statement of Work)
- [ ] Signed NDA
- [ ] Rules of Engagement approved
- [ ] Authorization letter signed
- [ ] Scope documented and approved
- [ ] Emergency contacts exchanged
- [ ] Timeline agreed
- [ ] Pricing finalized
- [ ] Insurance verification
- [ ] Legal review completed

## Post-Engagement Checklist

- [ ] Final report delivered
- [ ] All data returned/destroyed
- [ ] No tools left on systems
- [ ] Access credentials reset
- [ ] Exit interview conducted
- [ ] Invoice submitted
- [ ] Lessons learned documented

---

## Legal References

- Computer Fraud and Abuse Act (CFAA) - US
- Computer Misuse Act - UK
- GDPR - EU
- State-specific laws apply

**When in doubt, consult legal counsel before testing.**
