#!/bin/bash

manage_docker_containers() {
    containers=("ac-worldserver" "ac-authserver" "ac-database")

    all_running=true
    for container in "${containers[@]}"; do
        if ! docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
            all_running=false
            break
        fi
    done

    if $all_running; then
        echo "Stopping containers: ${containers[*]}"
        docker stop "${containers[@]}"
    else
        echo "Starting containers: ${containers[*]}"
        docker start "${containers[@]}"
    fi
}

manage_docker_containers