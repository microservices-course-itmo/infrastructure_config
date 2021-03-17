#!/bin/bash
RegistryHost=0.0.0.0:25001
count=2
sudo yum install epel-release jq -y
catalog=$(curl -s -G ${RegistryHost}/v2/_catalog \
    | jq -M ".repositories | @sh" | tr -d \' | tr -d \")
for repo in ${catalog}
do
    echo "Repo: ${repo}"
    tags=$(curl -s -G ${RegistryHost}/v2/${repo}/tags/list \
    | jq ".tags | @sh" | tr -d \' | tr -d \" \
    | tr ' '  '\n' | sed 's/^latest$//g')
    branches=$(echo ${tags} | tr ' '  '\n' | sed 's/_.*//g' | sort | uniq )
    refs=()
    echo ${tags}
    for branch in ${branches}
    do
        if [[ -n ${branch} ]]
        then
            echo "Deleting from ${branch}"
            branch_tags=$(echo ${tags} | tr ' ' '\n' | grep ${branch} | sort | head --lines=${count})
            not_delete_tags=$(echo ${tags} | tr ' ' '\n' | grep ${branch} | sort | tail --lines=${count})
            for tag in ${branch_tags}
            do
                ref=$(curl -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X GET ${RegistryHost}/v2/${repo}/manifests/${tag} 2>&1 | grep Docker-Content-Digest | awk '{print ($3)}')
                ref=${ref%$'\r'}
                refs+=(${ref})
            done
            ref=""
            for tag in ${not_delete_tags}
            do
                ref=$(curl -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X GET ${RegistryHost}/v2/${repo}/manifests/${tag} 2>&1 | grep Docker-Content-Digest | awk '{print ($3)}')
                ref=${ref%$'\r'}
                if [ -n "$( echo ${refs[@]} | grep ${ref} )" ]; then
                    refs=($( echo ${refs[@]} | sed "s|$ref||g" ))
                fi
            done
        fi
    done
    refs=( $(echo ${refs[@]} | uniq ) )
    for ref in ${refs[@]}
    do
        echo ${ref}
        curl -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X DELETE "${RegistryHost}/v2/${repo}/manifests/${ref}"
    done
done
# This command will work only if user have access without password to all nodes
container=$(docker service ps registry -q | head -n 1)
ssh "$(docker service ps registry | head -n 2 | tail -n 1 | awk '{ print $4}')" "docker exec -i registry.1.${container} bin/registry garbage-collect /etc/docker/registry/config.yml --delete-untagged=true"