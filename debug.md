# 🔍 Troubleshooting Checklist

If the system is not working, follow these steps in order. Do not skip steps.

### 1. The Docker Layer (Is the box open?)
*   [ ] Run `docker ps`. Is the container `my-asterisk` showing as "Up"?
*   [ ] If not, run `docker-compose up -d`.
*   [ ] Check logs: `docker logs my-asterisk`. Look for "Error" messages.

### 2. The Network Layer (Is the door open?)
*   [ ] **Port 5060**: Is it mapped? Check your `docker-compose.yml`.
*   [ ] **Firewall**: Temporarily disable Windows Firewall or add a rule for UDP 5060.
*   [ ] **IP Address**: Run `ipconfig`. Ensure MicroSIP is trying to connect to the correct IP.

### 3. The Asterisk Layer (Is the brain working?)
*   [ ] Enter the CLI: `docker exec -it my-asterisk asterisk -rvvv`.
*   [ ] Type `pjsip show endpoints`. Does it show your users?
*   [ ] If endpoints are missing, check `config/pjsip.conf` for syntax errors.

### 4. The SIP Client Layer (Is the phone set up?)
*   [ ] Check Username (1001) and Password (pass1001).
*   [ ] Ensure the Domain/Server is `127.0.0.1` (if on same PC) or your Local IP.
*   [ ] Ensure Transport is set to **UDP**.

### 5. Common Symptoms
*   **Status: Request Timeout**: Usually a Firewall or wrong IP address.
*   **Status: Forbidden/Unauthorized**: Wrong password or username.
*   **Connected but No Sound**: Port mapping for RTP (10000-10099) is missing or blocked.
*   **Call drops immediately**: Check `extensions.conf` to see if the dialplan exists for that number.