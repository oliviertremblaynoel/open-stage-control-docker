#!/bin/bash
export COMPOSE_BAKE=true # more efficient build process
docker compose -f example-compose.yml build
docker compose -f example-compose.yml up -d --force-recreate --remove-orphans
