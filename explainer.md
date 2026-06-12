# System Explainer

This document explains how the full system works together in a clean way.

## Big Picture

The system has four main parts:

1. Docker runs the Asterisk service.
2. Asterisk handles calls and audio rules.
3. Config files define behavior.
4. SIP clients connect to Asterisk and make calls.

## Main Flow

### 1. Docker Starts Asterisk

Docker creates a running container for Asterisk.

The container is the live environment.

### 2. Asterisk Reads Config Files

Asterisk reads files from `/etc/asterisk` inside the container.

In this repo, those settings come from the local `config` folder mounted into the container.

### 3. SIP Devices Register

A SIP client such as a phone app or softphone connects to Asterisk.

Registration uses the SIP transport and endpoint settings defined in `pjsip.conf`.

### 4. Dialplan Decides What Happens

When a call comes in, the dialplan decides where it goes.

That logic usually lives in `extensions.conf`.

### 5. RTP Carries Audio

After the call is set up, the audio moves over RTP.

RTP ports must be open, or the call may connect without sound.

## Why Docker Is Used

Docker keeps the setup portable.

That means the same Asterisk setup can run on another machine if the config files and ports are correct.

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