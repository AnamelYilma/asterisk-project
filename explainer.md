# 🚀 System Architecture Explainer

This document provides a high-level overview of how the Asterisk-Docker system operates.

## 1. The Core Layers

| Layer | Component | Responsibility |
| :--- | :--- | :--- |
| **Environment** | Docker | Hosts the Linux system needed for Asterisk on Windows. |
| **Processing** | Asterisk | The "PBX" engine that connects calls and manages users. |
| **Definition** | Config Files | `pjsip.conf` (Users) and `extensions.conf` (Dialing Rules). |
| **Hardware** | MicroSIP | The virtual phone used to make the actual calls. |

## 2. The Connection Journey

1.  **Request**: MicroSIP sends a registration request to the PC's IP.
2.  **Bridge**: Docker receives this on Port 5060 and "tunnels" it into the container.
3.  **Auth**: Asterisk checks the config files to see if the user/password is correct.
4.  **Ready**: Once authorized, the phone is "Registered" and ready to dial.

## 3. Why This Design?

*   **Portability**: We can move this entire setup to a different computer in minutes.
*   **Safety**: If Asterisk crashes or has a bad config, it doesn't affect the Windows host.
*   **Development Speed**: By using **Docker Volumes**, we can edit configuration files in Notepad and see the results immediately in the phone system.

## 4. Port Usage Summary
*   **UDP 5060**: Signaling (The "Call Manager").
*   **UDP 10000-10099**: Media (The "Voice Packets").

## What Each Part Does

### Docker

- Starts the service
- Holds the running process
- Maps ports
- Mounts config files

### Asterisk

- Accepts SIP registration
- Routes calls
- Manages audio behavior
- Applies call logic

### Config Files

- Tell Asterisk what to load
- Define endpoints
- Define dial rules
- Define media settings

### SIP Client

- Logs in
- Registers
- Dials numbers
- Receives calls

## How They Depend On Each Other

Docker must be running first.

Then Asterisk must start inside Docker.

Then the config files must be valid.

Then the SIP client can register.

Then calls can route and audio can flow.

## Common System Mistakes

- Docker is stopped
- The container is not running
- The config folder is not mounted correctly
- SIP port 5060 is blocked
- RTP ports are blocked
- The dialplan does not match the number being called

## Clean Mental Model

Think of the system like this:

- Docker is the box
- Asterisk is the engine
- Config files are the instructions
- SIP client is the user device
- RTP is the voice path

## What To Read First

If you are learning the system, read in this order:

1. `runner.md`
2. `pjsip.config`
3. `extensions.conf`
4. `rtp.conf`
5. `debug.md`

## One Line Summary

Docker runs Asterisk, Asterisk reads config files, SIP devices connect to it, the dialplan decides routing, and RTP moves the audio.