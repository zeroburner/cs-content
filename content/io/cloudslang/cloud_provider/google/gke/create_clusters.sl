#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow creates a cluster, consisting of the specified number and type of Google Compute Engine instances.
# By default, the cluster is created in the project's default network.
# One firewall is added for the cluster. After cluster creation, the cluster creates routes for each node to allow the containers on that node to communicate with all other instances in the cluster.
# Finally, an entry is added to the project's global metadata indicating which CIDR range is being used by the cluster.
#
# Note : Google Authentitification json key file downloaded from the Google APIs console is required. This referred to in GOOGLE_APPLICATION_CREDENTIALS is 
# expected to contain information about credentials that are ready to use. This means either service account information or user account information with 
# a ready-to-use refresh token:
#       {                                       {
#          'type': 'authorized_user',              'type': 'service_account',
#          'client_id': '...',                     'client_id': '...',
#          'client_secret': '...',       OR        'client_email': '...',
#          'refresh_token': '...,                  'private_key_id': '...',
#      }                                           'private_key': '...',
#                                              }
#
# Inputs:
#   - projectId - The Google Developers Console project ID or project number
#   - zone - optional - The name of the Google Compute Engine zone in which the cluster resides, or none for all zones
#   - jSonGoogleAuthPath - FileSystem Path to Google Authentitification json key file. Example : C:\\Temp\\cloudslang-026ac0ebb6e0.json
#   - cluster - A cluster resource
# Outputs:
#   - return_code - "0" if success, "-1" otherwise
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - reponse - jSon response body containing an instance of Operation
#   - cluster_name - cluster name identifier
#   - error_message - return_result if return_code is not "0"
####################################################

namespace: io.cloudslang.cloud_provider.google.gke

operation:
  name: create_clusters
  inputs:
    - projectId:
        required: true
    - zone:
        required: true
    - jSonGoogleAuthPath:
        required: true
    - cluster:
        required: true
  action:
    python_script: |
                import os
                import json

                json_cluster = json.loads(cluster)
                from apiclient import discovery
                from oauth2client.client import GoogleCredentials
                os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = jSonGoogleAuthPath
                credentials = GoogleCredentials.get_application_default()
                service = discovery.build('container', 'v1', credentials=credentials)
                request = service.projects().zones().clusters().create(projectId=projectId,zone=zone,body=json_cluster)
                response = request.execute()
                cluster_name = response['name']
                return_code = '0'
                return_result = 'Success'
  outputs:
    - return_code
    - return_result
    - cluster_name
    - response
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE