namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.65
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/accountservice/target/accountservice.war'
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 101
        y: 133
      remote_secure_copy:
        x: 302
        y: 314
        navigate:
          2a8cdc0a-e840-addc-d953-81f4306a7f7f:
            targetId: 1755668a-f618-d3a4-3e8f-411a6427bbfd
            port: SUCCESS
      get_file:
        x: 108
        y: 307
    results:
      SUCCESS:
        1755668a-f618-d3a4-3e8f-411a6427bbfd:
          x: 296
          y: 132
