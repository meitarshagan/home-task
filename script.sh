NETWORK_NAME=${DOCKER_NETWORK:-cluster_network}

# Initialize the nodelist variable
NODELIST=""

# Get the list of all container names in the same network using Docker's API
for container in $(docker network inspect --format='{{range .Containers}}{{.Name}} {{end}}' $NETWORK_NAME); do
    IP_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
    NODE_ID=$(echo $container | sed 's/[^0-9]*//g')
    NODELIST="${NODELIST}\n    node {\n        ring0_addr: ${IP_ADDRESS}\n        nodeid: ${NODE_ID}\n    }"
done
echo $NODELIST
