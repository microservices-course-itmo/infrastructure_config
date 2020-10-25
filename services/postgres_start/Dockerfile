FROM postgres
RUN apt-get update && apt-get install cron supervisor -y
COPY postgres_cron.conf /etc/supervisor/conf.d/postgres_cron.conf
RUN mkdir /etc/cron_scripts
COPY scripts/* /etc/cron_scripts/
COPY cron-jobs /
RUN cat /cron-jobs | crontab -
RUN (echo \#\!/bin/bash ; echo '/usr/bin/supervisord -c /etc/supervisor/supervisord.conf' ) > /run_all.sh
RUN chmod +x /run_all.sh
ENTRYPOINT ["/bin/bash", "/run_all.sh"]