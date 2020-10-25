#!/bin/bash

webhook="https://hooks.slack.com/services/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"
header="Состояние на "$( date +%d/%m/%Y )
services="Сервисы:\n"$(docker service ls | grep "5000" | awk '{ split($4,amount,"/"); split($5,image,"/"); if ( amount[1] == "0" ) status="не " ; print $2, status,"запущен с образом ", image[2] }')
memory="Память:\n"$( df -h | grep "/dev/sd" | awk '{ print $4, "/", $2, " свободно в ", $6 }')
text=$header"\n"$services"\n"$memory
curl -X POST -H 'Content-type: application/json' --data "{'text':'${text}'}"  $webhook