#!/bin/bash

NODE_ID=${NODE_ID}
NODE_ADDR=${NODE_ADDR}
PEER_NODES=${PEER_NODES}

# Initialize the nodelist variable
NODELIST=""

# Add the current node to the nodelist
NODELIST="${NODELIST}\n    node {\n        ring0_addr: ${NODE_ADDR}\n        nodeid: ${NODE_ID}\n    }"

# Add peer nodes to the nodelist
IFS=',' read -ra ADDR <<< "$PEER_NODES"
for PEER in "${ADDR[@]}"; do
    PEER_ID=$(echo $PEER | sed 's/[^0-9]*//g')
    NODELIST="${NODELIST}\n    node {\n        ring0_addr: ${PEER}\n        nodeid: ${PEER_ID}\n    }"
done

# Replace the placeholder in the corosync.conf template with the nodelist
sed -e "s|{{NODELIST}}|$NODELIST|g" /etc/corosync/corosync.conf.template > /etc/corosync/corosync.conf

echo "Starting Corosync..."
service corosync start


echo "Starting Pacemaker..."
service pacemaker start
/usr/sbin/sshd 
apachectl -D FOREGROUND
