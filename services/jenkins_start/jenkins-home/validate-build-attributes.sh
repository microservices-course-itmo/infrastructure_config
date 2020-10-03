#!/bin/bash

filename="pom.xml"

scmBranch="$(git branch | grep \* | cut -d ' ' -f2)"
currentVersion="$(xpath -q -e '//project/properties/current-version/text()' $filename)"

scmBranch_FORMAT="^[a-zA-Z0-9_\-]+$"
currentVersion_FORMAT="^([0-9]+\.)+[0-9]+$"

[[ ${scmBranch} =~ ${scmBranch_FORMAT} ]] || (echo "Bad branch $scmBranch" && exit 1)
[[ ${currentVersion} =~ ${currentVersion_FORMAT} ]] || (echo "Bad version $currentVersion" && exit 2)




# sudo apt install libxml-xpath-perl -- отсюда команда xpath
