#!/bin/bash

echo $( date +%d/%m/%Y_%H:%M:%S ) $( psql -U postgres -c  "SELECT COUNT(*) FROM pg_stat_activity;" | sed -n 3p )  >> /var/lib/postgresql/data/connections