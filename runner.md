# Scenario 1: First Time Setup

Do this only once when you clone the project or set up a new computer.

### Step 1: Install Docker
1. Download Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop).
2. Install it and restart your PC if asked.
3. Open Docker Desktop and wait until it is ready.

### Step 2: Open Terminal
1. Go to your project folder (`my-asterisk-project`).
2. Right-click in the folder and select **Open in Terminal** or **Open PowerShell window here**.

### Step 3: Run the Container
Copy and paste this command into PowerShell.

**Important:** Replace `C:\Users\YOUR_NAME\my-asterisk-project\config` with your actual path.

```powershell
docker run -d `
  --name my-asterisk `
  -p 5060:5060/udp `
  -p 10000-10099:10000-10099/udp `
  -v C:\continer\work\code\asterisk-project\config:/etc/asterisk `
  andrius/asterisk:stable
```

* `-d`: Runs in background.
* `--name`: Names the container `my-asterisk`.
* `-p`: Opens ports for SIP (5060) and Audio (10000-10099).
* `-v`: Connects your local `config` folder to Asterisk inside Docker.

---

## Scenario 2: Daily Use

### Start Asterisk
```powershell
docker start my-asterisk
```

### Stop Asterisk
```powershell
docker stop my-asterisk
```

### Check Status
```powershell
docker ps
```

---

## Scenario 3: Editing Configuration Files

When you change `pjsip.conf` or `extensions.conf`:

1. Edit the file in `config/`.
2. Save it.
3. Restart the container:

```powershell
docker restart my-asterisk
```

---

## Scenario 4: Troubleshooting & Maintenance

### View Logs
```powershell
docker logs my-asterisk
```

### Access Asterisk Console
```powershell
docker exec -it my-asterisk asterisk -rvvv
```

### Delete Everything
```powershell
docker rm -f my-asterisk
```

---

## Quick Command Cheat Sheet

| Action | Command |
| :--- | :--- |
| First Time Run | `docker run -d --name my-asterisk -p 5060:5060/udp -p 10000-10099:10000-10099/udp -v YOUR_PATH/config:/etc/asterisk andrius/asterisk:stable` |
| Start | `docker start my-asterisk` |
| Stop | `docker stop my-asterisk` |
| Restart | `docker restart my-asterisk` |
| Check Status | `docker ps` |
| View Logs | `docker logs my-asterisk` |
| Delete Container | `docker rm -f my-asterisk` |

---

## Checklist for Success

- [ ] Docker Desktop is running.
- [ ] My `config` folder has `pjsip.conf` and `extensions.conf`.
- [ ] I used the correct path in the `-v` command.
- [ ] I restarted the container after editing files.
- [ ] My firewall allows UDP ports 5060 and 10000-10099.
