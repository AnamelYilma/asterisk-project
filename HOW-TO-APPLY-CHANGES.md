# 🔄 HOW TO APPLY CONFIG CHANGES

## Quick Answer: After editing ANY config file, run this:

```powershell
docker restart my-asterisk
```

---

## Simple 3-Step Process

### 1️⃣ Edit your file
- Open file in Notepad, VS Code, or any editor
- Make your changes
- **SAVE THE FILE** (Ctrl+S)

### 2️⃣ Apply changes
```powershell
# Simple way (always works):
docker restart my-asterisk

# OR use the helper script:
.\apply-changes.ps1
```

### 3️⃣ Test
- Register your phone
- Make a test call
- Check if changes work

---

## Helper Script Usage

I created `apply-changes.ps1` for you!

### Basic Usage:
```powershell
# Restart everything (default)
.\apply-changes.ps1

# Reload only PJSIP (faster, for pjsip.conf changes)
.\apply-changes.ps1 -Action pjsip

# Reload only dialplan (faster, for extensions.conf changes)
.\apply-changes.ps1 -Action dialplan

# Reload only voicemail (faster, for voicemail.conf changes)
.\apply-changes.ps1 -Action voicemail

# Reload all modules without restart
.\apply-changes.ps1 -Action all
```

---

## What Files Need What Action?

| File Changed | Simple Method | Fast Method |
|--------------|---------------|-------------|
| `pjsip.conf` | `docker restart my-asterisk` | `.\apply-changes.ps1 -Action pjsip` |
| `extensions.conf` | `docker restart my-asterisk` | `.\apply-changes.ps1 -Action dialplan` |
| `voicemail.conf` | `docker restart my-asterisk` | `.\apply-changes.ps1 -Action voicemail` |
| `rtp.conf` | `docker restart my-asterisk` | Must restart! |
| Multiple files | `docker restart my-asterisk` | `.\apply-changes.ps1` |

---

## Important Notes

### ✅ DO:
- Always SAVE your file before restarting
- Wait 3-5 seconds after restart before testing
- Check logs if something doesn't work

### ❌ DON'T:
- Edit files INSIDE the container
- Forget to save (Ctrl+S)
- Panic if restart takes a few seconds

---

## Troubleshooting

### Changes not working?
1. Did you save the file? (Check LastWriteTime)
2. Did you restart Asterisk?
3. Check for syntax errors in logs

### Check logs:
```powershell
docker logs my-asterisk --tail 50
```

### Verify changes applied:
```powershell
# Check endpoints
docker exec -it my-asterisk asterisk -rx "pjsip show endpoints"

# Check dialplan
docker exec -it my-asterisk asterisk -rx "dialplan show"
```

---

## Complete Example

### Scenario: Add extension 1003

**Step 1:** Edit `pjsip.conf`
```conf
[1003]
type=endpoint
aors=1003
auth=1003
context=default
allow=ulaw

[1003]
type=aor
max_contacts=1

[1003]
type=auth
username=1003
password=pass1003
```

**Step 2:** Save file (Ctrl+S)

**Step 3:** Apply changes
```powershell
.\apply-changes.ps1 -Action pjsip
```

**Step 4:** Test
- Register phone with extension 1003
- Call from 1001 to 1003

---

## Quick Commands Reference

```powershell
# Restart container
docker restart my-asterisk

# Check if running
docker ps

# View logs
docker logs my-asterisk

# Check endpoints
docker exec -it my-asterisk asterisk -rx "pjsip show endpoints"

# Enter Asterisk CLI
docker exec -it my-asterisk asterisk -rvvv
```

---

**Remember:** After editing ANY config file, you MUST restart or reload Asterisk for changes to take effect!
