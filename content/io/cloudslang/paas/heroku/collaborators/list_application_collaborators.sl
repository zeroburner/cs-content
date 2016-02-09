#################################################### 
#!!
#! @description: This flow performs an REST API call in order to list all Heroku collaborators for a specified application
#! @input username: the Heroku username - Example: 'someone@mailprovider.com'
#! @input password: the Heroku used for authentication
#! @input app_id_or_name: the name or the id of the Heroku application
#! @output return_result: the response of the operation in case of success, the error message otherwise
#! @output error_message: return_result if statusCode is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: the code returned by the operation
#!!#
####################################################

namespace: io.cloudslang.paas.heroku.collaborators

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: list_application_collaborators
  inputs:
    - username
    - password
    - app_id_or_name

  workflow:
    - list_app_collaborators:
        do:
          rest.http_client_get:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name +'/collaborators'}
            - username
            - password
            - headers: "Accept:application/vnd.heroku+json; version=3"
            - content_type: "application/json"

        publish:
          - return_result
          - error_message
          - return_code
          - status_code

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code