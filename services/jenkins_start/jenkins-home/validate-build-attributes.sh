#!/bin/bash

filename="pom.xml"

scmBranch="$(git branch | grep \* | cut -d ' ' -f2)"
currentVersion="$(xpath -q -e '//project/properties/current-version/text()' $filename)"

scmBranch_FORMAT="^[a-zA-Z0-9_\-]+$"
currentVersion_FORMAT="^([0-9]+\.)+[0-9]+$"

[[ ${scmBranch} =~ ${scmBranch_FORMAT} ]] || (echo "Bad branch $scmBranch" && exit 1)
[[ ${currentVersion} =~ ${currentVersion_FORMAT} ]] || (echo "Bad version $currentVersion" && exit 2)

[[ $(xpath -q -e '//project/distributionManagement/' $filename | grep -o '<distributionManagement>' | wc -l) -lt "1" ]] \
    && echo "You must specify distributionManagement section in your pom" \
    && echo "<distributionManagement>
    <snapshotRepository>
        <id>snapshots</id>
        <url>http://artifactory:8081/artifactory/libs-snapshot-local</url>
    </snapshotRepository>
</distributionManagement>" \
    && exit 3

artifact_id="$(xpath -q -e '//project/artifactId/text()' $filename)"
service_FORMAT="-service$"

if [[ ${artifact_id} =~ ${service_FORMAT} ]]; then
    [[ $(xpath -q -e '//project/build/plugins/plugin/artifactId/text()' $filename | grep "dockerfile-maven-plugin" | wc -l) -lt "1" ]] \
    && echo "You must specify dockerfile-maven-plugin in your pom" \
    && exit 4
fi

# sudo apt install libxml-xpath-perl -- отсюда команда xpath
