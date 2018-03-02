#!/usr/bin/env bash

# based on https://gitlab.cern.ch/cloud-infrastructure/mistral-workflows/blob/master/scripts/validate.sh

code=0

for file in workbooks/*.yml; do
    [ -e "$file" ] || continue
    echo "Validating $file"
    error=$(openstack --os-cloud mistral workbook validate $file -f value -c Error | head -1)
    if [ "$error" != "None" ]; then
        echo "Validation failed on $file please check error '$error'"
        code=1
    fi
done

for file in workflows/*.yml; do
    [ -e "$file" ] || continue
    echo "Validating $file"
    error=$(openstack --os-cloud mistral workflow validate $file -f value -c Error | head -1)
    if [ "$error" != "None" ]; then
        echo "Validation failed on $file please check error '$error'"
        code=1
    fi
done

echo "Validation finished with code: $code"
exit $code
