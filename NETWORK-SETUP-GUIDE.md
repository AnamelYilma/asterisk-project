# 🌐 NETWORK SETUP GUIDE
## What to Change When You Switch WiFi/Network

---

## 📍 **STEP 1: FIND YOUR NEW PC IP ADDRESS**

### Every time you change network, your PC gets a NEW IP address!

**How to find it:**

```powershell
# In PowerShell, run:
ipconfig

# Look for "Ethernet adapter" (if wired) or "Wireless adapter" (if WiFi)
```

**Example output:**
```
Ethernet adapter Ethernet:
   IPv4 Address. . . . : 192.168.1.7    ← THIS IS YOUR PC IP!
```

**Write it down:** `192.168.1.___`

---

## 🔧 **STEP 2: FILES YOU NEED TO CHANGE IN ASTERISK**

### ❌ **GOOD NEWS: Usually NOTHING!**

**Your Asterisk config files DON'T need IP changes!**

**Why?** Because they listen on `0.0.0.0` (all interfaces)

**Files that are already correct:**

### ✅ `pjsip.conf` - Already Correct!
```conf
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060    ← This means "listen on ALL IPs" - PERFECT!
```

**No change needed!** ✅

### ✅ `extensions.conf` - Already Correct!
```conf
[default]
exten => 1001,1,Answer()
exten => 1001,n,Dial(PJSIP/1002,20)

exten => 1002,1,Answer()
exten => 1002,n,Dial(PJSIP/1001,20)
```

**No IP addresses here! No change needed!** ✅

---

## 📱 **STEP 3: PHONE CONFIGURATION - THIS NEEDS CHANGING!**

### ⚠️ **THIS IS WHERE YOU MUST CHANGE THE IP!**

### **Phone 1 (MicroSIP on PC) - Extension 1001**

If MicroSIP is on the SAME PC as Asterisk:

| Field | Value | Notes |
|-------|-------|-------|
| **Account Name** | `1001` | Just a label |
| **SIP Server** | `127.0.0.1` OR `localhost` | ✅ Never changes! |
| **Username** | `1001` | From pjsip.conf |
| **Password** | `pass1001` | From pjsip.conf |
| **Port** | `5060` | Standard SIP port |
| **Transport** | `UDP` | Must be UDP |

**No change needed when WiFi changes!** Because `localhost` always means "this computer"

---

### **Phone 2 (Mobile/Other Device) - Extension 1002**

If phone is on DIFFERENT device (your mobile):

| Field | Value | Notes |
|-------|-------|-------|
| **Account Name** | `1002` | Just a label |
| **SIP Server** | `192.168.1.7` | ⚠️ **CHANGE THIS!** |
| **Username** | `1002` | From pjsip.conf |
| **Password** | `pass1002` | From pjsip.conf |
| **Port** | `5060` | Standard SIP port |
| **Transport** | `UDP` | Must be UDP |

### 🚨 **WHEN WIFI CHANGES:**
1. Run `ipconfig` on PC
2. Find new IP (e.g., `192.168.5.100`)
3. Update **SIP Server** field in phone to new IP
4. Save and reconnect

---

## 📋 **QUICK REFERENCE TABLE**

### What Changes When Network Changes?

| Location | File/App | What to Change | Why |
|----------|----------|----------------|-----|
| **Asterisk Server** | `pjsip.conf` | ❌ Nothing | Already set to `0.0.0.0` |
| **Asterisk Server** | `extensions.conf` | ❌ Nothing | No IPs in dialplan |
| **Asterisk Server** | `rtp.conf` | ❌ Nothing | Already correct |
| **PC Phone** | MicroSIP (1001) | ❌ Nothing | Uses `localhost` |
| **Mobile Phone** | Softphone (1002) | ✅ **Update Server IP!** | Needs PC's new IP |
| **Other Devices** | Any external phone | ✅ **Update Server IP!** | Needs PC's new IP |

---

## 🎯 **COMPLETE WORKFLOW - When You Change WiFi**

### **Scenario: You Move to Different Network**

```
Old Network: 192.168.1.x
New Network: 192.168.5.x
```

### **Step-by-Step:**

#### 1️⃣ **Find Your New PC IP**
```powershell
ipconfig
# New IP: 192.168.5.100 (example)
```

#### 2️⃣ **Check Asterisk Files (Usually No Change Needed!)**
```powershell
# Just restart container to be safe
docker restart my-asterisk
```

#### 3️⃣ **Update ONLY External Phones**

**On your mobile phone softphone, change:**
```
OLD: Server: 192.168.1.7
NEW: Server: 192.168.5.100  ← Your new PC IP
```

#### 4️⃣ **Verify Connection**
```powershell
# In Asterisk CLI:
docker exec -it my-asterisk asterisk -rvvv

*CLI> pjsip show endpoints

# Should show "Available" for registered phones
```

---

## 🏠 **DIFFERENT NETWORK SCENARIOS**

### **Scenario A: Home Network (Most Common)**

```
[Your Router: 192.168.1.1]
    ├── PC (Wired): 192.168.1.7
    └── Phone (WiFi): 192.168.1.50

Phone Config:
  Server: 192.168.1.7  ← PC's IP
```

---

### **Scenario B: Office Network**

```
[Office Router: 10.0.0.1]
    ├── PC (Wired): 10.0.0.15
    └── Phone (WiFi): 10.0.0.82

Phone Config:
  Server: 10.0.0.15  ← PC's new IP
```

---

### **Scenario C: Hotel/Public WiFi (Both on WiFi)**

```
[Hotel WiFi: 172.16.0.1]
    ├── PC (WiFi): 172.16.0.200
    └── Phone (WiFi): 172.16.0.201

Phone Config:
  Server: 172.16.0.200  ← PC's IP
  
⚠️ Note: Some hotels block device-to-device communication!
```

---

### **Scenario D: Mobile Hotspot (Emergency)**

```
[Phone Hotspot: 192.168.43.1]
    └── PC (WiFi): 192.168.43.100
    
In this case:
  - MicroSIP on PC can only call itself (localhost)
  - Can't connect external phones
  - Useful for testing only
```

---

## 🔍 **TROUBLESHOOTING - By Symptoms**

### **Problem: Phone Says "Registration Failed"**

**Checklist:**

```
□ Did you use correct IP? (Run ipconfig)
□ Is PC and phone on same network? (First 3 numbers match?)
□ Is Asterisk running? (docker ps)
□ Is firewall blocking? (Check Windows Firewall)
□ Is password correct? (Check pjsip.conf)
```

**Debug commands:**
```powershell
# 1. Check if Asterisk is listening
docker exec -it my-asterisk asterisk -rx "pjsip show transports"

# 2. See registration attempts
docker exec -it my-asterisk asterisk -rx "pjsip set logger on"
# Then try to register phone and watch output
```

---

### **Problem: Can't Reach Asterisk from Phone**

**Test connectivity:**
```powershell
# From PC, find your IP
ipconfig
# Example: 192.168.1.7

# From phone's browser, visit:
http://192.168.1.7:8088
```

**If browser can't connect:**
- ❌ Firewall is blocking
- ❌ Wrong IP address
- ❌ Different network

**If browser shows Asterisk page:**
- ✅ Network is fine
- Problem is in phone SIP config

---

### **Problem: Phones Register but No Audio**

**This is RTP port issue!**

```powershell
# Check if RTP ports are open
docker exec -it my-asterisk asterisk -rx "rtp show settings"

# Allow RTP in firewall
netsh advfirewall firewall add rule name="Asterisk RTP" dir=in action=allow protocol=UDP localport=10000-10099
```

---

## 📝 **CONFIGURATION TEMPLATE - Save This!**

### **When You Setup New Phone:**

```
═══════════════════════════════════════
ASTERISK CONNECTION DETAILS
═══════════════════════════════════════

Last Updated: _______________
Current Network: _______________

┌─────────────────────────────────────┐
│ ASTERISK SERVER INFO                │
└─────────────────────────────────────┘
PC IP Address: 192.168.___.___
SIP Port: 5060 (UDP)
RTP Ports: 10000-10099 (UDP)

┌─────────────────────────────────────┐
│ EXTENSION 1001 (PC/MicroSIP)        │
└─────────────────────────────────────┘
Server: localhost
Username: 1001
Password: pass1001
Port: 5060
Transport: UDP

┌─────────────────────────────────────┐
│ EXTENSION 1002 (Mobile/External)    │
└─────────────────────────────────────┘
Server: 192.168.___.___  ← UPDATE THIS!
Username: 1002
Password: pass1002
Port: 5060
Transport: UDP

═══════════════════════════════════════
```

---

## 🚀 **QUICK SETUP COMMANDS**

### **Copy-Paste This When You Change Network:**

```powershell
# 1. Find your new IP
Write-Host "Your new PC IP address is:" -ForegroundColor Green
(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"}).IPAddress | Select-Object -First 1

# 2. Restart Asterisk
docker restart my-asterisk

# 3. Wait for startup
Start-Sleep -Seconds 5

# 4. Check endpoints
docker exec -it my-asterisk asterisk -rx "pjsip show endpoints"

Write-Host "`nUpdate your external phones with the IP shown above!" -ForegroundColor Yellow
```

---

## 💡 **PRO TIPS**

### **Tip 1: Set Static IP (Recommended!)**

Instead of changing config every time, make your PC IP PERMANENT:

1. Open Network Settings
2. Right-click network adapter → Properties
3. IPv4 Properties → Use the following IP:
   - IP: `192.168.1.7`
   - Subnet: `255.255.255.0`
   - Gateway: `192.168.1.1`
   - DNS: `8.8.8.8`

**Now your IP NEVER changes!** ✅

---

### **Tip 2: Use Local Domain Name**

Add entry to `C:\Windows\System32\drivers\etc\hosts`:
```
192.168.1.7    asterisk.local
```

Then in phones, use:
```
Server: asterisk.local
```

**Benefit:** Only change hosts file when IP changes!

---

### **Tip 3: Create Network Profile**

Save different network configs for each location:

**File: `network-profiles.txt`**
```
═════════════════════════════════
HOME NETWORK
═════════════════════════════════
PC IP: 192.168.1.7
Phone Server: 192.168.1.7

═════════════════════════════════
OFFICE NETWORK
═════════════════════════════════
PC IP: 10.0.0.15
Phone Server: 10.0.0.15

═════════════════════════════════
COFFEE SHOP
═════════════════════════════════
PC IP: 172.16.5.100
Phone Server: 172.16.5.100
```

---

## ✅ **SUMMARY CHECKLIST**

```
When Network Changes:

□ Find new PC IP (ipconfig)
□ Restart Asterisk (docker restart my-asterisk)
□ Update external phone configs (Server IP field)
□ Test with echo test (dial 999)
□ Test calls between extensions
□ Check firewall if issues
□ Write down new IP in this file!
```

---

## 📞 **SUPPORT - Self-Debug Commands**

```powershell
# Full diagnostic
Write-Host "=== ASTERISK DIAGNOSTICS ===" -ForegroundColor Cyan

Write-Host "`n1. Your PC IP:" -ForegroundColor Yellow
ipconfig | Select-String "IPv4"

Write-Host "`n2. Container Status:" -ForegroundColor Yellow
docker ps | Select-String "asterisk"

Write-Host "`n3. Asterisk Endpoints:" -ForegroundColor Yellow
docker exec -it my-asterisk asterisk -rx "pjsip show endpoints"

Write-Host "`n4. Active Calls:" -ForegroundColor Yellow
docker exec -it my-asterisk asterisk -rx "core show channels"

Write-Host "`n=== END DIAGNOSTICS ===" -ForegroundColor Cyan
```

Save this as `check-asterisk.ps1` and run when troubleshooting!

---

**Remember: Most of the time, you only need to change the IP in your external phone app! Asterisk configs rarely need changes.** ✅
