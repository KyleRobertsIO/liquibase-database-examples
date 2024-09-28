FROM postgres:16.4

RUN apt update
RUN apt-get install odbc-postgresql -y
RUN apt-get install postgresql-client -y

RUN mkdir /db_setup
COPY ./init_sql/healthcheck.sql /db_setup/healthcheck.sql
COPY ./init_scripts/healthcheck.sh /db_setup/healthcheck.sh
RUN chmod +x /db_setup/healthcheck.sh

COPY ./init_scripts/custom_db_init.sh /docker-entrypoint-initdb.d/custom_db_init.sh