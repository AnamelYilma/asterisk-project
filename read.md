To run Docker:

```powershell
docker run -d --name my-asterisk -p 5060:5060/udp -p 10000-10099:10000-10099/udp -v C:\continer\work\code\asterisk-project\config:/etc/asterisk andrius/asterisk:stable
```

What this does:

1. Downloads the Asterisk image.
2. Starts the container in the background.
3. Publishes SIP on `5060/udp`.
4. Publishes RTP audio on `10000-10099/udp`.
5. Mounts your local `config` folder into `/etc/asterisk`.

Important files:

- `config/pjsip.conf` for phone registration
- `config/extensions.conf` for dialplan and call routing
- `config/rtp.conf` for audio ports
