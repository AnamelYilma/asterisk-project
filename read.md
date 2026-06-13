# Asterisk Docker Quick Start

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

- `config/pjsip.conf` - Phone registration and transport
- `config/extensions.conf` - Dialplan and call routing
- `config/rtp.conf` - Audio ports

## Helpful Guides

### When You Change Wi-Fi or Network:
- `NETWORK-SETUP-GUIDE.md` - Complete network configuration guide
- `network-helper.ps1` - Automatic script that shows what to configure

### Usage:
```powershell
.\network-helper.ps1
```

## Quick Tips

- **Phone on the same PC:** Use `localhost` as the server.
- **Phone on another device:** Use the active adapter IP from `ipconfig`.
- **After network change:** Keep Asterisk bound to `0.0.0.0` in `pjsip.conf`; update only the phone client server address if needed.
