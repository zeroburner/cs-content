#   (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Gets the latest state of a long-running operation.
#!
#! @input access_token: The access token as a string.
#! @input app_id: The App Engine application id.
#! @input operation_id: The operation to be retrieved.
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: User name used when connecting to the proxy server.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Optional
#! @input connect_timeout: Time in seconds to wait for a connection to be established.
#!                         Default: '0'
#!                         Optional
#! @input socket_timeout: Time in seconds to wait for data to be retrieved.
#!                        Default: '0'
#!                        Optional
#!
#! @output return_result: If successful (status_code = 200), it contains and instance of the operation
#!                        or the error message otherwise.
#! @output error_message: The error message in case return_code = '-1'.
#! @output return_code: '0' if target server is reachable, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#!
#! @result SUCCESS: The operation has been properly retrieved.
#! @result FAILURE: Something went wrong while trying to retrieve the operation.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute.app_engine.operations

imports:
  http: io.cloudslang.base.http

flow:
  name: get_operation

  inputs:
    - access_token
    - app_id
    - operation_id
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_keystore:
        default: ''
        required: false
    - trust_password:
        required: false
    - keystore:
        default: ''
        required: false
    - keystore_password:
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false

  workflow:
    - get_operation:
        do:
          http.http_client_get:
            - url: "${'https://appengine.googleapis.com/v1/apps/' + app_id + '/operations/' + operation_id}"
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
            - content_type: application/json
            - headers: "${'Authorization: Bearer ' + access_token}"
        publish:
          - return_result
          - return_code
          - error_message
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - return_result
    - return_code
    - status_code
    - error_message

  results:
    - SUCCESS
    - FAILURE