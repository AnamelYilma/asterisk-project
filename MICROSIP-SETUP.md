# 📱 MicroSIP Configuration Guide

## Based on Your Asterisk Project Settings

---

## 🔍 Your Available Extensions

From your `pjsip.conf`, you have:

| Extension | Username | Password | Description |
|-----------|----------|----------|-------------|
| **1001** | 1001 | pass1001 | First phone |
| **1002** | 1002 | pass1002 | Second phone |

---

## 📋 MicroSIP Settings - Extension 1001

### Scenario 1: MicroSIP on SAME PC as Asterisk ✅

**This is most common if you're testing on your laptop/desktop.**

```
╔══════════════════════════════════════════╗
║         ACCOUNT SETTINGS                 ║
╚══════════════════════════════════════════╝

Account Name:    Asterisk 1001
                 (or any name you like)

─────────────────────────────────────────────

SIP Server:      localhost
                 (or 127.0.0.1)

SIP Proxy:       [Leave Empty]

Username:        1001

Domain:          localhost
                 (same as SIP Server)

Login:           1001
                 (same as Username)

Password:        pass1001

─────────────────────────────────────────────

☑ Register
☐ Publish presence
☐ Single account mode
```

---

### Scenario 2: MicroSIP on DIFFERENT PC ⚠️

**If MicroSIP is on another computer in your network.**

**FIRST, find your Asterisk server IP:**

```powershell
# On the PC running Docker/Asterisk, run:
ipconfig

# Look for: IPv4 Address. . . . : 192.168.x.x
# Example: 192.168.1.7
```

**THEN configure MicroSIP:**

```
╔══════════════════════════════════════════╗
║         ACCOUNT SETTINGS                 ║
╚══════════════════════════════════════════╝

Account Name:    Asterisk 1001

─────────────────────────────────────────────

SIP Server:      192.168.1.7
                 ⬆️ YOUR ASTERISK PC IP!

SIP Proxy:       [Leave Empty]

Username:        1001

Domain:          192.168.1.7
                 ⬆️ SAME AS SIP SERVER!

Login:           1001

Password:        pass1001

─────────────────────────────────────────────

☑ Register
☐ Publish presence
☐ Single account mode
```

---

## 🔧 Network Settings Tab

```
╔══════════════════════════════════════════╗
║         NETWORK SETTINGS                 ║
╚══════════════════════════════════════════╝

Transport:       UDP
                 (not TCP or TLS)

Port:            5060
                 (standard SIP port)

☑ Use random port
☐ Keep alive
☐ Rewrite Contact IP

Local IP:        [Auto]

Public IP:       [Leave Empty]
```

---

## 🔊 Audio Settings Tab

```
╔══════════════════════════════════════════╗
║         AUDIO SETTINGS                   ║
╚══════════════════════════════════════════╝

Audio Codecs (in order):
  1. ✅ PCMU (G.711u)      ← MUST BE ENABLED!
  2. ❌ PCMA (disable)
  3. ❌ G.722 (disable)
  4. ❌ Others (disable)

Your Asterisk is configured for: ulaw (PCMU)
Only enable PCMU codec!

─────────────────────────────────────────────

Microphone:      [Your microphone]
Speakers:        [Your speakers]
Ringing:         [Your speakers]

☑ Echo cancellation
☑ Noise suppression
☐ Voice activity detection
```

---

## 📞 Extension 1002 Settings

If you want to configure a second MicroSIP instance (or on another PC):

```
Account Name:    Asterisk 1002
SIP Server:      localhost (or 192.168.1.7)
Username:        1002
Password:        pass1002
Domain:          localhost (or 192.168.1.7)
Login:           1002
Port:            5060
Transport:       UDP
Codec:           PCMU
```

---

## ✅ After Configuration

### Step 1: Click "OK" to save

### Step 2: Check Status

**MicroSIP shows status at bottom:**

```
✅ Green icon = Registered successfully!
❌ Red icon = Not registered (check settings)
⚠️ Yellow icon = Trying to register...
```

### Step 3: Test Connection

**In Asterisk CLI:**
```powershell
docker exec -it my-asterisk asterisk -rx "pjsip show endpoints"
```

**You should see:**
```
Endpoint:  1001/1001    Available    0 of inf
           ↑            ↑
         Your ext    Status (good!)
```

---

## 🧪 Test Calls

### Test 1: Echo Test
1. In MicroSIP, dial: **999**
2. You should hear: "The echo test has begun"
3. Speak and hear yourself back
4. Press **#** to hang up

**If this works:** ✅ Audio is working!

---

### Test 2: Call Another Extension

**If you have 2 MicroSIP instances (1001 and 1002):**

1. From 1001, dial: **1002**
2. The 1002 phone should ring
3. Answer and talk

**If this works:** ✅ Everything is perfect!

---

## 🔍 Troubleshooting

### Problem: Red Icon (Not Registered)

**Check:**
1. Is Asterisk running? `docker ps`
2. Is SIP Server correct?
   - Same PC: use `localhost`
   - Different PC: use IP (192.168.x.x)
3. Is password correct? `pass1001` (all lowercase)
4. Is firewall blocking? Check Windows Firewall

---

### Problem: Registers but No Audio

**Check:**
1. Is PCMU codec enabled? (Must be!)
2. Are RTP ports open? (10000-10099)
3. Check Asterisk logs:
   ```powershell
   docker logs my-asterisk --tail 50
   ```

---

### Problem: "407 Proxy Authentication Required"

**This means:**
- Username or password is wrong

**Fix:**
- Double-check: Username = `1001`, Password = `pass1001`
- Make sure Login field also says `1001`

---

### Problem: "408 Request Timeout"

**This means:**
- Can't reach Asterisk server

**Fix:**
1. Check if Docker is running: `docker ps`
2. Check IP address is correct
3. Ping the server: `ping 192.168.1.7`

---

## 📱 Multiple Accounts (Advanced)

You can run multiple MicroSIP instances for testing:

**Method 1: Multiple Windows**
```powershell
# Run second instance
"C:\Program Files\MicroSIP\microsip.exe" /account:1002
```

**Method 2: Use Different Softphones**
- Extension 1001 → MicroSIP (on PC)
- Extension 1002 → Zoiper (on mobile)

---

## 🎯 Quick Reference Card

**Print this and keep it handy:**

```
═══════════════════════════════════════════
    MY ASTERISK EXTENSIONS
═══════════════════════════════════════════

Extension 1001
──────────────
Server:   localhost (or your PC IP)
Username: 1001
Password: pass1001
Port:     5060
Codec:    PCMU

Extension 1002
──────────────
Server:   localhost (or your PC IP)
Username: 1002
Password: pass1002
Port:     5060
Codec:    PCMU

Test Numbers
────────────
999  - Echo test
9999 - Echo test (alt)
1001 - Call extension 1001
1002 - Call extension 1002

═══════════════════════════════════════════
```

---

## 💾 Export/Import Settings

### Export Configuration (Backup)
1. MicroSIP → Menu → Settings
2. Export settings to file
3. Save as: `microsip-1001.xml`

### Import Configuration (Restore)
1. MicroSIP → Menu → Settings
2. Import settings from file

---

## ✅ Success Checklist

```
☐ Downloaded and installed MicroSIP
☐ Added account with correct settings
☐ Checked codec is PCMU only
☐ Verified green icon (registered)
☐ Tested echo (dial 999)
☐ Tested call to other extension
☐ Audio works both ways
☐ Can hang up calls
☐ Saved configuration backup
```

---

**Now you're ready to use MicroSIP with your Asterisk system!** 🎉
