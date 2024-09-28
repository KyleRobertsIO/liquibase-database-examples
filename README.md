# **Liquibase | Postgres Local Database**

This respository demonstrates leveraging Liquibase, a data migration
tool to instanciate a Postgres database with all changelog for the
purposes of development locally.

## **Getting Started**

The following is targeted for Linux based operating systems.
You need to have Docker and Docker Compose installed for this
setup to work.

```sh
sudo docker system prune -f && sudo docker compose up --build
```