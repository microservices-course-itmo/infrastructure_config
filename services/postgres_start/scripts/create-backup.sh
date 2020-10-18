#!/bin/bash

mkdir -p /var/lib/postgresql/backups
pg_dumpall -U postgres -c  > /var/lib/postgresql/data/backups/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql