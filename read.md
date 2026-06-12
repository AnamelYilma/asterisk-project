# 🚀 Asterisk Docker Quick Start

## Running Asterisk

```powershell
docker run -d --name my-asterisk -p 5060:5060/udp -p 10000-10099:10000-10099/udp -v C:\continer\work\code\asterisk-project\config:/etc/asterisk andrius/asterisk:stable
```

What this does:

1. Downloads the Asterisk image.
2. Starts the container in the background.
3. Publishes SIP on `5060/udp`.
4. Publishes RTP audio on `10000-10099/udp`.
5. Mounts your local `config` folder into `/etc/asterisk`.

## Important Files

- `config/pjsip.conf` - Phone registration (who can connect)
- `config/extensions.conf` - Dialplan and call routing
- `config/rtp.conf` - Audio ports

## 📚 Helpful Guides

### When You Change WiFi/Network:
- **READ THIS:** `NETWORK-SETUP-GUIDE.md` - Complete network configuration guide
- **QUICK REF:** `QUICK-CHECKLIST.md` - Fast checklist when switching networks
- **RUN THIS:** `network-helper.ps1` - Automatic script that shows what to configure

### Usage:
```powershell
# Find out what to configure after network change
.\network-helper.ps1
```

## 🎯 Quick Tips

- **Phone on same PC:** Use `localhost` as server (never changes!)
- **Phone on other device:** Use your PC's IP address (run `ipconfig` to find it)
- **After network change:** Only update external phone configs, Asterisk files don't need changes!
