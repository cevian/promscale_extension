DISTROS="debian:9 debian:10 debian:11 ubuntu:18.04 ubuntu:20.04 ubuntu:21.04"
PG_VERSIONS="12 13 14"
EXT_VERSIONS="0.3.0"

for distro in ${DISTROS}; do
  for pgver in ${PG_VERSIONS}; do
    for extver in ${EXT_VERSIONS}; do
      safe_distro=$(echo "${distro}" | tr ':' -)
      docker_tag="${extver}-pg${pgver}-${safe_distro}"
      echo building "${docker_tag}"
      docker build \
        --platform linux/amd64 \
        --build-arg BASE_IMAGE="${distro}" \
        --build-arg POSTGRES_VERSION="${pgver}" \
        --build-arg PROMSCALE_EXTENSION_VERSION="${extver}" \
        --progress plain \
        -f deb.Dockerfile \
        -t timescaldev/promscale-extension:"${docker_tag}" \
        . &
    done
  done
done