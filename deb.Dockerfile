ARG BASE_IMAGE=ubuntu:20.04
FROM ${BASE_IMAGE}
ARG BASE_IMAGE
ARG POSTGRES_VERSION
ARG PROMSCALE_EXTENSION_VERSION

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget gnupg2 lsb-release sudo

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y postgresql-${POSTGRES_VERSION}

RUN FILE=promscale_extension-${PROMSCALE_EXTENSION_VERSION}.pg${POSTGRES_VERSION}.debian11.x86_64.deb \
    && wget https://github.com/timescale/promscale_extension/releases/download/${PROMSCALE_EXTENSION_VERSION}/${FILE} \
    && dpkg -i ${FILE} \
    && rm ${FILE}

WORKDIR /var/lib/postgresql
ENV PGDATA /var/lib/postgresql/data
ENV PG_MAJOR ${POSTGRES_VERSION}
ENV PATH $PATH:/usr/lib/postgresql/$PG_MAJOR/bin

RUN mkdir /docker-entrypoint-initdb.d

RUN set -eux; \
	dpkg-divert --add --rename --divert "/usr/share/postgresql/postgresql.conf.sample.dpkg" "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"; \
	cp -v /usr/share/postgresql/postgresql.conf.sample.dpkg /usr/share/postgresql/postgresql.conf.sample; \
	ln -sv ../postgresql.conf.sample "/usr/share/postgresql/$PG_MAJOR/"; \
	sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample; \
	grep -F "listen_addresses = '*'" /usr/share/postgresql/postgresql.conf.sample

RUN apt-get install -y gnupg postgresql-common apt-transport-https lsb-release wget
RUN bash /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y
RUN echo "deb https://packagecloud.io/timescale/timescaledb/$(echo ${BASE_IMAGE} | cut -d ':' -f 1)/ $(lsb_release -c -s) main" > /etc/apt/sources.list.d/timescaledb.list \
    && wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add - \
    && apt-get update \
    && apt-get install -y timescaledb-2-postgresql-${POSTGRES_VERSION} timescaledb-tools

USER postgres

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
STOPSIGNAL SIGINT
EXPOSE 5432
