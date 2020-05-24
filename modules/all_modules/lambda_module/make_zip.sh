#!/bin/bash

set -uex

eval "$(jq -r '@sh "export MODULE_PATH=\(.module_path) LAMBDA=\(.lambda)"')"

/bin/cp -i -r ${MODULE_PATH}/handlers/${LAMBDA}/ ${MODULE_PATH}
/bin/cp -i -r ${MODULE_PATH}/handlers/pySetenv/  ${MODULE_PATH}/${LAMBDA}/

/bin/zip -r ${LAMBDA}.zip ${LAMBDA}

#jq -n --arg zip_file "${LAMBDA}.zip" '{"zip_file":$zip_file}'
echo "{\"zip_file\" : \"${LAMBDA}.zip\"}"