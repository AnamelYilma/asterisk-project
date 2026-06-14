# Use a stable Asterisk base image
FROM andrius/asterisk:stable

# Maintainer info
LABEL maintainer="YourName"

# Copy all config files from our local folder to the Asterisk folder in the container
COPY ./config/ /etc/asterisk/

# Expose the necessary ports
EXPOSE 5060/udp 10000-10099/udp

# Start Asterisk in the foreground so the container stays running
CMD ["/usr/sbin/asterisk", "-f"]