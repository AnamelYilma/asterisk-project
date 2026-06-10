
To run docker 

     ```
     docker run -d --name my-asterisk 5060:5060/udp ← Open SIP door -p 10000-10099:10000-10099/udp  ← Open audio doors -v C:\your-folder:/etc/asterisk ← Connect your files andrius/asterisk:stable 
     
     ```

Here is what happens in short:

1.Downloads: Grabs the Asterisk software image from the cloud.

2.Launches: Runs Asterisk silently in the background under the name my-asterisk.

3.Opens Ports: Routes phone calls (5060) and voice audio (10000-10099) into the container.

4.Shares Files: Links C:\your-folder on your computer directly to Asterisk's internal settings.

This setup allows you to manage Asterisk's configuration files on your computer while it runs in the container, making it easier to customize and maintain your VoIP system.

## ✅ THE 3 IMPORTANT FILES:

     asterisk-project/config/
     ├── sip.conf          ← Register users (phones)
     ├── extensions.conf   ← Call routing (dialplan)
     └── rtp.conf          ← Voice transmission ports
