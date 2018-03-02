#!/usr/bin/env bash

# based on https://gitlab.cern.ch/cloud-infrastructure/mistral-workflows/blob/master/scripts/update.sh

WORKBOOKS=$(openstack --os-cloud mistral workbook list -f value -c Name)

for file in workbooks/*.yml; do
    [ -e "$file" ] || continue
    echo "Updating $file"

    filename=${file##*/}
    name=${filename%.*}

    if [[ " ${WORKBOOKS[@]} " =~ "${name}" ]]; then
        openstack --os-cloud mistral workbook update $file
    else
        openstack --os-cloud mistral workbook create $file
    fi
done

WORKFLOWS=$(openstack --os-cloud mistral workflow list -f value -c Name)

for file in workflows/*.yml; do
    [ -e "$file" ] || continue
    echo "Updating $file"

    filename=${file##*/}
    name=${filename%.*}

    if [[ " ${WORKFLOWS[@]} " =~ "${name}" ]]; then
        openstack --os-cloud mistral workflow update --public $file
    else
        openstack --os-cloud mistral workflow create $file
    fi
done
