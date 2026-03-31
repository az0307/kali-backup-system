# Kali Backup System - Architecture Diagrams

## Project Overview Mindmap

```mermaid
mindmap
  root((Kali Backup System))
    Core Structure
      scripts (150+)
      bibles (22)
      docs (100+)
      agents (8)
      chains (9)
      config (4)
    Boot System
      boot/GRUB
      EFI/
      isolinux/
      live/
    Tools
      MCP Servers
      TUI Apps
      CLI Tools
      Desktop Apps
    Security Content
      Red Team Bibles (12)
      Blue Team Bibles (8)
      General Bibles (2)
    Integration
      GitHub Sync
      USB Deployment
      AutoBoros Branding
```

## Directory Structure

```mermaid
graph TD
    A[kali-backup-system] --> B[scripts/]
    A --> C[bibles/]
    A --> D[docs/]
    A --> E[agents/]
    A --> F[chains/]
    A --> G[mcp/]
    A --> H[tui/]
    A --> I[cli/]
    A --> J[desktop/]
    A --> K[config/]
    A --> L[skills/]
    
    C --> M[red-team]
    C --> N[blue-team]
    C --> O[general]
    
    M --> M1[web-pentesting]
    M --> M2[network-exploitation]
    M --> M3[password-attacks]
    M --> M4[wireless-hacking]
    M --> M5[social-engineering]
    M --> M6[physical-security]
    M --> M7[privilege-escalation]
    M --> M8[post-exploitation]
    M --> M9[reverse-engineering]
    M --> M10[cloud-pentesting]
    M --> M11[osint]
    M --> M12[phishing-campaigns]
    
    N --> N1[incident-response]
    N --> N2[forensics]
    N --> N3[malware-analysis]
    N --> N4[log-analysis]
    N --> N5[network-monitoring]
    N --> N6[siem-analysis]
    N --> N7[threat-hunting]
    N --> N8[vulnerability-management]
    
    O --> O1[hardware-arsenal]
    O --> O2[personal-botnet-c2]
```

## Scripts Flow

```mermaid
flowchart LR
    subgraph Install Scripts
        S1[giant-install-list.sh<br/>1000+ tools]
        S2[download-wordlists.sh]
        S3[windows-password-reset.sh]
        S4[install-tray-app.sh]
    end
    
    subgraph Sync Scripts
        S5[sync-to-f-drive.ps1]
        S6[backup-all.cmd]
    end
    
    subgraph Desktop Scripts
        S7[KaliShare-Connector.py]
        S8[kalishare-desktop.py]
    end
    
    S1 --> S5
    S2 --> S5
    S3 --> S5
    S4 --> S6
    S7 --> S8
```

## MCP Integration

```mermaid
flowchart TB
    subgraph MCP Servers
        M1[mermaid]
        M2[opencode]
        M3[context7]
        M4[brave-search]
        M5[github]
    end
    
    subgraph Config
        C1[opencode.json]
        C2[.env.mcp]
    end
    
    subgraph Skills
        SK1[mermaid-expert]
        SK2[pentest-expert]
        SK3[hardware-guru]
    end
    
    C1 --> M1
    C1 --> M2
    C1 --> M3
    C2 --> M4
    C2 --> M5
    
    M1 --> SK1
    M2 --> SK2
    M3 --> SK2
    M4 --> SK3
```

## GitHub Sync Flow

```mermaid
sequenceDiagram
    participant Local as Local (C:)
    participant Git as GitHub
    participant USB as USB (F:)
    
    Note over Local: Initialize git<br/>Add .gitignore
    Local->>Git: git init
    Local->>Git: git add .
    Local->>Git: git commit -m "Initial Kali Backup System"
    Git-->>Local: Commit created
    
    Note over USB: Copy scripts/<br/>Copy bibles/
    Local->>USB: robocopy /mir
    Note over USB: Preserve boot files<br/>EFI/, boot/, isolinux/
    
    Note over Local,USB: Verify integrity<br/>md5sum check
    Local->>Local: git push origin main
```

## Agent System

```mermaid
graph LR
    subgraph Agents
        A1[orchestrator-agent]
        A2[redteam-agent]
        A3[dev-agent]
        A4[monitor-agent]
    end
    
    subgraph Capabilities
        C1[Task Orchestration]
        C2[Pentest Automation]
        C3[Development]
        C4[Monitoring]
    end
    
    A1 --> C1
    A2 --> C2
    A3 --> C3
    A4 --> C4
    
    A1 --> A2
    A1 --> A3
    A1 --> A4
```

## Chains (Automation Workflows)

```mermaid
flowchart LR
    subgraph Pentest Chain
        C1[full-recon]
        C2[credential-harvest]
        C3[network-pivot]
        C4[wifi-audit]
    end
    
    subgraph Sync Chain
        C5[backup-all]
        C6[sync-desktop]
    end
    
    subgraph Setup Chain
        C7[home-lab-setup]
        C8[boot-takeover]
        C9[ai-pentest]
    end
    
    C1 --> C2
    C2 --> C3
    C3 --> C4
    
    C5 --> C6
    
    C7 --> C8
    C8 --> C9
```

## Boot System (Kali Live)

```mermaid
flowchart TB
    subgraph DO NOT OVERWRITE
        B1[boot/GRUB]
        B2[EFI/]
        B3[isolinux/]
        B4[install/]
        B5[dists/]
        B6[pool/]
        B7[firmware/]
        B8[live/]
        B9[tools/]
        B10[pics/]
    end
    
    subgraph Sync Allowed
        S1[scripts/]
        S2[bibles/]
        S3[mcp/]
        S4[tui/]
        S5[docs/]
    end
    
    B1 -.-> S1
    B2 -.-> S1
    B3 -.-> S2
```

## Branding (AutoBoros + Kali)

```mermaid
graph LR
    subgraph AutoBoros
        B1[AutoBoros Logo]
        B2[Custom Colors]
    end
    
    subgraph Kali
        K1[Kali Logo]
        K2[Green Theme #367bf0]
    end
    
    subgraph Result
        R1[Metallic Green/Purple]
        R2[kali-menu.png icons]
    end
    
    B1 --> R1
    K2 --> R1
    K1 --> R2
```

## Hardware Arsenal

```mermaid
mindmap
  root((Hardware Arsenal))
    Flipper Zero
      Sub-GHz
      NFC
      RFID
      iButton
    Raspberry Pi
      Pi Zero W
      Pi 4B
      Pi 5
      PiKVM
    ESP32
      Dev Boards
      Firmware Flashing
    Hak5
      Bash Bunny
      Packet Squirrel
      Shark Jack
      Key Croc
    SDR
      RTL-SDR
      HackRF
      USRP
    Networking
      OpenWRT
      Pineapple
```

## Personal C2/Botnet

```mermaid
flowchart LR
    subgraph Command & Control
        C1[Pi 4 Main]
        C2[Webhook Server]
        C3[Telegram Bot]
    end
    
    subgraph Agents
        A1[Pi Zero W]
        A2[ESP32]
        A3[Dropbox]
    end
    
    subgraph Capabilities
        P1[Persistence]
        P2[Beacon]
        P3[Payload Delivery]
    end
    
    C1 --> A1
    C1 --> A2
    C1 --> A3
    
    C2 --> P1
    C3 --> P2
    C1 --> P3
```