# Debug Guide

This file explains how to understand failures in this system.

## Debug Goal

When something fails, do not guess.

Find which layer failed, then check the file or setting that controls that layer.

## Main Layers To Check

1. Docker layer
2. Asterisk layer
3. Config layer
4. Network layer
5. SIP client layer
6. Audio layer

## Common Failure Types

### 1. Docker Does Not Start

Meaning:

- The container is not running
- The image may not be available
- Docker Desktop may be stopped

Check:

- Is Docker running?
- Does `docker ps -a` show the container?

### 2. Asterisk Starts But Config Is Wrong

Meaning:

- Asterisk is running, but settings are wrong
- A file may have a bad value

Check:

- `pjsip.conf`
- `extensions.conf`
- `voicemail.conf`
- `rtp.conf`

### 3. SIP Client Cannot Register

Meaning:

- Login settings are wrong
- Transport is wrong
- Network port is blocked

Check:

- username
- password
- endpoint name
- port 5060 UDP

### 4. Call Connects But No Audio

Meaning:

- SIP signaling works
- RTP audio is failing

Check:

- RTP port range
- Docker port mapping
- firewall rules
- `rtp.conf`

### 5. Wrong Number Behavior

Meaning:

- The dialplan does not match the number
- The context does not allow the action

Check:

- `extensions.conf`
- extension number
- dial rules
- context name

### 6. Voicemail Does Not Work

Meaning:

- Mailbox settings are wrong
- The call never reaches voicemail logic

Check:

- `voicemail.conf`
- mailbox number
- password
- route to voicemail in the dialplan

## Debug Method

Use this order:

1. Confirm Docker is running.
2. Confirm the container exists and is started.
3. Confirm the config files are mounted.
4. Confirm the SIP client credentials.
5. Confirm the dialplan number.
6. Confirm the RTP ports.

## How To Think During Debugging

Ask these questions:

- Which part failed?
- Which file controls that part?
- Which value is likely wrong?
- Did the problem start after a change?

## Useful Clues

- Registration problem usually means SIP settings.
- Call routing problem usually means dialplan settings.
- No sound usually means RTP or firewall settings.
- Voicemail problem usually means mailbox or routing settings.

## Clean Debug Rule

One symptom usually belongs to one layer.

Do not mix layers until you know which layer is failing first.

## Repo Focus

For this project, always check these first:

- `config/pjsip.conf`
- `config/extensions.conf`
- `config/rtp.conf`
- Docker port mapping

## Quick Decision Tree

- Cannot log in: check SIP settings
- Can log in but cannot call: check dialplan
- Can call but no audio: check RTP
- Can leave message but voicemail fails: check voicemail config
- Nothing starts: check Docker