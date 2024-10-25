#!/bin/bash

psql -U $POSTGRES_USER -f /db_setup/healthcheck.sql