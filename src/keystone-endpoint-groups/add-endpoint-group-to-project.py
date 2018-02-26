#!/usr/bin/env python

import os
import sys

import keystoneauth1
import os_client_config
import shade
import yaml

CLOUDNAME = 'service'

cloud = shade.operator_cloud(cloud=CLOUDNAME)
keystone = os_client_config.make_client('identity', cloud=CLOUDNAME)

try:
    keystone.endpoint_filter.add_endpoint_group_to_project(
        endpoint_group=os.environ.get("ENDPOINT_GROUP"),
        project=os.environ.get("PROJECT")
    )
except keystoneauth1.exceptions.http.Conflict:
    pass
