#!/bin/bash

cd azerothcore-wotlk

docker compose down

docker system prune -a

docker volume rm azerothcore-wotlk_ac-client-data
docker volume rm azerothcore-wotlk_ac-database

cd .. && rm -rf azerothcore-wotlk
