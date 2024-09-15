#!/bin/bash

manage_docker_containers() {
    # List of Docker containers
    containers=("ac-worldserver" "ac-authserver" "ac-database")

    # Check if all containers are running
    all_running=true
    for container in "${containers[@]}"; do
        if ! docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
            all_running=false
            break
        fi
    done

    if $all_running; then
        # Stop all containers if they are running
        echo "Stopping containers: ${containers[*]}"
        docker stop "${containers[@]}"
    else
        # Start all containers if they are not running
        echo "Starting containers: ${containers[*]}"
        docker start "${containers[@]}"
    fi
}

# Call the function
manage_docker_containers