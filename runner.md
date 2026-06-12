
## 🚀 Scenario 1: First Time Setup (New PC or New Project)

Do this **only once** when you clone the project or set up a new computer.

### Step 1: Install Docker
1. Download **Docker Desktop** from [docker.com](https://www.docker.com/products/docker-desktop).
2. Install it and restart your PC if asked.
3. Open Docker Desktop and wait until the whale icon stops moving (it is ready).

### Step 2: Open Terminal
1. Go to your project folder (`my-asterisk-project`).
2. Right-click in the folder and select **"Open in Terminal"** or **"Open PowerShell window here"**.

### Step 3: Run the Container
Copy and paste this command into PowerShell. 

**⚠️ IMPORTANT:** Replace `C:\Users\YOUR_NAME\my-asterisk-project\config` with your actual path.

```powershell
docker run -d `
  --name my-asterisk `
  -p 5060:5060/udp `
  -p 5061:5061/tcp `
  -p 10000-10099:10000-10099/udp `
  -v C:\continer\work\code\asterisk-project\config:/etc/asterisk `
  andrius/asterisk:stable
```

*   `-d`: Runs in background.
*   `--name`: Names the container "my-asterisk".
*   `-p`: Opens ports for SIP (5060) and Audio (10000-10099).
*   `-v`: Connects your local `config` folder to Asterisk inside Docker.

---

## 🔄 Scenario 2: Daily Use (Start & Stop)

Use these commands every day when you work on your project.

### Start Asterisk
If the container exists but is stopped:
```powershell
docker start my-asterisk
```

### Stop Asterisk
To turn off Asterisk safely:
```powershell
docker stop my-asterisk
```

### Check Status
To see if it is running:
```powershell
docker ps
```
*(If you see `my-asterisk` in the list, it is running.)*

---

## ✏️ Scenario 3: Editing Configuration Files

When you change `pjsip.conf` or `extensions.conf`, follow these steps:

1. **Edit** the file in your local `config/` folder using VS Code or Notepad.
2. **Save** the file (`Ctrl + S`).
3. **Restart** the container to apply changes:

```powershell
docker restart my-asterisk
```

> **Note:** You do **not** need to copy files manually. Because we used `-v` (volume), Docker sees your local files instantly. You only need to restart to reload the config.

---

## 🛠️ Scenario 4: Troubleshooting & Maintenance

### View Logs (If something is broken)
If Asterisk won't start or calls fail, check the logs:
```powershell
docker logs my-asterisk
```

### Access Asterisk Console (CLI)
To talk to Asterisk directly (like typing commands):
```powershell
docker exec -it my-asterisk asterisk -rvvv
```
*Type `core stop now` to exit the console.*

### Delete Everything (Reset)
If you want to delete the container and start fresh (your local `config` files are safe):
```powershell
docker rm -f my-asterisk
```
*Then go back to **Scenario 1** to create it again.*

---

## 📝 Quick Command Cheat Sheet

| Action | Command |
| :--- | :--- |
| **First Time Run** | `docker run -d --name my-asterisk -p 5060:5060/udp -p 10000-10099:10000-10099/udp -v YOUR_PATH/config:/etc/asterisk andrius/asterisk:stable` |
| **Start** | `docker start my-asterisk` |
| **Stop** | `docker stop my-asterisk` |
| **Restart (Apply Config)** | `docker restart my-asterisk` |
| **Check Status** | `docker ps` |
| **View Logs** | `docker logs my-asterisk` |
| **Delete Container** | `docker rm -f my-asterisk` |

---

## ✅ Checklist for Success

- [ ] Docker Desktop is running.
- [ ] My `config` folder has `pjsip.conf` and `extensions.conf`.
- [ ] I used the correct path in the `-v` command.
- [ ] I restarted the container after editing files.
- [ ] My firewall allows UDP ports 5060 and 10000-10099.
```