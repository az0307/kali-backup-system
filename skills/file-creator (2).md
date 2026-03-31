---
name: file-creator
description: >
  File creation and management expert. Use for: creating files, scripts, configs,
  writing documentation, generating code templates, editing files, batch operations,
  file organization, templates.
compatibility:
  tools: [bash, python, nano, vim, echo, cat, tee, sed, awk]
  os: [linux, windows, macos]
---

# File Creator

## Quick Commands

### Create File
```bash
touch filename
echo "content" > file
cat > file << 'EOF'
content here
EOF
```

### Edit File
```bash
nano file
vim file
sed -i 's/old/new/g' file
```

### Batch Create
```bash
for i in {1..10}; do touch file_$i.txt; done
```

---

## Create What You Need

Tell me what file to create and I'll make it!
