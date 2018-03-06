#!/usr/bin/env bash

# based on https://gitlab.cern.ch/cloud-infrastructure/mistral-workflows/blob/master/scripts/update.sh

WORKBOOKS=$(openstack --os-cloud mistral workbook list -f value -c Name)

for file in workbooks/*.yml; do
    [ -e "$file" ] || continue

    filename=${file##*/}
    name=${filename%.*}

    if [[ " ${WORKBOOKS[@]} " =~ "${name}" ]]; then
        echo "Updating workbook $name"
        openstack --os-cloud mistral workbook update --public $file
    else
        echo "Creating workbook $name"
        openstack --os-cloud mistral workbook create --public $file
    fi
done

WORKFLOWS=$(openstack --os-cloud mistral workflow list -f value -c Name)

for file in workflows/*.yml; do
    [ -e "$file" ] || continue

    filename=${file##*/}
    name=${filename%.*}

    if [[ " ${WORKFLOWS[@]} " =~ "${name}" ]]; then
        echo "Updating workflow $name"
        openstack --os-cloud mistral workflow update --public $file
    else
        echo "Creating workflow $name"
        openstack --os-cloud mistral workflow create --public $file
    fi
done
