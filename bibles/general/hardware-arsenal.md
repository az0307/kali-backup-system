# Hardware Arsenal Bible

## Tier 1: Entry Level ($50-$200)

### WiFi Adapters
| Device | Price | Specs | Notes |
|--------|-------|-------|-------|
| **Alfa AWUS036NHA** | $45 | Atheros AR9271, 2.4GHz, b/g/n | Best budget, monitor mode, injection |
| **Alfa AWUS036ACH** | $55 | Realtek 8812AU, 2.4/5GHz, a/ac/n | Dual band, good driver support |
| **TP-Link TL-WN722N v3** | $15 | Realtek RTL8188EUS, 2.4GHz | Cheap but limited |

### Network Tools
| Device | Price | Notes |
|--------|-------|-------|
| **Raspberry Pi Zero W** | $15 | Tiny渗透节点, HID攻击 |
| **USB Rubber Ducky** | $45 | Keystroke注入, 延迟可编程 |
| **Digispark Attiny85** | $5 | 极小 Rubber Ducky 替代 |

### Storage
| Device | Price | Notes |
|--------|-------|-------|
| **SanDisk Ultra 128GB** | $20 | 多系统启动盘, 便携工具库 |
| **Samsung T7 500GB** | $60 | 便携SSD, 敏感数据存储 |

---

## Tier 2: Mid-Range ($200-$500)

### WiFi Pentest
| Device | Price | Specs | Notes |
|--------|-------|-------|-------|
| **Alfa AWUS036AX200** | $80 | Intel AX200, WiFi 6, 2.4/5GHz | 最新WiFi协议, 未来-proof |
| **Alfa AWUS036ACM** | $65 | MediaTek MT7610U, AC1200 | 强信号, Linux原生支持 |
| **Ubiquiti WiFiStation** | $40 | 高增益天线, 远距离 |

### RF & RFID
| Device | Price | Notes |
|--------|-------|-------|
| **Proxmark3 RDV4** | $180 | RFID全协议, 读取/写入/模拟, HID/iClass/MIFARE |
| **ACR122U USB Reader** | $25 | 基础NFC读写, MIFARE |
| **T5577 Key Copier** | $20 | 125kHz 复制, 门禁卡 |

### Hardware Keylogger
| Device | Price | Notes |
|--------|-------|-------|
| **KeyGrabber** | $80 | PS/2+USB硬件键盘记录器, 存储8MB |
| **USB Keylogger** | $30 | 小型USB键盘记录器 |

### Network
| Device | Price | Notes |
|--------|-------|-------|
| **Bash Bunny** | $100 | 多功能 payloads, 快速切换攻击模式 |
| **Packet Squirrel** | $60 | 网络流量捕获, 透明代理 |
| **Shark Jack** | $70 | 网络评估, SSH开启 |

---

## Tier 3: Advanced ($500-$1500)

### Full-Spectrum WiFi
| Device | Price | Specs | Notes |
|--------|-------|-------|-------|
| **WiFi Pineapple Tetra** | $400 | 双频段, Karma攻击, 恶意热点, 自动hash捕获 |
| **WiFi Pineapple Nano** | $200 | 便携版, 同上功能 |
| **ASUS RT-AC68U** | $150 | 刷梅林固件, 强大处理, 离线密码攻击 |
| **GL-iNet GL-MT3000** | $80 | 便携路由器, OpenWrt, VPN链 |

### RF & SDR
| Device | Price | Notes |
|--------|-------|-------|
| **HackRF One** | $300 | 1MHz-6GHz, 传输/接收, 门锁/遥控/无人机 |
| **USRP B205-mini** | $800 | 高端SDR, 软件定义无线电 |
| **RTL-SDR v4** | $30 | 入门级SDR, 频率分析 |
| **Ubertooth One** | $250 | 蓝牙/BLE嗅探, 2.4GHz |

### Hardware Implants
| Device | Price | Notes |
|--------|-------|-------|
| **O.MG Cable** | $150 | HID注入线缆, WiFi控制 |
| **Bash Bunny Elite** | $120 | 高级 payloads, 快速执行 |
| **KeyCroak** | $100 | 高级硬件keylogger, 远程传输 |

### Lock Picking
| Device | Price | Notes |
|--------|-------|-------|
| **Southord PXS-05** | $40 | 专业锁具套装 |
| **Multipick EP-01** | $180 | 德国精度, 高级工具 |
| **LockAid Complete** | $50 | 入门级完整套装 |

---

## Tier 4: Enterprise ($1500+)

### Complete Assessment
| Device | Price | Notes |
|--------|-------|-------|
| **Lan Turtle MKIV** | $200 | 远程访问, 隐蔽部署, 持久化 |
| **CubicSDR Bundle** | $400 | 完整SDR工具链 |
| **BladeRF xA9** | $600 | 高性能SDR, 完整GNU Radio |

### Key Extraction
| Device | Price | Notes |
|--------|-------|-------|
| **TurboIntl KeyDuplicator** | $400 | 车辆钥匙克隆, 芯片复制 |
| **RHX200 Key Copier** | $250 | 专业车辆钥匙 |

### Mobile
| Device | Price | Notes |
|--------|-------|-------|
| **GrayKey** | $4000+ | iPhone 越狱, 政府级 |
| **Cellebrite UFED** | $10000+ | 法医级手机提取 |
| **Oxygen Forensic** | $5000+ | 全平台数据提取 |

---

## Self-Made Gadgets

### DIY WiFi Antenna
- **Cantenna** - 锡罐 + N公头 = 高增益定向
- **Grid Dish** - 烹饪用金属网 + 反射器
- **Yagi** - 多单元定向天线
- **Cost**: $10-30

### DIY Rubber Ducky
```
Digispark Attiny85 ($5) + Micro USB线 = 自制 HID 注入
编程: DigiKeyboard 库
Payload: 按键序列快速注入
```

### DIY Keylogger
- **Arduino Pro Mini** ($3) + SD卡模块 ($2) + 外壳
- **成本**: $10
- **功能**: PS/2/USB键盘记录, SD存储

### Portable Pi Labs
- **Raspberry Pi 4 + 屏幕模块 + 电池**
- **Kali Linux ARM 镜像**
- **成本**: $80-120
- **用途**: 移动渗透测试, 隐蔽部署

### Zero Trust Device
- **Pi Zero W + 外壳 + PoC攻击脚本**
- **预装**: Metasploit,Responder,Nmap,NC
- **成本**: $25

### ESP32-Based
- **ESP32-S3** ($10) + WiFi + 蓝牙
- **用途**: 恶意AP, BLE 监听, HID攻击
- **成本**: $15

### Custom Proxmark
- **Proxmark3 芯片 + 3D打印外壳**
- **固件**: Iceman Fork (最新功能)
- **成本**: $150

---

## Software Tools Pre-Installed

### On Every Device
```
├── /pentest/
│   ├── Nmap/
│   ├── Metasploit/
│   ├── Burp/
│   ├── John/
│   ├── Hashcat/
│   ├── SQLmap/
│   ├──Empire/
│   ├──Covenant/
│   └── CrackMapExec/
├── /wordlists/
│   ├── SecLists/
│   ├── RockYou2024/
│   └── Passwords/
├── /scripts/
│   ├── recon.sh
│   ├── enum.sh
│   └── privesc.sh
├── /loot/
│   ├── credentials/
│   ├── hashes/
│   ├── screenshots/
│   └── notes/
└── /tools/
    ├── LinPEAS/
    ├── WinPEAS/
    ├── PowerUp/
    └── Seatbelt/
```

---

## Vehicle Pentest Gear

### Key Cloning
| Tool | Price | Notes |
|------|-------|-------|
| **Xhorse VVDI2** | $500 | 多协议, 车辆钥匙生成 |
| **Autel IM608** | $800 | 专业级, 更多协议 |
| **T-Chip T800** | $300 | 基础车辆芯片 |

### RF Analysis
| Tool | Price | Notes |
|------|-------|-------|
| **HackRF + GNU Radio** | $350 | 信号分析, 重放攻击 |
| **SDR# + RTL-SDR** | $40 | 基础信号分析 |

---

## Industrial/ICS

### Hardware
| Tool | Price | Notes |
|------|-------|-------|
| **Conpot** | 软件 | 工控蜜罐 |
| **Plcscan** | $0 | PLC 发现 |
| **Mbtget** | $0 | Modbus 工具 |

---

## Recommended Bundles

### Home Lab Starter ($300)
```
1x Alfa AWUS036NHA ($45)
1x Alfa AWUS036ACH ($55)
1x Raspberry Pi 4 ($55)
1x Proxmark3 RDV4 ($180)
= $335
```

### Professional Kit ($1000)
```
1x WiFi Pineapple Nano ($200)
1x HackRF One ($300)
1x Proxmark3 RDV4 ($180)
1x Bash Bunny ($100)
1x Ubertooth One ($250)
= $1030
```

### Enterprise Grade ($3500+)
```
1x WiFi Pineapple Tetra ($400)
1x HackRF One ($300)
1x Proxmark3 RDV4 ($180)
1x Bash Bunny ($100)
1x Ubertooth One ($250)
1x Lan Turtle ($200)
1x CubicSDR ($400)
1x GrayKey ($4000)
= $5730
```

---

## Best Price/Performance

| Category | Best Value | Best Overall |
|----------|------------|--------------|
| WiFi Adapter | Alfa AWUS036NHA ($45) | Alfa AWUS036AX200 ($80) |
| RFID | ACR122U ($25) | Proxmark3 RDV4 ($180) |
| HID Attack | Digispark ($5) | USB Rubber Ducky ($45) |
| Network | Pi Zero W ($15) | Bash Bunny ($100) |
| SDR | RTL-SDR v4 ($30) | HackRF One ($300) |
| Vehicle | T5577 ($20) | Xhorse VVDI2 ($500) |

---

## Where to Buy

### Trusted Sources
- **Alfa Network** - 官方 store
- **Hak5 Shop** - 官方, 质量保证
- **Proxmark Shop** - RDV4 套件
- **Amazon** - 基础设备
- **AliExpress** - 便宜但风险
- **eBay** - 二手, 检查评价

### Avoid
- 过于便宜的 "proxmark3" - 假货
- 非授权 HackRF - 可能有硬件问题
- 未知来源 RFID 设备

---

## Maintenance

### Firmware Updates
- Proxmark3: Iceman Fork 最新
- WiFi Pineapple: 官方更新
- HackRF: Great Scott Gadgets 固件

### Calibration
- SDR: 定期校准
- Proxmark3: 校准线圈
- WiFi: 天线检查

## Glossary
- **HID** - Human Interface Device (键盘/鼠标)
- **SDR** - Software Defined Radio
- **RFID** - Radio Frequency Identification
- **NFC** - Near Field Communication
- **AP** - Access Point
- **PWN** - Own/Compromise
- **Ducky** - USB Rubber Ducky

---

# Hardware Arsenal Bible - EXPANDED

## NEW: Flipper Zero Ecosystem

### Core Device
| Device | Price | Notes |
|--------|-------|-------|
| **Flipper Zero** | $169 | 多协议 hacking 工具, 社区驱动 |
| **Flipper Zero + WiFi Devboard** | $200 | WiFi 扫描/攻击, MQTT |
| **Flipper Zero Case** | $20 | 保护壳, 战术外观 |

### Flipper Zero Capabilities
- **Sub-GHz**: 300-928MHz 接收/发送/重放
- **RFID**: 125kHz, 13.56MHz 读取/写入/模拟
- **NFC**: NTAG, MIFARE Classic/Ultralight, 手机模拟
- **IR**: 红外遥控学习/发送
- **BadUSB**: 键盘模拟, Ducky 脚本
- **GPIO**: 扩展接口, 传感器连接
- **WiFi Devboard**: WiFi 扫描, deauth, PMKID 捕获

### Flipper Zero Accessories
| Accessory | Price | Purpose |
|-----------|-------|---------|
| **WiFi Devboard** | $30 | WiFi 渗透, MQTT 桥接 |
| **NFC Proxy** | $25 | 门禁卡复制 |
| **Sub-GHz External Antenna** | $15 | 增强信号 |
| **Flipper SD Card 128GB** | $25 | 存储信号/固件 |
| **USB-C Extender** | $10 | 保护端口 |

### Flipper Zero Firmware/Resources
- **Official Firmware**: flipperzero.one
- **RogueMaster**: 社区分支, 更多功能
- **Unleashed**: 无锁定固件
- **Flipper RAW Scripts**: 430+ payloads (nullsec-flipper-suite)

---

## NEW: KodeDot Devices

### KodeDot Products
| Device | Price | Notes |
|--------|-------|-------|
| **KodeDot Dongle** | $99 | 多协议 RFID/NFC 写入 |
| **KodeDot Proxmark** | $180 | 改装 Proxmark3, 优化固件 |
| **KodeDot BT Keyboard** | $60 | 蓝牙键盘注入 |

---

## NEW: WiFi USB Cables & Antennas

### WiFi USB Cables (Long-Range)
| Device | Price | Specs | Notes |
|--------|-------|-------|-------|
| **Alfa RP-SMA to USB Cable 5m** | $20 | 延长线, 高增益天线 | 信号放大 |
| **USB WiFi Extender 10m** | $15 | Active USB 扩展 | 远距离渗透 |
| **Panda Wireless PAU09** | $35 | AC1200, 双频 | Linux 驱动完善 |
| **Comfast CF-912AC** | $25 | AC1200, 两天线 | 高性能 |
| **Netgear A6210** | $40 | AC1200, 强力 | 稳定 |

### High-Gain Antennas
| Device | Price | Specs | Notes |
|--------|-------|-------|-------|
| **Alfa 9dBi Panel** | $25 | 2.4GHz 定向 | 远距离连接 |
| **TP-Link 10dBi** | $15 | 全向 | 信号增强 |
| **Yagi-Uda 12dBi** | $30 | 定向 | 远距离点对点 |
| **Cantenna Kit** | $20 | 手动制作 | 定向 |

---

## NEW: Raspberry Pi Variants

### Pi Models for Pentest
| Model | Price | Specs | Use Case |
|-------|-------|-------|----------|
| **Pi Zero W** | $15 | 1GHz, 512MB, WiFi | 微型植入, HID |
| **Pi Zero 2 W** | $20 | 1GHz, 512MB, WiFi | 更强 Zero |
| **Pi 3 B+** | $40 | 1.4GHz, 1GB, WiFi/bt | 常规渗透 |
| **Pi 4 B 4GB** | $55 | 1.5GHz, 4GB, 快速 | 完整实验室 |
| **Pi 4 B 8GB** | $75 | 1.5GHz, 8GB | 高性能 |
| **Pi 5** | $80 | 2.4GHz, 8GB | 最新, 最强 |
| **Pi 400** | $100 | 内置键盘 | 便携桌面 |

### Pi Pentest Builds
| Build | Cost | Components |
|-------|------|------------|
| **Pi Kiosk** | $50 | Pi 3 + 7" 触摸屏 + 外壳 |
| **Pi Mesh Node** | $40 | Pi Zero W + 外接天线 |
| **Pi RFID Reader** | $35 | Pi Zero + PN532 |
| **Pi SDR Station** | $65 | Pi 4 + RTL-SDR + 天线 |
| **Pi Network Tap** | $45 | Pi 3 + 网络Hat |
| **Pi WASP** | $60 | Pi 4 + 无线网卡 + 外壳 |

### Pi Accessories
| Device | Price | Notes |
|--------|-------|-------|
| **Pi PoE Hat** | $25 | 网络供电 |
| **Pi 5 Active Cooler** | $15 | 散热 |
| **NVMe SSD Hat** | $40 | 快速存储 |
| **Touchscreen 7"** | $35 | 官方屏幕 |
| **PiCase** | $20 | 保护外壳 |
| **RTL-SDR v5** | $40 | 集成 SDR |

---

## NEW: ESP32 Ecosystem

### ESP32 Hacking Devices
| Device | Price | Features |
|--------|-------|----------|
| **ESP32-S3** | $10 | WiFi + BLE, USB OTG |
| **ESP32-C3** | $6 | RISC-V, WiFi + BLE |
| **ESP32-S2** | $8 | USB 主机 |
| **M5Stack Core2** | $35 | 屏幕 + 电池 |
| **M5Stick C Plus** | $20 | 小型, 带屏幕 |
| **LilyGo T-Deck** | $30 | 键盘 + 屏幕 |
| **LilyGo T-Watch** | $25 | 手表形态 |

### ESP32 Hacking Projects
- **Evil Portal**: 恶意 WiFi 热点
- **ESP32 Deauther**: WiFi 攻击
- **BLE Spam**: BLE 广告 spam
- **Keyboard Wedge**: HID 注入
- **WiFi Sniffer**: 数据包捕获

---

## NEW: Hak5 & Security Stuff

### Latest Hak5 Gear
| Device | Price | Notes |
|--------|-------|-------|
| **WiFi Pineapple Tetra** | $400 | 双频, 企业评估 |
| **WiFi Pineapple Nano** | $200 | 便携, Karma |
| **Bash Bunny Mark 2** | $100 | 快速 HID |
| **Packet Squirrel** | $60 | 网络捕获 |
| **Shark Jack** | $70 | 网络评估 |
| **Lan Turtle MKIV** | $200 | 远程访问 |
| **Cloud C2** | $50 | 命令控制 |
| **Screen Crab** | $80 | HDMI 捕获 |
| **Jackdaw** | $100 | USB 集线器 + 更多 |

---

## NEW: SDR Expansion

### SDR Devices
| Device | Price | Specs | Notes |
|--------|-------|-------|-------|
| **HackRF One** | $300 | 1MHz-6GHz | 最佳性价比 |
| **HackRF Portapack** | $150 | HackRF + 屏幕 | 独立操作 |
| **RTL-SDR v5** | $40 | 24-1766MHz | 入门最佳 |
| **SDRPlay RSP1A** | $180 | 1kHz-2GHz | 宽频 |
| **Airspy HF+** | $200 | 直流-31MHz + VHF | HF 专家 |
| **BladeRF xA4** | $420 | 47MHz-6GHz | 高性能 |
| **USRP B200** | $700 | 软件无线电 | 研究级 |
| **PlutoSDR** | $150 | 325MHz-3.8GHz | 入门级 USRP |

### SDR Accessories
| Device | Price | Notes |
|--------|-------|-------|
| **Log Periodic Antenna** | $30 | 宽频接收 |
| **Discone Antenna** | $25 | 全频段 |
| **Tuned Loop Antenna** | $20 | 低频 |
| **Bias T Adapter** | $15 | 供电天线 |
| **RF Filter** | $25 | 降噪 |

---

## NEW: Network Equipment

### Assessment Routers
| Device | Price | Notes |
|--------|-------|-------|
| **GL-iNet GL-MT3000** | $80 | WiFi 6, OpenWrt |
| **GL-iNet GL-S1300** | $60 | 三频 Mesh |
| **TP-Link EAP245** | $50 | 企业 AP |
| **Ubiquiti UniFi AP** | $60 | 企业 WiFi |
| **ASUS RT-AX88U** | $200 | WiFi 6, 梅林固件 |

### Network Tools
| Device | Price | Notes |
|--------|-------|-------|
| **USB Ethernet Adapter** | $15 | 多口 USB 网卡 |
| **Network Tap** | $40 | 流量镜像 |
| **PoE Injector** | $20 | 网络供电 |
| **USB Console Cable** | $10 | 串口控制 |

---

## NEW: Hardware Keyloggers & Implants

### Keyloggers
| Device | Price | Features |
|--------|-------|----------|
| **KeyGrabber PS/2** | $60 | PS/2 接口 |
| **KeyGrabber USB** | $80 | USB, 8MB |
| **KeyGrabber WiFi** | $120 | 无线传输 |
| **KeyCroak** | $100 | 远程, 存储 |
| **Mini Keylogger** | $25 | 隐藏式 |

### Hardware Implants
| Device | Price | Notes |
|--------|-------|-------|
| **O.MG Cable** | $150 | HID 注入, WiFi |
| **O.MG Elite** | $200 | 增强版 |
| **USB Ninja** | $80 | 隐藏 HID |
| **BadUSB Attack Stick** | $50 | 基础 HID |

---

## NEW: RFID/NFC Expansion

### Readers/Writers
| Device | Price | Notes |
|--------|-------|-------|
| **Proxmark3 RDV4** | $180 | 全协议, 金标 |
| **Proxmark3 Easy** | $90 | 简化版 |
| **ACR122U** | $25 | 基础 NFC |
| **ACR1252U** | $40 | NFC Forum |
| **T5577 Copier** | $20 | 125kHz 基础 |
| **CH341 USB Programmer** | $10 | 芯片编程 |

### RFID Cards/Tags
| Device | Price | Notes |
|--------|-------|-------|
| **MIFARE Classic 1K** | $0.50 | 常用门禁 |
| **NTAG215** | $0.30 | 贴纸 |
| **T5577 Cards** | $0.20 | 可写 |
| **ID卡白卡** | $0.10 | 批量 |

---

## NEW: Lock Picking Tools

### Pick Sets
| Set | Price | Notes |
|-----|-------|-------|
| **Southord PXS-05** | $40 | 专业入门 |
| **Multipick ELITE** | $200 | 德国精度 |
| **LockAid Complete** | $50 | 全套 |
| **Sparrow Tribute** | $80 | 入门 |

### Bypass Tools
| Tool | Price | Notes |
|------|-------|-------|
| **Bump Keys Set** | $15 | 撞锁 |
| **Shim Kit** | $20 | 弹子锁 |
| **Pick Guns** | $30 | 电动开锁 |
| **Decoders** | $40 | 圆筒锁 |

---

## NEW: Mobile Forensics

### iOS/Android
| Device | Price | Notes |
|--------|-------|-------|
| **GrayKey** | $4000 | iOS 越狱 |
| **Cellebrite UFED** | $10000 | 法医标准 |
| **Oxygen Forensic** | $5000 | 全平台 |
| **MSAB XRY** | $6000 | 法医工具 |
| **Magnet AXIOM** | $5000 | 软件 |

### Android Tools
| Tool | Price | Notes |
|------|-------|-------|
| **Magisk** | 免费 | ROOT |
| **SP Flash Tool** | 免费 | 刷机 |
| **Odin (Samsung)** | 免费 | 韩国机器 |

---

## NEW: Vehicle Pentest

### RF Tools
| Device | Price | Notes |
|--------|-------|-------|
| **HackRF One** | $300 | 信号分析 |
| **Proxmark3** | $180 | 钥匙克隆 |
| **Ubertooth** | $250 | BT 分析 |
| **Sdrtrunk** | 免费 | 数字解调 |

### Key Tools
| Device | Price | Notes |
|--------|-------|-------|
| **Xhorse VVDI2** | $500 | 多协议 |
| **Autel IM608** | $800 | 专业 |
| **T800 Chip** | $300 | 基础 |
| **T5577 Writer** | $20 | 简单复制 |

---

## NEW: Thermal Printers (Receipt/Evidence)

### For Pentesters
| Device | Price | Notes |
|--------|-------|-------|
| **MST3 Thermal Printer** | $40 | 小票打印 |
| **Epson TM-T88** | $150 | 专业收据 |
| **Portable Thermal** | $30 | 移动打印 |

### Use Cases
- 打印密码/凭证
- 收据伪造
- 物理取证标签
- 隐蔽笔记

---

## NEW: Audio/Voice

### Recording
| Device | Price | Notes |
|--------|-------|-------|
| **Zoom H1n** | $80 | 录音笔 |
| **Parabolic Mic** | $50 | 远距离听 |
| **USB Audio Adapter** | $15 | 电脑录音 |
| **Baofeng UV-5R** | $30 | 无线电 |

### Spoofing
| Device | Price | Notes |
|--------|-------|-------|
| **Call Intercept** | 免费 | 软件 |
| **Voice Changer** | $25 | 变声 |
- 

---

## NEW: Complete Bundle Recommendations

### Budget Starter ($150)
```
1x Flipper Zero ($169)
1x Alfa AWUS036NHA ($45)
1x Pi Zero W ($15)
= $229 (exceeds budget, adjust)
```

### Hacker Kit v2 ($500)
```
1x Flipper Zero ($169)
1x Alfa AWUS036ACH ($55)
1x HackRF One ($300)
1x Proxmark3 Easy ($90)
= $614
```

### Mobile Assessment ($2000)
```
1x Flipper Zero ($169)
1x WiFi Pineapple Nano ($200)
1x Proxmark3 RDV4 ($180)
1x Ubertooth One ($250)
1x HackRF One ($300)
1x Laptop + Tools
= ~$2000
```

### Full Arsenal ($5000+)
```
1x WiFi Pineapple Tetra ($400)
1x Flipper Zero + WiFi Devboard ($200)
1x HackRF One + Portapack ($450)
1x Proxmark3 RDV4 ($180)
1x Bash Bunny Mark 2 ($100)
1x Ubertooth One ($250)
1x Lan Turtle ($200)
1x BladeRF xA4 ($420)
1x GrayKey ($4000)
= ~$5800
```

---

## NEW: Shopping Sources

### Official Stores
- **hak5.shop** - Hak5 官方
- **flipperzero.one/store** - Flipper 官方
- **proxmark.com** - Proxmark 官方
- **Alfa Network** - WiFi 天线
- **GL-iNet** - 便携路由器

### Import/Alternative
- **AliExpress** - 便宜, 风险
- **Amazon** - 快速, 有保障
- **eBay** - 二手, 检查
- **Banggood** - 中国发货
- **Tindie** - 极客硬件

### Avoid
- 过于便宜的 Proxmark (假货)
- 假的 HackRF
- 非官方 Flipper 克隆
- 来路不明的 RFID 写入器

---

## NEW: Firmware/Maintenance

### Update Sources
- Flipper: 官方固件 + RogueMaster
- Proxmark: Iceman Fork
- HackRF: Great Scott Gadgets
- Ubertooth: LibreUbertooth
- WiFi Pineapple: 官方更新

### Calibration
- 定期: SDR 校准
- Proxmark: 线圈检查
- WiFi: 天线检查
- 电池: 保持充电

---

## NEW: Glossary Expansion
- **PMKID** - WPA2 密钥捕获
- **Karma** - 恶意热点攻击
- **Deauth** - 解除认证攻击
- **Evil Twin** - 邪恶双胞胎AP
- **RFID** - 射频识别
- **NFC** - 近场通信
- **Sub-GHz** - 低于1GHz射频
- **SDR** - 软件定义无线电
- **Ducky** - Rubber Ducky
- **HID** - 人机接口设备

(End of file - total lines)