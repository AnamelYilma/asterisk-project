# 📘 VoIP & Asterisk Glossary

This guide explains the technical terms used in this project in simple English.

### 🏗️ The Infrastructure
*   **Docker**: A "box" (container) that runs Asterisk. It keeps the software isolated from Windows.
*   **Image**: A template or "recipe" for creating a container.
*   **Port Mapping**: Connecting a "door" on your PC to a "door" inside Docker (e.g., PC 5060 -> Docker 5060).
*   **Volume**: A shared link between a folder on your Windows PC and a folder inside the Docker container.

### 📞 The Protocol (SIP & RTP)
*   **SIP (Session Initiation Protocol)**: The "Manager." It handles ringing, hanging up, and registering. Uses **Port 5060**.
*   **RTP (Real-time Transport Protocol)**: The "Voice." It carries the actual sound of your speech. Uses **Ports 10000-10099**.
*   **Endpoint**: A "User" or a "Phone" (e.g., MicroSIP is an endpoint).
*   **Registration**: When a phone "logs in" to Asterisk so Asterisk knows where to find it.

### 🧠 The Asterisk Brain
*   **Dialplan (`extensions.conf`)**: The logic. It tells Asterisk: "If someone dials 999, do THIS."
*   **Context**: A security group. It defines which numbers a specific user is allowed to call.
*   **PJSIP**: The modern driver Asterisk uses to talk to SIP phones.
*   **Codec**: The math used to compress your voice so it can travel over the internet (e.g., ulaw, alaw).

### 🌍 Networking
*   **NAT**: A way for devices in a private network to talk to the outside world.
*   **Bind**: Telling the software to stay active on a specific IP or Port.
*   **UDP**: The type of internet traffic used for phones because it is fast.

## How To Think About Words

When you see a word, ask these questions:

1. What does it mean here?
2. What part of the system uses it?
3. What is its purpose?
4. What happens if it changes?

## Simple Reading Rule

If a word appears in a config file, it usually means a setting, a rule, or a connection point.

## What To Focus On First

- What the word controls
- Which file uses it
- Whether it is for call setup, audio, routing, or login
- Whether it belongs to Docker, Asterisk, or the phone client

## Good Habit

Do not try to memorize every word at once.

Read the word, then read its purpose, then read the file where it lives.