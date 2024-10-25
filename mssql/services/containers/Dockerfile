FROM mcr.microsoft.com/mssql/server:latest

WORKDIR /db_setup

# Switch to root user for access to apt-get install
USER root

# Install any necessary dependencies
RUN apt-get update && apt-get install -y \
    g++ \
    unixodbc-dev \
    gnupg \
    curl \
    apt-transport-https \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Add Microsoft's GPG key
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Add Microsoft's SQL Server Debian repository
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install SQL Server drivers and SQL Server Command Line tools
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get -y install msodbcsql17 mssql-tools \
    && rm -rf /var/lib/apt/lists/*

# Required initialization SQL scripts
COPY ./init_sql ./init_sql

# Required initalization bash scripts
COPY ./init_scripts ./init_scripts
RUN chmod +x ./init_scripts/db_init.sh
RUN chmod +x ./init_scripts/healthcheck.sh
RUN chmod +x ./init_scripts/entrypoint.sh

# Run the command on container startup
ENTRYPOINT ["./init_scripts/entrypoint.sh"]