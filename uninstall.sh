#!/bin/bash

docker compose down

docker system prune -a

docker volume rm azerothcore-wotlk_ac-client-data
docker volume rm azerothcore-wotlk_ac-database
