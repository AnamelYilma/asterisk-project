

# **1\. SIP (Session Initiation Protocol)**

## **Simple Meaning**

SIP is the **call manager**.

It does **NOT carry your voice**.

Its job is:

* Start calls  
* End calls  
* Find users  
* Ring phones  
* Negotiate call settings  
  Think:  
  📞 SIP \= Phone call receptionist

  ## **Similar Thing**

  **Website:**  
  Browser → HTTP → Server  
  **Phone:**  
  Phone → SIP → Asterisk  
  **HTTP starts web communication.**  
  **SIP starts phone communication.**

# **2\. RTP (Real-Time Transport Protocol)**

## **Simple Meaning**

**RTP is the actual voice carrier.** 

**When you speak:**

**Hello**

**Your voice becomes packets.**

**RTP sends those packets.**

### **SIP : Starts call.**

### **RTP: Carries voice.**

# **3\. DTMF**

**What is it?**  
The beep sounds when you press phone buttons. 

**When you press:**

**1**

**2**

**3**

**\***

**\#**

**Those sounds are DTMF.**

**DTMF means:**

**Dual Tone Multi Frequency**

**Ignore the complicated name.**

## **Similar Example**

**ATM machine buttons.**

**Elevator buttons.**

**Phone buttons.**

**Same idea.**

# **4\. Asterisk (This is the most important one)**

## **Simple Meaning**

What is it? The "brain" of a phone system. 

**Asterisk is a PBX software.**

**PBX means:**

**Private Branch Exchange.**

**It can:**

* **Connect calls between phones**  
* **Connect to outside phone lines**  
* **Play recordings**  
* **Act as voicemail**  
* **Be a full phone system (PBX)**

**Asterisk manages phone calls.** 

## **Example**

**User A calls**

       **↓**

   **Asterisk**

       **↓**

**User B**

**Asterisk decides:**

* **Who receives calls**  
* **IVR menus**  
* **Call recording**  
* **Voicemail**  
* **Call forwarding**  
* **Call queues**  
  **Everything.**

# **Similar To**

**Web world:**

**Browser → Backend Server**

**Phone world:**

**Phone → Asterisk**

**Asterisk is like the backend server.**

1. **Dialplan** 

Dialplan is the brain of Asterisk. 

What is it? The instruction manual for handling calls. 

**Example of Dialplan:**

If user presses 1

    go Sales

If user presses 2

    go Support

If number \= 100

    call Ahmed

Dialplan is basically:

if this

do that

for phone calls.

# **B. Extension** 

What is it? A phone number inside your system.  
Analogy:  
Like room numbers in a hotel:

* Room 101 \= Sales  
* Room 102 \= Support  
* Room 999 \= Boss


In Asterisk  
exten \=\> 101,1,Dial(SIP/sales\_phone)    ; Extension 101  
exten \=\> 102,1,Dial(SIP/support\_phone)  ; Extension 102  
C. **IVR**

IVR means: 

Interactive Voice Response

## **Example**

You call customer service.

You hear:

Welcome.

Press 1 for English.

Press 2 for Amharic.

That's IVR.

IVR \= Automated menu system.

## **Similar To**

**Website menu:**

Home

About

Contact

**Phone menu:**

1 Sales

2 Support

3 Billing

	D. **AGI (Asterisk Gateway Interface )**

**AGI lets Asterisk run external programs.** 

**What is it? A way to write external programs that control Asterisk.**   
**Example**   
**Phone rings → Asterisk → "Hey golang script, what should I do?"**  
                              **↓**  
           **Golang : "Play this message, ask for input, check database..."**  
                              **↓**  
           **Asterisk: "Okay, done\!"**  
**Why use AGI?**

* **Dialplan is limited for complex logic**  
* **Want to check a database? Use AGI**  
* **Want to call an API? Use AGI**  
* **Want AI voice recognition? Use AGI**

  **E. Channel** 

**A channel is a communication path.**

**What is it? A single conversation path in Asterisk.**  
**Example :** 

**Ahmed calls:**

**Asterisk creates:**

**Channel 1**

**to Ahmed.**

**Then calls Sara.**

**Creates:**

**Channel 2**

**Then bridges them.**

## **Similar To**

**Socket connection.**

**Network connection.**

**Communication tunnel.**

**F. Codec **		

**Codec converts voice into digital data.**

**What is it? The compression method for voice.**  
**Analogy:**  
**Like file formats:**

* **.wav \= Uncompressed (huge)**  
* **.mp3 \= Compressed (small)**  
* **Codecs do the same for live voice\!**

## **Why?**

**Raw audio is huge.**

**Compression saves bandwidth.**

## **Popular Codecs**

### **G711**

* **High quality**  
* **More bandwidth**

### **G729**

* **Less bandwidth**  
* **More compression**

### **Opus**

* **Modern**  
* **Excellent quality**

## **How They All Work Together 🔄**

**You dial 100 (Extension)**

    **↓**

**SIP sends "ring" signal**

    **↓**

**Asterisk checks Dialplan**

    **↓**

**IVR plays "Press 1 for Sales"**

    **↓**

**You press 1 (DTMF sent)**

    **↓**

**Asterisk connects you using Channel**

    **↓**

**RTP carries your voice (using Codec like G.711)**

    **↓**

**If needed, AGI script checks database**

    **↓**

**Call ends, SIP sends "bye"**

# **FreeSWITCH vs Asterisk 🆚**

## What is FreeSWITCH?

In short: It's another "phone system brain" like Asterisk, but newer and more modern.

## Key Difference: Windows Support 🪟

### Asterisk on Windows:

❌ Not native  
❌ Like putting a car engine in a boat \- possible but painful  
❌ Need special tools, workarounds, Cygwin  
❌ Many things break or don't work properly  
❌ "It runs... but do you really want to?"

### FreeSWITCH on Windows:

✅ Native support  
✅ Download → Install → Works  
✅ Made to run on Windows from day one  
✅ Same experience as Linux  
✅ "Just works"

* Asterisk on Windows \= Playing PlayStation games on Xbox (possible with emulator, but messy)  
* FreeSWITCH on Windows \= Playing Xbox games on Xbox (natural)

