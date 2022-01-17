#!/usr/bin/env bash

DISTROS="debian:9 debian:10 debian:11 ubuntu:18.04 ubuntu:20.04 ubuntu:21.04"
PG_VERSIONS="12 13 14"
EXT_VERSIONS="0.3.0"

for distro in ${DISTROS}; do
  for pgver in ${PG_VERSIONS}; do
    for extver in ${EXT_VERSIONS}; do
      safe_distro=$(echo "${distro}" | tr ':' -)
      docker_tag="${extver}-pg${pgver}-${safe_distro}"
      echo -n "${docker_tag}"
      container=$(docker run \
        --rm \
        -e POSTGRES_PASSWORD=password \
        -p5432:5432 \
        -d timescaldev/promscale-extension:${docker_tag} 2>/dev/null)
      echo -n "."
      until PGPASSWORD=password psql -h localhost -U postgres -d postgres -c "select 1" 1>/dev/null 2>&1; do
        sleep 1
        echo -n "."
      done
      echo -n "."
      ../promscale/dist/promscale -db-ssl-mode=disable -db-user=postgres -db-password=password -db-name=postgres --startup.only 1>/dev/null 2>&1
      echo -n "."
      if [ "$?" -eq "0" ]; then
        echo "OK"
      else
        echo "NOK"
      fi
      docker stop ${container} 1>/dev/null
    done
  done
done