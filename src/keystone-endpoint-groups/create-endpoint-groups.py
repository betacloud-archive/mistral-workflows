#!/usr/bin/env python

import os
import sys

import keystoneauth1
import os_client_config
import shade
from tabulate import tabulate
import yaml

CLOUDNAME = os.environ.get("CLOUD", "service")

cloud = shade.operator_cloud(cloud=CLOUDNAME)
keystone = os_client_config.make_client("identity", cloud=CLOUDNAME)

existing_endpoint_groups = {x.name: x for x in keystone.endpoint_groups.list()}

for service in [x for x in keystone.services.list() if x.name not in existing_endpoint_groups.keys()]:
    print("create endpoint for service %s (%s)" % (service.name, service.id))
    payload = {
        "name": service.name,
        "filters": {
            "interface": "public",
            "service_id": service.id
        }
    }
    keystone.endpoint_groups.create(**payload)

result = []
for endpoint_group in existing_endpoint_groups:
    result.append([endpoint_group, existing_endpoint_groups[endpoint_group].id])
print(tabulate(result, headers=["endpoint group name", "endpoint group id"], tablefmt="psql"))
