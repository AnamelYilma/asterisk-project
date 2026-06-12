# Code Guide

This file explains how to read and write the system configuration code in this project.

## What This Means

This is not programming logic in a normal app.

Here, code means the configuration language that tells Asterisk how to work.

## Main File Groups

### SIP and PJSIP

Files like `pjsip.conf` define:

- transport
- login
- endpoint
- registration behavior
- device matching

Read these files when you want to know how a phone connects.

### Extensions

Files like `extensions.conf` define:

- call routing
- dial rules
- contexts
- what number does what

Read these files when you want to know what happens after a call arrives.

### Voicemail

Files like `voicemail.conf` define:

- mailbox numbers
- passwords
- voicemail behavior
- message storage rules

Read these files when you want to know how missed calls are handled.

### RTP

Files like `rtp.conf` define:

- audio port range
- media port behavior
- voice path settings

Read these files when you want to know how sound moves.

## How To Write Config Cleanly

### 1. Keep Each Section Small

Put one purpose in one section.

### 2. Use Clear Names

Names should show what the entry is for.

### 3. Keep Related Items Together

Group transport, auth, AOR, and endpoint for the same extension near each other.

### 4. Add Short Labels

Use short comments only when the purpose is not obvious.

## How To Read A Config File

Use this order:

1. Find the section name.
2. Check the type.
3. Read the important settings.
4. Ask what behavior this changes.
5. Follow the connection to the next file.

## What To Look For In PJSIP

### transport

This tells Asterisk how SIP traffic enters the system.

### aor

This tells Asterisk where the device can be reached.

### auth

This tells Asterisk how the device proves identity.

### endpoint

This tells Asterisk how the device behaves in calls.

## What To Look For In Extensions

- The extension number
- The context name
- The order of rules
- The action taken for each dialed number

## What To Look For In Voicemail

- Mailbox number
- Password
- Message policy
- Where messages are stored or delivered

## What To Look For In RTP

- Start port
- End port
- Whether the range matches the Docker port mapping

## Reading Rule For New Files

If you see a new file, ask:

- Is this for login?
- Is this for routing?
- Is this for audio?
- Is this for storage?
- Is this for network setup?

## Writing Rule For New Files

Write only what the system needs.

Do not mix unrelated behavior in one place.

## Current Repo Example

In this repo, the existing `pjsip.config` shows:

- `transport-udp` for SIP transport
- extension `1001` for one device
- extension `1002` for another device

That means the config is already organized around one clear job: SIP registration and calling.