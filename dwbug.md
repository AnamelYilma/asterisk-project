#To Check ports free 
# Check if port 5060 is free
netstat -an | findstr 5060

# Check if RTP ports are free
netstat -an | findstr 10000


# Check if container started
docker ps

# You should see:
# CONTAINER ID   IMAGE                    STATUS
# xxxxx          andrius/asterisk:stable  Up 2 seconds

# See live logs
docker logs -f my-asterisk


# Enter the running container   
    docker exec -it my-asterisk asterisk -rvvv


