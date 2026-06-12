# Learn Word Guide

This file teaches the meaning of words used in this system. It is for understanding, not for code.

## Purpose

The goal is to help you read Asterisk and system words clearly.

## Main Idea

Many files in this project are not random text. Each file has a purpose.

- Some files tell Asterisk how to accept calls.
- Some files tell Asterisk how to route calls.
- Some files tell Asterisk how to send audio.
- Some files tell Asterisk how the system should behave.

## Important Words

### System

A system is a group of parts that work together for one job.

In this project, the system includes Docker, Asterisk, config files, SIP phones, and audio ports.

### Technology

Technology is a tool or method used to solve a problem.

In this project, Docker is technology, Asterisk is technology, and SIP is technology.

### File

A file is a stored set of information.

In this project, config files tell the system what to do.

### Logic

Logic is the rule or decision flow behind behavior.

In this project, logic means how a call enters the system, gets matched, and goes to the right place.

### Purpose

Purpose means the reason something exists.

Example:

- `pjsip.conf` exists to define SIP endpoints and transport.
- `extensions.conf` exists to define dial behavior.
- `rtp.conf` exists to define audio media settings.

### Word Meaning In Context

The same word can mean different things in different places.

Examples:

- `endpoint` means a SIP device or client target.
- `auth` means login details.
- `aor` means where Asterisk can find the device.
- `context` means the call rule group used by the dialplan.
- `transport` means how SIP traffic moves on the network.

## Type Of Things In This System

### Application Layer

This is the part that gives service behavior.

In this project, Asterisk is the application layer.

### Configuration Layer

This layer tells the application how to work.

In this project, the `config` folder is the configuration layer.

### Network Layer

This layer moves messages and audio.

In this project, SIP uses UDP 5060 and audio uses RTP ports.

### Runtime Layer

This is the place where the system is actually running.

In this project, Docker is the runtime container.

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