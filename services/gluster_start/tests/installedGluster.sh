################################
#ТЕСТ ДЛЯ ПРОВЕРКИ ТОГО, ЧТО GLUSTER УСТАНОВЛЕН И ПРОСТО ЗАПУЩЕН НА МАШИНЕ
################################
#!/bin/sh

for node in $(cat hosts.list);
do
echo -e "\033[33m"$node"\033[0m"
psNodeResult=$(ssh root@$node "ps aux | grep /var/run/glusterd.pid | grep -v bash | grep -v grep")
echo $psNodeResult
if [[ -z $psNodeResult ]]
then
echo -e "\033[31mTest Failed! Glusterd.service is not working on "$node"\033[0m"
else
echo -e "\033[32mTest Passed! Glusterd.service is working on "$node"\033[0m"
fi
done
