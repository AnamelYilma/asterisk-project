# 🚀 Complete Asterisk VoIP Project - Help Request

## 📋 Current Situation

I'm working on an Asterisk VoIP project with Docker and need help with:
1. **Project structure** - How to organize PJSIP, extensions, RTP configuration files
2. **Docker setup** - How to create a proper Dockerfile and run Asterisk in container
3. **MicroSIP connection issue** - Getting "Request Timeout" error instead of successful registration

---

## 🎯 What I Need Help With

### Part 1: Project File Structure
**Please review and guide me on how to properly organize:**

**My current config files:**
- `pjsip.conf` - SIP endpoint configuration (users 1001, 1002)
- `extensions.conf` - Dialplan with echo test (999) and internal calling (1001, 1002)
- `rtp.conf` - RTP port configuration (10000-10099)
- Other files: `asterisk.conf`, `modules.conf`, `logger.conf`, `voicemail.conf`

**Questions:**
- Is my file structure correct?
- Are my PJSIP settings properly configured for Docker networking?
- Do I need any additional configuration files?

### Part 2: Docker Setup
**I need a complete Docker setup including:**

1. **Dockerfile** - How to:
   - Use the correct Asterisk base image
   - Copy my configuration files to the right locations
   - Expose necessary ports (5060 for SIP, 10000-10099 for RTP)
   - Set proper permissions and entrypoint

2. **Docker Run Command** - How to:
   - Run the container with network settings
   - Mount configuration volumes
   - Enable proper networking mode (bridge vs host)
   - Map ports correctly

3. **Docker Compose** (optional but preferred) - Complete setup with:
   - Service definition
   - Volume mappings
   - Port configurations
   - Network settings

### Part 3: Current Problem - "Request Timeout"
**MicroSIP shows "Request Timeout" instead of registering successfully**

**My environment:**
- Asterisk running in Docker container
- MicroSIP client on Windows (same PC as Docker host)
- Local network: 192.168.1.x

**My PJSIP configuration highlights:**
```
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060
local_net=172.17.0.0/16    # Docker network
local_net=192.168.1.0/24   # Local network
external_media_address=192.168.1.5
external_signaling_address=192.168.1.5

[1001]
type=endpoint
context=default
disallow=all
allow=ulaw
auth=auth1001
aors=aor1001
direct_media=no
force_rport=yes
rewrite_contact=yes
rtp_symmetric=yes
```

**My MicroSIP settings:**
- SIP Server: localhost (also tried 127.0.0.1 and 192.168.1.5)
- Username: 1001
- Password: pass1001
- Domain: localhost
- Port: 5060
- Transport: UDP
- Codec: PCMU enabled

**What I've tried:**
- Different server addresses (localhost, 127.0.0.1, 192.168.1.5)
- Checked Docker container is running: `docker ps`
- Checked firewall settings
- Verified configuration files are loaded

**Error symptoms:**
- MicroSIP shows "Request Timeout" 
- Cannot see registration in Asterisk CLI: `pjsip show endpoints`
- Container logs don't show registration attempts

---

## 📦 Required Deliverables

### 1. Complete Docker Setup

**Please provide:**

#### A) Dockerfile
```dockerfile
# Complete Dockerfile with:
# - Base image selection
# - Configuration file copying
# - Port exposure
# - Proper entrypoint
```

#### B) Docker Run Command
```bash
# Complete docker run command with all necessary flags
```

#### C) Docker Compose (YAML)
```yaml
# Complete docker-compose.yml file
```

### 2. Network Troubleshooting Plan

**Please provide step-by-step diagnosis:**

1. **Verify Docker is running correctly**
   - How to check container status
   - How to verify ports are exposed
   - How to test network connectivity

2. **Verify Asterisk is listening**
   - Commands to check if Asterisk is accepting connections on port 5060
   - How to view active transports
   - How to check if PJSIP module is loaded

3. **Verify MicroSIP can reach Asterisk**
   - Network connectivity tests (ping, telnet, etc.)
   - Packet capture commands if needed
   - Firewall verification steps

4. **Common fixes for "Request Timeout"**
   - Docker networking mode (bridge vs host)
   - Port mapping issues
   - NAT/firewall problems
   - PJSIP configuration errors

### 3. Configuration Validation

**Please review my configurations and tell me:**

- **PJSIP.conf issues:**
  - Are my bind/local_net/external addresses correct for Docker?
  - Should I use different settings when MicroSIP is on the same host?
  - Are endpoint settings optimal?

- **RTP.conf issues:**
  - Is port range 10000-10099 sufficient?
  - Do I need additional RTP settings?

- **Extensions.conf issues:**
  - Is my dialplan correct for basic calling?
  - Any improvements needed?

### 4. Testing & Verification Commands

**Please provide commands to:**

1. Verify Asterisk is running in Docker:
   ```bash
   # Commands here
   ```

2. Check if ports are open and listening:
   ```bash
   # Commands here
   ```

3. View Asterisk logs for registration attempts:
   ```bash
   # Commands here
   ```

4. Access Asterisk CLI from Docker:
   ```bash
   # Commands here
   ```

5. Check PJSIP endpoints and registrations:
   ```bash
   # Commands here
   ```

---

## 🔧 My Current Project Structure

```
asterisk-project/
├── config/
│   ├── asterisk.conf
│   ├── extensions.conf       # Dialplan: echo (999), calling (1001, 1002)
│   ├── logger.conf
│   ├── modules.conf
│   ├── pjsip.conf            # SIP users: 1001, 1002
│   ├── rtp.conf              # Ports: 10000-10099
│   ├── stasis.conf
│   └── voicemail.conf
├── Dockerfile                # MISSING - need help creating
├── docker-compose.yml        # MISSING - need help creating
└── [various documentation files]
```

---

## 🎯 Expected Outcome

After your help, I should be able to:

1. ✅ Build a Docker image with my Asterisk configuration
2. ✅ Run Asterisk container with proper networking
3. ✅ Connect MicroSIP successfully (see green "Registered" status)
4. ✅ Make test calls to echo (999)
5. ✅ Make calls between extensions (1001 ↔ 1002)
6. ✅ Understand how to troubleshoot future networking issues

---

## 💡 Additional Context

**My environment:**
- Operating System: Windows
- Docker: Running on Windows
- Network: Home network with 192.168.1.x subnet
- Asterisk version: Latest stable (or specify your version)
- MicroSIP: Latest version on same Windows PC

**My skill level:**
- Basic understanding of Docker
- Basic understanding of VoIP/SIP concepts
- Comfortable with command line
- Need clear step-by-step instructions

---

## 🚨 Priority Order

1. **HIGHEST PRIORITY:** Fix "Request Timeout" issue - I need MicroSIP to register
2. **HIGH PRIORITY:** Provide working Dockerfile and docker-compose.yml
3. **MEDIUM PRIORITY:** Validate my configuration files (pjsip, extensions, rtp)
4. **LOW PRIORITY:** Optimization and best practices

---

## 📝 Response Format I Prefer

Please structure your response as:

### 1. Docker Setup (Complete Files)
- Dockerfile (ready to use)
- docker-compose.yml (ready to use)
- Build and run commands

### 2. Quick Fix for Request Timeout
- Most likely cause
- Immediate steps to fix
- Verification steps

### 3. Configuration Review
- Issues found in my configs
- Recommended changes
- Explanation of why

### 4. Testing Guide
- Step-by-step commands
- Expected outputs
- What to look for

### 5. Troubleshooting Playbook
- Common issues and solutions
- Diagnostic commands
- Log interpretation

---

## ❓ Specific Questions

1. Should I use `--network host` or bridge mode for Docker when MicroSIP is on the same PC?

2. In pjsip.conf, should `bind=0.0.0.0:5060` or `bind=127.0.0.1:5060` when running in Docker?

3. Do I need `external_media_address` and `external_signaling_address` if everything is on localhost?

4. Is the "Request Timeout" a Docker networking issue, Asterisk config issue, or MicroSIP config issue?

5. What logs should I check first to diagnose the problem?

---

**Thank you for your help! Please provide complete, working solutions that I can copy and paste to get my system working.** 🙏
